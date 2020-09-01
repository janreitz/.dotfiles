#!/usr/bin/env bash

# Symbolic links
dotfiles=(
	".bashrc"
	".bash_aliases"
	".vimrc"
	".env"
)

for dotfile in "${dotfiles[@]}"; do
	rm "${HOME}/$dotfile"
	
	ln -s "$(pwd)/$dotfile" "${HOME}/$dotfile"
done
 
