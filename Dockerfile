FROM --platform=${BUILDPLATFORM} alpine:3.16.2 as build
RUN apk add --no-cache git
RUN git clone --recursive https://github.com/FKLC/WhatsAppToDiscord /app

FROM node:18.9.0-alpine3.16

RUN apk add --no-cache shadow
RUN useradd w2d
RUN apk del --purge shadow

COPY --from=build /app /app
WORKDIR /app

RUN npm install

USER w2d

ENTRYPOINT node .
