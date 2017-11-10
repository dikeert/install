#!/bin/bash

function has_llpp {
	has llpp
}

function get_deps {
	log "Installing required dependencies, it might require a password"
	install redhat-rpm-config
	install ocaml
}

function get_mupdf {
	local mupdf="mupdf"
	local commit="68dd6525d7b4d14b396a86448283dd4b9b625970"

	pwd
	log "Getting required version of mupdf"
	$git clone --recursive git://git.ghostscript.com/mupdf.git "${mupdf}"
	cd "${mupdf}"
	$git checkout "${commit}"
	$git submodule update --recursive
	log "MUPDF has been checked out"

	log "Buliding mupdf"
	$make build=native libs
	cd ../
	log "MUPDF's ready"
}

function build_llpp {
	local build="${1}"

	log "Building llpp"
	chmod +x build.sh
	./build.sh "${build}"
}

function install_llpp {
	local src="${1}"
	local target="${2}"

	log "Installing llpp to [${target}]"
	cp "${src}" "${target}"
}

function get_llpp {
	local git=$(get git)
	local make=$(get make)

	local currdir=$(pwd)

	local target="${HOME}/Downloads/Soft"
	local prefix="${HOME}/.local"

	local llpp="llpp"
	local build="build"

	get_deps

	mkdir -p "${target}"
	cd "${target}"

	log "Cloning llpp repo"
  $git clone git://repo.or.cz/llpp.git "${llpp}"
	cd "${llpp}"

	get_mupdf
	build_llpp "${build}"
	install_llpp "${build}/llpp" "${prefix}/bin"
	
	cd "${currdir}"
}

function run_installer_llpp {
	if has_llpp; then
		log "Detected llpp installation, skipping"
	else
		log "Installing llpp"
		get_llpp
	fi
}
