/* @menu
   displayname = "Plugins";
   icon = "extension-symbolic";
   order = 110;
   description = "DankMaterialShell plugins";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-plugins = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    # NOTE: desktop.ojuny.dms.plugins.<name> = { enable, src, settings } and
    # desktop.ojuny.dms.managePluginSettings; plugin settings are written to
    # plugin_settings.json.

  };

}
