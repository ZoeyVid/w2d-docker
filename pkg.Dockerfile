FROM --platform="$BUILDPLATFORM" node:18.16.0-alpine3.17 as build

ARG NODE_ENV=production \
    W2D_VERSION=v0.10.13 \
    TARGETARCH

WORKDIR /src
RUN apk add --no-cache ca-certificates git && \
    yarn global add pkg esbuild && \
    wget https://gobinaries.com/tj/node-prune -O - | sh && \
    git clone --recursive https://github.com/FKLC/WhatsAppToDiscord --branch "$W2D_VERSION" /src && \
    if [ "$TARGETARCH" = "amd64" ]; then \
    npm_config_target_platform=linux npm_config_target_arch=x64 yarn install --no-lockfile && \
    node-prune && \
    yarn cache clean --all && \
    esbuild src/index.js --bundle --platform=node --external:sharp --external:qrcode-terminal --external:jimp --external:link-preview-js --target=node18 --outfile=out.js && \
    pkg -t alpine-x64 -C Brotli --output rvx-builder out.js; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
    npm_config_target_platform=linux npm_config_target_arch=arm64 yarn install --no-lockfile && \
    node-prune && \
    yarn cache clean --all && \
    esbuild src/index.js --bundle --platform=node --external:sharp --external:qrcode-terminal --external:jimp --external:link-preview-js --target=node18 --outfile=out.js && \
    pkg -t alpine-arm64 -C Brotli --output rvx-builder out.js; \
    fi && \
    chmod +x /src/WA2DC

FROM alpine:3.18.0
RUN apk add --no-cache ca-certificates tzdata
COPY --from=build /src/WA2DC /usr/local/bin/WA2DC
WORKDIR /app
ENTRYPOINT ["WA2DC"]
