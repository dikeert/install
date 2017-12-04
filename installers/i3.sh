#!/bin/bash

function has_i3 {
	has i3
}


function get_deps {
	log "Installing i3 dependencies"
	
	install redhat-rpm-config \
		libev-devel \
		startup-notification-devel \
		xcb-util-devel \
		xcb-util-cursor-devel \
		xcb-util-keysyms-devel \
		xcb-util-wm-devel \
		xcb-util-xrm-devel \
		libxkbcommon-devel \
		libxkbcommon-x11-devel \
		yajl-devel \
		pango-devel
}

function download_i3 {
	download i3 "${1}" "${2}" "${3}"
}

function extract_i3 {
	local thing="${1}"
	local unzip="$(get unzip)"

	log "Extracting i3 [path=$(pwd)/${thing}, unzip=${unzip}]"
	$unzip -o "${thing}"
}

function build_i3 {
	local version="${1}"
	local dir="i3-${version}"
	local currdir="$(pwd)"

	local autoreconf="$(get autoreconf)"
	local make="$(get make)"
	cd "${dir}"

	log "Preparing to configure i3 [version=${version}, autoreconf=${autoreconf}]"
	$autoreconf --force --install
	rm -rf build/
	mkdir -p build && cd build/

	log "Configuring i3 [prefix=${PREFIX}]"
	../configure --prefix="${PREFIX}" --sysconfdir="${PREFIX}/etc" --disable-sanitizers

	log "Building i3"
	$make && $make install

	cd "${currdir}"
}

function create_xsession {
	log "Creating Xsession entry for i3-gaps. It might require sudo password"

	local source="i3-gaps.desktop"
	local target="/usr/share/xsessions/${source}"

	cat <<EOT >> "${source}"
[Desktop Entry]
Name=i3 Gaps
Comment=Improved dynamic tiling window manager with gaps
Exec=${PREFIX}/bin/i3
Type=Application
X-LightDM-DesktopName=i3 Gaps
DesktopNames=i3 Gaps
Keywords=tiling;wm;windowmanager;window;manager
EOT

	sudo cp ${source} ${target}
}

function get_i3 {
	local version="4.14.1"
	local url="https://github.com"
	local path="Airblader/i3/archive"
	local file="$version.zip"

	local currdir="$(pwd)"
	local dir="${HOME}/Downloads/Soft"

	mkdir -p "${dir}"
	cd "${dir}"

	download_i3 "${url}" "${path}" "${file}" 
	extract_i3 "${file}"
	build_i3 "${version}"
	create_xsession

	cd "${currdir}"
}

function run_installer_i3 {
	if has_i3; then
		log "Detected i3 installation, skipping"
	else
		log "Installing i3..."
		get_deps
		get_i3
	fi
}
