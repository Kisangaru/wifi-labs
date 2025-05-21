# Wi-Fi Security Labs Scripts

This repository contains Bash scripts for various Wi-Fi security lab tasks (for educational and research purposes only). These scripts demonstrate common techniques such as deauthentication attacks, MAC spoofing, rogue access point creation, WPA handshake capture, and WPA3 configuration using `hostapd`.

> ⚠️ Warning: These scripts are intended for use in controlled lab environments only. Unauthorized use on live networks may be illegal.

---

## Scripts Overview

### `lab1.sh`
Performs a basic deauthentication attack using `aireplay-ng`.

- Enables monitor mode on `wlan0`
- Scans for nearby networks
- Prompts for MAC address, channel, and number of deauth packets
- Sends repeated deauth packets to the access point

---

### `lab2.sh`
Performs MAC spoofing after scanning for Wi-Fi devices.

- Starts monitor mode and performs a scan with `airodump-ng`
- Asks for router's MAC address and channel
- Prompts for a new MAC address to spoof
- Applies the new MAC using `macchanger`

---

### `lab3_fake_ap.sh`
Creates a rogue access point using `hostapd`, `dnsmasq`, and `apache2`.

- Sets static IP on `wlan0`
- Starts `hostapd` with a custom config
- Runs a local DHCP server with `dnsmasq`
- Starts `apache2` to serve phishing pages or local HTML

---

### `lab4_handshake.sh`
Captures WPA handshake using `bettercap`.

- Kills interfering services (e.g., NetworkManager)
- Enables monitor mode on `wlan0`
- Scans and displays Wi-Fi networks
- Prompts for target MAC and channel
- Performs association and deauthentication
- Saves the handshake file
- Analyzes the capture with `aircrack-ng`

---

### `lab6_wpa3_fake_ap.sh`
Configures a rogue WPA3 access point.

- Detects wireless interface
- Scans for target ESSID using `airodump-ng`
- Extracts BSSID and channel
- Updates `hostapd` WPA3 config with correct parameters
- Starts `hostapd` with updated configuration

> ⚠️ Note: Paths in the script may need correction, so edit them to suit your needs
---

## Requirements

Ensure these tools are installed on your system (Kali Linux):

- `aircrack-ng`
- `hostapd`
- `dnsmasq`
- `apache2`
- `bettercap`
- `macchanger`
- `iw`, `ifconfig`, `systemctl`, etc.

---

## License

These scripts are for **educational use only**. The authors are not responsible for any misuse.
