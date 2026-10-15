/* @menu
   displayname = "Vesktop";
   icon = "internet-chat-symbolic";
   order = 60;
   description = "Discord client";
   category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-vesktop = { config, pkgs, ... }: {

    # NOTE: the vesktop package and any wayland/discord-related settings;
    # toggled from the applist page.

  };

}
