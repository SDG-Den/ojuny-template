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

        # Workspace swipes
        desktop.ojuny.mango.gesturebind.default.workspaceNext.modifier = [ "none" ];
        desktop.ojuny.mango.gesturebind.default.workspaceNext.keys = [ "left" "3" ];
        desktop.ojuny.mango.gesturebind.default.workspaceNext.dispatcher = "viewtoright";
        desktop.ojuny.mango.gesturebind.default.workspaceNext.args = [ "0" ];
        desktop.ojuny.mango.gesturebind.default.workspaceNext.description = "Next workspace";

        desktop.ojuny.mango.gesturebind.default.workspacePrev.modifier = [ "none" ];
        desktop.ojuny.mango.gesturebind.default.workspacePrev.keys = [ "right" "3" ];
        desktop.ojuny.mango.gesturebind.default.workspacePrev.dispatcher = "viewtoleft";
        desktop.ojuny.mango.gesturebind.default.workspacePrev.args = [ "0" ];
        desktop.ojuny.mango.gesturebind.default.workspacePrev.description = "Previous workspace";

        # Launcher swipe
        desktop.ojuny.mango.gesturebind.default.launcher.modifier = [ "none" ];
        desktop.ojuny.mango.gesturebind.default.launcher.keys = [ "down" "3" ];
        desktop.ojuny.mango.gesturebind.default.launcher.dispatcher = "spawn";
        # @option widget = "text"; label = "Launcher command"; group = "Gestures"; groupOrder = 10; order = 10;
        desktop.ojuny.mango.gesturebind.default.launcher.args = "dms ipc call spotlight toggle";
        desktop.ojuny.mango.gesturebind.default.launcher.description = "Launcher";

        # Menu swipe
        desktop.ojuny.mango.gesturebind.default.menu.modifier = [ "none" ];
        desktop.ojuny.mango.gesturebind.default.menu.keys = [ "up" "3" ];
        desktop.ojuny.mango.gesturebind.default.menu.dispatcher = "spawn";
        # @option widget = "text"; label = "Menu command"; group = "Gestures"; groupOrder = 10; order = 20;
        desktop.ojuny.mango.gesturebind.default.menu.args = "dms ipc call dankMenu toggle root";
        desktop.ojuny.mango.gesturebind.default.menu.description = "Settings menu";

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

      };
    };

}
