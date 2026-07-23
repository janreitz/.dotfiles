# Custom two-line prompt
#   line 1: user@host pwd [branch] [status] [duration]
#   line 2: -> (green on success, red on failure)

setopt PROMPT_SUBST
zmodload zsh/datetime

# vcs_info (zsh builtin) for the git branch
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

typeset -g _prompt_cmd_start='' _prompt_duration='' _prompt_git=''

_prompt_preexec() {
  _prompt_cmd_start=$EPOCHREALTIME
}

_prompt_precmd() {
  # ---- command duration (only shown if >= 1s) ----
  _prompt_duration=''
  if [[ -n $_prompt_cmd_start ]]; then
    local -F elapsed=$(( EPOCHREALTIME - _prompt_cmd_start ))
    _prompt_cmd_start=''
    if (( elapsed >= 1 )); then
      local -i t=$(( elapsed ))
      local out=''
      if (( t >= 3600 )); then
        out="$(( t / 3600 ))h $(( t / 60 % 60 ))m $(( t % 60 ))s"
      elif (( t >= 60 )); then
        out="$(( t / 60 ))m $(( t % 60 ))s"
      else
        out="$(printf '%.1fs' $elapsed)"
      fi
      _prompt_duration=" %F{yellow}${out}%f"
    fi
  fi

  # ---- git branch + status ----
  _prompt_git=''
  vcs_info
  if [[ -n $vcs_info_msg_0_ ]]; then
    local branch=${vcs_info_msg_0_//\%/%%}
    local staged='' modified='' untracked=''
    local -i ahead=0 behind=0
    local line
    # porcelain v2 reads local refs only; --branch gives ahead/behind
    # relative to the already-known upstream, no network access.
    while IFS= read -r line; do
      case $line in
        '# branch.ab '*)
          local -a parts=( ${(s: :)line} )
          ahead=${parts[3]#+}
          behind=${parts[4]#-}
          ;;
        '#'*) ;;
        '?'*) untracked='?' ;;
        [12]\ *)
          [[ $line[3] != '.' ]] && staged='+'
          [[ $line[4] != '.' ]] && modified='!'
          ;;
        u\ *) modified='!' ;;
      esac
    done < <(command git status --porcelain=v2 --branch 2>/dev/null)

    local st="${staged}${modified}${untracked}"
    local sync=''
    (( ahead ))  && sync+="⇡${ahead}"
    (( behind )) && sync+="⇣${behind}"

    _prompt_git=" %F{magenta}${branch}%f"
    [[ -n $st ]]   && _prompt_git+=" %F{red}[${st}]%f"
    [[ -n $sync ]] && _prompt_git+=" %F{cyan}${sync}%f"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd  _prompt_precmd

PROMPT='%F{blue}%n%f@%F{green}%m%f %F{cyan}%~%f${_prompt_git}${_prompt_duration}
%(?.%F{green}.%F{red})➜%f '
RPROMPT=''
