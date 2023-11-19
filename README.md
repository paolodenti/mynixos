# My NixOS default config

## WIP: Still Playing with NixOS

Manual setup

* install nixos
* from console
  * `git clone https://github.com/paolodenti/mynixos.git`
  * `sudo cp mynixos/configuration.nix /etc/nixos/configuration.nix`
  * `sudo nixos-rebuild switch`
  * Install pdenti secrets
  * `mkdir -p ~/.sops`
  * `cp mynixos/.secrets ~/.secrets`
  * copy the private `age.txt` to `~/.sops/age.txt`
  * `sops --decrypt --age $(agepublic) --in-place ~/.secrets`

TODO: use agenix
