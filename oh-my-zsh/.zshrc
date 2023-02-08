plugins=(vi-mode)

export ZSH="$HOME/.config/oh-my-zsh"

ZSH_THEME="af-magic_edited"
SOLARIZED_THEME="dark"

source $ZSH/oh-my-zsh.sh

#set t_Co=16
export TERM=xterm-256color
# !! immediately gets converted into the previous command
unsetopt HIST_VERIFY

unset ls
alias ls="ls --color=always"

alias python=python3
path+=($HOME'/.local/bin')
export PATH

alias rm="rm -r"
alias md='mkdir'
alias open="xdg-open 2>/dev/null"
alias lf="du -shc * | sort -rh"
alias mkdir="mkdir -pv"
alias diff="diff --color=always"
alias vim="nvim"

# git aliases
alias gs="git status"
alias gc="git commit"
alias gcb="git checkout -b"
alias gd="git diff"
alias gdc="git diff --cached"
alias ga="git add"
alias gpl="git pull"
alias gps="git push"
alias gr="git restore"

# always make compile_commands.json so that lsp in nvim works
alias make='make -j $(nproc --ignore 1)'
# alias make="make -j 12"
alias cmakev="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1"
alias makev="bear -- make"

alias grubmc="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# open man pages in nvim where it is easier to navigate with colors (same as ':Man (opt:section) {pagename}' command in nvim)
export MANPAGER="nvim +Man!"

# vim mode
bindkey -v
export KEYTIMEOUT=24
VI_MODE_SET_CURSOR=true # insert mode => line cursor; normal mode => block cursor

bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^R" history-incremental-pattern-search-backward

DISABLE_AUTO_TITLE="true"
function change_window_title() {
    WINDOW_TITLE="zsh - "$PWD
    echo -en "\033]0;$WINDOW_TITLE\007"
}
# change title on each change in pwd
# use 'precmd()' for retiteling before every executed command
function chpwd() {
    change_window_title
}
change_window_title # change title on opening terminal

#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  exec tmux # exit -> exit whole command no normal terminal to go back to
#fi

# clean up home folder
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'
#alias vim='vim -u "$XDG_CONFIG_HOME"/vim/vimrc' # unset alias from vim to neovim

# quick access config files
alias cfd='cd $HOME/Documents/dotfiles'
alias cfv='$EDITOR $HOME/.config/nvim/init.lua'
alias cfvp='cd $HOME/.local/share/nvim/site/pack/packer/start'
alias cfz='$EDITOR $HOME/.config/zsh/.zshrc'
alias cfp='$EDITOR $HOME/.zprofile'
alias cfa='$EDITOR $HOME/.config/alacritty/alacritty.yml'
alias cfq='$EDITOR /home/daang/.config/qtile/config.py'
alias cfs='$EDITOR $HOME/.config/sway/config'
alias cfw='$EDITOR $HOME/.config/waybar/config'
alias cfws='$EDITOR /home/daang/.config/waybar/style.css'
