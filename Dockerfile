FROM ubuntu:20.04 AS updater

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH="/home/megabyte/.local/go"
ENV GOROOT="/home/linuxbrew/.linuxbrew/opt/go/libexec"
ENV HOMEBREW_NO_ANALYTICS=1
ENV HOMEBREW_NO_AUTO_UPDATE=1
ENV PATH="${GOPATH}/bin:${GOROOT}/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

ARG BUILD_DATE
ARG REVISION
ARG VERSION

WORKDIR /work

COPY local/initctl start.sh Taskfile.yml ./

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3003,SC2010
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y ppa:git-core/ppa \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
      build-essential \
      bzip2 \
      ca-certificates \
      curl \
      file \
      fonts-dejavu-core \
      g++ \
      gawk \
      git \
      jq\
      less \
      locales \
      make \
      netbase \
      openssh-client \
      patch \
      procps \
      rsync \
      snapd \
      sudo \
      systemd \
      systemd-cron \
      systemd-sysv \
      tzdata \
      uuid-runtime \
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

RUN brew install \
    dasel \
    exiftool \
    gh \
    glab \
    go \
    node \
    poetry \
    python@3.10 \
    hudochenkov/sshpass/sshpass \
    yq

RUN brew install snapcraft

RUN echo "$BUILD_DATE"

RUN source "$HOME/.profile" \
  && bash start.sh

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

CMD ["/lib/systemd/systemd"]

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
