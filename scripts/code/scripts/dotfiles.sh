#!/bin/bash
##############################################
# Copy dotfiles to dotfile folder for git
# NOTE: this script is replaced by GNU stow
##############################################

########## Variables

dir=~/.dotfiles                   
cfgdir=config
files="bashrc vimrc xbindkeysrc Xresources xinitrc"
cpdir="i3 cava conky mpd polybar dunst nvim"

##########

# move to dotfiles directory
echo "Change to $dir directory"
cd $dir
echo "...done"

# Do the magic copying of files
for file in $files; do
    echo "Copying file: $file to $dir/$file"
    cp -rf ~/.$file $dir/$file
done

# Do the magic copying of directories
for direc in $cpdir; do
    echo "Making directory $dir/$cfgdir/$direc"
    mkdir -p $dir/$cfgdir/$direc
    echo "Copying directories: $direc to $dir/$cfgdir/$direc"
    cp -rf ~/.$cfgdir/$direc/* $dir/$cfgdir/$direc/
done
	
# Custom copying
echo -e "Custom copying\n"
cp -rf ~/code/scripts/* $dir/scripts/
cp -rf ~/.ncmpcpp/config ~/.ncmpcpp/bindings $dir/ncmpcpp/
cp -rf ~/.mozilla/gruvbox.css ~/.vimperatorrc ~/.vimperator/colors/gruvbox.vimp $dir/firefox/
echo "Done copying dotfiles!"
