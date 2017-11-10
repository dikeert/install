#!/bin/bash

function has_rofi {
	has rofi
}


function get_deps {
	log "Installing dependencies"

	install flex
	install flex-devel
	install librsvg2
	install librsvg2-devel
	install check
	install check-devel
}


function get_rofi {
	local currdir=$(pwd) 
	local downloads="$HOME/Downloads/GitHub"
	
	mkdir -p $downloads
	cd $downloads

	git clone https://github.com/DaveDavenport/rofi rofi
	cd rofi
	git submodule update --init
	autoreconf -i
	mkdir build
	cd build
	../configure --prefix="${HOME}/.local/"
	make
	log "Running 'make install'"
	make install
	cd $currdir
}

function run_installer_rofi {
	case $(uname) in
		Linux)
			if has_rofi; then
				log "Detected rofi installation, skipping"
			else
				log "Installing rofi"
				get_deps
				get_rofi
			fi
		;;
	esac
}
