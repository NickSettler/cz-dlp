import { createWriteStream, existsSync, mkdirSync } from 'node:fs';
import { Readable } from 'node:stream';
import decompress from 'decompress';
import { parse } from 'node-html-parser';
import { HTMLElement } from 'node-html-parser';
import { finished } from 'node:stream/promises';

export const getDLPPageHTML = async (): Promise<HTMLElement> => {
  const url = new URL(process.env.DATA_URL);

  const html = await fetch(url.toString()).then(async (res) => res.text());

  return parse(html);
};

export const getDLPLink = async (root: HTMLElement): Promise<string> => {
  const hrefs = root.querySelectorAll('a').map((a) => a.getAttribute('href'));

  const DLPLink = hrefs.find(
    (href) => href?.includes('DLP') && href?.endsWith('.zip'),
  );

  if (!DLPLink) {
    throw new Error('DLP link not found');
  }

  return DLPLink;
};

const getDLPMetadataLink = async (root: HTMLElement): Promise<string> => {
  const hrefs = root.querySelectorAll('a').map((a) => a.getAttribute('href'));

  const DLPMetadataLink = hrefs.find(
    (href) => href?.includes('DLP') && href?.endsWith('.csv'),
  );

  if (!DLPMetadataLink) {
    throw new Error('DLP metadata link not found');
  }

  return DLPMetadataLink;
};

export const getLatestDatasetVersion = async () => {
  const pageRoot = await getDLPPageHTML();

  const DLPLink = await getDLPLink(pageRoot);

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
    const pageRoot = await getDLPPageHTML();

    const DLPLink = await getDLPLink(pageRoot);
    const DLPMetadataLink = await getDLPMetadataLink(pageRoot);

    if (!existsSync(`${sourcesPath}`)) {
      mkdirSync(`${sourcesPath}`, {
        recursive: true,
      });
    }

    const archiveStream = createWriteStream(`${sourcesPath}/dlp.zip`);
    const metadataStream = createWriteStream(`${sourcesPath}/dlp_metadata.csv`);

    const [archiveFile, metadataFile] = await Promise.all([
      fetch(DLPLink),
      fetch(DLPMetadataLink),
    ]);

    if (archiveFile.ok && archiveFile.body) {
      // eslint-disable-next-line @typescript-eslint/ban-ts-comment
      // @ts-ignore
      Readable.fromWeb(archiveFile.body).pipe(archiveStream);
    }

    if (metadataFile.ok && metadataFile.body) {
      // eslint-disable-next-line @typescript-eslint/ban-ts-comment
      // @ts-ignore
      Readable.fromWeb(metadataFile.body).pipe(metadataStream);
    }

    Promise.all([finished(archiveStream), finished(metadataStream)]).then(
      () => {
        resolve(true);
      },
    );
  });

export const unzipData = async (sourcesPath: string) =>
  decompress(`${sourcesPath}/dlp.zip`, sourcesPath);
