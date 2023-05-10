FROM --platform="$BUILDPLATFORM" alpine:3.18.0 as build

ARG NODE_ENV=production \
    W2D_VERSION=v0.10.10 \
    TARGETARCH
    
RUN apk add --no-cache ca-certificates nodejs-current yarn git && \
    wget https://gobinaries.com/tj/node-prune -O - | sh && \
    git clone --recursive https://github.com/FKLC/WhatsAppToDiscord --branch "$W2D_VERSION" /app && \
    cd /app && \
    if [ "$TARGETARCH" = "amd64" ]; then \
    npm_config_target_platform=linux npm_config_target_arch=x64 yarn install --no-lockfile; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
    npm_config_target_platform=linux npm_config_target_arch=arm64 yarn install --no-lockfile; \
    fi && \
    node-prune && \
    yarn cache clean --all

FROM alpine:3.18.0
RUN apk add --no-cache ca-certificates tzdata nodejs-current
COPY --from=build /app /app
WORKDIR /app
ENTRYPOINT ["node", "src/index.js"]
