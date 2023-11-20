# My NixOS default config

For my PCs, and my account only.

Home Manager is enabled even if not strictly needed for myself only.

## WIP: Still playing with NixOS

Manual setup

## System config

* install nixos
* from console
  * `sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager`
  * `sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable`
  * `sudo nix-channel --update`
  * `nix-shell -p git vim`
  * `git clone https://github.com/paolodenti/mynixos.git`
  * `sudo cp mynixos/configuration.nix /etc/nixos/configuration.nix`
  * update hostname, wifi, trackpad in `/etc/nixos/configuration.nix` (should be divided in different hosts)
  * `sudo nixos-rebuild switch --upgrade`

## Install /home/pdenti secrets

* copy the private `age.txt` to `$HOME/.sops/age.txt`
* `sops --decrypt --age $(agepublic) --output $HOME/.secrets mynixos/.secrets`

TODO: check out agenix

## Manual installations (not the NixOS way)

Install SDKMAN manually, without updating zshrc

* `curl -s "https://get.sdkman.io?rcupdate=false" | bash`
* logout / login
* `sdk install java 17.0.9-amzn`
* `sdk install maven 3.9.5`

Enable flatpak repo

`flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`

## Notes

### To force update (autoupdate is enabled)

```
sudo nix-channel --update && sudo nixos-rebuild switch --upgrade
```

### To force garbage collect and clean boot menu (autogc is enabled

```
clear-nix-boot-menu
```
