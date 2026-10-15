/* @menu
   displayname = "Networking";
   icon = "network-wireless-symbolic";
   order = 30;
   description = "NetworkManager and firewall";
   category = "System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-networking = { config, pkgs, ... }: {

    # NOTE: networking.networkmanager.enable, firewall rules, and any
    # networking.wireless or static-address configuration.

  };

}
