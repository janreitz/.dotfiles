#!/usr/bin/env bash

# Backup exiting dotfiles and add symblic links to the ones in this dir
OLD_DOTFILES="${HOME}/.dotfile_backup_$(date -u +"%Y%m%d%H%M%S")"

backup_if_exists() {
	# Doesn't error if exists
	mkdir -p $OLD_DOTFILES

	if [ -f $1 ]; then
		mv $1 $OLD_DOTFILES
	fi
	if [ -d $1 ]; then
		mv $1 $OLD_DOTFILES
	fi
}

dotfiles=(
	".aliases"
	".bashrc"
	".env"
	".gitconfig"
	".spaceshiprc.zsh"
	".tmux.conf"
	".vimrc"
	".zshrc"
)

for dotfile in "${dotfiles[@]}"; do
	backup_if_exists "${HOME}/$dotfile"
	ln -s "$(pwd)/$dotfile" "${HOME}/$dotfile"
done

# Directories symlinked into ~/.config: "<repo dir>:<config name>"
config_dirs=(
	"neovim:nvim"
)

mkdir -p "${HOME}/.config"
for entry in "${config_dirs[@]}"; do
	src="${entry%%:*}"
	dest="${HOME}/.config/${entry#*:}"
	backup_if_exists "$dest"
	ln -s "$(pwd)/$src" "$dest"
done

echo "Done!"
