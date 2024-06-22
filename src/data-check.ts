import puppeteer from 'puppeteer';
import { createWriteStream, existsSync, mkdirSync } from 'node:fs';
import { Readable } from 'node:stream';

const getLatestDatasetVersion = async () =>
  new Promise((resolve) => {
    puppeteer
      .launch({
        headless: true,
        timeout: 1000 * 60 * 5,
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
