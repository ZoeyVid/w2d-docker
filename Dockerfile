FROM node:18.10.0-alpine3.16 as build

RUN apk add --no-cache ca-certificates git python3 make gcc

ARG W2D_VERSION=v0.8.2

RUN git clone --recursive https://github.com/FKLC/WhatsAppToDiscord --branch ${W2D_VERSION} /app
WORKDIR /app

RUN npm install

FROM node:18.10.0-alpine3.16

RUN apk add --no-cache ca-certificates

COPY --from=build /app /app
WORKDIR /app

ENTRYPOINT node .
