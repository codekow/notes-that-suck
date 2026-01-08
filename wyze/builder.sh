#!/bin/sh

getenforce && SELINUX=':z'
which podman && alias docker=podman

# docker rm firmware-builder -f

docker build \
  -t localhost/firmware-builder \
  -f wyze/Dockerfile

docker run -it --rm \
  --name firmware-builder \
  -v $(pwd):/build${SELINUX} \
  --privileged \
  --replace \
  localhost/firmware-builder
