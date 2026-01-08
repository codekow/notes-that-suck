FROM docker.io/library/ubuntu:trusty as builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        git build-essential vim \
        bc dialog sudo \
        curl gawk unzip wget ncurses-dev libssl-dev python-setuptools zlib1g-dev \
        libncurses5 libncurses-dev libmpc-dev \
        libmpfr-dev libgmp3-dev \
        lib32z1 lib32ncurses5-dev \
        flex bison debootstrap debian-keyring debian-archive-keyring qemu-user-static \
        u-boot-tools kmod gcc-arm-none-eabi && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

VOLUME /build
