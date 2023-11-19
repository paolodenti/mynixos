# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # docker
  virtualisation.docker = {
    enable = true;
    extraOptions = "--iptables=false";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.bash;
    users = {
      pdenti = {
        isNormalUser = true;
        description = "Paolo Denti";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
        password = "password";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAt/0brzr0xGFpaAgCAhNNXPj3EuCfmFndxyKlH/uLMnre9y6RzSOxHNJbiJy+jdkKsPv2zvISwnf7Z9Mv7rCZElRd9EKVZ7YZNVE02zfQCK/qEbhttacVvDEuPps55Mwywih+YlslsVq+UJ2I7Cyk6tnHuSXlV54qFi9kPeONwdtI9/tnYkpcpUzmFWWlHOcLPWgTM/8hczDCGSwTbQj+KHKKI9Wv5pCifPrgJQtPUeZV2Qqb+1ksxgNX841APdjUVDnZyuNa7Rd6+8WBWXt9I/wHVFzB5gTa08fsbeYOjaJ5Pg7oLYIKfJKKJaQ6jgOcU4eVCDJTscjxHms36vpK1w== pd@pdmac" ];
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    git
    gnumake42
    zsh
    kubectl
    stern
    helm
    terraform
    k9s
    jq
    google-cloud-sdk
    doctl
    sops
    age
    zip
    unzip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs = {
    zsh = {
      enable = true;
    };
  };

  # Home Manager
  home-manager.users.pdenti = { pkgs, ... }: {
    home.username = "pdenti";
    home.homeDirectory = "/home/pdenti";
    home.stateVersion = "23.05";
    nixpkgs.config.allowUnfree = true;
    home.packages = [
      pkgs.firefox
      pkgs.google-chrome
      pkgs.httpie
      pkgs.dbeaver
      pkgs.postman
      pkgs.jetbrains.idea-ultimate
      pkgs._1password
      pkgs.authy
      pkgs.telegram-desktop
      pkgs.zoom-us
      pkgs.qFlipper
    ];
    programs.home-manager.enable = true;
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        ll = "ls -lA";
        sshpassword = "ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no";
        clear-nix-boot-menu = "sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      };
      oh-my-zsh = {
        enable = true;
        theme = "agnoster";
        plugins = [
          "kubectl"
          "copyfile"
          "copypath"
          "history"
          "wd"
          "web-search"
          "sudo"
        ];
      };
      initExtra = ''
        DEFAULT_USER="$USER"
        CASE_SENSITIVE="true"

        export VISUAL=vim
        export EDITOR="$VISUAL"

        export CLICOLOR=1
        export LS_COLORS="di=33:ln=32:so=35:pi=33:ex=31:bd=34;46:cd=37;43:su=37;41:sg=30;46:tw=37;42:ow=37;43"

        mkdir -p $HOME/.sops
        export SOPS_AGE_KEY_FILE=$HOME/.sops/age.txt

        # age
        agepublic() {
          cat $SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)"
        }

        # git helpers
        gitmerge() {
          destination="$1"

          if [[ "" == "$destination" ]]; then
            echo "usage: 'gitmerge <destination branch>'"
            return
          fi
          if ! git show-ref --quiet "refs/heads/$destination"; then
            echo "$destination branch not found"
            return
          fi

          branch=`git branch 2> /dev/null | grep \* | sed 's#\*\ \(.*\)#\1#'`
          if [[ "$branch" == "$destination" ]]; then
            echo "cannot merge on the same branch"
            return
          fi

          git checkout "$destination" && git pull && git branch -d "branch" && git remote prune origin
        }

        gitbump() {
          branch="$1"
          git checkout -b "$branch" && make upgrade
        }

        # import my secrets
        if [ -f $HOME/.secrets ]; then                          
          source $HOME/.secrets                                   
        fi   

        #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
        export SDKMAN_DIR="$HOME/.sdkman"
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
      '';
    };
    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "Paolo Denti";
      userEmail = "paolo.denti@gmail.com";
      extraConfig = {
        core = {
          editor = "vim";
        };
        push = {
          autoSetupRemote = "true";
          default = "current";
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
    programs.vim = {
      enable = true;
      extraConfig = ''
        syntax on
      '';
    };
  };

  # List services that you want to enable:
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  # Auto Upgrade
  system.autoUpgrade.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
