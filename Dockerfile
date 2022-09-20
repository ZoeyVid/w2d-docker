FROM node:18.9.0-alpine3.16 as build

RUN apk add --no-cache ca-certificates git python3 make gcc

RUN git clone --recursive https://github.com/FKLC/WhatsAppToDiscord /app
WORKDIR /app

RUN npm install

FROM node:18.9.0-alpine3.16

RUN apk add --no-cache ca-certificates

COPY --from=build /app /app
WORKDIR /app

ENTRYPOINT node .
