import {
  readFileSync,
  writeFileSync,
  existsSync,
  mkdirSync,
  readdirSync,
} from 'node:fs';
import { parse } from 'csv';
import { E_SOURCE_FILES, MAIN_MAP } from './map.js';
import _ from 'lodash';
import { resaveDataFiles } from './encoding.js';

export const transformFile = async (
  path: string,
  outputPath: string,
): Promise<void> => {
  if (!existsSync(outputPath)) {
    mkdirSync(outputPath);
  }

  const fileName = path.split('/').pop() as E_SOURCE_FILES;

  if (!fileName.endsWith('.csv')) {
    return;
  }

  const headerMap = MAIN_MAP[fileName]?.headersMap;

  if (!headerMap) {
    throw new Error(`No header map found for file ${fileName}`);
  }

  const data = readFileSync(path, { encoding: 'utf8' });
  const objectData = parse(data, {
    columns: true,
    autoParse: true,
    delimiter: ';',
    castDate: true,
  });
  let dataArray = await objectData.toArray();

  dataArray = dataArray.map((item: any) => {
    let newItem: any = {};

    Object.keys(item).forEach((key) => {
      const newKey = headerMap[key];

      if (Array.isArray(newKey)) {
        newItem[newKey[0]] = newKey[1](item[key]);
        return;
      }

      newItem[newKey] = item[key];
    });

    newItem = _.mapValues(newItem, (value) => (value === '' ? null : value));

    return newItem;
  });

  writeFileSync(
    `${outputPath}/${fileName.replace('.csv', '.json')}`,
    JSON.stringify(dataArray)
      .split('},{')
      .join('}\n{')
      .replace(/^\[/gm, '')
      .replace(/]$/gm, ''),
    {
      encoding: 'utf8',
    },
  );
};

export const transformOutput = async (
  outputPath: string,
  transformedPath: string,
) => {
  console.log(`Transforming output from ${outputPath} to ${transformedPath}`);

  const files = readdirSync(outputPath);

  for await (const file of files) {
    await transformFile(`${outputPath}/${file}`, `${transformedPath}`).catch(
      console.error,
    );
  }

  console.log('Output transformed');
};

export const transformData = async (
  sourcesPath: string,
  outputPath: string,
  transformedPath: string,
) => {
  await resaveDataFiles(sourcesPath, outputPath);
  await transformOutput(outputPath, transformedPath);
};
