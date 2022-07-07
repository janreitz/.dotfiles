#!/usr/bin/env bash

# Backup exiting dotfiles and add symblic links to the ones in this dir
OLD_DOTFILES="${HOME}/.dotfile_backup_$(date -u +"%Y%m%d%H%M%S")"
mkdir $OLD_DOTFILES

backup_if_exists() {
	if [ -f $1 ]; then
		mv $1 $OLD_DOTFILES
	fi
	if [ -d $1 ]; then
		mv $1 $OLD_DOTFILES
	fi
}

dotfiles=(
	".bashrc"
	".aliases"
	".env"
)

for dotfile in "${dotfiles[@]}"; do
	backup_if_exists "${HOME}/$dotfile"
	ln -s "$(pwd)/$dotfile" "${HOME}/$dotfile"
done

PROGRAMS=( git vim zsh broot )
for program in ${PROGRAMS[@]}"; do
	stow -v --target=$HOME $program
	echo "Configuring $program"
done

echo "Done!"
