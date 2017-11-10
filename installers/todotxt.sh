#!/bin/bash

function has_todotxt {
	has todo.sh
}

function get_todotxt {
	local curl=$(get curl)
	local tar=$(get tar)
	# just to make sure that we have gzip
	local gzip=$(get gzip)

	local currdir="$(pwd)"

	local version="2.10"
	local github="https://github.com"
	local path="todotxt/todo.txt-cli/releases/download/v${version}.0"
	local dir="todo.txt_cli-${version}"
	local file="${dir}.tar.gz"

	local url="${github}/${path}/${file}"

	local target="${HOME}/Downloads/Soft"

	mkdir -p "${target}"
	cd "${target}"
	$curl -O -J -L "${url}"
	$tar xzvf "${file}"
	cp "${dir}/todo.sh" "${PREFIX}/bin"
	chmod +x "${PREFIX}/bin/todo.sh"
	add_completion "$(pwd)/${dir}/todo_completion"
	cd "${currdir}"
}

function run_installer_todotxt {
	if has_todotxt; then
		log "Detected Todo.TXT installation, skipping"
	else
		log "Installing Todo.TXT"
		get_todotxt
	fi
}
