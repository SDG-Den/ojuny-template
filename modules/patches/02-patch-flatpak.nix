/*
  @menu
  displayname = "Flatpak";
  icon = "system-software-install-symbolic";
  order = 20;
  description = "Sandboxed application distribution via flathub";
  category = "Patches";
  systems = [ "all" ];
*/

{ ... }:

{

  flake.modules.nixos."patch-flatpak" =
    { pkgs, ... }:
    {

      # @option widget = "switch"; label = "Flatpak"; group = "Flatpak"; description = "Enable the Flatpak service and its xdg portal integration.";
      services.flatpak.enable = true;

      # @option widget = "packages"; label = "Packages"; group = "Flatpak"; description = "Graphical store for discovering and installing flatpak applications.";
      environment.systemPackages = with pkgs; [
        bazaar
      ];

    };

}
