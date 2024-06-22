import { config } from 'dotenv';
import { transformData } from './transform.js';
import { getLatestData, unzipData } from './download.js';

config();

const sourcesPath = process.env.SOURCE_DIRECTORY;
const outputPath = process.env.OUTPUT_DIRECTORY;
const transformedPath = process.env.TRANSFORMED_DIRECTORY;

console.log('Downloading data');
getLatestData(sourcesPath)
  .then(async () => {
    console.log('Data downloaded');
    console.log('Unzipping data');
    return unzipData(sourcesPath);
  })
  .then(async () => {
    console.log('Data unzipped');
    console.log('Transforming data files');
    return transformData(sourcesPath, outputPath, transformedPath);
  })
  .then(() => {
    console.log('Data transformed');
  })
  .catch((e) => {
    console.error(e);
  });
