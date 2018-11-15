#!/bin/bash
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
cp $SOURCEDIR/etc/apt/sources.list $ROOTDIR/etc/apt/sources.list
cp $SOURCEDIR/etc/apt/apt.conf.d/50raspi $ROOTDIR/etc/apt/apt.conf.d/50raspi
chroot $ROOTDIR apt-get update

# Regenerate SSH host keys on first boot.
chroot $ROOTDIR apt-get install -y openssh-server rng-tools
rm -f $ROOTDIR/etc/ssh/ssh_host_*
mkdir -p $ROOTDIR/etc/systemd/system
cp $SOURCEDIR/etc/systemd/system/regen-ssh-keys.service $ROOTDIR/etc/systemd/system/regen-ssh-keys.service
chroot $ROOTDIR systemctl enable regen-ssh-keys

# Configure.
cp $SOURCEDIR/boot/cmdline.txt $ROOTDIR/boot/cmdline.txt
cp $SOURCEDIR/boot/config.txt $ROOTDIR/boot/config.txt
cp -r $SOURCEDIR/etc/default $ROOTDIR/etc/default
cp $SOURCEDIR/etc/fstab $ROOTDIR/etc/fstab
cp $SOURCEDIR/etc/modules $ROOTDIR/etc/modules
cp $SOURCEDIR/etc/network/interfaces $ROOTDIR/etc/network/interfaces

FILE="$SOURCEDIR/config/authorized_keys"
if [ -f $FILE ]; then
    echo "Adding authorized_keys."
    mkdir -p $ROOTDIR/root/.ssh/
    cp $FILE $ROOTDIR/root/.ssh/
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


# Konfiguration kopieren
cp -r $SOURCEDIR/etc/* $ROOTDIR/etc/
cp -r $SOURCEDIR/lib/* $ROOTDIR/lib/
cp -r $SOURCEDIR/usr/* $ROOTDIR/usr/
cp -r $SOURCEDIR/var/* $ROOTDIR/var/

# Libs kopieren
cp -r /opt/cross-pi-libs/* $ROOTDIR/

cp -rf  $SOURCEDIR/../../w48-WebGUI/*.deb     $ROOTDIR/usr/src/
cp -rf $SOURCEDIR/../../w48conf/*.deb         $ROOTDIR/usr/src/
cp -rf $SOURCEDIR/../../w48d/*.deb            $ROOTDIR/usr/src/
cp -rf $SOURCEDIR/../../w48play/*.deb         $ROOTDIR/usr/src/
cp -rf $SOURCEDIR/../../w48upnpd/*.deb        $ROOTDIR/usr/src/
cp -rf $SOURCEDIR/../../w48phpcmd/*.deb       $ROOTDIR/usr/src/
cp -rf $SOURCEDIR/../../w48rebootd/*.deb      $ROOTDIR/usr/src/

cp -f  $SOURCEDIR/../../changemac/changemac   $ROOTDIR/usr/sbin/
cp -f  $SOURCEDIR/../../w48phpcmd/w48phpcmd   $ROOTDIR/usr/sbin/


# Pakete installieren
chroot $ROOTDIR  find /usr/src -type f -name "*.deb" -exec dpkg -i "{}" \;


# reinigen
chroot $ROOTDIR rm /usr/src/*.deb




# Create a swapfile.
#dd if=/dev/zero of=$ROOTDIR/var/swapfile bs=1M count=512
#chroot $ROOTDIR mkswap /var/swapfile
#echo /var/swapfile none swap sw 0 0 >> $ROOTDIR/etc/fstab

# Done.
rm $ROOTDIR/usr/sbin/policy-rc.d
rm $ROOTDIR/etc/apt/apt.conf.d/50apt-cacher-ng
