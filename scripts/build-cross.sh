#!/bin/bash

set -x

BDIR=/usr/src # build dir

function install_dependencies {
######################################################################################
tput setaf 2
echo "First, make sure your system is updated and install the required prerequisites:"
apt-get update
apt-get -y upgrade
apt-get -y install build-essential gawk git texinfo bison flex
}

function create_builddir {
#######################################################################################
tput setaf 2
echo "Step 1"
echo "create a working folder in your home:"
tput setaf 7
mkdir -p $BDIR
}

function download_src {
####################################################################################
tput setaf 2
echo "Let's download the software that we'll use for building the cross compiler:"
echo "Step 2"
tput setaf 7
cd $BDIR
git clone https://github.com/Tischfernsprecher-W48/binutils-2.28.git
git clone https://github.com/Tischfernsprecher-W48/gcc-6.3.0.git
git clone https://github.com/Tischfernsprecher-W48/glibc-2.24.git
git clone https://github.com/Tischfernsprecher-W48/gcc-8.1.0.git
git clone --depth=1 https://github.com/Tischfernsprecher-W48/linux.git
}


function install_prerequisites {
######################
tput setaf 2
echo "GCC also needs some prerequisites which we can download inside the source folder:"
echo "Step 4"
tput setaf 7
cd $BDIR/gcc-6.3.0
contrib/download_prerequisites
rm *.tar.*

cd $BDIR/gcc-8.1.0
contrib/download_prerequisites
rm *.tar.*
}


function create_gcc_binfolder {
######################
tput setaf 2
echo "Step 5"
echo "Next, create a folder in which we'll put the cross compiler and add it to the path:"
tput setaf 7
cd $BDIR
mkdir -p /usr/local
#chown $USER /usr/local
export PATH=/usr/local/bin:$PATH
}

function copy_kernel_header {
#######################
tput setaf 2
echo "Step 5"
echo "Copy the kernel headers in the above folder, see Raspbian documentation for more info about the kernel:"
tput setaf 7
cd $BDIR/linux
KERNEL=kernel7
make ARCH=arm INSTALL_HDR_PATH=/usr/local/arm-linux-gnueabihf headers_install
}

function build_binutils {
######################
tput setaf 2
echo "Next, let's build Binutils:"
tput setaf 3
mkdir -p $BDIR/build-binutils 
cd $BDIR/build-binutils
../binutils-2.28/configure --prefix=/usr/local --target=arm-linux-gnueabihf --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
make -j 8
make install
}


function build_gcc_part1 {
#######################
tput setaf 2
echo "GCC and Glibc are interdependent, you can't fully build one without the other, so we are going to do a partial build of GCC, a partial build of Glibc and finally build GCC and Glibc."
tput setaf 5
mkdir -p $BDIR/build-gcc 
cd $BDIR/build-gcc
../gcc-6.3.0/configure --prefix=/usr/local --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
make -j8 all-gcc
make install-gcc
}


function build_glibc_part1 {
##############################
tput setaf 2
echo "Now, let's partially build Glibc:"
tput setaf 6
mkdir -p cd $BDIR/build-glibc 
cd $BDIR/build-glibc
../glibc-2.24/configure --prefix=/usr/local/arm-linux-gnueabihf --build=$MACHTYPE --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --with-arch=armv6 --with-fpu=vfp --with-float=hard --with-headers=/usr/local/arm-linux-gnueabihf/include --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j8 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o /usr/local/arm-linux-gnueabihf/lib
arm-linux-gnueabihf-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o /usr/local/arm-linux-gnueabihf/lib/libc.so
touch /usr/local/arm-linux-gnueabihf/include/gnu/stubs.h
}


function build_gcc_part2 {
############################
tput setaf 2
echo "Back to GCC:"
tput setaf 5
cd $BDIR/build-gcc
make -j8 all-target-libgcc
make install-target-libgcc
}

function build_glibc {
##############################
tput setaf 2
echo "Finish building Glibc:"
tput setaf 6
cd $BDIR/build-glibc
make -j8
make install
}

function build_gcc_part3 {
#############################
tput setaf 2
echo "Finish building GCC 6.3.0:"
tput setaf 5
cd $BDIR/build-gcc
make -j8
make install
}

function backup_gcc {
#############
tput setaf 2
echo "At this point, you have a full cross compiler toolchain with GCC 6.3.0. Make a backup before proceeding with the next step:"
tput setaf 7
cp -r /usr/local /usr/local-6.3.0
}

function build_gcc8 {
####################################
tput setaf 2
echo "Next, we are going to use the above built Glibc to build a more modern cross compiler that will overwrite 6.3:"
tput setaf 3
mkdir -p $BDIR/build-gcc8 
cd $BDIR/build-gcc8
../gcc-8.1.0/configure --prefix=/usr/local --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
#../gcc-8.1.0/configure --prefix=/usr/local --target=arm-linux-gnueabihf --enable-languages=c,c++ --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
make -j8
make install
}

function build_gcc8_rpi {
################################3
tput setaf 2
echo "At this point, you can use GCC 8.1 to cross compile any C, C++ or Fortran code for your Raspberry Pi."
echo "In order to stress test our cross compiler, let's use it to cross compile itself for the Pi:"
tput setaf 4
mkdir -p /opt/gcc-8.1.0
chown $USER /opt/gcc-8.1.0
cd ..

mkdir -p $BDIR/build-native-gcc8 
cd $BDIR/build-native-gcc8
../gcc-8.1.0/configure --prefix=/opt/gcc-8.1.0 --build=$MACHTYPE --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib --program-suffix=-8.1.0
make -j 8
make install-strip
}

function add2path {
###############################
tput setaf 2
echo "If you want to permanently add the cross compiler to your path, use something like:"
tput setaf 7
cd $BDIR
echo "export PATH=/usr/local/bin:$PATH" >> .bashrc
export PATH=/usr/local/bin:$PATH
}

function backup_gcc8 {
#########################
tput setaf 2
echo "You can now, optionally, safely erase the build folder."
cd $BDIR
#rm -rf $BDIR
cd /opt
tar -cjvf $BDIR/gcc-8.1.0.tar.bz2 gcc-8.1.0
cd $BDIR
tput setaf 7
}

function build-all {

    install_dependencies
    create_builddir
    download_src
    install_prerequisites
    create_gcc_binfolder
    copy_kernel_header
    build_binutils
    build_gcc_part1
    build_glibc_part1
    build_gcc_part2
    build_glibc
    build_gcc_part3
    backup_gcc
    #build_gcc8
    #build_gcc8_rpi
    add2path
    #backup_gcc8
exit 0
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
  # Show a helpful error
  echo "Try:" >&2
#  cat $0 | grep function | awk -F ' ' '{print $2}' | head -n -2
  exit 1
fi

exit $err