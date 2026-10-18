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

      workspaceGestures = {
        workspaceNext = {
          keys = [ "left" "3" ];
          dispatcher = "viewtoright";
          args = [ "0" ];
          description = "Next workspace";
        };
        workspacePrev = {
          keys = [ "right" "3" ];
          dispatcher = "viewtoleft";
          args = [ "0" ];
          description = "Previous workspace";
        };
      };

      spawnGestures = {
        launcher = {
          keys = [ "down" "3" ];
          dispatcher = "spawn";
          args = "dms ipc call spotlight toggle";
          description = "Launcher";
          spawn = true;
        };
        menu = {
          keys = [ "up" "3" ];
          dispatcher = "spawn";
          args = "dms ipc call dankMenu toggle root";
          description = "Settings menu";
          spawn = true;
        };
      };

      gestureDefaults = workspaceGestures // spawnGestures;
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

      options.ojuny.mango.gesture = lib.mapAttrs (
        name: spec:
        {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the ${spec.description} gesture.";
          };
        }
        // lib.optionalAttrs (spec.spawn or false) {
          command = lib.mkOption {
            type = lib.types.str;
            default = spec.args;
            description = "Command run by the ${spec.description} gesture.";
          };
        }
      ) gestureDefaults;

      config = {

        # Gestures
        # @option widget = "horizontal-submodule"; label = "Next workspace"; group = "Gestures"; groupOrder = 10; order = 10;
        ojuny.mango.gesture.workspaceNext = { enable = true; };

        # @option widget = "horizontal-submodule"; label = "Previous workspace"; group = "Gestures"; groupOrder = 10; order = 20;
        ojuny.mango.gesture.workspacePrev = { enable = true; };

        # @option widget = "horizontal-submodule"; label = "Launcher"; group = "Gestures"; groupOrder = 10; order = 30;
        ojuny.mango.gesture.launcher = { enable = true; command = "dms ipc call spotlight toggle"; };

        # @option widget = "horizontal-submodule"; label = "Settings menu"; group = "Gestures"; groupOrder = 10; order = 40;
        ojuny.mango.gesture.menu = { enable = true; command = "dms ipc call dankMenu toggle root"; };

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

        # Derived gesture binds, gated on each gesture's enable switch (no @option).
        desktop.ojuny.mango.gesturebind.default =
          lib.mapAttrs
            (name: _: {
              modifier = [ "none" ];
              keys = gestureDefaults.${name}.keys;
              dispatcher = gestureDefaults.${name}.dispatcher;
              args =
                if gestureDefaults.${name}.spawn or false
                then config.ojuny.mango.gesture.${name}.command
                else gestureDefaults.${name}.args;
              description = gestureDefaults.${name}.description;
            })
            (lib.filterAttrs (name: _: config.ojuny.mango.gesture.${name}.enable) gestureDefaults);

      };
    };

}
