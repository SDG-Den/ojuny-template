/*
  @menu
  displayname = "Hardware report";
  icon = "computer-symbolic";
  order = 46;
  description = "Generated nixos-facter hardware report";
  category = "07-System";
  hidden = true;
*/

{ self, ... }: {

  flake.modules.nixos.system-facter =
    { config, lib, ... }:
    {
      config = lib.mkIf (builtins.pathExists ./facter.json) {
        hardware.facter.reportPath = ./facter.json;
      };
    };
}
