/* @menu
   displayname = "Updates";
   icon = "software-update-available-symbolic";
   order = 70;
   description = "Update tooling and automatic update checks";
   category = "System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-updates = { config, pkgs, ... }: {

    imports = [
      inputs.nix-settings-gui.nixosModules.default
      inputs.simple-nix-update-gui.nixosModules.default
    ];

    /* @option widget = "switch"; label = "nix-settings-gui"; group = "Tools"; */
    services.nix-settings-gui.enable = true;

    /* @option widget = "switch"; label = "Simple Nix Update GUI"; group = "Tools"; */
    services.simple-nix-update-gui.enable = true;

    /* @option widget = "text"; label = "Flake URI"; group = "Update daemon"; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; description = "The flake the daemon updates from. Use git+https for private repositories so the logged-in user's credential helper is used."; */
    services.simple-nix-update-gui.flakeUri = "git+https://github.com/OWNER/REPO?dir=HOST";

    /* @option widget = "dropdown"; label = "Check interval"; group = "Update daemon"; choices = [ "30m" "1h" "6h" "12h" "1d" ]; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
    services.simple-nix-update-gui.checkInterval = "1h";

    /* @option widget = "switch"; label = "Notify when updates are available"; group = "Update daemon"; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
    services.simple-nix-update-gui.autoNotify = true;

    /* @option widget = "switch"; label = "Show builds in nitch (nom)"; group = "Update daemon"; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
    services.simple-nix-update-gui.useNom = true;

    /* @option widget = "switch"; label = "Start tray icon on login"; group = "Update daemon"; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
    services.simple-nix-update-gui.trayAutostart = true;

    /* @option widget = "text"; label = "Clone path"; group = "Update daemon"; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; description = "Where the daemon clones the flake, relative to the user's home."; */
    services.simple-nix-update-gui.clonePath = "repos/nix-flake";

  };

}
