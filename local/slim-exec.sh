#!/bin/bash
useradd -m -s /bin/bash hawkwood
sudo chown -Rf hawkwood:hawkwood ./
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
alias poetry="true"
bash slim-start.sh
