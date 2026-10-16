# TEMPORARY test module: SSH access for the ojuny-test key.
# Remove this file and its entry in 00-imports.nix when done testing.
{ self, ... }: {

  flake.modules.nixos.system-ssh-test = {

    services.openssh.enable = true;

    networking.firewall.allowedTCPPorts = [ 22 ];

    users.users.user.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4aHtgEXDU+Hoy3jBzEx42C1stuRo2Rv2jLX4Vc6M9Z ojuny-test-temporary"
    ];

  };

}
