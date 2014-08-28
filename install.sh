#!/bin/bash
BACKUPDIR=~/.files-backup

# install gdir ldir glob
function install() {
dir=$(pwd)
gdir=$1
ldir=$2
glob=$3
pushd "$ldir" > /dev/null
for file in $glob; do
    if [ -e "$file" ] && [ "$file" != ".gitignore" ]; then
        if [ -e "$gdir/$file" ]; then
            if ! [ "$file" -ef "$gdir/$file" ]; then
                echo "Backing up $file to $BACKUPDIR"
                mkdir -p "$BACKUPDIR/$ldir"
                mv -f "$gdir/$file" "$BACKUPDIR/$ldir"
            else
                continue
            fi
        fi
        ln -s "$dir/$ldir/$file" "$gdir/$file"
    fi
done
popd > /dev/null
}

install ~ dotfiles '.[!.]*'
if [ -d "$XDG_CONFIG_HOME" ]; then
    install "$XDG_CONFIG_HOME" xdg-config '*'
else
    install "$HOME/.config" xdg-config '*'
fi
