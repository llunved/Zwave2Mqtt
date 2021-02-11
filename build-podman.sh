#!/bin/bash

set +x

OS_RELEASE=${OS_RELEASE:-$(grep VERSION_ID /etc/os-release | cut -d '=' -f 2)}
OS_IMAGE=${OS_IMAGE:-"registry.fedoraproject.org/fedora:${OS_RELEASE}"}
BUILD_ID=${BUILD_ID:-`date +%s`}
BUILD_ARCH=${BUILD_ARCH:-`uname -m`}
PUSHREG=${PUSHREG:-""}

echo sudo podman build --build-arg OS_RELEASE=${OS_RELEASE} --build-arg OS_IMAGE=${OS_IMAGE} -t ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} -f Containerfile
sudo podman build --build-arg OS_RELEASE=${OS_RELEASE} --build-arg OS_IMAGE=${OS_IMAGE} -t ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} -f Containerfile


if [ $? -eq 0 ]; then
  echo sudo  podman tag ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} ${BUILD_ARCH}/zwave2mqtt:latest
  sudo podman tag ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} ${BUILD_ARCH}/zwave2mqtt:latest

  if [ ! -z "${PUSHREG}" ]; then
    echo sudo podman tag ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} ${PUSHREG}/${BUILD_ARCH}/zwave2mqtt:${BUILD_ID}
    sudo podman tag ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} ${PUSHREG}/${BUILD_ARCH}/zwave2mqtt:${BUILD_ID}
    echo sudo podman push ${PUSHREG}/${BUILD_ARCH}/zwave2mqtt:${BUILD_ID}
    sudo podman push ${PUSHREG}/${BUILD_ARCH}/zwave2mqtt:${BUILD_ID}
    echo sudo podman tag ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} ${PUSHREG}/${BUILD_ARCH}/zwave2mqtt:latest
    sudo podman tag ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} ${PUSHREG}/${BUILD_ARCH}/zwave2mqtt:latest
    echo sudo podman push ${PUSHREG}/${BUILD_ARCH}/zwave2mqtt:latest
    sudo podman push ${PUSHREG}/${BUILD_ARCH}/zwave2mqtt:latest
  fi
fi

