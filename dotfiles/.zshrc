# Autorun tmux
#if [ $TERM != "screen-256color" ]; then
#    export TERM=xterm-256color && exec tmux
#fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/matt/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source /usr/share/doc/pkgfile/command-not-found.zsh

# Environment Vars
path+=~"/bin/"
path+="$(ruby -e 'print Gem.user_dir')/bin"
export EDITOR='/usr/bin/nvim'
export vgaswitch=/sys/kernel/debug/vgaswitcheroo/switch

# Read better colors for ls
#eval `dircolors ~/.dir_colors`

# Make make faster
export MAKEFLAGS="-j4"

# Fix node.js using $HOME/tmp
export TMP=/tmp
export TMPDIR=/tmp

# Zsh functions
source ~/.zshfn

# Useful Aliases
alias ls='ls --color=auto --group-directories-first'
alias e="$EDITOR"
alias please="sudo `cat \`readlink -f $HISTFILE\` | tail -n1`"

# Less useful aliases
#vim() { echo 'Use neovim dummy'; read }
