#!/bin/bash

function has_atool {
	has atool
}

function get_atool {
	install atool
}

function run_installer_atool {
	if has_atool; then
		log "Detected atool installation, skipping"
	else
		log "Installing atool"
		get_atool
	fi
}
