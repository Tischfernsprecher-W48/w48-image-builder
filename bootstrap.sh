#!/bin/bash

set -x


SOURCEDIR=$(dirname $0)

vmdebootstrap \
    --verbose \
    --arch armhf \
    --distribution stretch \
    --mirror file:///mnt/mirror/raspbian \
    --image raspbian.img \
    --size 2500M \
    --bootsize 64M \
    --boottype vfat \
    --roottype ext4 \
    --hostname w48 \
    --root-password w48 \
    --no-lock-root-password \
    --user=w48/w48 \
    --sudo \
    --verbose \
    --no-kernel \
    --no-extlinux \
    --foreign /usr/bin/qemu-arm-static \
    --debootstrapopts="keyring=$SOURCEDIR/src/raspbian.org.gpg" \
    --debootstrapopts="verbose" \
    --customize "$SOURCEDIR/customize.sh"


err=0
report() {
        err=1
        echo -n "error at line ${BASH_LINENO[0]}, in call to "
        sed -n ${BASH_LINENO[0]}p $0
} >&2
trap report ERR

exit $err
