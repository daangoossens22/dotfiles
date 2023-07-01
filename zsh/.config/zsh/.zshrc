# NOTE: sources:
# - https://zsh.sourceforge.io/Guide/zshguide.pdf
# - https://zsh.sourceforge.io/Doc/Release/index.html#Top

d="$XDG_CONFIG_HOME/zsh/.dircolors"
test -r $d && eval "$(dircolors $d)"

source $ZDOTDIR/.zsh_prompt

# history
HISTFILE=$XDG_CACHE_HOME/zsh/history
HISTSIZE=1000
SAVEHIST=1000
# setopt appendhistory
setopt hist_ignore_all_dups
setopt share_history
setopt autocd autopushd pushdignoredups
setopt interactivecomments

# autocomplete
autoload -Uz compinit
zstyle ':completion:*'             menu select # shows the current selection in completion menu
zstyle ':completion:*'             rehash true # automatically autocomplete new packages in /usr/bin
zstyle ':completion:*'             matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*' # case insensitive autocompletion
zstyle ':completion:*'             use-cache on
zstyle ':completion:*'             cache-path $XDG_CACHE_HOME/zsh/zcompcache
zstyle ':completion:*'             file-sort inode
zstyle ':completion:*:default'     list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:cd:*'        ignore-parents parent pwd
# zstyle ':completion:*:functions'   ignored-patterns '_*'
zstyle ':completion:*:*:kill:*'    menu yes select
zstyle ':completion:*:*:killall:*' menu yes select
# zstyle ':completion:*:manuals'     separate-sections true
# zstyle ':completion:*:manuals.*'   insert-sections   true
# zstyle ':completion:*:man:*'       menu yes select

zmodload zsh/complist
zmodload zsh/zpty
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots) # include hidden files

# vi mode
bindkey -v

export KEYTIMEOUT=25 # https://github.com/zsh-users/zsh-autosuggestions/issues/254
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# NOTE: from https://thevaluable.dev/zsh-line-editor-configuration-mouseless/
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
    for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
        bindkey -M $km -- $c select-quoted
    done
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $km -- $c select-bracketed
    done
done

autoload -Uz incarg
zle -N incarg
decarg() {
    local incarg=-1
    zle incarg
}
zle -N decarg
bindkey -a '^a' incarg
bindkey -a '^x' decarg

# # NOTE: kitty seems to do this by default
# # NOTE: source: https://gist.github.com/LukeSmithxyz/e62f26e55ea8b0ed41a65912fbebbe52#file-zshrc-L31
# # Change cursor shape for different vi modes.
# function zle-keymap-select {
#     if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
#         echo -ne '\e[2 q'
#     elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
#          [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
#         echo -ne '\e[6 q'
#     fi
# }
# zle -N zle-keymap-select
# zle-line-init() {
#     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#     echo -ne "\e[6 q"
# }
# zle -N zle-line-init
# echo -ne '\e[6 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

bindkey "^?" backward-delete-char # NOTE: fixes backspace not working after going from normal mode => insert mode
# bindkey "^W" backward-kill-word 
# bindkey "^H" backward-delete-char      # Control-h also deletes the previous char
# bindkey "^U" backward-kill-line

# search history
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^R" history-incremental-pattern-search-backward
# traverse completion menu (have to enter wildmenu)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

autoload -Uz tetriscurses

# Edit line in $EDITOR with ctrl-e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

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

path+=($HOME'/.local/bin')
path+=($HOME'/.local/share/cargo/bin')
path+=($HOME'/.local/share/python/bin')
path+=($HOME'/Documents/Xilinx/Vitis/2022.2/bin')
path+=($HOME'/Documents/Xilinx/Vivado/2022.2/bin')
path+=($HOME'/Documents/Xilinx/Vitis_HLS/2022.2/bin')
export PATH

# open man pages in nvim where it is easier to navigate with colors (same as ':Man (opt:section) {pagename}' command in nvim)
export MANPAGER="nvim +Man!"

unalias run-help
autoload -Uz run-help
help() {
    run-help $@ | less
}

# plugin keybinds
zle -N autosuggest-accept
bindkey '^ ' autosuggest-accept

ZCALC_HISTFILE=$XDG_CACHE_HOME/zsh/zcalc_history # NOTE: in next zsh release
autoload -Uz zcalc
alias zc="zcalc"
autoload -Uz zcalc-auto-insert
zle -N zcalc-auto-insert
ZCALC_AUTO_INSERT_PREFIX="ans"
bindkey '+' zcalc-auto-insert
bindkey '\-' zcalc-auto-insert
bindkey '*' zcalc-auto-insert
bindkey '/' zcalc-auto-insert
bindkey '%' zcalc-auto-insert
bindkey '^' zcalc-auto-insert
bindkey '|' zcalc-auto-insert
bindkey '&' zcalc-auto-insert

# autoload -Uz quote-and-complete-word
# zle -N quote-and-complete-word
# bindkey '\t' quote-and-complete-word

source $ZDOTDIR/.zsh_aliases
source $ZDOTDIR/.zsh_fzf

# load plugins ; should be last (use 2>/dev/null at the end of the line to ignore errors)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[comment]='fg=8,bold'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
