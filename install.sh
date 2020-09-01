#!/usr/bin/env bash

apt install zsh
apt-get install fonts-powerline
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
 
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
# spaceship-prompt symlink
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" 

# Substitute existing dotfiles with symbolic links
dotfiles=(
	".bashrc"
	".bash_aliases"
	".vimrc"
	".env"
	".zshrc"
)

for dotfile in "${dotfiles[@]}"; do
	rm -rf "${HOME}/$dotfile"
	ln -s "$(pwd)/$dotfile" "${HOME}/$dotfile"
done

 
