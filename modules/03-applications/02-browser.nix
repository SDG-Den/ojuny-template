/* @menu
   displayname = "Browser";
   icon = "web-browser-symbolic";
   order = 20;
   description = "Web browser and default browser";
   category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-browser = { config, pkgs, ... }: {

    # NOTE: the default browser package, xdg.mimeApps.defaultApplications for
    # http/https, and browser extensions once a firefox-addons input is added
    # to flake.nix.

  };

}
