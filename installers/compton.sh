#!/bin/bash

function has_compoton {
	has compton
}

function get_deps {
	log "Installing compton dependencies"

	install redhat-rpm-config \
		libX11-devel \
		libXcomposite-devel \
		libXfixes-devel \
		libXrandr-devel \
		libXinerama-devel \
		libXrender-devel \
		pcre-devel \
		libconfig-devel \
		libdrm-devel \
		mesa-libGL-devel \
		dbus-devel \
		asciidoc
}

function clone_compton {
	local repo="git@github.com:chjj/compton.git"
	local git="$(get git)"
	
	log "Cloning compton [repo=${repo}] in [path=$(pwd)] with [git=${git}]"
	$git clone --recurse "${repo}"
}

function build_compton {
	log "Building compton"

	local currdir="$(pwd)"

	cd compton || exit 1
	make PREFIX="${PREFIX}" && \
		make docs PREFIX="${PREFIX}" && \
		make install PREFIX="${PREFIX}"

	cd "${currdir}"
}

function get_compoton {
	log "Installing compton"
	local currdir="$(pwd)"
	local dir="${HOME}/Downloads/Soft"

	mkdir -p "${dir}" && cd "${dir}"
	clone_compton
	build_compton

	cd "${currdir}"
}

function run_installer_compton {
	if has_compton; then
		log "Detected compton installation, skipping"
	else
		get_deps
		get_compoton
	fi
}
