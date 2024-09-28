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

ENV PATH="${PATH}:/root/.bun/bin"

COPY package.json .
COPY bun.lockb .
COPY tsconfig.json .

RUN bun install

COPY src src

RUN bun run run

FROM postgres:16.3-alpine AS pure-database

ARG TRANSFORMED_DIRECTORY

ADD docker/postgres/pg_hba.conf /etc/postgresql/
ADD docker/postgres/postgresql.conf /etc/postgresql/

ADD docker/postgres/sql/001-pure.sql /docker-entrypoint-initdb.d
ADD docker/postgres/sql/003-data-import.sql /docker-entrypoint-initdb.d

COPY --from=download ${TRANSFORMED_DIRECTORY} /docker-entrypoint-initdb.d

RUN cat /usr/local/bin/docker-entrypoint.sh > init.sh && \
    echo "docker_process_init_files /docker-entrypoint-initdb.d/*" >> init.sh && \
    chmod +x init.sh

ENTRYPOINT ["./init.sh"]

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]

FROM postgres:16.3-alpine AS directus-database

ARG TRANSFORMED_DIRECTORY

ADD docker/postgres/pg_hba.conf /etc/postgresql/
ADD docker/postgres/postgresql.conf /etc/postgresql/

ADD docker/postgres/sql /docker-entrypoint-initdb.d

COPY --from=download ${TRANSFORMED_DIRECTORY} /docker-entrypoint-initdb.d

RUN cat /usr/local/bin/docker-entrypoint.sh > init.sh && \
    echo "docker_process_init_files /docker-entrypoint-initdb.d/*" >> init.sh && \
    chmod +x init.sh

ENTRYPOINT ["./init.sh"]

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
