#!/bin/bash
# Valedmar3301

#setup
FQDN=$1 # FQDN of node
if [[ $1 = '' ]]; then
  echo "*** no FQDN of node set as first arg."
  exit
fi

EMAIL=$2
if [[ $2 = '' ]]; then
  echo "*** no mail set as second arg."
  exit
fi

# Check the FQDN
FQDNip=$(nslookup $FQDN | awk -F': ' 'NR==6 { print $2 } ')
nodeip=$(curl ifconfig.me)

if [[ $FQDNip != $nodeip ]]; then
  echo "*** FQDN does not match node ip address"
  exit
fi

## full upgrade
echo "*** Updating packages ..."
sudo apt update && sudo apt full-upgrade -y
echo "*** Installing necessary packages ..."
sudo apt install -y certbot


echo "*** Running Certbot"
if dpkg -s nginx &>/dev/null; then
   sudo apt install -y python3-certbot-nginx
   sudo certbot certonly --non-interactive --agree-tos --email $EMAIL --nginx -d $FQDN
elif dpkg -s apache2 &>/dev/null; then
   sudo apt install -y python3-certbot-apache
   sudo certbot certonly --non-interactive --agree-tos --email $EMAIL --apache -d $FQDN
else
    sudo certbot certonly --non-interactive --agree-tos --email $EMAIL --standalone -d $FQDN
fi
sudo chmod 755 /etc/letsencrypt/live


# install docker
echo "*** Installing Docker ..."
sudo curl -sSL https://get.docker.com/ | CHANNEL=stable bash
sudo systemctl enable docker

# install wings
echo "*** Installing Wings ..."
sudo mkdir -p /etc/pterodactyl
sudo curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
sudo chmod +x /usr/local/bin/wings

sudo curl -o /etc/systemd/system/wings.service https://raw.githubusercontent.com/Thomas5300/pterodactyl-installation-script/main/configurations/wings/wings.service
sudo systemctl enable --now wings

cd /etc/pterodactyl

echo "*** Wings is installed, run autodeploy! (Remember to restart wings with systemctl)"
