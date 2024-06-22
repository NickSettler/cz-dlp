import puppeteer from 'puppeteer';
import { createWriteStream, existsSync, mkdirSync } from 'node:fs';
import { Readable } from 'node:stream';
import decompress from 'decompress';

export const getLatestData = async (sourcesPath: string) =>
  new Promise((resolve) => {
    puppeteer
      .launch({
        headless: true,
        timeout: 0,
        args: ['--no-sandbox', '--disable-setuid-sandbox'],
        executablePath: '/usr/bin/chromium',
      })
      .then(async (browser) => {
        const url = new URL(process.env.DATA_URL);
        const page = await browser.newPage();
        await page.goto(url.toString());

        const links = await page.$$('a');

        const hrefs = await Promise.all(
          links.map(async (link) => page.evaluate((el) => el.href, link)),
        );

        const DLPLink = hrefs.find(
          (href) => href.includes('DLP') && href.endsWith('.zip'),
        );

        if (!existsSync(`${sourcesPath}`)) {
          mkdirSync(`${sourcesPath}`, {
            recursive: true,
          });
        }

        const archiveStream = createWriteStream(`${sourcesPath}/dlp.zip`);

        const archiveFile = await fetch(DLPLink);

        if (archiveFile.ok && archiveFile.body) {
          // eslint-disable-next-line @typescript-eslint/ban-ts-comment
          // @ts-ignore
          Readable.fromWeb(archiveFile.body).pipe(archiveStream);
        }

        await browser.close();

        archiveStream.on('finish', () => {
          browser.close();
          resolve(true);
        });
      });
  });

export const unzipData = async (sourcesPath: string) =>
  decompress(`${sourcesPath}/dlp.zip`, sourcesPath);
