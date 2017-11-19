#!/bin/bash

function has_go {
	has go
}

function get_go {
	local version="1.9.2"
	local system=$(uname | awk '{print tolower($0)}')

	local host="https://redirector.gvt1.com"
	local path="/edgedl/go"
	local file="go${version}.${system}-amd64.tar.gz"
	local url="${host}/${path}/${file}"

	local curl="$(get curl)"
	local gzip="$(get gzip)"
	local tar="$(get tar)"

	local currdir="$(pwd)"
	local target="${HOME}/Downloads/Soft"

	mkdir -p "${target}"
	cd "${target}"
	$curl -O -J -L "${url}"
	$tar -C "${PREFIX}" -xzf "${file}"
	
	cd "${currdir}"
}

function run_installer_go {
	if has_go; then
		log "Detected go installation, skipping"
	else
		log "Installing go..."
		get_go
	fi
}
