FROM ubuntu:focal AS updater

ENV APP_USER="megabyte"
ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive
ENV NO_INSTALL_HOMEBREW=true
ENV NO_INSTALL_POETRY=true

ARG BUILD_DATE
ARG REVISION
ARG VERSION

WORKDIR /work

COPY local/initctl start.sh Taskfile.yml ./
COPY bin/ /usr/local/bin/

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN set -ex \
  && chmod +x /usr/local/bin/* \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
  build-essential=12.* \
  ca-certificates=* \
  curl=7.* \
  expect=5.* \
  file=* \
  g++=* \
  gawk=* \
  gcc=* \
  git=* \
  jq=1.* \
  libimage-exiftool-perl=11.* \
  make=4.* \
  procps=* \
  rsync=3.* \
  software-properties-common=0.* \
  sudo \
  && add-apt-repository -y ppa:git-core/ppa \
  && add-apt-repository -y ppa:deadsnakes/ppa \
  && curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/node_setup.sh \
  && bash /tmp/node_setup.sh \
  && rm /tmp/node_setup.sh \
  && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null \
  && echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  nodejs=16.* \
  python3.10=* \
  python3-pip=20.* \
  yarn=1.* \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /usr/share/doc /usr/share/man /tmp/* /var/tmp/* \
  && useradd -m -s "$(which bash)" "${APP_USER}" \
  && echo "${APP_USER}"' ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && chown -R "${APP_USER}:${APP_USER}" ./ \
  && ln -s "$(which python3)" /usr/local/bin/python \
  && npm install -g \
  @appnest/readme@1 \
  eslint@8 \
  hbs-cli@1 \
  leasot@12 \
  liquidjs@9 \
  pnpm@latest \
  pnpm-lock-export@latest \
  prettier@2 \
  remark-cli@10 \
  synp@1 \
  && pip3 install --no-cache-dir \
  ansible-base==2.* \
  ansibler==0.* \
  black==22.* \
  mod-ansible-autodoc==0.* \
  toml-sort==0.* \
  && for ITEM in $HOME/.local/bin/*; do ln -s "$ITEM" "/usr/local/bin/$(basename "$ITEM")"; done

USER megabyte

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

ENTRYPOINT ["/bin/bash"]

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

FROM updater AS poetry

# Poetry **********************
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py > /tmp/get-poetry.py \
  && python /tmp/get-poetry.py \
  && rm /tmp/get-poetry.py

FROM updater AS brew

# Homebrew ********************
ENV HOMEBREW_NO_ANALYTICS=1
ENV HOMEBREW_NO_AUTO_UPDATE=1
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
WORKDIR /home/linuxbrew/.linuxbrew
RUN sudo chown -R "${APP_USER}:${APP_USER}" . \
  && mkdir -p \
  /home/linuxbrew/.linuxbrew/bin \
  /home/linuxbrew/.linuxbrew/etc \
  /home/linuxbrew/.linuxbrew/include \
  /home/linuxbrew/.linuxbrew/lib \
  /home/linuxbrew/.linuxbrew/opt \
  /home/linuxbrew/.linuxbrew/sbin \
  /home/linuxbrew/.linuxbrew/share \
  /home/linuxbrew/.linuxbrew/var/homebrew/linked \
  /home/linuxbrew/.linuxbrew/Cellar \
  && git clone https://github.com/Homebrew/brew.git Homebrew \
  && ln -s ../Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew \
  && brew tap homebrew/core \
  && brew install-bundler-gems \
  && brew cleanup \
  && { git -C /home/linuxbrew/.linuxbrew/Homebrew config --unset gc.auto; true; } \
  && { git -C /home/linuxbrew/.linuxbrew/Homebrew config --unset homebrew.devcmdrun; true; } \
  && rm -rf .cache

FROM updater AS golang

# Go **************************
ENV GOPATH="${HOME}/.local/go"
ENV GOROOT="/home/linuxbrew/.linuxbrew/opt/go/libexec"
ENV PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"
WORKDIR /work
USER root
RUN apt-get install -y --no-install-recommends golang=*
USER megabyte

FROM brew AS dind

# Poetry **********************
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py > /tmp/get-poetry.py \
  && python /tmp/get-poetry.py \
  && rm /tmp/get-poetry.py

# Go **************************
ENV GOPATH="${HOME}/.local/go"
ENV GOROOT="/home/linuxbrew/.linuxbrew/opt/go/libexec"
ENV PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"
WORKDIR /work
USER root
RUN apt-get install -y --no-install-recommends golang=*
USER megabyte

# Semantic ********************
ARG DOCKER_VERSION="latest"
ARG ENABLE_NONROOT_DOCKER="true"
ARG USE_MOBY="true"
ARG USERNAME="megabyte"

COPY local/dind.sh dind.sh

RUN npm install -g semantic-release@19 \
  && bash dind.sh "${ENABLE_NONROOT_DOCKER}" "${USERNAME}" "${USE_MOBY}" "${DOCKER_VERSION}"

VOLUME ["/var/lib/docker"]
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

CMD ["/lib/systemd/systemd"]
ENTRYPOINT ["dind-init"]
