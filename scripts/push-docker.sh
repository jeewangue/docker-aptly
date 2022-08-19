#! /bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJ_DIR="$( realpath $DIR/.. )"
source $DIR/base-docker.sh

docker push ${IMG_REGISTRY}/${IMG_NAME}:${IMG_TAG}

