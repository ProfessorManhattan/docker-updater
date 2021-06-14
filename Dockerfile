FROM alpine:3

ENV container docker
ENV NODE_EXTRA_CA_CERTS /etc/ssl/certs/ca-certificates.crt

RUN apk --no-cache add --virtual build-dependencies \
      perl~=5 \
      wget~=1 \
  && apk --no-cache add \
      bash~=5 \
      curl~=7 \
      git~=2 \
      jq~=1 \
      nodejs~=14 \
      npm~=14 \
      python3~=3 \
      py3-pip~=20 \
      py3-wheel~=0 \
  && npm install -g \
      npm@latest \
  && apk del build-dependencies

WORKDIR /work

ARG BUILD_DATE
ARG REVISION
ARG VERSION

LABEL maintainer="Megabyte Labs <help@megabyte.space"
LABEL org.opencontainers.image.authors="Brian Zalewski <brian@megabyte.space>"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.description="A general-purpose, compact Dockerfile project that includes bash, curl, git, jq, and Node.js in a single container (only 0 MB compressed!)"
LABEL org.opencontainers.image.documentation="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.source="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater.git"
LABEL org.opencontainers.image.url="https://megabyte.space"
LABEL org.opencontainers.image.vendor="Megabyte Labs"
LABEL org.opencontainers.image.version=$VERSION
LABEL space.megabyte.type="ci-pipeline"
