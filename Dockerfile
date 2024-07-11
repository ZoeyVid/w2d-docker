# syntax=docker/dockerfile:labs
FROM --platform="$BUILDPLATFORM" alpine:3.20.1 AS build
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
ARG NODE_ENV=production \
    W2D_VERSION=v0.10.26 \
    TARGETARCH

RUN apk upgrade --no-cache -a && \
    apk add --no-cache ca-certificates git nodejs yarn && \
    yarn global add clean-modules && \
    git clone --recursive https://github.com/FKLC/WhatsAppToDiscord --branch "$W2D_VERSION" /app && \
    cd /app && \
    if [ "$TARGETARCH" = "amd64" ]; then \
      npm_config_arch=x64 npm_config_target_arch=x64 yarn install --no-lockfile && \
      for file in $(find /app/node_modules -name "*.node" -type f -exec file {} \; | grep -v "x86-64\|x86_64" | grep "aarch64\|arm64" | sed "s|\([^:]\):.*|\1|g"); do rm -v "$file"; done; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      npm_config_arch=arm64 npm_config_target_arch=arm64 yarn install --no-lockfile && \
      for file in $(find /app/node_modules -name "*.node" -type f -exec file {} \; | grep -v "aarch64\|arm64" | grep "x86-64\|x86_64" | sed "s|\([^:]\):.*|\1|g"); do rm -v "$file"; done; \
    fi && \
    yarn cache clean --all && \
    clean-modules --yes
FROM alpine:3.20.1 AS strip
COPY --from=build /app /app
RUN apk upgrade --no-cache -a && \
    apk add --no-cache ca-certificates binutils file && \
    find /app/node_modules -name "*.node" -type f -exec strip -s {} \; && \
    find /app/node_modules -name "*.node" -type f -exec file {} \;

FROM alpine:3.20.1
RUN apk upgrade --no-cache -a && \
    apk add --no-cache ca-certificates tzdata tini nodejs-current
COPY --from=strip /app /app
WORKDIR /app
ENTRYPOINT ["tini", "--", "node", "src/index.js", "--skip-update"]
