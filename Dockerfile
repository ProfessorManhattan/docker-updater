FROM ubuntu:focal AS updater

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive

ARG BUILD_DATE
ARG REVISION
ARG VERSION

WORKDIR /work

COPY local/initctl start.sh Taskfile.yml ./
COPY bin/ /usr/local/bin/

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3003,SC2010
RUN set -ex && \
  chmod +x /usr/local/bin/* && \
  apt-get update && \
  apt-get install -y --no-install-recommends software-properties-common=0.* && \
  add-apt-repository -y ppa:git-core/ppa && \
  add-apt-repository -y ppa:deadsnakes/ppa && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  build-essential=12.* \
  ca-certificates=* \
  curl=7.* \
  exiftool=11.* \
  expect=5.* \
  file=* \
  g++=* \
  gawk=* \
  gcc=* \
  git=* \
  jq=1.* \
  make=4.* \
  procps=* \
  python3.10=* \
  rsync=3.* \
  sudo && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /usr/share/doc /usr/share/man /tmp/* /var/tmp/* && \
  useradd -m -s "$(which bash)" --gecos "" --disabled-login -c "Megabyte Labs" megabyte && \
  echo 'megabyte ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  chown -R megabyte:megabyte ./ && \
  curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/node_setup.sh && \
  bash /tmp/node_setup.sh && \
  rm /tmp/node_setup.sh && \
  ln -s "$(which python3)" /usr/local/bin/python \
  curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python - && \
  npm install -g \
  @appnest/readme@1 \
  eslint@8 \
  leasot@12 \
  liquidjs@9 \
  pnpm@latest \
  prettier@2 \
  remark@10 \
  synp@1 && \
  pip3 install --no-cache-dir \
  ansible-base==2.* \
  ansibler==0.* \
  black==22.* \
  mod-ansible-autodoc==0.* \
  toml-sort==0.*

USER megabyte

RUN bash start.sh

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

CMD ["/bin/bash"]

LABEL maintainer="Megabyte Labs <help@megabyte.space"
LABEL org.opencontainers.image.authors="Brian Zalewski <brian@megabyte.space>"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.description="A general-purpose, compact Dockerfile project that includes various programs required for synchronizing projects with upstream repositories"
LABEL org.opencontainers.image.documentation="https://github.com/ProfessorManhattan/docker-updater/blob/master/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.source="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater.git"
LABEL org.opencontainers.image.url="https://megabyte.space"
LABEL org.opencontainers.image.vendor="Megabyte Labs"
LABEL org.opencontainers.image.version=$VERSION
LABEL space.megabyte.type="ci-pipeline"

FROM updater AS updater-brew

ENV GOPATH="/home/megabyte/.local/go"
ENV GOROOT="/home/linuxbrew/.linuxbrew/opt/go/libexec"
ENV HOMEBREW_NO_ANALYTICS=1
ENV HOMEBREW_NO_AUTO_UPDATE=1
ENV PATH="${GOPATH}/bin:${GOROOT}/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

COPY --chown=megabyte:megabyte .modules/homebrew /home/linuxbrew/.linuxbrew/Homebrew/
WORKDIR /home/linuxbrew/.linuxbrew/Homebrew/

RUN rm .git \
  && chown -R megabyte:megabyte /home/linuxbrew/.linuxbrew

USER megabyte

RUN git init \
  && git remote add origin https://github.com/Homebrew/brew.git

WORKDIR /work

# hadolint ignore=DL3004
RUN mkdir -p \
  /home/linuxbrew/.linuxbrew/bin \
  /home/linuxbrew/.linuxbrew/etc \
  /home/linuxbrew/.linuxbrew/include \
  /home/linuxbrew/.linuxbrew/lib \
  /home/linuxbrew/.linuxbrew/opt \
  /home/linuxbrew/.linuxbrew/sbin \
  /home/linuxbrew/.linuxbrew/share \
  /home/linuxbrew/.linuxbrew/var/homebrew/linked \
  /home/linuxbrew/.linuxbrew/Cellar \
  && ln -s ../Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew \
  && brew tap homebrew/core \
  && brew install-bundler-gems \
  && brew cleanup \
  && { git -C /home/linuxbrew/.linuxbrew/Homebrew config --unset gc.auto; true; } \
  && { git -C /home/linuxbrew/.linuxbrew/Homebrew config --unset homebrew.devcmdrun; true; } \
  && rm -rf .cache
