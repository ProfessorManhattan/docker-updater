FROM alpine:3

ENV container docker
ENV NODE_EXTRA_CA_CERTS /etc/ssl/certs/ca-certificates.crt
ENV TASK_RELEASE_URL https://github.com/go-task/task/releases/latest
ENV YQ_RELEASE_URL https://github.com/mikefarah/yq/releases

RUN apk --no-cache add --virtual build-dependencies \
      perl~=5 \
      upx~=3 \
  && apk --no-cache add \
      bash~=5 \
      curl~=7 \
      git~=2 \
      jq~=1 \
      nodejs~=14 \
      npm~=7 \
      python3~=3 \
      py3-pip~=20 \
      py3-wheel~=0 \
  && curl -OL "$TASK_RELEASE_URL/download/task_linux_amd64.tar.gz" \
  && tar -xzvf task_linux_amd64.tar.gz \
  && mv task /usr/local/bin/task \
  && chmod _x /usr/local/bin/task \
  && upx /usr/local/bin/task \
  && curl "$YQ_RELEASE_URL/latest/download/yq_linux_amd64" -o /usr/bin/local/yq \
  && chmod +x /usr/local/bin/yq \
  && upx /usr/local/bin/yq \
  && npm install -g \
      @appnest/readme \
      @megabytelabs/prettier-config@latest \
      @megabytelabs/prettier-config-ansible@latest \
      hbs-cli@latest \
      npm@latest \
      prettier@latest \
      prettier-plugin-sh@latest \
      prettier-package-json@latest \
  && pip3 install --no-cache-dir \
      "virtualenv==20.*" \
  && apk del build-dependencies

WORKDIR /work

ARG BUILD_DATE
ARG REVISION
ARG VERSION

LABEL maintainer="Megabyte Labs <help@megabyte.space"
LABEL org.opencontainers.image.authors="Brian Zalewski <brian@megabyte.space>"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.description="Node.js files/configurations that support the creation of Dockerfiles"
LABEL org.opencontainers.image.documentation="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.source="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater.git"
LABEL org.opencontainers.image.url="https://megabyte.space"
LABEL org.opencontainers.image.vendor="Megabyte Labs"
LABEL org.opencontainers.image.version=$VERSION
LABEL space.megabyte.type="ci-pipeline"
