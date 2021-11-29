{config, pkgs, ...}:
{
  systemd.services.consul.serviceConfig.Type = "notify";
  services = {
    consul = {
      enable = true;
      webUi = true;
    };
    nomad = {
      enable = true;
      #dropPrivileges = true;
      enableDocker = true;
      extraPackages = with pkgs; [
        cni-plugins
        dnsname-cni
      ];
      #extraSettingsPaths = [
      #    "/etc/nomad"
      #];
      settings = {
          bind_addr = "0.0.0.0";
          ui = {
              enabled = true;
          };
          server = {
              enabled = true;
              bootstrap_expect = 1; # for demo; no fault tolerance
          };
          client = {
              enabled = true;
          };
      };
    };
  };
  
}