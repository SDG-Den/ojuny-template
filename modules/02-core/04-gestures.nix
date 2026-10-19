/*
  @menu
  displayname = "Gestures";
  icon = "input-touchpad-symbolic";
  order = 40;
  description = "Touchpad swipe gestures and swipe tuning";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-gestures =
    { config, lib, ... }:

    let
      # mango stores booleans as the integers 0 and 1, so this is exposed as a
      # switch under ojuny.mango.* and written back as 0/1 below.
      flagDefaults = {
        gesture_live = true;
      };

      # Every mango swipe gesture: 3- or 4-finger, four directions — 8 total.
      # The attr name is the label shown as the row key in the settings table;
      # it supplies this row's defaults (enable/dispatcher/args/keys/description).
      gestureDefaults = {
        "Next workspace (3f left)" = {
          keys = [ "left" "3" ];
          dispatcher = "viewtoright";
          args = "0";
          description = "Next workspace";
          enableDefault = true;
        };
        "Previous workspace (3f right)" = {
          keys = [ "right" "3" ];
          dispatcher = "viewtoleft";
          args = "0";
          description = "Previous workspace";
          enableDefault = true;
        };
        "Launcher (3f down)" = {
          keys = [ "down" "3" ];
          dispatcher = "spawn";
          args = "dms ipc call spotlight toggle";
          description = "Launcher";
          enableDefault = true;
        };
        "Settings menu (3f up)" = {
          keys = [ "up" "3" ];
          dispatcher = "spawn";
          args = "dms ipc call dankMenu toggle root";
          description = "Settings menu";
          enableDefault = true;
        };
        "4-finger left" = {
          keys = [ "left" "4" ];
          dispatcher = "viewnext_have_client";
          args = "0";
          description = "4-finger left (workspace next / view next)";
          enableDefault = false;
        };
        "4-finger right" = {
          keys = [ "right" "4" ];
          dispatcher = "viewprev_have_client";
          args = "0";
          description = "4-finger right (workspace prev / view prev)";
          enableDefault = false;
        };
        "4-finger down" = {
          keys = [ "down" "4" ];
          dispatcher = "toggleoverview";
          args = "0";
          description = "4-finger down (toggle overview)";
          enableDefault = false;
        };
        "4-finger up" = {
          keys = [ "up" "4" ];
          dispatcher = "toggleoverview";
          args = "0";
          description = "4-finger up (toggle overview)";
          enableDefault = false;
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

      # One option set, one table row per gesture. enable/dispatcher/args are
      # all user-settable. Unknown keys (row adds/renames) take inert defaults.
      options.ojuny.mango.gesture = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule (
          { name, ... }:
          let
            spec = gestureDefaults.${name} or {
              enableDefault = false;
              dispatcher = "";
              args = "";
            };
          in
          {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = spec.enableDefault;
                description = "Enable this swipe gesture.";
              };
              dispatcher = lib.mkOption {
                type = lib.types.str;
                default = spec.dispatcher;
                description = "mango dispatcher this gesture runs.";
              };
              args = lib.mkOption {
                type = lib.types.str;
                default = spec.args;
                description = "Dispatcher arguments, comma-joined into the bind value.";
              };
            };
          }
        ));
        default = { };
      };

      config = {

        # @option widget = "table-attrset"; label = "Swipe gestures"; group = "Gestures"; groupOrder = 10; columns = [ "enable" "dispatcher" "args" ]; columnTypes = [ "bool" "str" "str" ];
        ojuny.mango.gesture = {
          "Next workspace (3f left)" = {
            enable = true;
            dispatcher = "viewtoright";
            args = "0";
          };
          "Previous workspace (3f right)" = {
            enable = true;
            dispatcher = "viewtoleft";
            args = "0";
          };
          "Launcher (3f down)" = {
            enable = true;
            dispatcher = "spawn";
            args = "dms ipc call spotlight toggle";
          };
          "Settings menu (3f up)" = {
            enable = true;
            dispatcher = "spawn";
            args = "dms ipc call dankMenu toggle root";
          };
          "4-finger left" = {
            enable = false;
            dispatcher = "viewnext_have_client";
            args = "0";
          };
          "4-finger right" = {
            enable = false;
            dispatcher = "viewprev_have_client";
            args = "0";
          };
          "4-finger down" = {
            enable = false;
            dispatcher = "toggleoverview";
            args = "0";
          };
          "4-finger up" = {
            enable = false;
            dispatcher = "toggleoverview";
            args = "0";
          };
        };

        # Swipe tuning
        # @option widget = "switch"; label = "Live gesture transitions"; group = "Swipe tuning"; groupOrder = 20; order = 10; description = "Follow the swipe while the fingers are still down.";
        ojuny.mango.flag.gesture_live = true;

        # @option widget = "spin"; label = "Swipe min threshold"; group = "Swipe tuning"; groupOrder = 20; order = 20; min = 0; max = 100;
        desktop.ojuny.mango.global.swipe_min_threshold = 1;

        # @option widget = "spin"; label = "Gesture swipe distance"; group = "Swipe tuning"; groupOrder = 20; order = 30; min = 0; max = 2000; unit = "px";
        desktop.ojuny.mango.global.gesture_swipe_distance = 300;

        # @option widget = "slider"; label = "Gesture cancel ratio"; group = "Swipe tuning"; groupOrder = 20; order = 40; min = 0.0; max = 1.0; step = 0.05;
        desktop.ojuny.mango.global.gesture_swipe_cancel_ratio = 0.5;

        # @option widget = "spin"; label = "Gesture force-commit speed"; group = "Swipe tuning"; groupOrder = 20; order = 50; min = 0; max = 200; unit = "px";
        desktop.ojuny.mango.global.gesture_swipe_min_speed_to_force = 10;

        # Derived mango integer (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.gesture_live = if config.ojuny.mango.flag.gesture_live then 1 else 0;

        # Derived gesture binds for the eight known gestures, gated on enable;
        # dispatcher/args come from the editable table above (no @option).
        desktop.ojuny.mango.gesturebind.default =
          lib.mapAttrs
            (name: _: {
              modifier = [ "none" ];
              keys = gestureDefaults.${name}.keys;
              dispatcher = config.ojuny.mango.gesture.${name}.dispatcher;
              args = config.ojuny.mango.gesture.${name}.args;
              description = gestureDefaults.${name}.description;
            })
            (lib.filterAttrs (name: _: config.ojuny.mango.gesture.${name}.enable) gestureDefaults);

      };
    };

}
