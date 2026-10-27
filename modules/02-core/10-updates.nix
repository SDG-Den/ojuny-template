/* @menu
   displayname = "Updates";
   icon = "software-update-available-symbolic";
   order = 100;
   description = "Update tooling and automatic update checks";
   category = "02-Core";
   hidden = true;
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-updates =
    { config, lib, pkgs, ... }:
    let
      /* @option widget = "text"; label = "Flake URI override"; group = "Update daemon"; groupOrder = 20; order = 10; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; description = "Leave empty to use the flake URI set during setup. Use git+https for private repositories so the logged-in user's credential helper is used."; */
      flakeUriOverride = "";

      /* @option widget = "text"; label = "Clone path override"; group = "Update daemon"; groupOrder = 20; order = 60; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; description = "Leave empty to use the clone path set during setup. Where the daemon clones the flake, relative to the user's home."; */
      clonePathOverride = "";
    in
    {

      imports = [
        inputs.nix-settings-gui.nixosModules.default
        inputs.simple-nix-update-gui.nixosModules.default
      ];

      services.nix-settings-gui.enable = true;

      /* @option widget = "switch"; label = "Simple Nix Update GUI"; group = "Tools"; groupOrder = 10; order = 10; */
      services.simple-nix-update-gui.enable = false;

      services.simple-nix-update-gui.flakeUri =
        lib.mkIf (flakeUriOverride != "") flakeUriOverride;

      /* @option widget = "dropdown"; label = "Check interval"; group = "Update daemon"; groupOrder = 20; order = 20; choices = [ "30m" "1h" "6h" "12h" "1d" ]; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
      services.simple-nix-update-gui.checkInterval = "1h";

      /* @option widget = "switch"; label = "Notify when updates are available"; group = "Update daemon"; groupOrder = 20; order = 30; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
      services.simple-nix-update-gui.autoNotify = true;

      /* @option widget = "switch"; label = "Use nix-output-monitor for build graphing"; group = "Update daemon"; groupOrder = 20; order = 40; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
      services.simple-nix-update-gui.useNom = true;

      /* @option widget = "switch"; label = "Start tray icon on login"; group = "Update daemon"; groupOrder = 20; order = 50; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
      services.simple-nix-update-gui.trayAutostart = true;

      services.simple-nix-update-gui.clonePath = lib.mkMerge [
        (lib.mkIf (clonePathOverride != "") clonePathOverride)
        (lib.mkDefault config.ojuny.repoPath)
      ];

    };

}
