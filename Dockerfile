FROM node:18.9.0-alpine3.16

RUN apk add --no-cache git shadow
RUN git clone --recursive https://github.com/FKLC/WhatsAppToDiscord /app
WORKDIR /app
RUN npm install
RUN useradd w2d
USER w2d
ENTRYPOINT node .
