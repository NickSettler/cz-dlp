import { config } from 'dotenv';
import { getLatestDatasetVersion } from './download.js';

config();

const getGithubRepoTags = async () => {
  const url = new URL(
    `https://api.github.com/repos/${process.env.GITHUB_REPO}/tags`,
  );

  const response = await fetch(url.toString());

  if (!response.ok) {
    throw new Error('Failed to fetch tags');
  }

  const tagsJSON = await response.json();

  return tagsJSON.map((tag: any) => tag.name);
};

const checkNewData = async () => {
  const currentVersion = await getLatestDatasetVersion();
  const tags = await getGithubRepoTags();

  if (!tags.includes(currentVersion)) {
    console.log('Data already exists');
    process.exit(0);
  }

  console.log('New data found');
  process.exit(1);
};

checkNewData();
