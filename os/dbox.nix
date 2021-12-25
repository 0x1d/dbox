{ config, pkgs, callPackage, ... }:

{
   
  virtualisation.docker.enable = true;

  # OpenGL supprt (needed for Steam)
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "ch,us,de"; # Configure keymap in X11
    xkbOptions = "grp:win_space_toggle";

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    #  lightdm + xfce + i3 = 8-)
    displayManager = {
        defaultSession = "xfce+i3";
        lightdm = {
          enable = true;
        };
    };

    # xfce as display manager
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false; # do not run the window manager
      };
    };

    # i3 as window Manager
    windowManager = {
      leftwm = {
        enable = true;
      };
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          rofi #application launcher
          i3status # gives you the default i3 status bar
          #i3status-rs # TODO configuration
          i3lock #default i3 screen locker
          i3blocks #if you are planning on using i3blocks over i3status
          arandr # xrandr ui
          nitrogen # wallpaper
          pavucontrol # pulse audio volume control for xfce
          ncpamixer # ncurses mixer
        ];
      };
    };

  };

  environment.pathsToLink = [ "/libexec" ];
  programs.dconf.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.master = {
    isNormalUser = true;
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = [ "wheel" "docker" ];
  };
  users.users.doctor = {
    isNormalUser = true;
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = [ "wheel" "docker" ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "ffmpeg-ovenmediaengine-3.4.8"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    nixos-generators
    libcap glibc.static go gcc glibc

    # shell
    direnv
    git
    fish starship
    tree fzf
    curl wget
    unzip
    
    tmux ranger vim
    spacevim
    bpytop
    iotop
    nmap
    dig

    # viewers
    imv
    emulsion
    vlc

    # streaming
    oven-media-engine
    streamlink
    pitivi
    ffmpeg-full
    
    # ui
    xorg.xkill
    nerdfonts
    picom
    brave
    firefox
    qutebrowser
    chromium
    chromium-xorg-conf
    remmina
    rofi
    polybar
        
    # virtualization
    docker
    docker-compose

    # Hashistack
    packer
    consul
    consul-template
    nomad
    nomad-autoscaler
    vault
    terraform
    waypoint
    hashi-ui
    
    # Kubernetes
    kubectl kubectx kubernetes-helm lens k3d
    google-cloud-sdk

    # devel
    gnumake
    ansible
    vscode-with-extensions
    etcher
    gparted

    # tools
    gimp
    obsidian
    obs-studio obs-gstreamer obs-multi-rtmp

    # sdr
    pothos
    rtl-sdr soapysdr soapyhackrf 
    hackrf kalibrate-hackrf  kalibrate-rtl
    gqrx cubicsdr
    rtl_433

    # ui
    lxappearance
    juno-theme
    sweet
    beauty-line-icon-theme

    #  util
    barrier
    filelight
      
    # networking
    networkmanager
    wireguard-tools
    wireshark termshark

    # dcloud
    nextdns
    syncthing
    exodus
    
    # gaming
    #sc-controller
    #eidolon # Provides a single TUI-based registry for drm-free, wine and steam games on linux, accessed through a rofi launch menu.
    #steam
    #steam-run
    #steam-run-native
  ];

  # Compositor
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.8;
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

  # --------------------------------------------------------------------------
  # Networking

  services.openssh.enable = true;
  programs.nm-applet.enable = true;
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    24800 # ???

    # nomad
    4646
    4647 
    4648

    # consul
    8500

    # syncthing
    22000
    8384
  ];

  networking.firewall.allowedUDPPorts = [
    # syncthing
    22000
    21027
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  services = {
      syncthing = {
          enable = true;
          user = "master";
          dataDir = "/home/master/Sync";
          configDir = "/home/master/.config/syncthing";
      };
  };

}
