#! /bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PROJ_DIR="$(realpath $DIR/..)"

SOURCE=$(git config --get remote.origin.url | sed -e 's/:/\//g'| sed -e 's/ssh\/\/\///g'| sed -e 's/git@/https:\/\//g')
VERSION=$(git describe --tags --exact-match 2>/dev/null ||
  git symbolic-ref -q --short HEAD ||
  git rev-parse --short HEAD)
REVISION=$(git rev-parse --short HEAD)

echo "SOURCE=$SOURCE"
echo "VERSION=$VERSION"
echo "REVISION=$REVISION"

IMG_TAG=${IMG_TAG:-${VERSION}}

echo "IMG_NAME=$IMG_NAME"
echo "IMG_REGISTRY=$IMG_REGISTRY"
echo "IMG_TAG=$IMG_TAG"
