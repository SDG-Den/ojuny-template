/* @template
   label = "NixOS patch";
   kind = "nixos";
   filename = "patch-nixos.nix";
   output = "modules/patches";
   placeholders.name.label = "Patch name";
   placeholders.name.default = "example";
   placeholders.name.hint = "flake.modules.nixos.patch-<name>";
   placeholders.title.label = "Menu title";
   placeholders.title.default = "Patch";
*/

/* @menu
   displayname = "%%title%%";
   order = 10;
   category = "Patches";
   systems = [ "all" ];
*/

{ self, inputs, ... }: {

  flake.modules.nixos."patch-%%name%%" = { config, lib, pkgs, ... }: {

  };

}
