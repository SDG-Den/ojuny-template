/* @menu
   displayname = "Launcher";
   icon = "system-search-symbolic";
   order = 70;
   description = "App launcher style and behaviour";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-launcher = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    # NOTE: launcher behaviour: desktop.ojuny.dms.settings (launcherStyle,
    # spotlightBarShowModeChips) and the launcher widget settings inside
    # desktop.ojuny.dms.dockConfigs.<id>.

  };

}
