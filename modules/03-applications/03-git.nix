/* @menu
   displayname = "Git";
   icon = "folder-remote-symbolic";
   order = 30;
   description = "Git and version control defaults";
   category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-git = { config, pkgs, ... }: {

    # NOTE: git as a package or programs.git, the default user.name/email, and
    # any graphical git clients.

  };

}
