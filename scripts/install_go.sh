#!/bin/bash
set -euo pipefail

GO_VERSION="1.19"
expected_sha="7e231ea5c68f4be7fea916d27814cc34b95e78c4664c3eb2411e8370f87558bd"

DOWNLOAD_FOLDER=/tmp/Downloads
mkdir -p ${DOWNLOAD_FOLDER}
DOWNLOAD_FILE=${DOWNLOAD_FOLDER}/go${GO_VERSION}.tar.gz

export GoInstallDir="/tmp/go$GO_VERSION"
mkdir -p $GoInstallDir

# Download the archive if we do not have it cached
if [ ! -f ${DOWNLOAD_FILE} ]; then
  # Delete any cached go downloads, since those are now out of date
  rm -rf ${DOWNLOAD_FOLDER}/go*.tar.gz

  #GO_MD5="4577d9ba083ac86de78012c04a2981be"
  #URL=https://buildpacks.cloudfoundry.org/dependencies/go/go${GO_VERSION}.linux-amd64-${GO_MD5:0:8}.tar.gz
  URL="https://buildpacks.cloudfoundry.org/dependencies/go/go_${GO_VERSION}_linux_x64_cflinuxfs3_${expected_sha:0:8}.tgz"
  
  echo "-----> Download go ${GO_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o ${DOWNLOAD_FILE}

  #DOWNLOAD_MD5=$(md5sum ${DOWNLOAD_FILE} | cut -d ' ' -f 1)

  #if [[ $DOWNLOAD_MD5 != $GO_MD5 ]]; then
  #  echo "       **ERROR** MD5 mismatch: got $DOWNLOAD_MD5 expected $GO_MD5"
  #  exit 1
  #fi
else
  echo "-----> go install package available in cache"
fi

if [ ! -f $GoInstallDir/bin/go ]; then
  tar xzf ${DOWNLOAD_FILE} -C $GoInstallDir
fi

if [ ! -f $GoInstallDir/bin/go ]; then
  echo "       **ERROR** Could not download go"
  exit 1
fi
