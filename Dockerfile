FROM alpine:3

ENV container docker
ENV NODE_EXTRA_CA_CERTS /etc/ssl/certs/ca-certificates.crt

RUN apk --no-cache add --virtual build-dependencies \
      perl=5.32.0-r0 \
      wget=1.21.1-r1 \
  && apk --no-cache add \
      bash=5.1.0-r0 \
      curl=7.77.0-r1 \
      git=2.30.2-r0 \
      jq=1.6-r1 \
      nodejs=14.16.1-r1 \
      npm=14.16.1-r1 \
      python3=3.8.10-r0 \
      py3-pip=20.3.4-r0 \
  && npm install -g npm@latest \
  && apk del build-dependencies \
  && rm -Rf /var/cache/apk/*

WORKDIR /work

CMD ["node", "--version"]

ARG BUILD_DATE
ARG REVISION
ARG VERSION

LABEL maintainer="Megabyte Labs <help@megabyte.space"
LABEL org.opencontainers.image.authors="Brian Zalewski <brian@megabyte.space>"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.description="A general-purpose, compact Dockerfile project that includes bash, curl, git, jq, and Node.js in a single container (only 32.1585 MB compressed!)"
LABEL org.opencontainers.image.documentation="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.source="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater.git"
LABEL org.opencontainers.image.url="https://megabyte.space"
LABEL org.opencontainers.image.vendor="Megabyte Labs"
LABEL org.opencontainers.image.version=$VERSION
LABEL space.megabyte.type="ci-pipeline"
