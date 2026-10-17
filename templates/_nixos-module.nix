/* @template
   label = "NixOS module";
   kind = "nixos";
   filename = "module.nix";
   output = "modules";
   placeholders.name.label = "Module name";
   placeholders.name.default = "new-module";
   placeholders.name.hint = "flake.modules.nixos.<name>";
   placeholders.title.label = "Menu title";
   placeholders.title.default = "New Module";
   placeholders.category.label = "Category";
   placeholders.category.default = "07-System";
*/

/* @menu
   displayname = "%%title%%";
   category = "%%category%%";
   order = 1000;
*/

{ self, inputs, ... }: {

  flake.modules.nixos."%%name%%" = { config, pkgs, ... }: {

  };

}
