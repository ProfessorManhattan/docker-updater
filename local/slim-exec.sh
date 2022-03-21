#!/bin/bash

# Prevent permissions from messing up
git clone https://gitlab.com/megabyte-labs/ansible-roles/androidstudio.git
cd androidstudio || exit

curl --version
expect --version
gawk --version
git --version
jq --version
exiftool --version
make --version
rsync --version
node --version
python3 --version
yarn --version

if type brew >/dev/null; then
  brew --version
  brew install zsh
fi

if type poetry >/dev/null; then
  poetry about
fi

if type go >/dev/null; then
  go --version
fi

curl -sSL https://gitlab.com/megabyte-labs/common/shared/-/raw/master/common/start.sh > slim-start.sh
bash slim-start.sh || echo "Error occurred while running start script"
