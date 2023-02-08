#!/bin/sh

configs_root_file="configs_root.txt"
configs_cur_file="configs_cur.txt"

# install/update the configs by using stow
# NOTE: $# => number of arguments
if [ $# -le 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || { [ "$1" != "install" ] && [ "$1" != "uninstall" ]; }; then
    echo "$0 install [config_dir ...|cur]"
    echo "$0 uninstall [config_dir ...|cur]"
else
    mode="-S"
    if [ "$1" = "uninstall" ]; then
        mode="-D"
    fi
    configs_root=$(test -r "$configs_root_file" && cat "$configs_root_file")
    stow_config () {
        if echo "$configs_root" | grep -F -x -q "$i"; then
            sudo stow "$mode" -v -t "/" "$1" 2>&1 | grep -v "BUG in find_stowed_path"
        else
            stow "$mode" -v -t "$HOME" "$1" 2>&1 | grep -v "BUG in find_stowed_path"
        fi
    }

    shift
    configs="$*"
    if [ "$1" = "cur" ]; then
        configs=$(test -r "$configs_cur_file" && cat "$configs_cur_file")
    fi

    for i in $configs; do
        stow_config "$i"
    done
fi
