/* @menu
   displayname = "Gaming";
   icon = "applications-games-symbolic";
   order = 70;
   description = "Steam and gaming";
   category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-steam = { config, pkgs, ... }: {

    # NOTE: programs.steam and gaming-related packages; other game launchers
    # are out of scope for this template.

  };

}
