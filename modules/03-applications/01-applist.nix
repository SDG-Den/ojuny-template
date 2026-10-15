/* @menu
   displayname = "Installed applications";
   icon = "system-software-install-symbolic";
   order = 10;
   description = "Applications installed system-wide";
   category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-applist = { config, pkgs, ... }: {

    # NOTE: environment.systemPackages for general applications. The pages
    # below add their own packages; toggles for the optional desktop apps
    # (vesktop, steam, office and friends) live here.

  };

}
