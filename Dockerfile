FROM alpine:20230208 as build

RUN apk upgrade --no-cache
RUN apk add --no-cache ca-certificates wget tzdata git nodejs-current yarn

ARG W2D_VERSION=v0.8.5

RUN git clone --recursive https://github.com/FKLC/WhatsAppToDiscord --branch "$W2D_VERSION" /app
WORKDIR /app

RUN yarn --no-lockfile

FROM alpine:20230208

RUN apk upgrade --no-cache && \
    apk add --no-cache ca-certificates wget tzdata nodejs-current

COPY --from=build /app /app
WORKDIR /app

ENTRYPOINT ["node", "src/index.js"]
