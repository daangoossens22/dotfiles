# Dotfiles
current default applications:
- editor : neovim
- terminal : kitty
- shell : zsh
- wm : sway (+ waybar)
- cursor : volantes cursors (https://github.com/varlesh/volantes-cursors)
- gtk/qt theme : arc-dark-solid

# Installation
To install/uninstall configs:
```bash
./update_configs.sh install [config_dir ...|cur]
./update_configs.sh uninstall [config_dir ...|cur]
```

Make, apply and deapply laptop.patch
```bash
git diff > laptop.patch
git apply laptop.patch
git apply -R laptop.pathc
```

# Notes to self to remember

Swap caps and escape key:
```bash
setxkbmap -option caps:swapescape
```

Make tabs in firefox thinner:
```
(about:config) uidensity => 1
```

Enable reflector timer (that updates the mirrorlist weekly)
```bash
systemctl enable --now reflector.timer
```
Clean unused (older version of) pacman packages weekly
```bash
systemctl enable paccache.timer
```
Check which packages are dependent on some package
```bash
pactree -r {package_name}
```

Improve SSD longivity
See: https://wiki.archlinux.org/title/Solid\_state\_drive#TRIM
```bash
lsblk --discard # check that DISC-GRAN and DISC-MAX are both non-zero before proceeding
systemctl enable fstrim.service
systemctl enable fstrim.timer
```

Improving responsiveness in low-memory conditions
```bash
systemctl enable --now systemd-oomd.service
```

Enable bluetooth
```bash
pacman -S bluez bluez-utils
lsusb | grep btusb # check if bluetooth kernel module is there
systemctl enable --now bluetooth.service
```

Enable NTP (to update clock via the network)
```bash
timedatectl set-ntp 1
```

To edit systemd files use
```bash
systemctl edit {unit} # add snippet
systemctl edit --full {unit} # replace whole unit
systemctl revert {unit} # remove all edits to unit file
```

D-Bus from command-line
```bash
busctl tree
busctl introspect org.bluez /org/bluez/hci0/dev_XX_XX_XX_XX_XX_XX
dbus-send --system --dest=org.bluez --print-reply /org/bluez/hci0/dev_XX_XX_XX_XX_XX_XX --type=method_call org.bluez.Device1.Connect
```
