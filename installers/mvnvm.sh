#!/bin/bash

function has_mvnvm {
	has mvn
}

function get_mvnvm {
	local curl=$(get_curl)
	local target="$HOME/.local/bin"
	local bb_url="https://bitbucket.org"
	local mvnvm_path="mjensen/mvnvm/raw/master/mvn"
	local mvnvm_url="${bb_url}/${mvnvm_path}"

	mkdir -p $target
	$curl -s $mvnvm_url > $target/mvn
	chmod 0755 $target/mvn
}

function run_installer_mvnvm {
	if has_mvnvm; then 
		log "Detected MVNVM installation, skipping"
	else
		log "Installing MVNVM"
		get_mvnvm
	fi
}

