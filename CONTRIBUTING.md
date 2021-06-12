<!-- ⚠️ This README has been generated from the file(s) "./.modules/docs/blueprint-contributing.md" ⚠️--><h1>Contributing Guide</h1>

First of all, thanks for visiting this page 😊 ❤️ ! We are totally ecstatic that you may be considering contributing to this project. You should read this guide if you are considering creating a pull request.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)

## ➤ Table of Contents

- [➤ Code of Conduct](#-code-of-conduct)
- [➤ Overview](#-overview)
- [➤ Philosophy](#-philosophy)
  - [Choosing a Base Image](#choosing-a-base-image)
- [➤ Requirements](#-requirements)
  - [Optional Requirements](#optional-requirements)
- [➤ Getting Started](#-getting-started)
  - [Descriptions of Build Scripts](#descriptions-of-build-scripts)
  - [Creating DockerSlim Builds](#creating-dockerslim-builds)
    - [How to Determine Which Paths to Include](#how-to-determine-which-paths-to-include)
    - [Determining Binary Dependencies](#determining-binary-dependencies)
  - [Using a `paths.txt` File](#using-a-pathstxt-file)
  - [Updating the `.blueprint.json` File](#updating-the-blueprintjson-file)
- [➤ Creating a New Dockerfile Project](#-creating-a-new-dockerfile-project)
- [➤ Testing](#-testing)
  - [Creating Test Cases](#creating-test-cases)
  - [Testing DockerSlim Builds](#testing-dockerslim-builds)
  - [Testing Web Apps](#testing-web-apps)
- [➤ Linting](#-linting)
- [➤ Pull Requests](#-pull-requests)
  - [How to Commit Code](#how-to-commit-code)
  - [Pre-Commit Hook](#pre-commit-hook)

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#code-of-conduct)

## ➤ Code of Conduct

This project and everyone participating in it is governed by the [Code of Conduct](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/blob/master/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [help@megabyte.space](mailto:help@megabyte.space).

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#overview)

## ➤ Overview

All our Dockerfiles are created for specific tasks. In many cases, this allows us to reduce the size of the Dockerfiles by removing unnecessary files and performing other optimizations. [Our Dockerfiles](https://gitlab.com/megabyte-labs/dockerfile) are broken down into the following categories:

- **[Ansible Molecule](https://gitlab.com/megabyte-labs/dockerfile/ansible-molecule)** - Dockerfile projects used to generate pre-built Docker containers that are intended for use by Ansible Molecule
- **[Apps](https://gitlab.com/megabyte-labs/dockerfile/apps)** - Full-fledged web applications
- **[CI Pipeline](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline)** - Projects that include tools used during deployments such as linters and auto-formatters
- **[Software](https://gitlab.com/megabyte-labs/dockerfile/software)** - Docker containers that are meant to replace software that is traditionally installed directly on hosts

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#philosophy)

## ➤ Philosophy

When you are working on one of our Dockerfile projects, try asking yourself, "How can this be improved?" By asking yourself that question, you might decide to take the project a step further by opening a merge request that:

- Reduces the size of the Docker container by converting it from a Ubuntu image to an Alpine image
- Improves the security and reduces the size of the Docker container by including a [DockerSlim](https://github.com/docker-slim/docker-slim) configuration
- Lints the Dockerfile to conform with standards set in place by [Haskell Dockerfile Linter](https://github.com/hadolint/hadolint)

All of these improvements would be greatly appreciated by us and our community. After all, we want all of our Dockerfiles to be the best at what they do.

### Choosing a Base Image

- Whenever possible, use Alpine as the base image. It has a very small footprint so the container image downloads faster.
- Whenever possible, choose an image with a `slim` tag. This is beneficial when, say, Alpine is incompatible with the requirements and you must use something besides an Alpine image.
- Avoid using the latest tag (e.g. `node:latest`). Instead use specific versions like `node:15.4.2`. This makes debugging production issues easier.
- When choosing a base image version, always choose the most recent update. There are often known vulnerabilities with older versions.
- If all else fails, feel free to use other base images as long as they come from a trusted provider (i.e. using `ubuntu:latest` is fine but using `bobmighthackme:latest` is not).

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#requirements)

## ➤ Requirements

Before getting started with development, you should ensure that the following requirements are present on your system:

- **[Docker](https://gitlab.com/megabyte-labs/ansible-roles/docker)**

### Optional Requirements

- [DockerSlim](https://gitlab.com/megabyte-labs/ansible-roles/dockerslim) - Used for generating compact, secure images
- [jq](https://gitlab.com/megabyte-labs/ansible-roles/jq) - Used by `.start.sh` to interact with JSON documents from the bash shell
- [Node.js](https://gitlab.com/megabyte-labs/ansible-roles/nodejs) (_Version >=10_) - Utilized to add development features like a pre-commit hook and other automations

_Each of the requirements links to an Ansible Role that can install the dependency with a one-line bash script install._ Even if you do not have the optional dependencies installed, the `.start.sh` script (which is called by many of our build tool sequences) will attempt to install missing dependencies to the `~/.local/bin` folder.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#getting-started)

## ➤ Getting Started

To get started when developing one of [our Dockerfile projects](https://gitlab.com/megabyte-labs/dockerfile) (after you have installed [Docker](https://gitlab.com/megabyte-labs/ansible-roles/docker)), the first command you need to run in the root of the project is:

```shell
bash .start.sh
```

This command will:

- Install missing dependencies without sudo (i.e. the binary dependencies will be stored in `~/.local/bin` and your PATH will be updated to reference the `~/.local/bin` directory)
- Ensure Node.js dependencies are installed if the `node_modules/` folder is missing
- Copy (and possibly overwrite) the shared common files from the [Dockerfile common files repository](https://gitlab.com/megabyte-labs/common/dockerfile) and the [shared common files repository](https://gitlab.com/megabyte-labs/common/shared)
- Update the `package.json` file
- Re-generate the documentation
- Register a pre-commit hook that only allows commits to register if tests are passed

### Descriptions of Build Scripts

After you run `npm i` (or `bash .start.sh`), you can view the various build commands by running `npm run info`. This will display a chart in your terminal with descriptions of the build scripts. It might look something like this:

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

You can then build the Docker image, for instance, by running `npm run build` or list the sizes of Docker images on your system by running `npm run sizes`. You can check out exactly what each command does by looking at the `package.json` file in the root of the project.

### Creating DockerSlim Builds

Whenever possible, a DockerSlim build should be provided and tagged as `:slim`. DockerSlim provides many configuration options so please check out the [DockerSlim documentation](https://github.com/docker-slim/docker-slim) to get a thorough understanding of it and what it is capable of. When you have formulated _and fully tested_ the proper DockerSlim configuration, you can add it to the `.blueprint.json` file.

#### How to Determine Which Paths to Include

In most cases, the DockerSlim configuration in `.blueprint.json` (which gets injected into `package.json`) will require the use of `--include-path`. If you were creating a slim build that included `jq`, for instance, then you would need to instruct DockerSlim to hold onto the `jq` binary. You can determine where the binary is stored on the target machine by running:

```bash
npm run shell
which jq
```

You would then need to include the path that the command above displays in the `dockerslim_command` key of `.blueprint.json`. The `.blueprint.json` might look something like this:

```json
{
  ...
  "dockerslim_command": "--http-probe=false --exec 'npm install' --include-path '/usr/bin/jq'"
}
```

#### Determining Binary Dependencies

If you tried to use the `"dockerslim_command"` above, you might notice that it is incomplete. That is because `jq` relies on some libraries that are not bundled into the executable. You can determine the libraries you need to include by using the `ldd` command like this:

```bash
npm run shell
ldd $(which jq)
```

The command above would output something like this:

```shell
	/lib/ld-musl-x86_64.so.1 (0x7fa35376c000)
	libonig.so.5 => /usr/lib/libonig.so.5 (0x7fa35369e000)
	libc.musl-x86_64.so.1 => /lib/ld-musl-x86_64.so.1 (0x7fa35376c000)
```

Using the information above, you can see two unique libraries being used. You should then check out the slim build to see which of the two libraries is missing. This can be done by running:

```bash
echo "***Base image libraries for jq***"
npm run shell
cd /usr/lib
ls | grep libonig.so.5
cd /lib
ls | grep ld-musl-x86_64.so.1
exit
echo "***Slim image libraries for jq***"
npm run shell:slim
cd /usr/lib
ls | grep libonig.so.5
cd /lib
ls | grep ld-musl-x86_64.so.1
exit
```

You should then compare the output from the base image with the slim image. After you compare the two, in this case, you will see that the slim build is missing `/usr/lib/libonig.so.5` and `/usr/lib/libonig.so.5.1.0`. So, finally, you can complete the necessary configuration in `.blueprint.json` by including the paths to the missing libraries:

```json
{
  ...
  "dockerslim_command": "--http-probe=false --exec 'npm install' --include-path '/usr/bin/jq' --include-path '/usr/lib/libonig.so.5' --include-path '/usr/lib/libonig.so.5.1.0'"
}
```

### Using a `paths.txt` File

In the above example, we use `--include-path` to specify each file we want to include in the optimized Docker image. If you are ever including more than a couple includes, you should instead create a line return seperated list of paths to preserve in a file named `paths.txt`. You can then include the paths in the `"dockerslim_command"` by using utilizing `--preserve-path-file`. The `"dockerslim_command"` above would then look like this if you create the `paths.txt` file:

```json
{
  ...
  "dockerslim_command": "--http-probe=false --exec 'npm install' --preserve-path-file 'paths.txt'"
}
```

### Updating the `.blueprint.json` File

The `.blueprint.json` file stores some of the information required to automatically generate, scaffold, and update this repository when `bash .start.sh` is run. When creating a new Dockerfile project, the `.blueprint.json` file must be filled out. The following chart details the possible data that you can populate `.blueprint.json` with:

| Variable                | Description                                                                                                                                                                                                                                                                               |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `badge_style`           | Badge style to use from shields.io when generating the documentation.                                                                                                                                                                                                                     |
| `description_template`  | Only necessary for for projects injecting size information into the description in `package.json` (e.g. the text that says "Only 5.37 MB!"). When you add the text `IMAGE_SIZE_PLACEHOLDER` to this variable, it will be replaced with container size information.                        |
| `docker_command`        | The command that you would normally run when using the tool. For Ansible Lint this command would just be `ansible-lint`. However, for YAML Lint this command would be `yamllint .` (notice how a period comes after the command).                                                         |
| `docker_command_alias`  | Used for generating the documentation for running the Docker container via a bash alias. This variable is the function name. For YAML Lint, this would be `yamllint` (notice how the period is removed when comparing to the above command since `yamllint .` cannot be a function name). |
| `dockerhub_description` | The short description of the project. This is shown on DockerHub and has a limit of 100 characters.                                                                                                                                                                                       |
| `dockerslim_command`    | The arguments passed to DockerSlim when generating a slim build. \*\*Any \ included in this string must be added as \\\*\*.                                                                                                                                                               |
| `preferred_tag`         | In general, this should either be `latest` or `slim`. This is the tag that is used to generate the parts of the documentation that refer to specific Docker image tags.                                                                                                                   |
| `pretty_name`           | The full (pretty) name of the tool (used for generating documentation).                                                                                                                                                                                                                   |
| `project_title`         | The title of the project - this controls the title of the README.md and will generally be the same as the `pretty_name`.                                                                                                                                                                  |
| `slug`                  | The slug is found by looking at the URL of the repository (e.g. for Ansible Lint, the slug would be `ansible-lint` since the last part of [this URL](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/ansible-lint) is ansible-lint).                                              |
| `slug_full`             | This variable is populated by `.start.sh` by combining the `subgroup` and `slug` variables.                                                                                                                                                                                               |
| `subgroup`              | The subgroup is found by looking at the second to last part of the URL of the repository (e.g. for Ansible Lint the subgroup would be `ci-pipeline`).                                                                                                                                     |

When populating the `.blueprint.json` file, it is a good idea to check out [repositories in the same group](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline) to see what variables are being utilized.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#creating-a-new-dockerfile-project)

## ➤ Creating a New Dockerfile Project

If you are creating a new Dockerfile project, you should first populate the `.blueprint.json` file as described above. After you have a `.blueprint.json` in the root of the project, you should also copy the `.start.sh` file from another one of our Dockerfile projects. With the files in place, you can then run `bash .start.sh`. This will copy over all the other files and set up the project. You should then:

1. Rename the `"name"` field to the desired image name (e.g. `megabytelabs/**name**:slim`).
2. Code your Dockerfile
3. Create a test case for your Dockerfile (more details are in the [Creating Test Cases](#creating-test-cases) section)
4. Test your Dockerfile by running `npm run test`
5. Build your Dockerfile after you finish coding it using `npm run build`
6. After everything is completely done, test the complete flow by running `npm run publish`

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#testing)

## ➤ Testing

Testing is an **extremely important** part of contributing to this project. Before opening a merge request, **you must test all common use cases of the Docker image**. This should be relatively straight-forward. You should be able to run all of the commands described by `npm run info` successfully.

### Creating Test Cases

`npm run test` will test several elements of the project. It will lint the Dockerfile, lint shell scripts, and run the file in `./test/test.sh`. The test case, defined in `test.sh`, is mainly for testing that slim builds work as expected but should also be utilized across all of our Dockerfile projects. In a standard test for a project with a slim build, you should compare the output of a command run against a regular build and a test build. You can accomplish this by using code similar to the following:

**`./test/test.sh`**

```bash
#!/bin/bash

cd ./test/example || exit 1
echo "Testing latest image"
LATEST_OUTPUT=$(docker run -v "${PWD}:/work" -w /work megabytelabs/ansible-lint:latest ansible-lint)
echo "Testing slim image"
SLIM_OUTPUT=$(docker run -v "${PWD}:/work" -w /work megabytelabs/ansible-lint:slim ansible-lint)
if [ "$LATEST_OUTPUT" == "$SLIM_OUTPUT" ]; then
  echo "Slim image appears to be working"
  exit 0
else
  echo "Slim image output differs from latest image output"
  exit 1
fi
```

**Note: The test.sh file is now created from a template. To make sure it gets generated, you should create the `test/` folder in the root of the project and then run `bash .start.sh`. The template version of `test.sh` will recursively loop through all of the folders inside the `test/` folder unlike the example above which only tests the `test/example/` scenario.**

The above script, combined with some dummy data in `test/example/`, will properly validate that the slim build is working the same way the regular build is working. If no `test/` folder exists in the root of the repository, then the test step will be removed from `package.json`. We prefer you create a test that validates that the container is working whenever possible but in some cases it might not be necessary especially when there is no slim version. For a full example of implementing a test, please see the [Ansible Lint repository](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/ansible-lint).

### Testing DockerSlim Builds

It is especially important to test DockerSlim builds. DockerSlim works by removing all the components in a container's operating system that it thinks are unnecessary. This can easily break things.

For example, if you are testing a DockerSlim build that packages [ansible-lint](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/ansible-lint) into a slim container, you might be tempted to simply test it by running `docker exec -it MySlimAnsibleLint ansible-lint`. This will ensure that the ansible-lint command can be accessed but that is not enough. You should also test it by passing in files as a volume and command line arguments. You can see an [example of this in the Ansible Lint repository](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/ansible-lint).

It is **important** to test all common use cases. Some people might be using the `ansible-lint` container in CI where the files are injected into the Docker container and some people might be using an inline command to directly access ansible-lint from the host.

### Testing Web Apps

When testing Docker-based web applications, ensure that after you destroy the container along with its volumes you can bring the Docker container back up to its previous state using volumes and file mounts. This allows users to periodically update the Docker container while having their settings persist. This requirement is also for disaster recovery.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#linting)

## ➤ Linting

We utilize several different linters to ensure that all our Dockerfile projects use similar design patterns. Linting sometimes even helps spot errors as well. The most important linter for Dockerfile projects is called [Haskell Dockerfile Linter](https://github.com/hadolint/hadolint) (or hadolint). You can install it by utilizing our one-line installation method found in our [hadolint Ansible role](https://gitlab.com/megabyte-labs/ansible-roles/hadolint). In order for a merge request to be accepted, it has to successfully pass hadolint tests. For more information about hadolint, check out the [Haskell Dockerfile Linter GitHub page](https://github.com/hadolint/hadolint).

We also incorporate other linters that are run automatically whenever you commit code (assuming you have run `npm i` in the root of the project). These linters include:

- [Prettier](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/prettier)
- [Shellcheck](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/shellcheck)

Some of the linters are also baked into the CI pipeline. The pipeline will trigger whenever you post a commit to a branch. All of these pipeline tasks must pass in order for merge requests to be accepted. You can check the status of recently triggered pipelines for this project by going to the [CI/CD pipeline page](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/pipelines).

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#pull-requests)

## ➤ Pull Requests

All pull requests should be associated with issues. You can find the [issues board on GitLab](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater/-/issues). The pull requests should be made to [the GitLab repository](https://gitlab.com/megabyte-labs/dockerfile/ci-pipeline/updater) instead of the [GitHub repository](https://github.com/ProfessorManhattan/docker-updater). This is because we use GitLab as our primary repository and mirror the changes to GitHub for the community.

### How to Commit Code

Instead of using `git commit`, we prefer that you use `npm run commit`. You will understand why when you try it but basically it streamlines the commit process and helps us generate better CHANGELOG files.

### Pre-Commit Hook

Even if you decide not to use `npm run commit`, you will see that `git commit` behaves differently because there is a pre-commit hook that installs automatically after you run `npm i` (or `bash .start.sh`). This pre-commit hook is there to test your code before committing and help you become a better coder. If you need to bypass the pre-commit hook, then you may add the `--no-verify` tag at the end of your `git commit` command (e.g. `git commit -m "Commit" --no-verify`).
