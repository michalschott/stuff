#!/usr/bin/env bash

set -xe

install_pihole() {
  curl -sSL -o piholesetup https://install.pi-hole.net
  sudo bash ./piholesetup
}

install_vpn() {
  curl -sSLO https://git.io/vpnsetup
  sudo \
    VPN_IPSEC_PSK=$VPN_IPSEC_PSK \
    VPN_USER=$VPN_USER \
    VPN_PASSWORD=$VPN_PASSWORD \
    sh ./vpnsetup
}

install_noip_agent() {
  curl -sSLO https://www.noip.com/client/linux/noip-duc-linux.tar.gz
  tar zxvf noip-duc-linux.tar.gz
  cd noip-2.1.9-1
  make
  sudo make install
  sudo curl -sSLo /etc/systemd/system/noip2.service https://gist.githubusercontent.com/NathanGiesbrecht/da6560f21e55178bcea7fdd9ca2e39b5/raw/b5594a39e908548f4319294553497d2db3053e0a/noip2.service
  sudo systemctl daemon-reload
  sudo systemctl enable noip2
  sudo systemctl start noip2
}

TMP=$(mktemp -d)
cd $TMP

install_noip_agent
install_vpn
install_pihole

cd -
rm -rf $TMP
