# My NixOS default config

## WIP: Still Playing with NixOS

Manual setup

## System config

* install nixos
* from console
  * `git clone https://github.com/paolodenti/mynixos.git`
  * `sudo cp mynixos/configuration.nix /etc/nixos/configuration.nix`
  * `sudo nixos-rebuild switch`

## Install /home/pdenti secrets

* `mkdir -p $HOME/.sops`
* copy the private `age.txt` to `$HOME/.sops/age.txt`
* `sops --decrypt --age $(agepublic) --output $HOME/.secrets mynixos/.secrets`

TODO: check out agenix

## Manual installations (not the NixOS way)

Install SDKMAN manually, without updating zshrc

* `curl -s "https://get.sdkman.io?rcupdate=false" | bash`
* logout / login
* `sdk install java 17.0.9-amzn`
* `sdk install maven 3.9.5 `
