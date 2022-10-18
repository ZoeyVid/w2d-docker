FROM alpine:3.16.2 as build

RUN apk add --no-cache ca-certificates nodejs-current yarn git

ARG W2D_VERSION=v0.8.2

RUN git clone --recursive https://github.com/FKLC/WhatsAppToDiscord --branch ${W2D_VERSION} /app
WORKDIR /app
RUN rm -rf yarn.lock

RUN yarn

FROM alpine:3.16.2

RUN apk add --no-cache ca-certificates nodejs-current

COPY --from=build /app /app
WORKDIR /app

ENTRYPOINT node .
