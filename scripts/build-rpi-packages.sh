#!/bin/bash

set -x

export BDIR=/usr/src

function start_init {

BDIR=/usr/src
export BDIR=/usr/src
mkdir -p $BDIR/.build

apt-get install -y dh-make autoconf libasound2-dev devscripts

}


function print_help {
    echo "Help"

exit 0
}

function build-all {

    start_init

    build_mkversion_deb
    build_mkpasswd_deb

#    build_changemac_deb

    build_w48-WebGUI_deb

    build_w48conf_deb

    build_w48rebootd_deb
    build_w48phpcmd_deb


    build_wiringpi
    build_libupnp
    build_libalsa_deb

    build_libupnp_deb
    build_wiringpi_deb

    build_w48upnpd_deb
    build_w48play_deb

    build_w48d_deb

    echo "Fertig"
}


function download-all {
    cd $BDIR
    if [ ! -f "backup_w48" ]; then
        git clone https://github.com/Tischfernsprecher-W48/iperfd.git
        git clone https://github.com/Tischfernsprecher-W48/w48upnpd.git
        git clone https://github.com/Tischfernsprecher-W48/wiringpi.git
        git clone https://github.com/Tischfernsprecher-W48/w48keygen.git
        git clone https://github.com/Tischfernsprecher-W48/changemac.git
        git clone https://github.com/Tischfernsprecher-W48/w48ddnsd.git
        git clone https://github.com/Tischfernsprecher-W48/w48d.git
        git clone https://github.com/Tischfernsprecher-W48/w48play.git
        git clone https://github.com/Tischfernsprecher-W48/w48conf.git
        git clone https://github.com/Tischfernsprecher-W48/lib-alsa.git
        git clone https://github.com/Tischfernsprecher-W48/w48rebootd.git
        git clone https://github.com/Tischfernsprecher-W48/w48phpcmd.git
        git clone https://github.com/Tischfernsprecher-W48/mkpasswd.git
        git clone https://github.com/Tischfernsprecher-W48/libupnp.git
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
        rm -rf  w48d
        rm -rf  w48upnpd
        rm -rf  mkversion
        rm -rf  w48play
        rm -rf  mkpasswd
        rm -rf  wiringpi
        rm -rf  w48conf
        rm -rf  lib-alsa
        rm -rf  libupnp
        rm -rf .build
}



############################################################################
####################################### w48-WebGUI
function dl_w48-WebGUI {
    if [ -f $BDIR/.build/w48-WebGUI.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/w48-WebGUI.git

    touch $BDIR/.build/w48-WebGUI.ok
}

function build_w48-WebGUI_deb {
    if [ ! -f $BDIR/.build/w48-WebGUI.ok ]; then dl_w48-WebGUI; fi
    if [ -f $BDIR/.build/w48-WebGUI_deb.ok ]; then return; fi
    cd $BDIR/w48-WebGUI 

    ./mkdeb.sh 4

    touch $BDIR/.build/w48-WebGUI_deb.ok
}

#######################################################################
##################################### w48conf
function dl_changemac {
    if [ -f $BDIR/.build/changemac.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/changemac.git

    touch $BDIR/.build/changemac.ok
}

function build_changemac {
    if [ ! -f $BDIR/.build/changemac.ok ]; then dl_changemac; fi
    if [ -f $BDIR/.build/changemac_bin.ok ]; then return; fi
    cd $BDIR/changemac 

    ./configure
    make
    make install
    make clean
    make distclean

    touch $BDIR/.build/changemac_bin.ok
}



#######################################################################
##################################### w48conf
function dl_w48conf {
    if [ -f $BDIR/.build/w48conf.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/w48conf.git

    touch $BDIR/.build/w48conf.ok
}

function build_w48conf {
    if [ ! -f $BDIR/.build/w48conf.ok ]; then dl_w48conf; fi
    if [ -f $BDIR/.build/w48conf_bin.ok ]; then return; fi
    cd $BDIR/w48conf 

    ./configure
    make
    make install
    make clean
    make distclean

    touch $BDIR/.build/w48conf_bin.ok
}


function build_w48conf_deb {
    if [ ! -f $BDIR/.build/w48conf_bin.ok ]; then build_w48conf; fi
    if [ -f $BDIR/.build/w48conf_deb.ok ]; then return; fi
    cd $BDIR/w48conf 

    ./mkdeb.sh 4

    touch $BDIR/.build/w48conf_deb.ok
}


#######################################################################
##################################### lib-alsa ToDo

function dl_libalsa {
    if [ -f $BDIR/.build/libalsa.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/lib-alsa.git

    touch $BDIR/.build/lib-alsa.ok
}

function build_libalsa {
    if [ ! -f $BDIR/.build/libalsa.ok ]; then dl_libalsa; fi
    if [ -f $BDIR/.build/libalsa_bin.ok ]; then return; fi
    cd $BDIR/lib-alsa 

    ./configure -prefix=/usr/local  --host=arm-linux-gnueabihf  CC=arm-linux-gnueabihf-gcc CPPFLAGS="-I$BDIR/cross-pi-gcc/arm-linux-gnueabihf/include/" LDFLAGS="-Wl,-rpath-link=$BDIR/cross-pi-gcc/arm-linux-gnueabihf/lib/ -L$BDIR/cross-pi-gcc/arm-linux-gnueabihf/lib/" LIBS="-lc"
    make 
    make install
    make clean
    make distclean

    touch $BDIR/.build/lib-alsa_bin_rpi.ok
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

    git clone https://github.com/Tischfernsprecher-W48/w48play.git

    touch $BDIR/.build/w48play.ok
}

function build_w48play {
    if [ ! -f $BDIR/.build/libalsa_bin.ok ]; then build_libalsa; fi # Abhaengig von build_libalsa
    if [ ! -f $BDIR/.build/w48play.ok ]; then dl_w48play; fi # Paket schon geladen ?
    if [ -f $BDIR/.build/w48play_bin.ok ]; then return; fi      # Job schon erledigt ?
    cd $BDIR/w48play

    ./configure
    make
    make install
    make clean
    make distclean

    touch $BDIR/.build/w48play_bin.ok
}

function build_w48play_deb {
    if [ ! -f $BDIR/.build/w48play_bin.ok ]; then build_w48play; fi
    if [ -f $BDIR/.build/w48play_deb.ok ]; then return; fi

    cd $BDIR/w48play

    ./mkdeb.sh 4

    touch $BDIR/.build/w48play_deb.ok
}


########################################################################
##################################### w48upnpd
function dl_w48upnpd {
    if [ -f $BDIR/.build/w48upnpd.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/w48upnpd.git

    touch $BDIR/.build/w48upnpd.ok
}

function build_w48upnpd {
    if [ ! -f $BDIR/.build/libupnp_bin.ok ]; then build_libupnp; fi # Abhaengig von build_libupnp
    if [ ! -f $BDIR/.build/w48upnpd.ok ]; then dl_w48upnpd; fi
    if [ -f $BDIR/.build/w48upnpd_bin.ok ]; then return; fi
    cd $BDIR/w48upnpd

    ./configure
    make
    make install
    make clean
    make distclean

    touch $BDIR/.build/w48upnpd_bin.ok
}

function build_w48upnpd_deb {
    if [ ! -f $BDIR/.build/w48upnpd_bin.ok ]; then build_w48upnpd; fi
    if [ -f $BDIR/.build/w48upnpd_deb.ok ]; then return; fi

    cd $BDIR/w48upnpd

    ./mkdeb.sh 4

    touch $BDIR/.build/w48upnpd_deb.ok
}


###########################################################################
##################################### w48rebootd
function dl_w48rebootd {
    if [ -f $BDIR/.build/w48rebootd.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/w48rebootd.git

    touch $BDIR/.build/w48rebootd.ok
}

function build_w48rebootd {
    if [ ! -f $BDIR/.build/w48rebootd.ok ]; then dl_w48rebootd; fi
    if [ -f $BDIR/.build/w48rebootd_bin.ok ]; then return; fi
    cd $BDIR/w48rebootd

    ./configure
    make
    make install
    make clean
    make distclean

    touch $BDIR/.build/w48rebootd_bin.ok
}

function build_w48rebootd_deb {
    if [ ! -f $BDIR/.build/w48rebootd_bin.ok ]; then build_w48rebootd; fi
    if [ -f $BDIR/.build/w48rebootd_deb.ok ]; then return; fi

    cd $BDIR/w48rebootd 

    ./mkdeb.sh 4

    touch $BDIR/.build/w48rebootd_deb.ok
}


###########################################################################
##################################### w48phpcmd
function dl_w48phpcmd {
    if [ -f $BDIR/.build/w48phpcmd.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/w48phpcmd.git

    touch $BDIR/.build/w48phpcmd.ok
}

function build_w48phpcmd {
    if [ ! -f $BDIR/.build/w48phpcmd.ok ]; then dl_w48phpcmd; fi
    if [ -f $BDIR/.build/w48phpcmd_bin.ok ]; then return; fi
    cd $BDIR/w48phpcmd

    ./configure
    make
    make install
    make clean
    make distclean

    touch $BDIR/.build/w48phpcmd_bin.ok
}

function build_w48phpcmd_deb {
    cd $BDIR/w48phpcmd

    ./mkdeb.sh 4

    touch $BDIR/.build/w48phpcmd_deb.ok
}


############################################################################
##################################### libupnp
function dl_libupnp {
    if [ -f $BDIR/.build/libupnp.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/libupnp.git

    touch $BDIR/.build/libupnp.ok
}

function build_libupnp {
    if [ ! -f $BDIR/.build/libupnp.ok ]; then dl_libupnp; fi
    if [ -f $BDIR/.build/libupnp_bin.ok ]; then return; fi
    cd $BDIR/libupnp 

    ./configure -prefix=/usr/local --host=arm-linux-gnueabihf  CC=arm-linux-gnueabihf-gcc CPPFLAGS="-I$BDIR/cross-pi-gcc/arm-linux-gnueabihf/include/" LDFLAGS="-Wl,-rpath-link=$BDIR/cross-pi-gcc/arm-linux-gnueabihf/lib/ -L$BDIR/cross-pi-gcc/arm-linux-gnueabihf/lib/" LIBS="-lc"
    make
    make install
    make clean
    make distclean
#       mkdir -p w48-image-builder/src/usr/local/include/
#       mkdir -p w48-image-builder/src/usr/local/lib/
#       cp -r /usr/local/include/* w48-image-builder/src/usr/local/include/
#       cp -r /usr/local/lib/* w48-image-builder/src/usr/local/lib/
    touch $BDIR/.build/libupnp_bin.ok
}

function build_libupnp_deb {
    echo "ToDo"
}
############################################################################
##################################### wiringpi
function dl_wiringpi {
    if [ -f $BDIR/.build/wiringpi.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/wiringpi.git

    touch $BDIR/.build/wiringpi.ok
}

function build_wiringpi {
    if [ ! -f $BDIR/.build/wiringpi.ok ]; then dl_wiringpi; fi
    if [ -f $BDIR/.build/wiringpi_bin.ok ]; then return; fi
    cd $BDIR/wiringpi 

    ./configure
    make
    make clean
    make distclean

    touch $BDIR/.build/wiringpi_bin.ok
}

function build_wiringpi_deb {
    if [ ! -f $BDIR/.build/wiringpi_bin.ok ]; then build_wiringpi; fi
    if [ -f $BDIR/.build/wiringpi_deb.ok ]; then return; fi
    cd $BDIR/wiringpi

    ./mkdeb.sh 4

    touch $BDIR/.build/wiringpi_deb.ok
}

############################################################################
##################################### w48d
function dl_w48d {
    if [ -f $BDIR/.build/w48d.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/w48d.git

    touch $BDIR/.build/w48d.ok
}

function build_w48d {
    if [ ! -f $BDIR/.build/wiringpi_bin.ok ]; then build_wiringpi; fi # Abhaengig von wiringpi
    if [ ! -f $BDIR/.build/w48d.ok ]; then dl_w48d; fi
    if [ -f $BDIR/.build/w48d_bin.ok ]; then return; fi
    cd $BDIR/w48d

    ./configure
    make
    make clean
    make distclean

    touch $BDIR/.build/w48d_bin.ok
}

function build_w48d_deb {

    cd $BDIR/w48d

    ./mkdeb.sh 4

    touch $BDIR/.build/w48d_deb.ok
}


###########################################################################
######################################## mkversion

function dl_mkversion {
    if [ -f $BDIR/.build/mkversion.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/mkversion.git

    touch $BDIR/.build/mkversion.ok
}

function build_mkversion {
    if [ ! -f $BDIR/.build/mkversion.ok ]; then dl_mkversion; fi
    if [ -f $BDIR/.build/mkversion_bin.ok ]; then return; fi
    cd $BDIR/mkversion

    ./configure
    make 
    make install
    make clean
    make distclean

    touch $BDIR/.build/mkversion_bin.ok
}

function build_mkversion_deb {
    if [ ! -f $BDIR/.build/mkversion_bin.ok ]; then build_mkversion; fi
    if [ -f $BDIR/.build/mkversion_deb.ok ]; then return; fi

    cd $BDIR/mkversion

    ./mkdeb.sh 4

    touch $BDIR/.build/mkversion_deb.ok
}


##########################################################################
######################################### mkpasswd
function dl_mkpasswd {
    if [ -f $BDIR/.build/mkpasswd.ok ]; then return; fi
    cd $BDIR

    git clone https://github.com/Tischfernsprecher-W48/mkpasswd.git

    touch $BDIR/.build/mkpasswd.ok
}


function build_mkpasswd {
    if [ ! -f $BDIR/.build/mkpasswd.ok ]; then dl_mkpasswd; fi
    if [ -f $BDIR/.build/mkpasswd_bin.ok ]; then return; fi
    cd $BDIR/mkpasswd

    ./configure
    make 
    make install
    make clean
    make distclean

    touch $BDIR/.build/mkpasswd_bin.ok
}

function build_mkpasswd_deb {
    if [ ! -f $BDIR/.build/mkpasswd_bin.ok ]; then build_mkpasswd; fi
    if [ -f $BDIR/.build/mkpasswd_deb.ok ]; then return; fi

    cd $BDIR/mkpasswd 

    ./mkdeb.sh 4

    touch $BDIR/.build/mkpasswd_deb.ok
}




err=0
report() {
        err=1
        echo -n "error at line ${BASH_LINENO[0]}, in call to "
        sed -n ${BASH_LINENO[0]}p $0
} >&2
trap report ERR



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
print_help
  exit 1
fi

exit $err
