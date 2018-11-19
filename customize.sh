#!/bin/bash

set -x

set -e


SOURCEDIR=$(dirname $0)/src
ROOTDIR="$1"


# Do not start services during installation.
echo exit 101 > $ROOTDIR/usr/sbin/policy-rc.d
chmod +x $ROOTDIR/usr/sbin/policy-rc.d

# Configure apt.
export DEBIAN_FRONTEND=noninteractive
cat $SOURCEDIR/raspbian.org.gpg | chroot $ROOTDIR apt-key add -
mkdir -p $ROOTDIR/etc/apt/sources.list.d/
mkdir -p $ROOTDIR/etc/apt/apt.conf.d/
echo "Acquire::http { Proxy \"http://localhost:3142\"; };" > $ROOTDIR/etc/apt/apt.conf.d/50apt-cacher-ng
cp -vf $SOURCEDIR/etc/apt/sources.list $ROOTDIR/etc/apt/sources.list
cp -vf $SOURCEDIR/etc/apt/apt.conf.d/50raspi $ROOTDIR/etc/apt/apt.conf.d/50raspi
chroot $ROOTDIR apt-get update

# Regenerate SSH host keys on first boot.
chroot $ROOTDIR apt-get install -y openssh-server rng-tools
rm -f $ROOTDIR/etc/ssh/ssh_host_*
mkdir -p $ROOTDIR/etc/systemd/system
cp -vf $SOURCEDIR/etc/systemd/system/regen-ssh-keys.service $ROOTDIR/etc/systemd/system/regen-ssh-keys.service
chroot $ROOTDIR systemctl enable regen-ssh-keys

# Configure.
cp -vf  $SOURCEDIR/boot/cmdline.txt $ROOTDIR/boot/cmdline.txt
cp -vf $SOURCEDIR/boot/config.txt $ROOTDIR/boot/config.txt
cp -vr $SOURCEDIR/etc/default $ROOTDIR/etc/default
cp -vf $SOURCEDIR/etc/fstab $ROOTDIR/etc/fstab
cp -vf $SOURCEDIR/etc/modules $ROOTDIR/etc/modules
cp -vf $SOURCEDIR/etc/network/interfaces $ROOTDIR/etc/network/interfaces

FILE="$SOURCEDIR/config/authorized_keys"
if [ -f $FILE ]; then
    echo "Adding authorized_keys."
    mkdir -p $ROOTDIR/root/.ssh/
    cp -vf $FILE $ROOTDIR/root/.ssh/
else
    echo "No authorized_keys, allowing root login with password on SSH."
    sed -i "s/.*PermitRootLogin.*/PermitRootLogin yes/" $ROOTDIR/etc/ssh/sshd_config
fi

# Install kernel.
mkdir -p $ROOTDIR/lib/modules
chroot $ROOTDIR apt-get install -y ca-certificates curl binutils git-core kmod
wget https://raw.github.com/Hexxeh/rpi-update/master/rpi-update -O $ROOTDIR/usr/local/sbin/rpi-update
chmod a+x $ROOTDIR/usr/local/sbin/rpi-update
SKIP_WARNING=1 SKIP_BACKUP=1 ROOT_PATH=$ROOTDIR BOOT_PATH=$ROOTDIR/boot $ROOTDIR/usr/local/sbin/rpi-update


# Install extra packages.
chroot $ROOTDIR apt-get install -y ntp apt-utils whiptail netbase less iputils-ping net-tools isc-dhcp-client man-db
chroot $ROOTDIR apt-get install -y anacron fake-hwclock libnewt0.52 parted triggerhappy lua5.1 alsa-utils

# W48 
chroot $ROOTDIR apt-get install -y asterisk iperf libapache2-mod-php7.0 minidlna wireless-tools wpasupplicant

#apache index.html loeschen
rm -f $ROOTDIR/var/www/html/index.html

# Accesspoint create_ap
chroot $ROOTDIR apt-get install -y util-linux procps hostapd iproute2 iw dnsmasq iptables


# Dev
chroot $ROOTDIR apt-get install -y mc make gcc sudo locales 

# Auto install dependancies on eg. ubuntu server on RPI
chroot $ROOTDIR apt-get install -fy



echo "Europe/Oslo" > $ROOTDIR/etc/timezone 
chroot $ROOTDIR dpkg-reconfigure -f noninteractive tzdata

sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' $ROOTDIR/etc/locale.gen 
sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' $ROOTDIR/etc/locale.gen
echo 'LANG="de_DE.UTF-8"'>$ROOTDIR/etc/default/locale
chroot $ROOTDIR dpkg-reconfigure --frontend=noninteractive locales
chroot $ROOTDIR update-locale LANG=de_DE.UTF-8


# ToDo

# Make chroot for croos build

/bin/bash scripts/./build-chroot.sh build-all

# Libs kopieren ToDo
#cp -r /opt/cross-pi-libs/* $ROOTDIR/

# Pakete suchen und kopioeren ToDo
find $(dirname $0)/chroot/usr/src -name '*.deb' -exec cp -vft $ROOTDIR/usr/src/ {} +



# Pakete installieren
chroot $ROOTDIR  find /usr/src -type f -name "*.deb" -exec dpkg -i "{}" \;


# reinigen
chroot $ROOTDIR rm -rf /usr/src/*.deb


# Konfiguration kopieren
cp -vr $SOURCEDIR/etc/* $ROOTDIR/etc/
cp -vr $SOURCEDIR/lib/* $ROOTDIR/lib/
cp -vr $SOURCEDIR/usr/* $ROOTDIR/usr/
cp -vr $SOURCEDIR/var/* $ROOTDIR/var/



# Create a swapfile.
#dd if=/dev/zero of=$ROOTDIR/var/swapfile bs=1M count=512
#chroot $ROOTDIR mkswap /var/swapfile
#echo /var/swapfile none swap sw 0 0 >> $ROOTDIR/etc/fstab

# Done.
rm $ROOTDIR/usr/sbin/policy-rc.d
rm $ROOTDIR/etc/apt/apt.conf.d/50apt-cacher-ng

# errorhandling
err=0
report() {
        err=1
        echo -n "error at line ${BASH_LINENO[0]}, in call to "
        sed -n ${BASH_LINENO[0]}p $0
} >&2
trap report ERR

exit $err
