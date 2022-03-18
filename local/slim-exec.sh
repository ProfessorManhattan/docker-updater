#!/bin/bash

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
