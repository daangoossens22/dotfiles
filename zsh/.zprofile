# used to differentiate laptop/desktop configs
export LAPTOP_CONFIG=false

# default programs
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"
export BROWSER="firefox-developer-edition"
# export SHELL=/usr/zsh
# export PAGER=/bin/less
export SUDO_EDITOR="nvim --clean -u NONE --noplugin"

# XDG spec
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# clean up home folder
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
# export PULSE_COOKIE="$XDG_CONFIG_HOME/pulse/pulse-cookie"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export SSB_HOME="$XDG_DATA_HOME"/zoom
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export JUPYTER_PLATFORM_DIRS="1"
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# theming
export QT_QPA_PLATFORMTHEME="qt5ct"
export XCURSOR_PATH=$XDG_DATA_HOME/icons
# export QT_STYLE_OVERRIDE=kvantum # better to change style in qt5ct

# wayland variables
export MOZ_ENABLE_WAYLAND=1
# export QT_WAYLAND_FORCE_DPI=96
# export QT_QPA_PLATFORM=wayland
# export GDK_BACKEND=wayland
# export SDL_VIDEODRIVER=wayland
# export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
export _JAVA_AWT_WM_NONREPARENTING=1

# export WLR_DRM_NO_MODIFIERS=1
# export WLR_DRM_NO_ATOMIC=1
# export WLR_RENDERER=vulkan

# start sway (only once) automatically on /det/tty1
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    # NOTE: see https://wiki.archlinux.org/title/Hardware_video_acceleration
    if [ "$LAPTOP_CONFIG" = true ]; then
        # export LIBVA_DRIVER_NAME="vdpau" # nvidia VDPAU
        # export LIBVA_DRIVER_NAME="nvidia" # nvidia NVDECODE
        # export VDPAU_DRIVER="nvidia"

        export LIBVA_DRIVER_NAME="iHD" # intel-media-driver
        # export LIBVA_DRIVER_NAME="i965" # libva-intel-driver
        export VDPAU_DRIVER="va_gl"
        exec sway --unsupported-gpu
    else
        export LIBVA_DRIVER_NAME="radeonsi"
        export VDPAU_DRIVER="radeonsi"
        exec sway
    fi
fi
