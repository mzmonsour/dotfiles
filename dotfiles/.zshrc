# Autorun tmux, except on login shells
if [[ $TERM != "screen-256color" && ! -o login ]]; then
    export TERM=xterm-256color && exec tmux -L "$DISPLAY" attach
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/matt/.zshrc'

fpath+=~"/.zfunc"
autoload -Uz compinit
compinit
# End of lines added by compinstall

source /usr/share/doc/pkgfile/command-not-found.zsh

# Environment Vars
path+=~"/bin/"
path+=~"/.cargo/bin/"
path+=~"/code/flora/Flora-2/flora2"
export EDITOR='/usr/bin/nvim'
export vgaswitch=/sys/kernel/debug/vgaswitcheroo/switch
export MIPSGCC_DIR=~/code/mips-gcc/

# Read better colors for ls
eval `dircolors ~/.dir_colors`
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Make make faster
export MAKEFLAGS="-j4"

# Fix node.js using $HOME/tmp
export TMP=/tmp
export TMPDIR=/tmp

# Fix graphical issues with Matlab
export J2D_D3D=false
export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre

# Zsh functions
source ~/.zshfn

# Useful Aliases
alias ls='ls --color=auto --group-directories-first'
alias e="$EDITOR"
alias please="sudo `cat \`readlink -f $HISTFILE\` | tail -n1`"
alias pacaur="sudo -u pacaur MAKEFLAGS=\"$MAKEFLAGS\" pacaur"

# Less useful aliases
vim() { echo 'Use neovim dummy'; read }

#path+="$(ruby -e 'print Gem.user_dir')/bin"
path+="$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
