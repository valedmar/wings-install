#!/bin/bash

#setup
panelDomain="https://panel.orehub.net"
FQDN=$1 # FQDN of node
if [[ $1 = '' ]]; then
  echo "no FQDN of node set as first arg."
  exit
fi

## full upgrade
echo "Updating packages ..."
sudo apt update && sudo apt full-upgrade -y
echo "Installing necessary packages ..."
sudo apt install -y bind

FQDNip=$(nslookup $FQDN | awk -F': ' 'NR==6 { print $2 } ')
nodeip=$(curl ifconfig.me)

if [[ $FQDNip != $nodeip ]]; then
  echo "FQDN does not match node ip address"
  exit
fi

