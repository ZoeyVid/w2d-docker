FROM node:18.9.0-alpine3.16

RUN apk add --no-cache ca-certificates shadow git python3 make gcc
RUN useradd w2d

RUN git clone --recursive https://github.com/FKLC/WhatsAppToDiscord /app
WORKDIR /app

RUN npm install

RUN apk add --no-cache shadow git python3 make gcc

USER w2d

ENTRYPOINT node .
