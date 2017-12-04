#!/bin/bash

function has_polybar {
	has polybar
}

function get_deps {
	log "Installing polybar dependencies"

	install redhat-rpm-config \
		cairo-devel \
		xcb-proto \
		xcb-util-devel \
		xcb-util-image-devel \
		xcb-util-wm-devel \
		xcb-util-xrm-devel \
		xcb-util-renderutil-devel \
		alsa-lib-devel \
		jsoncpp-devel \
		libmpdclient-devel \
		libcurl-devel \
		wireless-tools-devel \
		i3-ipc \
		cmake \
		clang
}

function clone_polybar {
	local git="$(get git)"

	$git clone --recursive https://github.com/jaagr/polybar
}

function build_polybar {
	local cmake="$(get cmake)"

	local currdir="$(pwd)"
	local dir="polybar"

	cd "${dir}"

	log "Configuring polybar"
	mkdir -p build && cd build
	cmake \
		-DCMAKE_C_COMPILER="clang" \
		-DCMAKE_CXX_COMPILER="clang++" \
		-DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
		..

	log "Building polybar"
	make install

	cd "${currdir}"
}

function get_polybar {
	local currdir="$(pwd)"
	local dir="${HOME}/Downloads/Soft"

	log "Installing polybar"
	mkdir -p "${dir}"
	cd "${dir}"

	clone_polybar "${host}" "${path}" "${file}"
	build_polybar "${version}"

	cd "${currdir}"
}

function run_installer_polybar {
	if has_polybar; then
		log "Detected polybar installation, skipping"
	else
		get_deps
		get_polybar
	fi
}
