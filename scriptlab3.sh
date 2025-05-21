#!/bin/bash

sudo ifconfig wlan0 192.168.10.1 netmask 255.255.255.0 up

x-terminal-emulator -e "bash -c 'sudo hostapd ~/Desktop/hostapd.conf; exec bash'" &

echo "[*] Waiting for hostapd..."
while ! pgrep -x "hostapd" > /dev/null; do
    sleep 1
done

sleep 6

echo "[*] Starting dnsmasq..."
sudo dnsmasq -i wlan0 --no-resolv --no-poll --log-dhcp \
--dhcp-range=192.168.10.10,192.168.10.50,12h \
--dhcp-option=3,192.168.10.1 \
--dhcp-option=6,192.168.10.1 \
--bind-interfaces \
--address=/#/192.168.10.1 &

echo "[*] Starting apache2..."
sudo systemctl start apache2

echo "[*] Ready!"
