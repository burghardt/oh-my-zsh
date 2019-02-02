export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_info {
    [[ -n $VIRTUAL_ENV ]] && echo '('`basename $VIRTUAL_ENV`') '
}

if [[ $terminfo[colors] -ge 256 ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
else
    turquoise="%F{cyan}"
    orange="%F{yellow}"
    purple="%F{magenta}"
    hotpink="%F{red}"
    limegreen="%F{green}"
fi

function user_info {
    [[ "$USER" == "root" ]] && echo %{$hotpink%}%n%f || echo %{$limegreen%}%n%f
}

function chroot_info {
    [[ -r /etc/debian_chroot ]] && echo " %{$purple%}($(cat /etc/debian_chroot))%f"
}

setopt prompt_subst

autoload -U add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr   "%{$orange%}●"
zstyle ':vcs_info:*:prompt:*' stagedstr     "%{$limegreen%}●"
zstyle ':vcs_info:*:prompt:*' actionformats "(%{$turquoise%}%b%u%c%f)(%{$limegreen%}%a%f)"
zstyle ':vcs_info:*:prompt:*' formats       "(%{$turquoise%}%b%u%c%f)"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

function burghardt_precmd {
    vcs_info 'prompt'
}
add-zsh-hook precmd burghardt_precmd

PROMPT=$'
$(user_info) @ %{$orange%}%m%f$(chroot_info) : %{$limegreen%}%~%f $vcs_info_msg_0_$(virtualenv_info)
$ '
