#!/bin/bash

function has_rofi_wifi_menu {
	has rofi-wifi-menu.sh
}

function get_rofi_wifi_menu {
	local git=$(get git)
	local currdir=$(pwd)
	local target="${HOME}/Downloads/GitHub"

	mkdir -p "${target}"
	cd "${target}"
	$git clone git@github.com:dikeert/rofi-wifi-menu.git
	cd rofi-wifi-menu
	make install PREFIX="${HOME}/.local"
	cd $currdir
}

function run_installer_rofi_wifi_menu {
	if has_rofi_wifi_menu; then
		log "Detected rofi-wifi-menu installation, skipping"
	else
		log "Installing rofi-wifi-menu"
		get_rofi_wifi_menu
	fi
}
