#!/bin/bash

function print_help {
    echo "Help"
}

function build-all {
#build-all : w48-image-builder changemac_deb_rpi mkversion_deb_rpi w48-WebGUI_deb mkversion_deb_rpi w48rebootd_deb_rpi w48phpcmd_deb_rpi w48conf_deb_rpi lib-alsa_bin_rpi libupnp_bin_rpi wiringpi_bin_rpi w48play_deb_rpi w48upnpd_deb_rpi w48d_deb_rpi w48-image-builder_bin
        echo "Fertig"
}


function download-all {
#download-all : w48conf w48play w48upnpd w48rebootd w48phpcmd libupnp wiringpi w48d w48-image-builder w48-WebGUI mkversion mkpasswd lib-alsa
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
        rm -rf /opt/cross-pi-gcc
        rm -rf /opt/cross-pi-gcc-6.3.0
        rm -rf /opt/cross-pi-libs
#       rm -rf /opt/gcc-8.1.0
        rm -f *.ok
}


#############################################################################
###################################### w48-image-builder
function dl_w48-image-builder {
        git clone https://github.com/Sven-Moennich/w48-image-builder.git
        touch w48-image-builder.ok
}

function build_w48-image-builder {
        cd w48-image-builder && make image
        touch w48-image-builder_bin.ok
}


############################################################################
####################################### w48-WebGUI
function dl_w48-WebGUI {
        git clone https://github.com/Sven-Moennich/w48-WebGUI.git
        touch w48-WebGUI.ok
}

function build_w48-WebGUI_deb {
        cd w48-WebGUI && ./mkdeb.sh 4
        touch w48-WebGUI_deb.ok
}

#######################################################################
##################################### w48conf
function dl_changemac {
        git clone https://github.com/Sven-Moennich/changemac.git
        touch changemac.ok
}

function build_changemac {
        cd changemac && make
        touch changemac_bin.ok
}

function build_changemac {
        cd changemac && ./mkdeb.sh 4
        touch changemac_deb.ok
}



#######################################################################
##################################### w48conf
function dl_w48conf {
        git clone https://github.com/Sven-Moennich/w48conf.git
        touch w48conf.ok
}

function build_w48conf {
        cd w48conf && make
        touch w48conf_bin.ok
}


function build_w48conf_deb {
        cd w48conf && ./mkdeb.sh 4
        touch w48conf_deb.ok
}


#######################################################################
##################################### lib-alsa ToDo

function dl_libalsa {
        git clone https://github.com/Sven-Moennich/lib-alsa.git
        touch lib-alsa.ok
}

function build_libalsa {
        cd lib-alsa && ./configure -prefix=/opt/cross-pi-libs  --host=arm-linux-gnueabihf  CC=arm-linux-gnueabihf-gcc CPPFLAGS="-I/opt/cross-pi-gcc/arm-linux-gnueabihf/include/" LDFLAGS="-Wl,-rpath-link=/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/ -L/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/" LIBS="-lc"
        cd lib-alsa && make 
        cd lib-alsa && make install
        touch lib-alsa_bin_rpi.ok
}

function build_libalsa_deb {
    echo "ToDo"
}
#####################################################################
##################################### w48play

function dl_w48play {
        git clone https://github.com/Sven-Moennich/w48play.git
        touch w48play.ok
}

function build_w48play {
        cd w48play && make
        touch w48play_bin.ok
}

function build_w48play_deb {
        cd w48play && ./mkdeb.sh 4
        touch w48play_deb.ok
}


########################################################################
##################################### w48upnpd
function dl_w48upnpd {
        git clone https://github.com/Sven-Moennich/w48upnpd.git
        touch w48upnpd.ok
}

function build_w48upnpd {
        cd w48upnpd && make
        touch w48upnpd_bin.ok
}

function build_w48upnpd_deb {
        cd w48upnpd && ./mkdeb.sh 4
        touch w48upnpd_deb.ok
}


###########################################################################
##################################### w48rebootd
function dl_w48rebootd {
        git clone https://github.com/Sven-Moennich/w48rebootd.git
        touch w48rebootd.ok
}

function build_w48rebootd {
        cd w48rebootd && make
        touch w48rebootd_bin.ok
}

function build_w48rebootd_deb {
        cd w48rebootd && ./mkdeb.sh 4
        touch w48rebootd_deb.ok
}


###########################################################################
##################################### w48phpcmd
function dl_w48phpcmd {
        git clone https://github.com/Sven-Moennich/w48phpcmd.git
        touch w48phpcmd.ok
}

function build_w48phpcmd {
        cd w48phpcmd && make
        touch w48phpcmd_bin.ok
}

function build_w48phpcmd_deb {
        cd w48phpcmd && ./mkdeb.sh 4
        touch w48phpcmd_deb.ok
}


############################################################################
##################################### libupnp
function dl_libupnp {
        git clone https://github.com/Sven-Moennich/libupnp.git
        touch libupnp.ok
}

function build_libupnp {
        cd libupnp && ./configure -prefix=/opt/cross-pi-libs --host=arm-linux-gnueabihf  CC=arm-linux-gnueabihf-gcc CPPFLAGS="-I/opt/cross-pi-gcc/arm-linux-gnueabihf/include/" LDFLAGS="-Wl,-rpath-link=/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/ -L/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/" LIBS="-lc"
        cd libupnp && make
        cd libupnp && make install
#       mkdir -p w48-image-builder/src/usr/local/include/
#       mkdir -p w48-image-builder/src/usr/local/lib/
#       cp -r /opt/cross-pi-libs/include/* w48-image-builder/src/usr/local/include/
#       cp -r /opt/cross-pi-libs/lib/* w48-image-builder/src/usr/local/lib/
        touch libupnp_bin_rpi.ok
}

function build_libupnp_deb {
    echo "ToDo"
}
############################################################################
##################################### wiringpi
function dl_wiringpi {
        git clone https://github.com/Sven-Moennich/wiringpi.git
        touch wiringpi.ok
}

function build_wiringpi {
        cd wiringpi && ./build
        touch wiringpi_bin.ok
}

function build_wiringpi_deb {
    echo "ToDo"
}

############################################################################
##################################### w48d
function dl_w48d {
        git clone https://github.com/Sven-Moennich/w48d.git
        touch w48d.ok
}

function build_w48d {
        cd w48d && make
        touch w48d_bin.ok
}

function build_w48d_deb {
        cd w48d && ./mkdeb.sh 4
        touch w48d_deb.ok
}


###########################################################################
######################################## mkversion

function dl_mkversion {
        git clone https://github.com/Sven-Moennich/mkversion.git
        touch mkversion.ok
}

function build_mkversion {
        cd mkversion && make && make install
        touch mkversion_bin.ok
}

function build_mkversion_deb {
        cd mkversion && ./mkdeb.sh 4
        touch mkversion_deb.ok
}


##########################################################################
######################################### mkpasswd
function dl_mkpasswd {
        git clone https://github.com/Sven-Moennich/mkpasswd.git
        touch mkpasswd.ok
}


function build_mkpasswd {
        cd mkpasswd && make && make install
        touch mkpasswd_bin.ok
}

function build_mkpasswd_deb {
        cd mkpasswd && ./mkdeb.sh 4
        touch mkpasswd_deb.ok
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

