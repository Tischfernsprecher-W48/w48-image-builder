#!/bin/bash

SOURCEDIR=$(dirname $0)

vmdebootstrap \
    --verbose \
    --arch armhf \
    --distribution stretch \
    --mirror http://localhost:3142/archive.raspbian.org/raspbian \
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

