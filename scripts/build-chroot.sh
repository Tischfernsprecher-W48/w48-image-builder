#!/bin/bash



function start_init {
# run unmount on exit
#trap unmount_chroot SIGHUP SIGINT SIGTERM
CUR_DIR=$( pwd )
export MY_CHROOT=$CUR_DIR/chroot
mkdir -p $MY_CHROOT
}

function bootstrap {
tput setaf 2
echo "Bootstrap"
tput setaf 3
if [ ! -d "backup_w48" ]; then
debootstrap --arch i386 stretch $MY_CHROOT http://deb.debian.org/debian/
else
cp -vaf backup_w48/chroot .
fi
}

function config_chroot {
tput setaf 2
echo "chroot einrichten"
tput setaf 4
echo "proc $MY_CHROOT/proc proc defaults 0 0" >> /etc/fstab
mount proc $MY_CHROOT/proc -t proc
echo "sysfs $MY_CHROOT/sys sysfs defaults 0 0" >> /etc/fstab
mount sysfs $MY_CHROOT/sys -t sysfs
cp -vf /etc/hosts $MY_CHROOT/etc/hosts
cp -vf /proc/mounts $MY_CHROOT/etc/mtab
# build scripte kopieren
cp -vf $CUR_DIR/scripts/build-cross.sh $MY_CHROOT/usr/src
cp -vf $CUR_DIR/scripts/build-rpi-packages.sh $MY_CHROOT/usr/src
}

function copy_cross_src {
tput setaf 2
echo "Dateien kopieren"
tput setaf 3
if [ -d "$CUR_DIR/backup_w48" ]; then
cp -vaf $CUR_DIR/backup_w48/binutils-2.28 $MY_CHROOT/usr/src
cp -vaf $CUR_DIR/backup_w48/gcc-6.3.0 $MY_CHROOT/usr/src
cp -vaf $CUR_DIR/backup_w48/gcc-8.1.0 $MY_CHROOT/usr/src
cp -vaf $CUR_DIR/backup_w48/glibc-2.24 $MY_CHROOT/usr/src
cp -vaf $CUR_DIR/backup_w48/linux $MY_CHROOT/usr/src
fi
}

function run_chroot {
tput setaf 2
echo "Zu chroot wechseln"
tput setaf 7
#chroot $MY_CHROOT /bin/bash
chroot $MY_CHROOT /bin/bash /usr/src/build-cross.sh
chroot $MY_CHROOT /bin/bash /usr/src/build-rpi-packages.sh

#chroot $MY_CHROOT /bin/bash

}

function umount_chroot {
umount $MY_CHROOT/proc
umount $MY_CHROOT/sys
}


start_init
bootstrap
config_chroot
copy_cross_src
run_chroot
umount_chroot



if [ ! -z "$1" ]; then
    if declare -f "$1" > /dev/null; then
      # call arguments verbatim
      "$@"
    exit 0
    else
      echo "'$1' is not a known. Try:" >&2
      cat $0 | grep function | awk -F ' ' '{print $2}' | head -n -2
    fi
else
  # Show a helpful error
  echo "Try:" >&2
  cat $0 | grep function | awk -F ' ' '{print $2}' | head -n -2
  exit 1
fi

