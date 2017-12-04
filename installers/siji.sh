#!/bin/bash


function run_installer_siji {
	local host="https://github.com"
	local path="stark/siji"

	local repo="${host}/${path}"

	local currdir="$(pwd)"
	local dir="${HOME}/Downloads/Misc"
	local target="${PREFIX}/share/fonts"

	local git="$(get git)"

	log "Installing siji font"
	mkdir -p "${dir}" && cd "${dir}"

	log "Cloning siji font [repo=${repo}]"
	$git clone "${repo}"
	cd siji

	log "Installing siji font"
	./install.sh -d "${target}"

	cd "${currdir}"
}
