
# ---- Completion system -----------------------------------------------
autoload -Uz compinit
# Only rebuild the completion cache once a day (much faster startup than
# oh-my-zsh's default of re-checking every single time).
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
	compinit
else
	compinit -C
fi

# ---- fzf: shell integration ---------------------------------------------
# apt-installed fzf on Debian/Ubuntu
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

export FZF_DEFAULT_OPTS='--layout=reverse'

# ---- Prompt: spaceship -------------------------------------------------
source ~/.zsh/spaceship-prompt/spaceship.zsh

# ---- Plugin: fzf-tab  ---------------------------------------
# Needs to be loaded before widgets that wrap completion widgets -> zsh-autosuggestions
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

# ---- Plugin: zsh-autosuggestions ---------------------------------------
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c6c6c'


# ---- Misc options ---------------------------------------------------------
unsetopt BEEP # Turn off all beeps

if [ -f "${HOME}/.aliases" ]; then
	source "${HOME}/.aliases"
fi

if [ -f "${HOME}/.env" ]; then
	source "${HOME}/.env"
fi

n ()
{
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}

fcd() {
  local dir
  dir=$(fd --type d --base-directory "${1:-.}" --absolute-path | fzf --preview 'ls -la {}') && cd "$dir"
}

mcd() {
	mkdir -p $1 && cd $1
}


# Created by `pipx` on 2025-12-22 18:46:10
export PATH="$PATH:/home/jan/.local/bin"
