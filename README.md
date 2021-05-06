<!-- ⚠️ This README has been generated from the file(s) "./.modules/docs/blueprint-readme-ci.md" ⚠️--><h1>Dockerfile: Updater (Node.js/Docker/DockerSlim/jq)</h1>

<h4>
  <a href="https://megabyte.space">Homepage</a>
  <span> | </span>
  <a href="https://hub.docker.com/u/megabytelabs">DockerHub Profile</a>
  <span> | </span>
  <a href="https://hub.docker.com/r/megabytelabs/updater">DockerHub Image</a>
  <span> | </span>
  <a href="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/CONTRIBUTING.md">Contributing</a>
  <span> | </span>
  <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/">Chat</a>
  <span> | </span>
  <a href="https://github.com/MegabyteLabs/docker-updater">GitHub Mirror</a>
</h4>
<p>
  <a href="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater">
    <img alt="Version" src="https://img.shields.io/docker/v/megabytelabs/updater?logo=docker&logoColor=white&style=flat" />
  </a>
  <a href="https://hub.docker.com/repository/docker/megabytelabs/updater">
    <img alt="DockerHub image size: Updater" src="https://img.shields.io/docker/image-size/megabytelabs/updater?logo=docker&logoColor=white&style=flat">
  </a>
  <a href="https://hub.docker.com/repository/docker/megabytelabs/updater" target="_blank">
    <img alt="DockerHub pulls: Updater" src="https://img.shields.io/docker/pulls/megabytelabs/updater?logo=docker&logoColor=white&style=flat" />
  </a>
  <a href="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater" target="_blank">
    <img alt="GitLab pipeline status" src="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/badges/master/pipeline.svg" />
  </a>
  <a href="https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/raw/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://github.com/https://github.com/MegabyteLabs" target="_blank">
    <img alt="GitHub: https://github.com/MegabyteLabs" src="https://img.shields.io/github/followers/MegabyteLabs?style=social" target="_blank" />
  </a>
  <a href="https://twitter.com/PrfssrManhattan" target="_blank">
    <img alt="Twitter: PrfssrManhattan" src="https://img.shields.io/twitter/follow/PrfssrManhattan.svg?style=social" />
  </a>
</p>

> <br/>**A general-purpose Dockerfile project that includes Node.js, DockerSlim, and jq (only 498 MB decompressed!)**<br/><br/>

**NOTE:** To use our compact image for Updater, you must use a build tagged with the `slim` keyword. For instance, to use the latest slim build you should specify the image as `megabytelabs/updater:slim`.


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)

## ➤ Table of Contents

* [➤ Overview](#overview)
* [➤ Requirements](#requirements)
	* [Optional Requirements](#optional-requirements)
* [➤ Example Usage](#example-usage)
	* [Integrating with GitLab CI](#integrating-with-gitlab-ci)
	* [Building the Docker Container](#building-the-docker-container)
	* [Building a Slim Container](#building-a-slim-container)
	* [Build Tools](#build-tools)
* [➤ Contributing](#contributing)
* [➤ License](#license)

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#overview)

## ➤ Overview

Utilizing Continuous Integration (CI) tools can improve developer efficiency drastically. They allow you to do things like scan new code for possible errors and automatically deploy new software.

This repository is home to the build instructions for a Docker container that is just one piece to the CI puzzle. Nearly all of [our CI pipeline Docker projects](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline) serve a single purpose.

Instead of using one of the countless Updater public Docker images available, we create it in-house so we know exactly what code is present in the container. We also ensure that all of our CI pipeline images are as small as possible so that our CI environment can download and run the specific task as quickly as possible. Using this repository as a base, you too can easily create your own in-house CI pipeline container image.

At first glance, you might notice that there are many files in this repository. Nearly all the files and folders that have a period prepended to them are development configurations. The tools that these files and folders configure are meant to make development easier and faster. They are also meant to improve team development by forcing developers to follow strict standards so that the same design patterns are used across all of our repositories.


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#requirements)

## ➤ Requirements

* **[Docker](https://gitlab.com/megabyte-labs/ansible-roles/docker)**

### Optional Requirements

* [DockerSlim](https://gitlab.com/megabyte-labs/ansible-roles/dockerslim) - Used for generating compact, secure images
* [jq](https://gitlab.com/megabyte-labs/ansible-roles/jq) - Used by `.start.sh` to interact with JSON documents from the bash shell
* [Node.js](https://gitlab.com/megabyte-labs/ansible-roles/nodejs) (*Version >=10*) - Utilized to add development features like a pre-commit hook and maintenance tasks

If you choose to utilize the development tools provided by this project then at some point you will have to run `bash .start.sh` (or `npm i` which calls `bash .start.sh` after it is done). The `.start.sh` script will attempt to automatically install any requirements (without sudo) that are not already present on your build system to the user's `~/.local/bin` folder. For more details on how the Optional Requirements are used and set up, check out the [CONTRIBUTING.md](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/CONTRIBUTING.md) guide.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#example-usage)

## ➤ Example Usage

There are several different ways you can use the Docker container provided by this project. For starters, you can test the feature out locally by running:

```shell
docker run -v ${PWD}:/work -w /work megabytelabs/updater:preferred_tag npm run update
```

This allows you to run Updater without installing it locally. This could be good for security since the application is within a container and also keeps your file system clean.

You can also add a bash alias to your `~/.bashrc` file so that you can run the Updater command at any time. To do this, add the following snippet to your `~/.bashrc` file (or `~/.bash_profile` if you are on macOS):

```shell
updater() {
    docker run -v ${PWD}:/work -w /work megabytelabs/updater:preferred_tag npm run update
}
```

### Integrating with GitLab CI

The main purpose of this project is to build a Docker container that can be used in CI pipelines. For example, if you want to incorporate this CI pipeline tool into GitLab CI project then your first step would be to create a `.gitlab-ci.yml` file in the root of your repository that is hosted by GitLab. Your `.gitlab-ci.yml` file should look something like this:

```yaml
---
stages:
  - lint

include:
  - remote: https://gitlab.com/megabyte-space/gitlab-ci-templates/-/raw/master/updater.gitlab-ci.yml
```

That is it! Updater will now run anytime you commit code (that matches the parameters laid out in the `remote:` file above). Ideally, for production, you should copy the source code from the `remote:` link above to another location and update the `remote:` link to the file's new location. That way, you do not have to worry about any changes that are made to the `remote:` file by our team.

### Building the Docker Container

You may have a use case that requires some modifications to our Docker image. After you make changes to the Dockerfile, you can upload your custom container to [Docker Hub](https://hub.docker.com/) using the following code:

```shell
docker login -u "DOCKERHUB_USERNAME" -p "DOCKERHUB_PASSWORD" docker.io
docker build --pull -t "DOCKERHUB_USERNAME/updater:latest" .
docker push "DOCKERHUB_USERNAME/updater:latest"
```

Replace `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` in the snippet above with your Docker Hub username and password. The commands will build the Docker image and upload it to [Docker Hub](https://hub.docker.com/) where it will be publicly accessible. You can see this logic being implemented as a [GitLab CI task here](https://gitlab.com/megabyte-labs/ci/gitlab-ci-templates/-/blob/master/dockerhub.gitlab-ci.yml). This GitLab CI task works in conjunction with the `.gitlab-ci.yml` file in the root of this repository.

### Building a Slim Container

Some of our repositories support creating a slim build via [DockerSlim](https://gitlab.com/megabyte-labs/ansible-roles/dockerslim). According to [DockerSlim's GitHub page](https://github.com/docker-slim/docker-slim), slimming down containers reduces the final image size and improves the security of the image by reducing the attack surface. It makes sense to create a slim build for anything that supports it, including Alpine images. On their GitHub page, they report that some images can be reduced in size by up to 448.76X. This means that if your image is naturally **700MB** then it **can be reduced to 1.56MB**! It works by removing everything that is unnecessary in the container image.

As a convenience feature, we include a command defined in `package.json` that should build the slim image. Just run `npm run build:slim` after running `npm i` (or `bash .start.sh` if you do not have `Node.js` installed) in the root of this repository to build a slim build.

To build and publish a slim Dockerfile to Docker Hub, you can use the following as a starting point:

```shell
docker login -u "DOCKERHUB_USERNAME" -p "DOCKERHUB_PASSWORD" docker.io
docker build -t "DOCKERHUB_USERNAME/updater:latest" .
docker-slim build --tag megabytelabs/updater:slim --tag megabytelabs/updater:${npm_package_version}-slim --http-probe=false --exec 'npx -y @appnest/readme --help' --mount "$PWD:/work" --workdir '/work' --include-path '/usr/local/bin/docker-slim' --include-path '/usr/bin/jq' --include-path '/usr/bin/git' --include-path '/bin/bash' --include-path '/usr/bin/npm' --include-path '/usr/bin/node' --include-path '/bin/sed' megabytelabs/updater:latest
docker push "DOCKERHUB_USERNAME/updater:slim"
```

It may be possible to modify the DockerSlim command above to fix an issue or reduce the footprint even more than our command. You can modify the slim build command inline in the `package.json` file. However, running `bash .start.sh` will overwrite your changes in the `package.json` file. We detail a better way of modifying the `npm run build:slim` configuration in [CONTRIBUTING.md](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/CONTRIBUTING.md).

If you come up with an improvement, please do [open a pull request](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/issues/new). And again, make sure you replace `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` in the snippet above with your Docker Hub username and password. The commands in the snippet above will build the slim Docker image and upload it to [Docker Hub](https://hub.docker.com/) where it will be publicly accessible. You can see this logic being implemented as a [GitLab CI task here](https://gitlab.com/megabyte-labs/ci/gitlab-ci-templates/-/blob/master/dockerhub-slim.gitlab-ci.yml).

### Build Tools

You might notice that we have a lot of extra files considering that this repository basically boils down to a single Dockerfile. These extra files are meant to make team development easier, predictable, and enjoyable. If you have a recent version of [Node.js](https://gitlab.com/megabyte-labs/ansible-roles/nodejs) installed, you can get started using our build tools by running `npm i` (or by running `bash .start.sh` if you do not currently have Node.js installed) in the root of this repository. After that, you can run `npm run info` to see a list of the available development features. The command will output a chart that may look something like this:

```shell
❯ npm run info

> ansible-lint@0.0.23 info
> npm-scripts-info

build:
  Build the regular Docker image and then build the slim image
build:latest:
  Build the regular Docker image
build:slim:
  Build a compact Docker image with DockerSlim
commit:
  The preferred way of running git commit (instead of git commit, we prefer you run 'npm run commit' in the root of this repository)
fix:
  Automatically fix formatting errors
info:
  Logs descriptions of all the npm tasks
prepare-release:
  Updates the CHANGELOG with commits made using 'npm run commit' and updates the project to be ready for release
publish:
  Creates new release(s) and uploads the release(s) to DockerHub
scan:
  Scans images for vulnerabilities
shell:
  Run the Docker container and open a shell
sizes:
  List the sizes of the Docker images on the system
test:
  Validates the Dockerfile, tests the Docker image, and performs project linting
update:
  Runs .start.sh to automatically update meta files and documentation
version:
  Used by 'npm run prepare-release' to update the CHANGELOG and app version
start:
  Kickstart the application
```

For more details, check out the [CONTRIBUTING.md](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/CONTRIBUTING.md) file.


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#contributing)

## ➤ Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/issues). If you would like to contribute, please take a look at the [contributing guide](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/CONTRIBUTING.md).

<details>
<summary>Sponsorship</summary>
<br/>
<blockquote>
<br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

***Brian Zalewski***<br/><br/>
</blockquote>

<a href="https://www.patreon.com/ProfessorManhattan">
  <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>

</details>


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#license)

## ➤ License

Copyright © 2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/raw/master/LICENSE) licensed.

