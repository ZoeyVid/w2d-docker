FROM node:18.9.0-alpine3.16

RUN apk add --no-cache git shadow python3 make
RUN useradd w2d

RUN git clone --recursive https://github.com/FKLC/WhatsAppToDiscord /app
WORKDIR /app

RUN npm install

RUN apk del --purge git shadow python3 make

USER w2d

ENTRYPOINT node .
