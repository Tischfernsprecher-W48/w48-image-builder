#!/bin/bash

dd if=raspbian.img of=/dev/$1 bs=1M && sync

