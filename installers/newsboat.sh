#!/bin/bash

function has_newsboat {
    has newsboat
}

function get_deps {
    log "Installing newsboat dependencies"
    install redhat-rpm-config \
			json-devel \
			json-c-devel \
			stfl-devel \
			libxml2-devel

    log "Newsboat depndencies are ready!"
}

function get_newsboat {
    local version="2.10.1"

    local host="https://github.com"
    local path="/newsboat/newsboat/archive"

    local file="r${version}.tar.gz"

    local url="${host}/${path}/${file}"

    local currdir="$(pwd)"
    local target="newsboat-r${version}"
    local dir="${HOME}/Downloads/Soft"
    local curl="$(get curl)"
    local tar="$(get tar)"

    mkdir -p "${dir}"
    cd "${dir}"

    $curl -o "${target}.tar.gz" -J -L "${url}"
    $tar xzvf "${target}.tar.gz"
    cd "${target}"

    make prefix="${PREFIX}"
    make install prefix="${PREFIX}"

    cd "${currdir}"
}

function run_installer_newsboat {
    if has_newsboat; then
        log "Detected newsboat installation, skipping"
    else
        log "Installing newsboat..."
        get_deps
        get_newsboat
    fi
}
