#!/bin/bash
set -e

if [ -e /usr/bin/sudo ]; then
	SUDO=/usr/bin/sudo
fi

DOMAINS=faustcloud.grame.fr
MAIL=fober@grame.fr
VERIFY=--no-verify-ssl

####################################################
function installhttps {

	echo "########################### Installing https support for domains $DOMAINS"
	$SUDO apt-get install -y software-properties-common
	$SUDO add-apt-repository -y ppa:certbot/certbot
	$SUDO apt-get update
	$SUDO apt-get install -y python-certbot-apache 
	$SUDO certbot -n -m $MAIL --apache --agree-tos --no-redirect $VERIFY --domains $DOMAINS
	$SUDO certbot renew --dry-run
	echo "Installation Done!"
}

installhttps
