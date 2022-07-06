### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/anshumanbiswas/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
eval "$(starship init zsh)"
export EDITOR="/usr/bin/vim"

#Source files libraries
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Add other source files that can be ignored
source .custom.zsh

#Bind
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#Aliases
alias ec="$EDITOR $HOME/.zshrc"
alias sc=". $HOME/.zshrc"

alias conflict="git diff --name-only --diff-filter=U"
alias showlog="git log -n 1 --pretty=format:%s"
alias gl="git log"
alias gs="git status"
alias ga="git add"
alias gr="git rm"
alias gc="git commit -m "

#Methods
gcln() {
    git stash
    git clean -fd
}
