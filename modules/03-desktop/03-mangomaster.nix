/*
  @menu
  displayname = "Master layout";
  icon = "preferences-system-windows-symbolic";
  order = 30;
  description = "Master and stack layout";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-mangomaster =
    { config, lib, ... }:

    let
      # mango stores booleans as the integers 0 and 1, so these are exposed as
      # switches under ojuny.mango.* and written back as 0/1 in the derived
      # assignments at the bottom of this module.
      flagDefaults = {
        new_is_master = true;
        center_master_overspread = true;
        center_when_single_stack = true;
      };
    in
    {
      options.ojuny.mango.flag = lib.mapAttrs (
        name: default:
        lib.mkOption {
          type = lib.types.bool;
          inherit default;
          description = "mango global ${name}, stored as 0/1.";
        }
      ) flagDefaults;

      config = {
        # Master layout
        # @option widget = "switch"; label = "New window becomes master"; group = "Master layout";
        ojuny.mango.flag.new_is_master = true;

        # @option widget = "slider"; label = "Master factor"; group = "Master layout"; min = 0.1; max = 1.0; step = 0.05;
        desktop.ojuny.mango.global.default_master_factor = 0.65;

        # @option widget = "dropdown"; label = "Master count"; group = "Master layout"; choices = [ "1" "2" "3" "4" "5" ];
        desktop.ojuny.mango.global.default_master_count = 1;

        # @option widget = "switch"; label = "Master spreads when no stack"; group = "Master layout";
        ojuny.mango.flag.center_master_overspread = true;

        # @option widget = "switch"; label = "Center master with single stack window"; group = "Master layout";
        ojuny.mango.flag.center_when_single_stack = true;

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.new_is_master = if config.ojuny.mango.flag.new_is_master then 1 else 0;
        desktop.ojuny.mango.global.center_master_overspread =
          if config.ojuny.mango.flag.center_master_overspread then 1 else 0;
        desktop.ojuny.mango.global.center_when_single_stack =
          if config.ojuny.mango.flag.center_when_single_stack then 1 else 0;
      };
    };
}