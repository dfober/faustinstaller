#!/bin/bash
set -e

group=faust
name=faust

createfaustuser() {
	echo "Create $name user"
	addgroup -f $group
	useradd -c "Faust" -m -g $group -p '$apr1$nHGI0Q5e$0mNv0DJ2ptyA8OKdYicco1' -s /bin/bash -r $name && chmod go-rx /home/$name

}

installfaustservice() {
	SUDO=`which sudo`

	echo "Installing faustservice (remote compilation service)"

	$SUDO apt install -y libarchive-dev libboost-all-dev apache2

	# Check requirements
	if [ ! -d ~/FaustInstall ]; then
		echo "Please install faust before by running install.developer.sh"
		exit 1
	fi

	if [ ! -d ~/FaustInstall/faustservice ]; then
		cd ~/FaustInstall
		git clone https://github.com/grame-cncm/faustservice.git
	fi

	grep $name /etc/passwd || createfaustuser

	echo "Update faustservice"
	cd ~/FaustInstall/faustservice
	git pull
	make
	$SUDO make install
	$SUDO make install_systemd

	echo "Installation Done! (but service not started: run ./faustweb)"
}

installfaustservice
