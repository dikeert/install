#!/bin/bash

function has_st {
	has st
}

function get_deps {
	log "Installing ST dependencies"

	install redhat-rpm-config \
		fontconfig-devel \
		libXft-devel
}

function get_st {
	local curr=$(pwd)
	cd ~/Downloads/Soft/st
	
	log "Building st..."
	make
	log "ST has been built, installing"
	make install PREFIX="$HOME/.local"
	log "ST has been installed"
	cd $curr
}

function run_installer_st {
	if has_st; then
		log "Detected st installation, skipping"
	else
		log "Installing st..."
		get_deps
		get_st
	fi
}
