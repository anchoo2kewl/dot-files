export XDG_CONFIG_HOME="$HOME"/.config

isM1=`sysctl -n sysctl.proc_translated`
re='^[0-9]+$'

# Set where your .zshrc lives (explicitly)
ZSHRC_DIR="$HOME/projects/dot-files"

# Get parent directory
PARENT_DIR="$(dirname "$ZSHRC_DIR")"

# Print them for debugging
echo "ZSHRC_DIR (script_dir): $ZSHRC_DIR"
echo "Parent directory: $PARENT_DIR"

# Safely add $ZSHRC_DIR/bin to PATH if not already present
case ":$PATH:" in
    *":$ZSHRC_DIR/bin:"*) ;;
    *) export PATH="$PATH:$ZSHRC_DIR/bin" ;;
esac

# Safely add $PARENT_DIR/bin to PATH if not already present
case ":$PATH:" in
    *":$PARENT_DIR/bin:"*) ;;
    *) export PATH="$PATH:$PARENT_DIR/bin" ;;
esac

export PATH=$PATH:$script_dir/bin

# Add bin one level higher

if [[ $isM1 =~ $re ]] ; then 
    export PATH=$PATH:/opt/homebrew/bin;
fi

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

fastfetch

#History setup
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}

zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}

zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell
setopt auto_cd # cd by typing directory name if it's not a command
setopt correct # autocorrect commands
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

#Source files libraries
[ -f "$HOME/libs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source $HOME/libs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f "$HOME/libs/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source $HOME/libs/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f "$HOME/libs/zsh-history-substring-search/zsh-history-substring-search.zsh" ] && source $HOME/libs/zsh-history-substring-search/zsh-history-substring-search.zsh

# Add other source files that can be ignored
[ -f ".custom.zsh" ] && source "$HOME/.custom.zsh"

#Bind
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

[ -f "$HOME/.config/.aliasrc" ] && source "$HOME/.config/.aliasrc"

#Methods
gcln() {
    git stash
    git clean -fd
}

# Docker Compose pull and clean old images
dcp() { 
    docker-compose pull
    docker-compose up --force-recreate --build -d
    docker image prune -f
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/anshuman/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# jenv removed - not installed on this system
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"

# Added by Windsurf - Next
export PATH="/Users/anshumanbiswas/.codeium/windsurf/bin:$PATH"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH="$HOME/go/bin:$PATH"

# Created by `pipx` on 2025-07-11 12:43:38
export PATH="$PATH:/Users/anshumanbiswas/.local/bin"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# opencode
export PATH=/Users/anshumanbiswas/.opencode/bin:$PATH
