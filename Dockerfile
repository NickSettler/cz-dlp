FROM node:20-slim AS download

ARG DATA_URL
ARG SOURCE_DIRECTORY
ARG OUTPUT_DIRECTORY
ARG TRANSFORMED_DIRECTORY

ENV DATA_URL=${DATA_URL}
ENV SOURCE_DIRECTORY=${SOURCE_DIRECTORY}
ENV OUTPUT_DIRECTORY=${OUTPUT_DIRECTORY}
ENV TRANSFORMED_DIRECTORY=${TRANSFORMED_DIRECTORY}
ENV DOCKER_BUILD=true

WORKDIR /app

RUN apt update && \
    apt install -y bash curl unzip && \
    curl -fsSL https://bun.sh/install | bash

RUN apt update && apt install -y chromium-sandbox chromium chromium-driver

RUN apt update && apt install -y libx11-xcb1 libxcomposite1 libasound2 libatk1.0-0 libatk-bridge2.0-0 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6

ENV PATH="${PATH}:/root/.bun/bin"

COPY package.json .
COPY bun.lockb .
COPY tsconfig.json .

RUN bun install

COPY src src

RUN bun run run

FROM postgres:16.3-alpine AS database

ARG TRANSFORMED_DIRECTORY

ADD docker/postgres/pg_hba.conf /etc/postgresql/
ADD docker/postgres/postgresql.conf /etc/postgresql/

ADD docker/postgres/sql /docker-entrypoint-initdb.d

COPY --from=download ${TRANSFORMED_DIRECTORY} /docker-entrypoint-initdb.d

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
