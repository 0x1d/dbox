{config, pkgs, ...}:
 {
   # root filesytem
   fileSystems."/".label = "vmdisk";
 
   # The test vm name is based on the hostname, so it's nice to set one
   networking.hostName = "vmhost"; 
 
   # Add a test user who can sudo to the root account for debugging
   users.extraUsers.vm = {
     isNormalUser = true;
     password = "vm";
     shell = "${pkgs.bash}/bin/bash";
     group = "wheel";
   };

   security.sudo = {
     enable = true;
     wheelNeedsPassword = false;
   };
   
   services.consul = {
     enable = true;
     dropPrivileges = true;
   };

   services.nomad = {
     enable = true;
     dropPrivileges = true;
   };

 }