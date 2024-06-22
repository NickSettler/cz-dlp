import {
  readFileSync,
  readdirSync,
  writeFileSync,
  mkdirSync,
  existsSync,
} from 'fs';
import { decode } from './windows-1250.js';

export const readWithEncoding = (file: string): string => {
  const data = readFileSync(file);

  if (!data || data.length === 0) {
    throw new Error(`File ${file} is empty`);
  }

  return decode(data);
};

export const resaveDataFiles = async (
  dataPath: string,
  outputPath: string,
): Promise<void> => {
  console.log(
    `Resaving data files from ${dataPath} to ${outputPath} with encoding`,
  );

  const files = readdirSync(dataPath);

  if (!existsSync(outputPath)) {
    mkdirSync(outputPath);
  }

  files.forEach((file) => {
    const data = readWithEncoding(`${dataPath}/${file}`);

    writeFileSync(`${outputPath}/${file}`, data, {
      encoding: 'utf8',
    });
  });

  console.log('Data files resaved');
};
