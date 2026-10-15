/* @menu
   displayname = "Application menu";
   icon = "open-menu-symbolic";
   order = 100;
   description = "DMS application menu entries";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-menu = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    # NOTE: desktop.ojuny.dankMenu — enable, the id-keyed menu rows
    # (icon/label/aliases/target/action/when/checked/disabled) and additional
    # dankMenu settings. A non-empty menu tree overrides the bundled menu.

  };

}
