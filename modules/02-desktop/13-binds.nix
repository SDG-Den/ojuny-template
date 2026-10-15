/*
  @menu
  displayname = "Keybinds";
  icon = "preferences-desktop-keyboard-symbolic";
  order = 130;
  description = "Key, mouse, axis and gesture bindings";
  category = "Desktop";
*/

/*
  @snippet
  name = "keybind";
  label = "Add keybind";
  snippet = ''
    # @option widget = "submodule"; label = "%%label%%"; group = "Custom binds";
    desktop.ojuny.mango.binds.default.%%id%% = {
      # @option widget = "list"; label = "Modifiers"; group = "Custom binds";
      modifier = [ %%modifier%% ];
      # @option widget = "list"; label = "Keys"; group = "Custom binds";
      keys = [ "%%keys%%" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Custom binds"; hidden = true;
      dispatcher = "%%dispatcher%%";
      # @option widget = "list"; label = "Arguments"; group = "Custom binds";
      args = %%args%%;
      # @option widget = "text"; label = "Description"; group = "Custom binds"; hidden = true;
      description = "%%label%%";
    };
  '';
  placeholders.id.label = "Bind ID";
  placeholders.id.default = "myBind";
  placeholders.label.label = "Label";
  placeholders.label.default = "My bind";
  placeholders.modifier.label = "Modifiers";
  placeholders.modifier.default = "\"SUPER\"";
  placeholders.keys.label = "Key";
  placeholders.keys.default = "X";
  placeholders.dispatcher.label = "Dispatcher";
  placeholders.dispatcher.default = "spawn";
  placeholders.args.label = "Arguments";
  placeholders.args.default = "\"my-app\"";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-binds = { config, pkgs, ... }: {

    # Each bind is a small, closely related group (modifier, keys, target), so
    # the submodule widget fits here. Dispatchers and descriptions are internal
    # to mango and DMS, so they stay hidden behind the hidden-settings toggle.

    # @option widget = "submodule"; label = "Terminal"; group = "Applications";
    desktop.ojuny.mango.binds.default.terminal = {
      # @option widget = "list"; label = "Modifiers"; group = "Applications";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Applications";
      keys = [ "Return" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Applications"; hidden = true;
      dispatcher = "spawn";
      # @option widget = "text"; label = "Arguments"; group = "Applications"; hidden = true;
      args = "ghostty";
      # @option widget = "text"; label = "Description"; group = "Applications"; hidden = true;
      description = "Terminal";
    };

    # @option widget = "submodule"; label = "Browser"; group = "Applications";
    desktop.ojuny.mango.binds.default.browser = {
      # @option widget = "list"; label = "Modifiers"; group = "Applications";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Applications";
      keys = [ "B" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Applications"; hidden = true;
      dispatcher = "spawn";
      # @option widget = "text"; label = "Arguments"; group = "Applications"; hidden = true;
      args = "firefox --new-window";
      # @option widget = "text"; label = "Description"; group = "Applications"; hidden = true;
      description = "Open Browser";
    };

    # @option widget = "submodule"; label = "Files"; group = "Applications";
    desktop.ojuny.mango.binds.default.files = {
      # @option widget = "list"; label = "Modifiers"; group = "Applications";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Applications";
      keys = [ "E" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Applications"; hidden = true;
      dispatcher = "spawn";
      # @option widget = "text"; label = "Arguments"; group = "Applications"; hidden = true;
      args = "nautilus --new-window";
      # @option widget = "text"; label = "Description"; group = "Applications"; hidden = true;
      description = "Open Files";
    };

    # @option widget = "submodule"; label = "Launcher"; group = "Applications";
    desktop.ojuny.mango.binds.default.launcher = {
      # @option widget = "list"; label = "Modifiers"; group = "Applications";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Applications";
      keys = [ "SPACE" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Applications"; hidden = true;
      dispatcher = "spawn";
      # @option widget = "text"; label = "Arguments"; group = "Applications"; hidden = true;
      args = "dms ipc call spotlight toggle";
      # @option widget = "text"; label = "Description"; group = "Applications"; hidden = true;
      description = "Launcher";
    };

    # @option widget = "submodule"; label = "Settings menu"; group = "Applications";
    desktop.ojuny.mango.binds.default.settings = {
      # @option widget = "list"; label = "Modifiers"; group = "Applications";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Applications";
      keys = [ "X" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Applications"; hidden = true;
      dispatcher = "spawn";
      # @option widget = "text"; label = "Arguments"; group = "Applications"; hidden = true;
      args = "dms ipc call dankMenu toggle root";
      # @option widget = "text"; label = "Description"; group = "Applications"; hidden = true;
      description = "Toggle Settings";
    };

    # @option widget = "submodule"; label = "Keybind overview"; group = "Applications";
    desktop.ojuny.mango.binds.default.keybinds = {
      # @option widget = "list"; label = "Modifiers"; group = "Applications";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Applications";
      keys = [ "K" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Applications"; hidden = true;
      dispatcher = "spawn";
      # @option widget = "text"; label = "Arguments"; group = "Applications"; hidden = true;
      args = "dms ipc call keybinds open binds";
      # @option widget = "text"; label = "Description"; group = "Applications"; hidden = true;
      description = "Show Keybinds";
    };

    # @option widget = "submodule"; label = "Reload config"; group = "Window manager";
    desktop.ojuny.mango.binds.default.reload = {
      # @option widget = "list"; label = "Modifiers"; group = "Window manager";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Window manager";
      keys = [ "R" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Window manager"; hidden = true;
      dispatcher = "reload_config";
      # @option widget = "text"; label = "Arguments"; group = "Window manager"; hidden = true;
      args = [ ];
      # @option widget = "text"; label = "Description"; group = "Window manager"; hidden = true;
      description = "Reload Config";
    };

    # @option widget = "submodule"; label = "Close window"; group = "Window manager";
    desktop.ojuny.mango.binds.default.close = {
      # @option widget = "list"; label = "Modifiers"; group = "Window manager";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Window manager";
      keys = [ "Q" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Window manager"; hidden = true;
      dispatcher = "killclient";
      # @option widget = "text"; label = "Arguments"; group = "Window manager"; hidden = true;
      args = [ ];
      # @option widget = "text"; label = "Description"; group = "Window manager"; hidden = true;
      description = "Kill Client";
    };

    # @option widget = "submodule"; label = "Quit mango"; group = "Window manager";
    desktop.ojuny.mango.binds.default.quit = {
      # @option widget = "list"; label = "Modifiers"; group = "Window manager";
      modifier = [
        "SUPER"
        "SHIFT"
      ];
      # @option widget = "list"; label = "Keys"; group = "Window manager";
      keys = [ "Escape" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Window manager"; hidden = true;
      dispatcher = "quit";
      # @option widget = "text"; label = "Arguments"; group = "Window manager"; hidden = true;
      args = [ ];
      # @option widget = "text"; label = "Description"; group = "Window manager"; hidden = true;
      description = "Quit Mango";
    };

    # @option widget = "submodule"; label = "Maximize"; group = "Window manager";
    desktop.ojuny.mango.binds.default.maximize = {
      # @option widget = "list"; label = "Modifiers"; group = "Window manager";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Window manager";
      keys = [ "F" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Window manager"; hidden = true;
      dispatcher = "togglemaximizescreen";
      # @option widget = "text"; label = "Arguments"; group = "Window manager"; hidden = true;
      args = [ ];
      # @option widget = "text"; label = "Description"; group = "Window manager"; hidden = true;
      description = "Toggle Maximize";
    };

    # @option widget = "submodule"; label = "Fullscreen"; group = "Window manager";
    desktop.ojuny.mango.binds.default.fullscreen = {
      # @option widget = "list"; label = "Modifiers"; group = "Window manager";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Window manager";
      keys = [ "F11" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Window manager"; hidden = true;
      dispatcher = "togglefullscreen";
      # @option widget = "text"; label = "Arguments"; group = "Window manager"; hidden = true;
      args = [ ];
      # @option widget = "text"; label = "Description"; group = "Window manager"; hidden = true;
      description = "Toggle Fullscreen";
    };

    # @option widget = "submodule"; label = "Floating"; group = "Window manager";
    desktop.ojuny.mango.binds.default.floating = {
      # @option widget = "list"; label = "Modifiers"; group = "Window manager";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Window manager";
      keys = [ "V" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Window manager"; hidden = true;
      dispatcher = "togglefloating";
      # @option widget = "text"; label = "Arguments"; group = "Window manager"; hidden = true;
      args = [ ];
      # @option widget = "text"; label = "Description"; group = "Window manager"; hidden = true;
      description = "Toggle Floating";
    };

    # @option widget = "submodule"; label = "Focus left"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusLeft = {
      # @option widget = "list"; label = "Modifiers"; group = "Focus";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Focus";
      keys = [ "A" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Focus"; hidden = true;
      dispatcher = "focusdir";
      # @option widget = "text"; label = "Arguments"; group = "Focus"; hidden = true;
      args = "left";
      # @option widget = "text"; label = "Description"; group = "Focus"; hidden = true;
      description = "Focus Left";
    };

    # @option widget = "submodule"; label = "Focus down"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusDown = {
      # @option widget = "list"; label = "Modifiers"; group = "Focus";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Focus";
      keys = [ "S" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Focus"; hidden = true;
      dispatcher = "focusdir";
      # @option widget = "text"; label = "Arguments"; group = "Focus"; hidden = true;
      args = "down";
      # @option widget = "text"; label = "Description"; group = "Focus"; hidden = true;
      description = "Focus Down";
    };

    # @option widget = "submodule"; label = "Focus up"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusUp = {
      # @option widget = "list"; label = "Modifiers"; group = "Focus";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Focus";
      keys = [ "W" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Focus"; hidden = true;
      dispatcher = "focusdir";
      # @option widget = "text"; label = "Arguments"; group = "Focus"; hidden = true;
      args = "up";
      # @option widget = "text"; label = "Description"; group = "Focus"; hidden = true;
      description = "Focus Up";
    };

    # @option widget = "submodule"; label = "Focus right"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusRight = {
      # @option widget = "list"; label = "Modifiers"; group = "Focus";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Focus";
      keys = [ "D" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Focus"; hidden = true;
      dispatcher = "focusdir";
      # @option widget = "text"; label = "Arguments"; group = "Focus"; hidden = true;
      args = "right";
      # @option widget = "text"; label = "Description"; group = "Focus"; hidden = true;
      description = "Focus Right";
    };

    # @option widget = "submodule"; label = "Move window up"; group = "Move";
    desktop.ojuny.mango.binds.default.moveUp = {
      # @option widget = "list"; label = "Modifiers"; group = "Move";
      modifier = [
        "SUPER"
        "SHIFT"
      ];
      # @option widget = "list"; label = "Keys"; group = "Move";
      keys = [ "W" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Move"; hidden = true;
      dispatcher = "move_client";
      # @option widget = "text"; label = "Arguments"; group = "Move"; hidden = true;
      args = "up";
      # @option widget = "text"; label = "Description"; group = "Move"; hidden = true;
      description = "Move Client Up";
    };

    # @option widget = "submodule"; label = "Move window left"; group = "Move";
    desktop.ojuny.mango.binds.default.moveLeft = {
      # @option widget = "list"; label = "Modifiers"; group = "Move";
      modifier = [
        "SUPER"
        "SHIFT"
      ];
      # @option widget = "list"; label = "Keys"; group = "Move";
      keys = [ "A" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Move"; hidden = true;
      dispatcher = "move_client";
      # @option widget = "text"; label = "Arguments"; group = "Move"; hidden = true;
      args = "left";
      # @option widget = "text"; label = "Description"; group = "Move"; hidden = true;
      description = "Move Client Left";
    };

    # @option widget = "submodule"; label = "Move window down"; group = "Move";
    desktop.ojuny.mango.binds.default.moveDown = {
      # @option widget = "list"; label = "Modifiers"; group = "Move";
      modifier = [
        "SUPER"
        "SHIFT"
      ];
      # @option widget = "list"; label = "Keys"; group = "Move";
      keys = [ "S" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Move"; hidden = true;
      dispatcher = "move_client";
      # @option widget = "text"; label = "Arguments"; group = "Move"; hidden = true;
      args = "down";
      # @option widget = "text"; label = "Description"; group = "Move"; hidden = true;
      description = "Move Client Down";
    };

    # @option widget = "submodule"; label = "Move window right"; group = "Move";
    desktop.ojuny.mango.binds.default.moveRight = {
      # @option widget = "list"; label = "Modifiers"; group = "Move";
      modifier = [
        "SUPER"
        "SHIFT"
      ];
      # @option widget = "list"; label = "Keys"; group = "Move";
      keys = [ "D" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Move"; hidden = true;
      dispatcher = "move_client";
      # @option widget = "text"; label = "Arguments"; group = "Move"; hidden = true;
      args = "right";
      # @option widget = "text"; label = "Description"; group = "Move"; hidden = true;
      description = "Move Client Right";
    };

    # @option widget = "submodule"; label = "Previous tag"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.viewLeft = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "Left" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "viewtoleft";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "0" ];
      # @option widget = "text"; label = "Description"; group = "Workspaces"; hidden = true;
      description = "Previous Tag";
    };

    # @option widget = "submodule"; label = "Next tag"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.viewRight = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "Right" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "viewtoright";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "0" ];
      # @option widget = "text"; label = "Description"; group = "Workspaces"; hidden = true;
      description = "Next Tag";
    };

    # @option widget = "submodule"; label = "Workspace 1"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace1 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "1" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "1" ];
    };

    # @option widget = "submodule"; label = "Workspace 2"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace2 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "2" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "2" ];
    };

    # @option widget = "submodule"; label = "Workspace 3"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace3 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "3" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "3" ];
    };

    # @option widget = "submodule"; label = "Workspace 4"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace4 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "4" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "4" ];
    };

    # @option widget = "submodule"; label = "Workspace 5"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace5 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "5" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "5" ];
    };

    # @option widget = "submodule"; label = "Workspace 6"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace6 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "6" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "6" ];
    };

    # @option widget = "submodule"; label = "Workspace 7"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace7 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "7" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "7" ];
    };

    # @option widget = "submodule"; label = "Workspace 8"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace8 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "8" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "8" ];
    };

    # @option widget = "submodule"; label = "Workspace 9"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace9 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "9" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "9" ];
    };

    # @option widget = "submodule"; label = "Workspace 10"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace10 = {
      # @option widget = "list"; label = "Modifiers"; group = "Workspaces";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Workspaces";
      keys = [ "0" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; hidden = true;
      dispatcher = "comboview";
      # @option widget = "text"; label = "Arguments"; group = "Workspaces"; hidden = true;
      args = [ "10" ];
    };

    # @option widget = "submodule"; label = "Screenshot (selection)"; group = "Screenshots";
    desktop.ojuny.mango.binds.default.screenshot = {
      # @option widget = "list"; label = "Modifiers"; group = "Screenshots";
      modifier = [ ];
      # @option widget = "list"; label = "Keys"; group = "Screenshots";
      keys = [ "PRINT" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Screenshots"; hidden = true;
      dispatcher = "spawn";
      # @option widget = "text"; label = "Arguments"; group = "Screenshots"; hidden = true;
      args = "dms screenshot";
      # @option widget = "text"; label = "Description"; group = "Screenshots"; hidden = true;
      description = "Selection Screenshot";
    };

    # @option widget = "submodule"; label = "Screenshot (window)"; group = "Screenshots";
    desktop.ojuny.mango.binds.default.screenshotWindow = {
      # @option widget = "list"; label = "Modifiers"; group = "Screenshots";
      modifier = [ "SUPER" ];
      # @option widget = "list"; label = "Keys"; group = "Screenshots";
      keys = [ "PRINT" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Screenshots"; hidden = true;
      dispatcher = "spawn";
      # @option widget = "text"; label = "Arguments"; group = "Screenshots"; hidden = true;
      args = "dms screenshot window";
      # @option widget = "text"; label = "Description"; group = "Screenshots"; hidden = true;
      description = "Window Screenshot";
    };

    # @option widget = "submodule"; label = "Screenshot (full)"; group = "Screenshots";
    desktop.ojuny.mango.binds.default.screenshotFull = {
      # @option widget = "list"; label = "Modifiers"; group = "Screenshots";
      modifier = [ "ALT" ];
      # @option widget = "list"; label = "Keys"; group = "Screenshots";
      keys = [ "PRINT" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Screenshots"; hidden = true;
      dispatcher = "spawn";
      # @option widget = "text"; label = "Arguments"; group = "Screenshots"; hidden = true;
      args = "dms screenshot full";
      # @option widget = "text"; label = "Description"; group = "Screenshots"; hidden = true;
      description = "Full Screenshot";
    };

    # @option widget = "submodule"; label = "Move window (mouse)"; group = "Mouse";
    desktop.ojuny.mango.mousebind.default.move = {
      # @option widget = "list"; label = "Modifiers"; group = "Mouse";
      modifier = [ "SUPER" ];
      # @option widget = "text"; label = "Button"; group = "Mouse";
      keys = [ "btn_left" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Mouse"; hidden = true;
      dispatcher = "moveresize";
      # @option widget = "text"; label = "Arguments"; group = "Mouse"; hidden = true;
      args = "curmove";
      # @option widget = "text"; label = "Description"; group = "Mouse"; hidden = true;
      description = "Move Window";
    };

    # @option widget = "submodule"; label = "Resize window (mouse)"; group = "Mouse";
    desktop.ojuny.mango.mousebind.default.resize = {
      # @option widget = "list"; label = "Modifiers"; group = "Mouse";
      modifier = [ "SUPER" ];
      # @option widget = "text"; label = "Button"; group = "Mouse";
      keys = [ "btn_right" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Mouse"; hidden = true;
      dispatcher = "moveresize";
      # @option widget = "text"; label = "Arguments"; group = "Mouse"; hidden = true;
      args = "curresize";
      # @option widget = "text"; label = "Description"; group = "Mouse"; hidden = true;
      description = "Resize Window";
    };

    # @option widget = "submodule"; label = "Maximize (middle click)"; group = "Mouse";
    desktop.ojuny.mango.mousebind.default.maximize = {
      # @option widget = "list"; label = "Modifiers"; group = "Mouse";
      modifier = [ ];
      # @option widget = "text"; label = "Button"; group = "Mouse";
      keys = [ "btn_middle" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Mouse"; hidden = true;
      dispatcher = "togglemaximizescreen";
      # @option widget = "text"; label = "Arguments"; group = "Mouse"; hidden = true;
      args = "0";
      # @option widget = "text"; label = "Description"; group = "Mouse"; hidden = true;
      description = "Toggle Maximize";
    };

    # @option widget = "submodule"; label = "Previous tag (scroll)"; group = "Scroll";
    desktop.ojuny.mango.axisbind.default.viewPrev = {
      # @option widget = "list"; label = "Modifiers"; group = "Scroll";
      modifier = [ "SUPER" ];
      # @option widget = "text"; label = "Axis"; group = "Scroll";
      keys = [ "UP" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Scroll"; hidden = true;
      dispatcher = "viewtoleft_have_client";
      # @option widget = "text"; label = "Arguments"; group = "Scroll"; hidden = true;
      args = [ ];
      # @option widget = "text"; label = "Description"; group = "Scroll"; hidden = true;
      description = "Previous Tag";
    };

    # @option widget = "submodule"; label = "Next tag (scroll)"; group = "Scroll";
    desktop.ojuny.mango.axisbind.default.viewNext = {
      # @option widget = "list"; label = "Modifiers"; group = "Scroll";
      modifier = [ "SUPER" ];
      # @option widget = "text"; label = "Axis"; group = "Scroll";
      keys = [ "DOWN" ];
      # @option widget = "text"; label = "Dispatcher"; group = "Scroll"; hidden = true;
      dispatcher = "viewtoright_have_client";
      # @option widget = "text"; label = "Arguments"; group = "Scroll"; hidden = true;
      args = [ ];
      # @option widget = "text"; label = "Description"; group = "Scroll"; hidden = true;
      description = "Next Tag";
    };

    # Touch gestures (desktop.ojuny.mango.gesturebind) are empty by default;
    # add entries here in the same shape if the machine has a touchscreen.

    /*
      @insert
      name = "keybind";
      group = "Custom binds";
      order = 10;
    */

  };

}
