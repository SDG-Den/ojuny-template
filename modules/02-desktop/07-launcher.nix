/*
  @menu
  displayname = "Launcher";
  icon = "system-search-symbolic";
  order = 70;
  description = "App launcher style and behaviour";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-launcher = { config, pkgs, ... }: {

    # @option widget = "dropdown"; label = "Launcher style"; group = "Launcher"; description = "DMS launcher style."; choices = [ "island" "bar" "floating" "compact" ];
    desktop.ojuny.dms.settings.launcherStyle = "island";

    # @option widget = "switch"; label = "Show mode chips"; group = "Launcher";
    desktop.ojuny.dms.settings.spotlightBarShowModeChips = true;

    # The dock's own launcher button and logo options live on the Dock page.

  };

}
