FROM alpine:20221110 as build

RUN apk upgrade --no-cache
RUN apk add --no-cache ca-certificates wget tzdata nodejs-current yarn git

ARG W2D_VERSION=v0.8.5

RUN git clone --recursive https://github.com/FKLC/WhatsAppToDiscord --branch ${W2D_VERSION} /app
WORKDIR /app

RUN yarn --no-lockfile

RUN rm -rf yarn.lock install_script.sh README.md LICENSE.txt .gitignore .eslintrc.js docs .github .git package.json

FROM alpine:20221110

RUN apk upgrade --no-cache
RUN apk add --no-cache ca-certificates wget tzdata nodejs-current

COPY --from=build /app /app
WORKDIR /app

ENTRYPOINT node src/index.js
