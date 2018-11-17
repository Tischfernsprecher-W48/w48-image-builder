#!/bin/bash

function start_init {

BDIR=/usr/src
export BDIR=/usr/src
mkdir -p $BDIR/.build
}


function print_help {
    echo "Help"

}

function build-all {
#build-all : w48-image-builder changemac_deb_rpi mkversion_deb_rpi w48-WebGUI_deb mkversion_deb_rpi w48rebootd_deb_rpi w48phpcmd_deb_rpi w48conf_deb_rpi lib-alsa_bin_rpi libupnp_bin_rpi wiringpi_bin_rpi w48play_deb_rpi w48upnpd_deb_rpi w48d_deb_rpi w48-image-builder_bin
        echo "Fertig"
}


function download-all {
    cd $BDIR
    if [ ! -f "backup_w48" ]; then
        git clone https://github.com/Sven-Moennich/iperfd.git
        git clone https://github.com/Sven-Moennich/w48upnpd.git
        git clone https://github.com/Sven-Moennich/wiringpi.git
        git clone https://github.com/Sven-Moennich/w48keygen.git
        git clone https://github.com/Sven-Moennich/changemac.git
        git clone https://github.com/Sven-Moennich/w48ddnsd.git
        git clone https://github.com/Sven-Moennich/w48d.git
        git clone https://github.com/Sven-Moennich/w48play.git
        git clone https://github.com/Sven-Moennich/w48conf.git
        git clone https://github.com/Sven-Moennich/lib-alsa.git
        git clone https://github.com/Sven-Moennich/w48rebootd.git
        git clone https://github.com/Sven-Moennich/w48phpcmd.git
        git clone https://github.com/Sven-Moennich/mkpasswd.git
        git clone https://github.com/Sven-Moennich/libupnp.git
        git clone https://github.com/Sven-Moennich/create_ap.git
        git clone https://github.com/Sven-Moennich/raspi-config.git
    fi

    echo "dl_all"
}


function clean {

        rm -rf  w48rebootd
        rm -rf  changemac
        rm -rf  w48-WebGUI
        rm -rf  w48phpcmd
        rm -rf  w48-image-builder
        rm -rf  w48d
        rm -rf  libupnp
        rm -rf  w48upnpd
        rm -rf  mkversion
        rm -rf  w48play
        rm -rf  mkpasswd
        rm -rf  wiringpi
        rm -rf  gcc_all
        rm -rf  w48conf
        rm -f *.deb
        rm -rf  lib-alsa
        rm -rf  cross
        rm -rf $BDIR/cross-pi-gcc
        rm -rf $BDIR/cross-pi-gcc-6.3.0
        rm -rf $BDIR/cross-pi-libs
#       rm -rf $BDIR/gcc-8.1.0
        rm -f *.ok
}



############################################################################
####################################### w48-WebGUI
function dl_w48-WebGUI {
    if [ -f $BDIR/.build/w48-WebGUI.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/w48-WebGUI.git

    touch $BDIR/w48-WebGUI.ok
}

function build_w48-WebGUI_deb {
    if [ ! -f $BDIR/.build/w48-WebGUI.ok ]; then $0 dl_w48-WebGUI; fi
    if [ -f $BDIR/.build/w48-WebGUI_deb.ok ]; then return; fi
    cd $BDIR/w48-WebGUI 

    ./mkdeb.sh 4

    touch $BDIR/w48-WebGUI_deb.ok
}

#######################################################################
##################################### w48conf
function dl_changemac {
    if [ -f $BDIR/.build/changemac.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/changemac.git

    touch $BDIR/changemac.ok
}

function build_changemac {
    if [ ! -f $BDIR/.build/changemac.ok ]; then $0 dl_changemac; fi
    if [ -f $BDIR/.build/changemac_bin.ok ]; then return; fi
    cd $BDIR/changemac 

    make

    touch $BDIR/changemac_bin.ok
}



#######################################################################
##################################### w48conf
function dl_w48conf {
    if [ -f $BDIR/.build/w48conf.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/w48conf.git

    touch $BDIR/w48conf.ok
}

function build_w48conf {
    if [ ! -f $BDIR/.build/w48conf.ok ]; then $0 dl_w48conf; fi
    if [ -f $BDIR/.build/w48conf_bin.ok ]; then return; fi
    cd $BDIR/w48conf 

    make

    touch $BDIR/w48conf_bin.ok
}


function build_w48conf_deb {

    cd $BDIR/w48conf 

    ./mkdeb.sh 4

    touch $BDIR/w48conf_deb.ok
}


#######################################################################
##################################### lib-alsa ToDo

function dl_libalsa {
    if [ -f $BDIR/.build/libalsa.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/lib-alsa.git

    touch $BDIR/lib-alsa.ok
}

function build_libalsa {
    if [ ! -f $BDIR/.build/libalsa.ok ]; then $0 dl_libalsa; fi
    if [ -f $BDIR/.build/libalsa_bin.ok ]; then return; fi
    cd $BDIR/lib-alsa 

    ./configure -prefix=/usr/local  --host=arm-linux-gnueabihf  CC=arm-linux-gnueabihf-gcc CPPFLAGS="-I$BDIR/cross-pi-gcc/arm-linux-gnueabihf/include/" LDFLAGS="-Wl,-rpath-link=$BDIR/cross-pi-gcc/arm-linux-gnueabihf/lib/ -L$BDIR/cross-pi-gcc/arm-linux-gnueabihf/lib/" LIBS="-lc"
    make 
    make install

    touch $BDIR/lib-alsa_bin_rpi.ok
}

function build_libalsa_deb {
    echo "ToDo"
#$BDIR/
}
#####################################################################
##################################### w48play

function dl_w48play {
    if [ -f $BDIR/.build/w48play.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/w48play.git

    touch $BDIR/w48play.ok
}

function build_w48play {
    if [ ! -f $BDIR/.build/w48play.ok ]; then $0 dl_w48play; fi
    if [ -f $BDIR/.build/w48play_bin.ok ]; then return; fi
    cd $BDIR/w48play

    make

    touch $BDIR/w48play_bin.ok
}

function build_w48play_deb {
    cd $BDIR/w48play

    ./mkdeb.sh 4

    touch $BDIR/w48play_deb.ok
}


########################################################################
##################################### w48upnpd
function dl_w48upnpd {
    if [ -f $BDIR/.build/w48upnpd.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/w48upnpd.git

    touch $BDIR/w48upnpd.ok
}

function build_w48upnpd {
    if [ ! -f $BDIR/.build/w48upnpd.ok ]; then $0 dl_w48upnpd; fi
    if [ -f $BDIR/.build/w48upnpd_bin.ok ]; then return; fi
    cd $BDIR/w48upnpd

    make

    touch $BDIR/w48upnpd_bin.ok
}

function build_w48upnpd_deb {
    cd $BDIR/w48upnpd

    ./mkdeb.sh 4

    touch $BDIR/w48upnpd_deb.ok
}


###########################################################################
##################################### w48rebootd
function dl_w48rebootd {
    if [ -f $BDIR/.build/w48rebootd.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/w48rebootd.git

    touch $BDIR/w48rebootd.ok
}

function build_w48rebootd {
    if [ ! -f $BDIR/.build/w48rebootd.ok ]; then $0 dl_w48rebootd; fi
    if [ -f $BDIR/.build/w48rebootd_bin.ok ]; then return; fi
    cd w48rebootd && make



    touch $BDIR/w48rebootd_bin.ok
}

function build_w48rebootd_deb {

    cd $BDIR/w48rebootd 

    ./mkdeb.sh 4

    touch $BDIR/w48rebootd_deb.ok
}


###########################################################################
##################################### w48phpcmd
function dl_w48phpcmd {
    if [ -f $BDIR/.build/w48phpcmd.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/w48phpcmd.git

    touch $BDIR/w48phpcmd.ok
}

function build_w48phpcmd {
    if [ ! -f $BDIR/.build/w48phpcmd.ok ]; then $0 dl_w48phpcmd; fi
    if [ -f $BDIR/.build/w48phpcmd_bin.ok ]; then return; fi
    cd w48phpcmd && make

    touch $BDIR/w48phpcmd_bin.ok
}

function build_w48phpcmd_deb {
    cd $BDIR/w48phpcmd

    ./mkdeb.sh 4

    touch $BDIR/w48phpcmd_deb.ok
}


############################################################################
##################################### libupnp
function dl_libupnp {
    if [ -f $BDIR/.build/libupnp.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/libupnp.git

    touch $BDIR/libupnp.ok
}

function build_libupnp {
    if [ ! -f $BDIR/.build/libupnp.ok ]; then $0 dl_libupnp; fi
    if [ -f $BDIR/.build/libupnp_bin.ok ]; then return; fi
    cd $BDIR/libupnp 

    ./configure -prefix=/usr/local --host=arm-linux-gnueabihf  CC=arm-linux-gnueabihf-gcc CPPFLAGS="-I$BDIR/cross-pi-gcc/arm-linux-gnueabihf/include/" LDFLAGS="-Wl,-rpath-link=$BDIR/cross-pi-gcc/arm-linux-gnueabihf/lib/ -L$BDIR/cross-pi-gcc/arm-linux-gnueabihf/lib/" LIBS="-lc"
    make
    make install
#       mkdir -p w48-image-builder/src/usr/local/include/
#       mkdir -p w48-image-builder/src/usr/local/lib/
#       cp -r /usr/local/include/* w48-image-builder/src/usr/local/include/
#       cp -r /usr/local/lib/* w48-image-builder/src/usr/local/lib/
    touch $BDIR/libupnp_bin.ok
}

function build_libupnp_deb {
    echo "ToDo"
}
############################################################################
##################################### wiringpi
function dl_wiringpi {
    if [ -f $BDIR/.build/wiringpi.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/wiringpi.git

    touch $BDIR/wiringpi.ok
}

function build_wiringpi {
    if [ ! -f $BDIR/.build/wiringpi.ok ]; then $0 dl_wiringpi; fi
    if [ -f $BDIR/.build/wiringpi_bin.ok ]; then return; fi
    cd $BDIR/wiringpi 

    ./build

    touch $BDIR/wiringpi_bin.ok
}

function build_wiringpi_deb {
    echo "ToDo"
}

############################################################################
##################################### w48d
function dl_w48d {
    if [ -f $BDIR/.build/w48d.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/w48d.git

    touch $BDIR/w48d.ok
}

function build_w48d {
    if [ ! -f $BDIR/.build/w48d.ok ]; then $0 dl_w48d; fi
    if [ -f $BDIR/.build/w48d_bin.ok ]; then return; fi
    cd $BDIR/w48d

    make

    touch $BDIR/w48d_bin.ok
}

function build_w48d_deb {

    cd $BDIR/w48d

    ./mkdeb.sh 4

    touch $BDIR/w48d_deb.ok
}


###########################################################################
######################################## mkversion

function dl_mkversion {
    if [ -f $BDIR/.build/mkversion.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/mkversion.git

    touch $BDIR/mkversion.ok
}

function build_mkversion {
    if [ ! -f $BDIR/.build/mkversion.ok ]; then $0 dl_mkversion; fi
    if [ -f $BDIR/.build/mkversion_bin.ok ]; then return; fi
    cd $BDIR/mkversion

    make 
    make install

    touch $BDIR/mkversion_bin.ok
}

function build_mkversion_deb {

    cd $BDIR/mkversion

    ./mkdeb.sh 4

    touch $BDIR/mkversion_deb.ok
}


##########################################################################
######################################### mkpasswd
function dl_mkpasswd {
    if [ -f $BDIR/.build/mkpasswd.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Sven-Moennich/mkpasswd.git

    touch $BDIR/mkpasswd.ok
}


function build_mkpasswd {
    if [ ! -f $BDIR/.build/mkpasswd.ok ]; then $0 dl_mkpasswd; fi
    if [ -f $BDIR/.build/mkpasswd_bin.ok ]; then return; fi
    cd $BDIR/mkpasswd

    make 
    make install

    touch $BDIR/mkpasswd_bin.ok
}

function build_mkpasswd_deb {

    cd $BDIR/mkpasswd 

    ./mkdeb.sh 4

    touch $BDIR/mkpasswd_deb.ok
}






if [ ! -z "$1" ]; 
then
if declare -f "$1" > /dev/null
then
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

