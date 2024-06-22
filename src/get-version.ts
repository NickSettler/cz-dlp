import { config } from 'dotenv';
import { getLatestDatasetVersion } from './download.js';

config();

getLatestDatasetVersion().then((version) => process.stdout.write(version));
