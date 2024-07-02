# Directus Database for Czech Medicines Registry

The repository contains the docker image setup for the Directus database of the Czech Medicines Registry.

## Usage

In order to create the image, you need to have Docker installed on your machine. Then you can run the following command:

```bash
docker build \
  --build-arg "DATA_URL=<URL>" \
  --build-arg "SOURCE_DIRECTORY=<PATH>" \
  --build-arg "OUTPUT_DIRECTORY=<PATH>" \
  --build-arg "TRANSFORMED_DIRECTORY=<PATH>" \
  -t dlp-database .
```

The build arguments are as follows:
* `DATA_URL` - the URL of the page with the data archive. The data archive should be in the ZIP format. The name of the archive should contain `DLP` string.
* `SOURCE_DIRECTORY` - the path to the directory where the data archive will be downloaded and extracted to CSV files.
* `OUTPUT_DIRECTORY` - the path to the directory where the CSV files will be saved with the UTF-8 encoding.
* `TRANSFORMED_DIRECTORY` - the path to the directory where the CSV files will be saved as JSON files.

After the image is built, you should run the container with the following command:

```bash
docker run -d \
  --name dlp-database \
  -e POSTGRES_PASSWORD=directus \
  -e POSTGRES_DB=directus \
  -e POSTGRES_USER=directus \
  dlp-database
```

The `POSTGRES_PASSWORD`, `POSTGRES_DB`, and `POSTGRES_USER` environment variables are required for the PostgreSQL database. The `POSTGRES_USER` should be set to `directus` as the SQL scripts are set up to use this user as the owner of the tables.

In order to change this user, you should modify the [001-pure.sql](docker/postgres/sql/001-pure.sql) file.

## Data Usage

Data in the repository and related docker images are shared based on the terms of usage from the Czech Medicines Registry: https://opendata.sukl.cz/?q=podminky-uziti-otevrenych-dat
