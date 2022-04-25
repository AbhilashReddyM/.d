#!/usr/bin/env bash

#make a directory to backup any existing config files
mkdir -p ~/.rcbackup/



for f in .{vimrc,tmux.conf,bash_aliases,gitconfig}
do  
if [ -f ~/$f ]; then
  mv ~/$f ~/.rcbackup/
fi
  echo $f
  ln -sf ~/.d/$f ~/$f
done


