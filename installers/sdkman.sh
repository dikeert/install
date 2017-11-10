#!/bin/bash

function has_sdkman {
	has sdk
}

function get_sdkman {
	local curl=$(get_curl)

	$curl -s "https://get.sdkman.io" | bash
}

function run_installer_sdkman {
	if has_sdkman; then
		log "Detected SDKMAN installation, skipping"
	else
		log "Installing SDKMAN..."
		get_sdkman
	fi
}
