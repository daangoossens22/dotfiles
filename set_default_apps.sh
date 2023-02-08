#!/bin/sh

set -x # show executed commands in this script

# Set default applications for xdg-open
# - stored in ~/.config/mimeapps.list
# - available types in /usr/share/mime/types and /usr/share/mime/packages/*
# - file --mime-type -b

xdg-mime default thunar.desktop inode/directory
xdg-mime default org.pwmt.zathura.desktop application/pdf
# xdg-mime default firefox-developer-edition.desktop application/pdf
xdg-mime default nvim.desktop text/*
# xdg-mime default nvim.desktop text/plain
# xdg-mime default nvim.desktop text/x-script.python # python files
# xdg-mime default nvim.desktop text/x-script.python3 # python files
# xdg-mime default nvim.desktop text/x-shellscript # sh scripts
