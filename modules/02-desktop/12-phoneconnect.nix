/* @menu
   displayname = "Phone connect";
   icon = "phone-symbolic";
   order = 120;
   description = "Phone integration through KDE Connect";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-phoneconnect = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    # NOTE: phone integration: services.kdeconnect.enable plus the
    # dankKDEConnect bar widget and the plugin_dankKDEConnect control-center
    # row of the DMS configs.

  };

}
