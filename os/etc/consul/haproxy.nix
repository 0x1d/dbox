{ config, pkgs, callPackage, ... }:

{
  services.haproxy.enable = true;
  services.haproxy.config = "#this should be replaced via systemd.services.haproxy-config";
  systemd.services.haproxy-config = {
      enable = true;
      description = "Consul-Template configuration for HAPROXY.";
      documentation = [ "https://github.com/hashicorp/consul-template" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" "consul.service" ];
      path = with pkgs; [
        pkgs.coreutils
        pkgs.consul
        pkgs.consul-template
        pkgs.vault
        pkgs.cacert
        pkgs.procps
      ];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.consul-template}/bin/consul-template -template "/path/to/haproxy.consul:/etc/haproxy.cfg:${pkgs.procps}/bin/pkill -SIGUSR2 haproxy"
          '';
        ExecReload = "${pkgs.procps}/bin/pkill -HUP -f haproxy.consul";
        KillMode = "process";
        KillSignal = "SIGINT";
        LimitNOFILE = "infinity";
        LimitNPROC = "infinity";
        Restart = "on-failure";
        RestartSec = "2";
        StartLimitBurst = "3";
        StartLimitIntervalSec="10";
        TasksMax = "infinity";
        # we run as root, because /etc/ is not writable by the haproxy user, the config file should really exist in /etc/haproxy/
        #User = "${config.services.haproxy.user}";
        User = "root";
      };

      environment = {
        #systemd environment for haproxy-config
      };
    };
}