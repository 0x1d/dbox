{ config,lib, pkgs, callPackage, ... }:
{
  imports = [
    ./os/iso.nix
  ];

  services.sshd.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  
  users.users.root.password = "nixos";
  services.openssh.permitRootLogin = lib.mkDefault "yes";
  services.getty.autologinUser = lib.mkDefault "root";

}
