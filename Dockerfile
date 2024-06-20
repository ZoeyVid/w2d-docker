# syntax=docker/dockerfile:labs
FROM --platform="$BUILDPLATFORM" alpine:3.20.1 as build
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
ARG NODE_ENV=production \
    W2D_VERSION=v0.10.26 \
    TARGETARCH

RUN apk upgrade --no-cache -a && \
    apk add --no-cache ca-certificates nodejs yarn git && \
    yarn global add clean-modules && \
    git clone --recursive https://github.com/FKLC/WhatsAppToDiscord --branch "$W2D_VERSION" /app && \
    cd /app && \
    if [ "$TARGETARCH" = "amd64" ]; then \
      npm_config_target_platform=linux npm_config_target_arch=x64 yarn install --no-lockfile; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      npm_config_target_platform=linux npm_config_target_arch=arm64 yarn install --no-lockfile; \
    fi && \
    clean-modules --yes && \
    yarn cache clean --all

FROM alpine:3.20.1
RUN apk upgrade --no-cache -a && \
    apk add --no-cache ca-certificates tzdata tini nodejs-current
COPY --from=build /app /app
WORKDIR /app
ENTRYPOINT ["tini", "--", "node", "src/index.js", "--skip-update"]
