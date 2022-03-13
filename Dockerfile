FROM ubuntu:20.04

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH="/home/megabyte/.local/go"
ENV GOROOT="/home/linuxbrew/.linuxbrew/opt/go/libexec"
ENV HOMEBREW_NO_ANALYTICS=1
ENV HOMEBREW_NO_AUTO_UPDATE=1
ENV PATH="${GOPATH}/bin:${GOROOT}/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

VOLUME ["/work"]
WORKDIR /work

COPY local/initctl ./

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3003,SC2010
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common=0.99.9.8 \
    && add-apt-repository -y ppa:git-core/ppa \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
      build-essential=12.8ubuntu1.1 \
      bzip2=1.0.8-2 \
      ca-certificates=20210119~20.04.2 \
      curl=7.68.0-1ubuntu2.7 \
      file=1:5.38-4 \
      fonts-dejavu-core=2.37-1 \
      g++=4:9.3.0-1ubuntu2 \
      gawk=1:5.0.1+dfsg-1 \
      git=1:2.25.1-1ubuntu3.2 \
      jq=1.6-1ubuntu0.20.04.1 \
      less=551-1ubuntu0.1 \
      locales=2.31-0ubuntu9.2 \
      make=4.2.1-1.2 \
      netbase=6.1 \
      openssh-client=1:8.2p1-4ubuntu0.4 \
      patch=2.7.6-6 \
      procps=2:3.3.16-1ubuntu2.3 \
      rsync=3.1.3-8ubuntu0.1 \
      snapd=2.54.3+20.04.1ubuntu0.2 \
      sudo=1.8.31-1ubuntu1.2 \
      systemd=245.4-4ubuntu3.15 \
      systemd-cron=1.5.14-2 \
      systemd-sysv=245.4-4ubuntu3.15 \
      tzdata=2021e-0ubuntu0.20.04 \
      uuid-runtime=2.34-0.1ubuntu9.3 \
  && apt-get clean \
  && rm -Rf /usr/share/doc /usr/share/man /tmp/* /var/tmp/* \
  && localedef -i en_US -f UTF-8 en_US.UTF-8 \
  && useradd -m -s /bin/bash megabyte \
  && echo 'megabyte ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && chown -R megabyte:megabyte ./ \
  && rm -rf /sbin/initctl \
  && mv initctl /sbin/initctl \
  && cd /lib/systemd/system/sysinit.target.wants/ \
  && ls | grep -v systemd-tmpfiles-setup | xargs rm -f "$1" \
  && rm -f /lib/systemd/system/multi-user.target.wants/* \
      /etc/systemd/system/*.wants/* \
      /lib/systemd/system/local-fs.target.wants/* \
      /lib/systemd/system/sockets.target.wants/*udev* \
      /lib/systemd/system/sockets.target.wants/*initctl* \
      /lib/systemd/system/basic.target.wants/* \
      /lib/systemd/system/anaconda.target.wants/* \
      /lib/systemd/system/plymouth* \
      /lib/systemd/system/systemd-update-utmp* \
      /lib/systemd/system/systemd*udev* \
      /lib/systemd/system/getty.target

COPY --chown=megabyte:megabyte .modules/homebrew /home/linuxbrew/.linuxbrew/Homebrew/

USER megabyte

# hadolint ignore=DL3004
RUN sudo chown megabyte:megabyte /home/linuxbrew/.linuxbrew \
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
  && ln -s ../Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew \
  && brew tap homebrew/core \
  && brew install-bundler-gems \
  && brew cleanup \
  && { git -C /home/linuxbrew/.linuxbrew/Homebrew config --unset gc.auto; true; } \
  && { git -C /home/linuxbrew/.linuxbrew/Homebrew config --unset homebrew.devcmdrun; true; } \
  && rm -rf .cache \
  && brew install \
    dasel \
    exiftool \
    gh \
    glab \
    go \
    node \
    poetry \
    python@3.10 \
    snapcraft \
    hudochenkov/sshpass/sshpass \
    yq

# hadolint ignore=DL3004
RUN curl -sSL https://github.com/go-task/task/releases/latest/download/task_linux_amd64.tar.gz \
  && tar -xzvf task_linux_amd64.tar.gz \
  && sudo mv task /usr/local/bin/task \
  && sudo chmod +x /usr/local/bin/task \
  && npm install -g \
    @appnest/readme@latest \
    esbuild@latest \
    eslint@latest \
    hbs-cli@latest \
    leasot@latest \
    liquidjs@latest \
    pnpm@latest \
    prettier@latest \
    remark-cli@latest \
  && go install github.com/marcosnils/bin@latest \
  && go install github.com/goreleaser/goreleaser@latest \
  && go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest \
  && mkdir -p "$HOME/.config/bin" \
  && echo '{}' > "$HOME/.config/bin/config.json" \
  && TMP="$(mktemp)" \
  && jq '. | .default_path = "./.bin" | .bins = {}' "$HOME/.config/bin/config.json" > "$TMP" \
  && mv "$TMP" "$HOME/.config/bin/config.json" \
  && bin install -f github.com/edgelaboratories/fusion "$PWD/fusion" \
  && sudo mv "$PWD/fusion" /usr/local/bin/fusion \
  && echo "export PATH=$PATH" > "$HOME/.profile"

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

CMD ["/lib/systemd/systemd"]

ARG BUILD_DATE
ARG REVISION
ARG VERSION

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
