sudo apt-get install -y zsh
chsh -s /usr/bin/zsh
sudo apt-get install -y mosh

cat <<EOT >> $HOME/.tmux.conf
# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
# vim keys to move panes
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

set-option -g set-titles on

# Set vim bindings
set-window-option -g mode-keys vi

# Colours
set -g status-fg green
set -g status-bg black

# Remove time and just have the host name
set -g status-right '#H'

# Persist sessions on reboot
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'

# Set the current git branch
set -g status-right "#(cd #{pane_current_path}; $(thisbranch))"
set -g status-right-length 200

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOT

curl -sS https://starship.rs/install.sh | sh

mkdir -p $HOME/libs
cd $HOME/libs

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zsh-users/zsh-history-substring-search.git

ln -s $HOME/projects/dot-files/.zshrc.linux $HOME/.zshrc
