/*
  @menu
  displayname = "Dwindle layout";
  icon = "preferences-system-windows-symbolic";
  order = 40;
  description = "Dwindle tiling layout";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-mangodwindle =
    { config, lib, ... }:

    let
      # mango stores booleans as the integers 0 and 1, so these are exposed as
      # switches under ojuny.mango.* and written back as 0/1 in the derived
      # assignments at the bottom of this module.
      flagDefaults = {
        dwindle_smart_split = false;
        dwindle_preserve_split = true;
        dwindle_smart_resize = false;
        dwindle_drop_simple_split = false;
        dwindle_manual_split = false;
      };

      # mango mode integers, exposed as named choices under ojuny.mango.enum and
      # mapped back to their integers in the derived assignments below.
      enumSpecs = {
        dwindle_horizontal_split = {
          default = "right";
          choices = {
            "follow-cursor" = 0;
            "right" = 1;
            "left" = 2;
          };
        };
        dwindle_vertical_split = {
          default = "below";
          choices = {
            "follow-cursor" = 0;
            "below" = 1;
            "above" = 2;
          };
        };
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

      options.ojuny.mango.enum = lib.mapAttrs (
        name: spec:
        lib.mkOption {
          type = lib.types.enum (lib.attrNames spec.choices);
          default = spec.default;
          description = "mango global ${name}.";
        }
      ) enumSpecs;

      config = {
        # Dwindle layout
        # @option widget = "slider"; label = "Split ratio"; group = "Dwindle layout"; min = 0.05; max = 0.95; step = 0.05; advanced = true;
        desktop.ojuny.mango.global.dwindle_split_ratio = 0.5;

        # @option widget = "switch"; label = "Split axis from cursor"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_smart_split = false;

        # @option widget = "dropdown"; label = "Horizontal split position"; group = "Dwindle layout"; choices = [ "follow-cursor" "right" "left" ]; hidden = true;
        ojuny.mango.enum.dwindle_horizontal_split = "right";

        # @option widget = "dropdown"; label = "Vertical split position"; group = "Dwindle layout"; choices = [ "follow-cursor" "below" "above" ]; hidden = true;
        ojuny.mango.enum.dwindle_vertical_split = "below";

        # @option widget = "switch"; label = "Preserve sibling split on close"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_preserve_split = true;

        # @option widget = "switch"; label = "Smart resize toward cursor"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_smart_resize = false;

        # @option widget = "switch"; label = "Two-zone drop preview"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_drop_simple_split = false;

        # @option widget = "switch"; label = "Manual split mode"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_manual_split = false;

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.dwindle_smart_split =
          if config.ojuny.mango.flag.dwindle_smart_split then 1 else 0;
        desktop.ojuny.mango.global.dwindle_preserve_split =
          if config.ojuny.mango.flag.dwindle_preserve_split then 1 else 0;
        desktop.ojuny.mango.global.dwindle_smart_resize =
          if config.ojuny.mango.flag.dwindle_smart_resize then 1 else 0;
        desktop.ojuny.mango.global.dwindle_drop_simple_split =
          if config.ojuny.mango.flag.dwindle_drop_simple_split then 1 else 0;
        desktop.ojuny.mango.global.dwindle_manual_split =
          if config.ojuny.mango.flag.dwindle_manual_split then 1 else 0;

        desktop.ojuny.mango.global.dwindle_horizontal_split =
          enumSpecs.dwindle_horizontal_split.choices.${config.ojuny.mango.enum.dwindle_horizontal_split};
        desktop.ojuny.mango.global.dwindle_vertical_split =
          enumSpecs.dwindle_vertical_split.choices.${config.ojuny.mango.enum.dwindle_vertical_split};
      };
    };
}