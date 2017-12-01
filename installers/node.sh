#!/bin/bash

function has_node {
	has nvm
}

function get_node {
	local prfx="$PREFIX"
	unset PREFIX # because nvm is not compatible with the PREFIX env var

	local curl=$(get_curl)
	local github_url="https://raw.githubusercontent.com"
	local nvm_path="creationix/nvm/v0.33.6/install.sh"
	local nvm_url="${github_url}/${nvm_path}"

	$curl -o- $nvm_url | bash
	. "$HOME/.nvm/nvm.sh"
	nvm install node
	nvm use node

	PREFIX="$prfx"
}

function run_installer_node {
	if has_node; then
		log "Detected NVM node installation, skipping"
	else
		log "Installing node via NVM"
		get_node
	fi
}

