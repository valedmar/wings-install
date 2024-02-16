# Install script for Pterodactyl wings

## Requirements:
- Certbot

Installing:
./install FQDN mail && sudo wings configure [wings token stuff] && sudo systemctl restart wings 

- FQDN is the Fully Qualified Domain Name of the node, used for Let's Encrypt and ssl certs.
- mail is the mail for setting up Let's Encrypt
- omit the "cd /etc/pterodactyl" part in generating the config token
