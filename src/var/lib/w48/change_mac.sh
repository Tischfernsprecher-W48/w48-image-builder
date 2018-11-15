#!/bin/bash

CFG_FILE=/etc/w48/w48.config
CFG_CONTENT=$(cat $CFG_FILE | sed -r '/[^=]+=[^=]+/!d' | sed -r 's/\s+=\s/=/g')
eval "$CFG_CONTENT"


maclist=( $(ifconfig | grep ether | awk {'print $2}') )
dev=( eth0 wlan0 wlan1 )
count=0

for mac in "${maclist[@]}"
do

echo "change ${mac} to ${w48_mac_eth0} for dev  ${dev[$count]}"

cat <<EOF >/etc/systemd/network/00-${dev[$count]}.link
[Match]
MACAddress=${mac}

[Link]
MACAddress=${w48_mac_eth0}
NamePolicy=kernel database onboard slot path

EOF

((count++))

done


