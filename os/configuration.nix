# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./dbox.nix
    ];

  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.systemd-boot.enable = true;

  time.timeZone = "Europe/Zurich";
  networking.hostName = "yak0";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.useDHCP = false;

  # CUSTOM interfaces
  networking.interfaces.enp0s31f6.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

}
