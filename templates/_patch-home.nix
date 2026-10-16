/* @template
   label = "Home-manager patch";
   kind = "home";
   filename = "patch-home.nix";
   output = "modules/patches";
   placeholders.name.label = "Patch name";
   placeholders.name.default = "example";
   placeholders.name.hint = "flake.modules.homeManager.patch-<name>";
   placeholders.title.label = "Menu title";
   placeholders.title.default = "Patch";
*/

/* @menu
   displayname = "%%title%%";
   order = 1000;
*/

{ self, inputs, ... }: {

  flake.modules.homeManager."patch-%%name%%" = { config, lib, pkgs, ... }: {

  };

}
