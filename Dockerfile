FROM docker:20.10-dind

ENV container docker
ENV DOCKERSLIM_SHA256 b0f1b488d33b09be8beb224d4d26cb2d3e72669a46d242a3734ec744116b004c
ENV DOCKERSLIM_URL https://downloads.dockerslim.com/releases/1.35.1/dist_linux.tar.gz

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk --no-cache add --virtual build-dependencies \
      perl=5.32.0-r0 \
      wget=1.21.1-r1 \
  && apk --no-cache add \
      bash=5.1.0-r0 \
      curl=7.76.1-r0 \
      git=2.30.2-r0 \
      jq=1.6-r1 \
      nodejs=14.16.1-r1 \
      npm=14.16.1-r1 \
  && wget -nv $DOCKERSLIM_URL -O /tmp/dockerslim.tar.gz \
  && echo "$DOCKERSLIM_SHA256  /tmp/dockerslim.tar.gz" | sha256sum -c \
  && tar -zxvf /tmp/dockerslim.tar.gz \
  && cp -rf dist_linux/* /usr/local/bin \
  && rm -rf /tmp/* dist_linux \
  && chmod +x /usr/local/bin/docker-slim \
  && chmod +x /usr/local/bin/docker-slim-sensor \
  && apk del build-dependencies \
  && rm -Rf /var/cache/apk/*

WORKDIR /work

CMD ["bash", ".start.sh"]

ARG BUILD_DATE
ARG REVISION
ARG VERSION

LABEL maintainer="Megabyte Labs <help@megabyte.space"
LABEL org.opencontainers.image.authors="Brian Zalewski <brian@megabyte.space>"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.description="A general-purpose Dockerfile project that includes Node.js, DockerSlim, and jq in a single container (only 27.7892 MB compressed!)"
LABEL org.opencontainers.image.documentation="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.source="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater.git"
LABEL org.opencontainers.image.url="https://megabyte.space"
LABEL org.opencontainers.image.vendor="Megabyte Labs"
LABEL org.opencontainers.image.version=$VERSION
LABEL space.megabyte.type="ci-pipeline"
