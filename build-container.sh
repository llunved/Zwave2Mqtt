#!/bin/bash

set +x

FEDORA_RELEASE=${FEDORA_RELEASE:-$(grep VERSION_ID /etc/os-release | cut -d '=' -f 2)}
FEDORA_IMAGE_RT=${FEDORA_IMAGE_BUILD:-"registry.fedoraproject.org/fedora"}
FEDORA_IMAGE_RT=${FEDORA_IMAGE_RT:-"registry.fedoraproject.org/fedora-minimal"}
BUILD_ID=${BUILD_ID:-`date +%s`}
PUSHREG=${PUSHREG:-""}

echo sudo podman build --build-arg FEDORA_RELEASE=${FEDORA_RELEASE} --build-arg FEDORA_IMAGE_BUILD=${FEDORA_IMAGE_BUILD} --build-arg FEDORA_IMAGE_RT=${FEDORA_IMAGE_RT} -t ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} -f Dockerfile.Fedora
sudo podman build --build-arg FEDORA_RELEASE=${FEDORA_RELEASE} --build-arg FEDORA_IMAGE_RT=${FEDORA_IMAGE_RT} -t ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} -f Dockerfile.Fedora
echo sudo  podman tag ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} ${BUILD_ARCH}/zwave2mqtt:latest
sudo podman tag ${BUILD_ARCH}/zwave2mqtt:${BUILD_ID} ${BUILD_ARCH}/zwave2mqtt:latest

if [ $? -eq 0 ]; then
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

