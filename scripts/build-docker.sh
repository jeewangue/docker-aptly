#! /bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PROJ_DIR="$(realpath $DIR/..)"
source $DIR/base-docker.sh

BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

docker build \
  -f Dockerfile \
  --label org.opencontainers.image.source=${SOURCE} \
  --label org.opencontainers.image.created=${BUILD_DATE} \
  --label org.opencontainers.image.version=${VERSION} \
  --label org.opencontainers.image.revision=${REVISION} \
  -t ${IMG_NAME}:${IMG_TAG} $PROJ_DIR

docker tag ${IMG_NAME}:${IMG_TAG} ${IMG_REGISTRY}/${IMG_NAME}:${IMG_TAG}
