#!/bin/bash

PREFIX="${HOME}/.local"

function install_log {
  local scope=$1
  local msg=$2
  echo "[${scope}]: ${msg}"
}

function install_error {
  install_log "$1" "$2" >&2
}

function log {
  install_log "${FUNCNAME[1]}" "$1"
}

function error {
  install_error "${FUNCNAME[1]}" "FATAL: $1"
  exit 3
}

function get {
	which $1 2>&1
}

function has {
	local thing=$1
	local slow_cmd="source ~/.bashrc && type -t $thing"

	if [ -x "$(get $thing)" ]; then
		return 0
	elif [ "function" = "$(type -t $thing)" ]; then
		return 0
	elif [ "function" = "$(/bin/bash -c "$slow_cmd")" ]; then
		return 0
	else
		return 3
	fi
}

function get_gpg {
	local gpg="$(get gpg)"
	local gpg2="$(get gpg2)"
	
	if [ -x "$gpg2" ]; then
		gpg=$gpg2
	fi
	
	if [ ! -x "$gpg" ]; then
		error "GPG is required for [${FUNCNAME[1]}]"
	fi

	echo $gpg
}

function get_curl {
	local curl="$(get curl)"

	if [ ! -x "$curl" ]; then
		error "CURL is required for [${FUNCNAME[1]}]"
	fi

	echo $curl
}

function add_completion {
	local completions="${PREFIX}/share/completions"

	local thing="$1"

	mkdir -p "${completions}"
	
	if [ -f "${thing}" ]; then
		log "Adding bash completion [${thing}] into [${completions}] for [${FUNCNAME[1]}]"
		cp "${thing}" "${completions}"
	else
		log "Can't install [${thing}] as bash completion, not a file"
	fi
}

function do_install_apt {
	log "Running apt-get with sudo, password might be necessary"
	sudo apt-get install -y $1
}

function do_install_dnf {
	log "Running dnf with sudo, password might be necessary"
	sudo dnf install -y $@
}

function do_install_brew {
	log "Running brew..."
	brew install -y $1
}

function install {
	local thing=$@
	local install_base="do_install_"
	local install_suff=""

	if has apt; then
		install_suff="apt"
	elif has dnf; then
		install_suff="dnf"
	elif has brew; then
		install_suff="brew"
	else
		error "Unsupport configuration"
	fi

	local cmd="${install_base}${install_suff}"
	log "Using installer [${cmd}] for [${FUNCNAME[1]}] to install [${thing}]"

	$cmd $thing
}

function run_installer {
	local me="${1}"
	local installer="${2}"
	local path="installers/${installer}.sh"
	local bash=$(get bash)

	local func_prefix="run_installer_"

	if [ -f $path ]; then
		$bash -c "source '${me}'; source '${path}'; ${func_prefix}${installer}"
	else
		error "Can't find [installer=${installer}] in [${path}]"
	fi
}

function run_all_installers {
	local me="${1}"
	local bash=$(get bash)
	local func_prefix="run_installer_"

	for f in installers/*.sh; do
		[ -f $f ] || continue
		local installer=$(echo $f | cut -d '/' -f 2 | cut -d '.' -f 1)
		$bash -c "source '${me}'; source $f; ${func_prefix}${installer}"
	done
}

if [ "$(basename $0)" = "install.sh" ]; then
	if [ "_x_${1}" == "_x_" ]; then
		run_all_installers "$(basename $0)"
	else
		run_installer "$(basename $0)" "${1}"
	fi
fi

