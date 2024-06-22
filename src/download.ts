import { createWriteStream, existsSync, mkdirSync } from 'node:fs';
import { Readable } from 'node:stream';
import decompress from 'decompress';
import { parse } from 'node-html-parser';

export const getDLPLink = async (): Promise<string> => {
  const url = new URL(process.env.DATA_URL);

  const html = await fetch(url.toString()).then(async (res) => res.text());

  const root = parse(html);

  const hrefs = root.querySelectorAll('a').map((a) => a.getAttribute('href'));

  const DLPLink = hrefs.find(
    (href) => href?.includes('DLP') && href?.endsWith('.zip'),
  );

  if (!DLPLink) {
    throw new Error('DLP link not found');
  }

  return DLPLink;
};

export const getLatestDatasetVersion = async () => {
  const DLPLink = await getDLPLink();

  const filename = DLPLink.split('/').pop();

  const version = Array.from(filename.matchAll(/DLP(\d{8})\.zip/gm))?.[0]?.[1];

  if (!version) {
    throw new Error('Version not found');
  }

  return version;
};

export const getLatestData = async (sourcesPath: string) =>
  // eslint-disable-next-line no-async-promise-executor
  new Promise(async (resolve) => {
    const DLPLink = await getDLPLink();

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

    archiveStream.on('finish', () => {
      resolve(true);
    });
  });

export const unzipData = async (sourcesPath: string) =>
  decompress(`${sourcesPath}/dlp.zip`, sourcesPath);
