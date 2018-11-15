w48-image-builder
====================

Builds a minimal [Raspbian](http://raspbian.org/) image.

Login: `root`  
Password: `raspberry`

Only a basic Debian with standard networking utilities.

**:exclamation: Careful: As an exception openssh-server is pre-installed and
will allow root login with the default password.** Host keys are generated on
first boot.

Downloads
---------


Dependencies
------------

 * `apt-get install vmdebootstrap` (at least `0.11` required)
 * `apt-get install binfmt-support qemu-user-static`
 * `apt-get install ca-certificates curl binutils git-core kmod` (required
    by the rpi-update script)
 * `apt-get install apt-cacher-ng` (or change mirror URLs in `bootstrap.sh`
    and `customize.sh`)

Usage
-----

Run `sudo make` (root required for loopback device management)
to create a fresh raspbian.img in the current directory.


Writing the image to an SD card
-------------------------------

`dd if=raspbian.img of=/dev/mmcblk0 bs=1M && sync`

