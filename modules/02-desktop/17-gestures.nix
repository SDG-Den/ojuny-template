/*
  @menu
  displayname = "Gestures";
  icon = "input-touchpad-symbolic";
  order = 135;
  description = "Touchpad swipe gestures and swipe tuning";
  category = "Desktop";
*/

/*
  @snippet
  name = "gesture";
  label = "Add gesture";
  snippet = ''
    # @option widget = "list"; label = "Modifiers"; group = "Custom gestures"; hidden = true;
    desktop.ojuny.mango.gesturebind.default.%%id%%.modifier = [ "none" ];
    # @option widget = "list"; label = "Direction and fingers"; group = "Custom gestures";
    desktop.ojuny.mango.gesturebind.default.%%id%%.keys = [ "%%direction%%" "%%fingers%%" ];
    # @option widget = "text"; label = "Dispatcher"; group = "Custom gestures";
    desktop.ojuny.mango.gesturebind.default.%%id%%.dispatcher = "%%dispatcher%%";
    # @option widget = "list"; label = "Arguments"; group = "Custom gestures";
    desktop.ojuny.mango.gesturebind.default.%%id%%.args = %%args%%;
    # @option widget = "text"; label = "Description"; group = "Custom gestures";
    desktop.ojuny.mango.gesturebind.default.%%id%%.description = "%%label%%";
  '';
  placeholders.id.label = "Gesture ID";
  placeholders.id.default = "myGesture";
  placeholders.label.label = "Label";
  placeholders.label.default = "My gesture";
  placeholders.direction.label = "Direction";
  placeholders.direction.default = "left";
  placeholders.fingers.label = "Fingers";
  placeholders.fingers.default = "3";
  placeholders.dispatcher.label = "Dispatcher";
  placeholders.dispatcher.default = "viewtoright";
  placeholders.args.label = "Arguments";
  placeholders.args.default = "[ \"0\" ]";
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
        # @option widget = "list"; label = "Modifiers"; group = "Workspace"; hidden = true;
        desktop.ojuny.mango.gesturebind.default.workspaceNext.modifier = [ "none" ];

        # @option widget = "list"; label = "Swipe left"; group = "Workspace"; description = "Direction and finger count, e.g. left 3.";
        desktop.ojuny.mango.gesturebind.default.workspaceNext.keys = [ "left" "3" ];

        # @option widget = "text"; label = "Dispatcher"; group = "Workspace";
        desktop.ojuny.mango.gesturebind.default.workspaceNext.dispatcher = "viewtoright";

        # @option widget = "list"; label = "Arguments"; group = "Workspace";
        desktop.ojuny.mango.gesturebind.default.workspaceNext.args = [ "0" ];

        # @option widget = "text"; label = "Description"; group = "Workspace";
        desktop.ojuny.mango.gesturebind.default.workspaceNext.description = "Next workspace";

        # @option widget = "list"; label = "Modifiers"; group = "Workspace"; hidden = true;
        desktop.ojuny.mango.gesturebind.default.workspacePrev.modifier = [ "none" ];

        # @option widget = "list"; label = "Swipe right"; group = "Workspace"; description = "Direction and finger count, e.g. right 3.";
        desktop.ojuny.mango.gesturebind.default.workspacePrev.keys = [ "right" "3" ];

        # @option widget = "text"; label = "Dispatcher"; group = "Workspace";
        desktop.ojuny.mango.gesturebind.default.workspacePrev.dispatcher = "viewtoleft";

        # @option widget = "list"; label = "Arguments"; group = "Workspace";
        desktop.ojuny.mango.gesturebind.default.workspacePrev.args = [ "0" ];

        # @option widget = "text"; label = "Description"; group = "Workspace";
        desktop.ojuny.mango.gesturebind.default.workspacePrev.description = "Previous workspace";

        # Launcher swipe
        # @option widget = "list"; label = "Modifiers"; group = "Launcher"; hidden = true;
        desktop.ojuny.mango.gesturebind.default.launcher.modifier = [ "none" ];

        # @option widget = "list"; label = "Swipe down"; group = "Launcher"; description = "Direction and finger count, e.g. down 3.";
        desktop.ojuny.mango.gesturebind.default.launcher.keys = [ "down" "3" ];

        # @option widget = "text"; label = "Dispatcher"; group = "Launcher";
        desktop.ojuny.mango.gesturebind.default.launcher.dispatcher = "spawn";

        # @option widget = "text"; label = "Command"; group = "Launcher";
        desktop.ojuny.mango.gesturebind.default.launcher.args = "dms ipc call spotlight toggle";

        # @option widget = "text"; label = "Description"; group = "Launcher";
        desktop.ojuny.mango.gesturebind.default.launcher.description = "Launcher";

        # Menu swipe
        # @option widget = "list"; label = "Modifiers"; group = "Menu"; hidden = true;
        desktop.ojuny.mango.gesturebind.default.menu.modifier = [ "none" ];

        # @option widget = "list"; label = "Swipe up"; group = "Menu"; description = "Direction and finger count, e.g. up 3.";
        desktop.ojuny.mango.gesturebind.default.menu.keys = [ "up" "3" ];

        # @option widget = "text"; label = "Dispatcher"; group = "Menu";
        desktop.ojuny.mango.gesturebind.default.menu.dispatcher = "spawn";

        # @option widget = "text"; label = "Command"; group = "Menu";
        desktop.ojuny.mango.gesturebind.default.menu.args = "dms ipc call dankMenu toggle root";

        # @option widget = "text"; label = "Description"; group = "Menu";
        desktop.ojuny.mango.gesturebind.default.menu.description = "Settings menu";

        # Swipe tuning
        # @option widget = "switch"; label = "Live gesture transitions"; group = "Swipe tuning"; description = "Follow the swipe while the fingers are still down.";
        ojuny.mango.flag.gesture_live = true;

        # @option widget = "spin"; label = "Swipe min threshold"; group = "Swipe tuning"; min = 0; max = 100;
        desktop.ojuny.mango.global.swipe_min_threshold = 1;

        # @option widget = "spin"; label = "Gesture swipe distance"; group = "Swipe tuning"; min = 0; max = 2000; unit = "px";
        desktop.ojuny.mango.global.gesture_swipe_distance = 300;

        # @option widget = "slider"; label = "Gesture cancel ratio"; group = "Swipe tuning"; min = 0.0; max = 1.0; step = 0.05;
        desktop.ojuny.mango.global.gesture_swipe_cancel_ratio = 0.5;

        # @option widget = "spin"; label = "Gesture force-commit speed"; group = "Swipe tuning"; min = 0; max = 200; unit = "px";
        desktop.ojuny.mango.global.gesture_swipe_min_speed_to_force = 10;

        # Derived mango integer (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.gesture_live = if config.ojuny.mango.flag.gesture_live then 1 else 0;

        /*
          @insert
          name = "gesture";
          group = "Custom gestures";
          order = 1000;
        */

      };
    };

}
