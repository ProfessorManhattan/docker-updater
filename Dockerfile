FROM ubuntu:20.04

ENV container docker
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y ppa:git-core/ppa \
    && apt-get update \
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
      less \
      libz-dev \
      locales \
      make \
      netbase \
      openssh-client \
      patch \
      procps \
      rsync \
      snapd \
      sudo \
      tzdata \
      uuid-runtime \
  && localedef -i en_US -f UTF-8 en_US.UTF-8 \
  && useradd -m -s /bin/bash megabyte \
  && echo 'megabyte ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER megabyte
COPY --chown=megabyte:megabyte .modules/homebrew /home/linuxbrew/.linuxbrew/Homebrew/
ENV GOPATH "/home/megabyte/.local/go"
ENV GOROOT "/home/linuxbrew/.linuxbrew/opt/go/libexec"
ENV PATH "${GOPATH}/bin:${GOROOT}/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
WORKDIR /home/megabyte

RUN sudo chown megabyte:megabyte /home/linuxbrew/.linuxbrew \
    && mkdir -p \
     ../linuxbrew/.linuxbrew/bin \
     ../linuxbrew/.linuxbrew/etc \
     ../linuxbrew/.linuxbrew/include \
     ../linuxbrew/.linuxbrew/lib \
     ../linuxbrew/.linuxbrew/opt \
     ../linuxbrew/.linuxbrew/sbin \
     ../linuxbrew/.linuxbrew/share \
     ../linuxbrew/.linuxbrew/var/homebrew/linked \
     ../linuxbrew/.linuxbrew/Cellar \
  && ln -s ../Homebrew/bin/brew ../linuxbrew/.linuxbrew/bin/brew \
  && HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1 brew tap homebrew/core \
  && brew install-bundler-gems \
  && brew cleanup \
  && { git -C ../linuxbrew/.linuxbrew/Homebrew config --unset gc.auto; true; } \
  && { git -C ../linuxbrew/.linuxbrew/Homebrew config --unset homebrew.devcmdrun; true; } \
  && rm -rf .cache \
  && brew install go

RUN brew install exiftool \
  && brew install gh \
  && brew install glab \
  && brew install go \
  && brew install jq \
  && brew install node \
  && brew install poetry \
  && brew install python@3.10 \
  && brew install hudochenkov/sshpass/sshpass \
  && brew install yq \
  && curl -OL https://github.com/go-task/task/releases/latest/download/task_linux_amd64.tar.gz \
  && tar -xzvf task_linux_amd64.tar.gz \
  && sudo mv task /usr/local/bin/task \
  && sudo chmod +x /usr/local/bin/task \
  && npm install -g \
      @appnest/readme@latest \
      cz-emoji \
      esbuild@latest \
      eslint@latest \
      hbs-cli@latest \
      leasot@latest \
      liquidjs@latest \
      pnpm@latest \
      prettier@latest \
      remark-cli

RUN go install github.com/marcosnils/bin@latest \
  && go install github.com/goreleaser/goreleaser@latest \
  && go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest

RUN brew install snapcraft

WORKDIR /work

ARG BUILD_DATE
ARG REVISION
ARG VERSION

LABEL maintainer="Megabyte Labs <help@megabyte.space"
LABEL org.opencontainers.image.authors="Brian Zalewski <brian@megabyte.space>"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.description="A general-purpose, compact Dockerfile project that includes various programs required for synchronizing projectLABEL org.opencontainers.image.description="Node.js files/configurations that support the creation of Dockerfiles"#x27;s with upstream repositories"
LABEL org.opencontainers.image.documentation="https://github.com/ProfessorManhattan/docker-updater/blob/master/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.source="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater.git"
LABEL org.opencontainers.image.url="https://megabyte.space"
LABEL org.opencontainers.image.vendor="Megabyte Labs"
LABEL org.opencontainers.image.version=$VERSION
LABEL space.megabyte.type="ci-pipeline"
