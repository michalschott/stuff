#!/usr/bin/env sh

wget https://git.io/vpnsetup -O vpnsetup.sh && sudo \
VPN_IPSEC_PSK='${vpn_ipsec_psk}' \
VPN_USER='${vpn_username}' \
VPN_PASSWORD='${vpn_password}' sh vpnsetup.sh
