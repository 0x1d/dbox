# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Use the GRUB 2 boot loader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.version = 2;
  #boot.loader.grub.efiSupport = true;
  #boot.loader.grub.efiInstallAsRemovable = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.systemd-boot.enable = true;

  time.timeZone = "Europe/Zurich";
  networking.hostName = "yakos";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.enp0s20f0u3.useDHCP = true;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  
  virtualisation.docker.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us"; # Configure keymap in X11
    desktopManager = {
      xterm.enable = false;
      # Enable xfce only as display manager
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager = {
        defaultSession = "xfce+i3";
        lightdm = {
          enable = true;
        };
    };
    windowManager = {
    i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        rofi #application launcher 
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
        arandr # xrandr ui
        nitrogen # wallpaper
     ];
    };
  };
  };

  environment.pathsToLink = [ "/libexec" ];
  programs.dconf.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.master = {
    isNormalUser = true;
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    libcap glibc.static go gcc 
    vim
    spacevim
    starship
    bpytop
    iotop
    git
    wget
    alacritty
    fish
    tmux
    ranger
    picom
    pcmanfm
    curl
    brave
    firefox
    qutebrowser
    chromium
    chromium-xorg-conf
    ffmpeg-full
    vlc
    
    
    # virtualization
    docker
    docker-compose

    # Hashistack
    packer
    consul
    nomad
    nomad-autoscaler
    vault
    terraform
    waypoint
    
    # monitoring
    telegraf

    
    etcher
    gnumake
    xorg.xkill
    vscode-with-extensions
    ansible
    kubectl kubectx kubernetes-helm lens k3d
    gimp
    pothos
    obsidian
    syncthing
    obs-studio obs-gstreamer obs-multi-rtmp
    hackrf soapyhackrf kalibrate-hackrf gqrx rtl_433 kalibrate-rtl
    lxappearance
    juno-theme
    barrier
    filelight
    gparted
    
    # networking
    networkmanager
    nextdns
    wireguard-tools
    wireshark termshark

    # crypto stuff
    exodus
    #fscryptctl
  ];

  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}


