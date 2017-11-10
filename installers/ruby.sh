#!/bin/bash

function has_ruby {
	has rvm
}

function get_ruby {
	local gpg=$(get_gpg)
	local curl=$(get_curl)

	$gpg \
		--keyserver hkp://keys.gnupg.net \
		--recv-keys \
		409B6B1796C275462A1703113804BB82D39DC0E3 \
		7D2BAF1CF37B13E2069D6956105BD0E739499BDB

	$curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles

	source /home/aner/.rvm/scripts/rvm

	rvm install --latest ruby
	rvm use --latest ruby

	cat <<EOT >> "$HOME/.bashrc"
if [ -d $HOME/.rvm ]; then
	source ~/.rvm/scripts/rvm
	export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi
EOT
}

function run_installer_ruby {
	if has_ruby; then
		log "Detected RVM ruby installation, skipping"
	else
		log "Installing ruby via RVM"
		get_ruby
	fi
}

