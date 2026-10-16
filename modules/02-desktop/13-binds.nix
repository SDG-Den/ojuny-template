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
      # @option widget = "text"; label = "Dispatcher"; group = "Custom binds";
      dispatcher = "%%dispatcher%%";
      # @option widget = "list"; label = "Arguments"; group = "Custom binds";
      args = %%args%%;
      # @option widget = "text"; label = "Description"; group = "Custom binds";
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

    # Each builtin bind is a few flat controls so they show up at the default
    # level; the dispatcher, its arguments and the description are internal to
    # mango and DMS, so they stay behind the hidden-settings toggle. New binds
    # added through the snippet keep every field editable.

    # Terminal
    # @option widget = "list"; label = "Terminal: Modifiers"; group = "Applications";
    desktop.ojuny.mango.binds.default.terminal.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Terminal: Keys"; group = "Applications";
    desktop.ojuny.mango.binds.default.terminal.keys = [ "Return" ];
    # @option widget = "text"; label = "Terminal: Dispatcher"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.terminal.dispatcher = "spawn";
    # @option widget = "text"; label = "Terminal: Arguments"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.terminal.args = "ghostty";
    # @option widget = "text"; label = "Terminal: Description"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.terminal.description = "Terminal";

    # Browser
    # @option widget = "list"; label = "Browser: Modifiers"; group = "Applications";
    desktop.ojuny.mango.binds.default.browser.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Browser: Keys"; group = "Applications";
    desktop.ojuny.mango.binds.default.browser.keys = [ "B" ];
    # @option widget = "text"; label = "Browser: Dispatcher"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.browser.dispatcher = "spawn";
    # @option widget = "text"; label = "Browser: Arguments"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.browser.args = "firefox --new-window";
    # @option widget = "text"; label = "Browser: Description"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.browser.description = "Open Browser";

    # Files
    # @option widget = "list"; label = "Files: Modifiers"; group = "Applications";
    desktop.ojuny.mango.binds.default.files.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Files: Keys"; group = "Applications";
    desktop.ojuny.mango.binds.default.files.keys = [ "E" ];
    # @option widget = "text"; label = "Files: Dispatcher"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.files.dispatcher = "spawn";
    # @option widget = "text"; label = "Files: Arguments"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.files.args = "nautilus --new-window";
    # @option widget = "text"; label = "Files: Description"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.files.description = "Open Files";

    # Launcher
    # @option widget = "list"; label = "Launcher: Modifiers"; group = "Applications";
    desktop.ojuny.mango.binds.default.launcher.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Launcher: Keys"; group = "Applications";
    desktop.ojuny.mango.binds.default.launcher.keys = [ "SPACE" ];
    # @option widget = "text"; label = "Launcher: Dispatcher"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.launcher.dispatcher = "spawn";
    # @option widget = "text"; label = "Launcher: Arguments"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.launcher.args = "dms ipc call spotlight toggle";
    # @option widget = "text"; label = "Launcher: Description"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.launcher.description = "Launcher";

    # Settings menu
    # @option widget = "list"; label = "Settings menu: Modifiers"; group = "Applications";
    desktop.ojuny.mango.binds.default.settings.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Settings menu: Keys"; group = "Applications";
    desktop.ojuny.mango.binds.default.settings.keys = [ "X" ];
    # @option widget = "text"; label = "Settings menu: Dispatcher"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.settings.dispatcher = "spawn";
    # @option widget = "text"; label = "Settings menu: Arguments"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.settings.args = "dms ipc call dankMenu toggle root";
    # @option widget = "text"; label = "Settings menu: Description"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.settings.description = "Toggle Settings";

    # Keybind overview
    # @option widget = "list"; label = "Keybind overview: Modifiers"; group = "Applications";
    desktop.ojuny.mango.binds.default.keybinds.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Keybind overview: Keys"; group = "Applications";
    desktop.ojuny.mango.binds.default.keybinds.keys = [ "K" ];
    # @option widget = "text"; label = "Keybind overview: Dispatcher"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.keybinds.dispatcher = "spawn";
    # @option widget = "text"; label = "Keybind overview: Arguments"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.keybinds.args = "dms ipc call keybinds open binds";
    # @option widget = "text"; label = "Keybind overview: Description"; group = "Applications"; hidden = true;
    desktop.ojuny.mango.binds.default.keybinds.description = "Show Keybinds";

    # Reload config
    # @option widget = "list"; label = "Reload config: Modifiers"; group = "Window manager";
    desktop.ojuny.mango.binds.default.reload.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Reload config: Keys"; group = "Window manager";
    desktop.ojuny.mango.binds.default.reload.keys = [ "R" ];
    # @option widget = "text"; label = "Reload config: Dispatcher"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.reload.dispatcher = "reload_config";
    # @option widget = "text"; label = "Reload config: Arguments"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.reload.args = [ ];
    # @option widget = "text"; label = "Reload config: Description"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.reload.description = "Reload Config";

    # Close window
    # @option widget = "list"; label = "Close window: Modifiers"; group = "Window manager";
    desktop.ojuny.mango.binds.default.close.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Close window: Keys"; group = "Window manager";
    desktop.ojuny.mango.binds.default.close.keys = [ "Q" ];
    # @option widget = "text"; label = "Close window: Dispatcher"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.close.dispatcher = "killclient";
    # @option widget = "text"; label = "Close window: Arguments"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.close.args = [ ];
    # @option widget = "text"; label = "Close window: Description"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.close.description = "Kill Client";

    # Quit mango
    # @option widget = "list"; label = "Quit mango: Modifiers"; group = "Window manager";
    desktop.ojuny.mango.binds.default.quit.modifier = [
        "SUPER"
        "SHIFT"
      ];
    # @option widget = "list"; label = "Quit mango: Keys"; group = "Window manager";
    desktop.ojuny.mango.binds.default.quit.keys = [ "Escape" ];
    # @option widget = "text"; label = "Quit mango: Dispatcher"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.quit.dispatcher = "quit";
    # @option widget = "text"; label = "Quit mango: Arguments"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.quit.args = [ ];
    # @option widget = "text"; label = "Quit mango: Description"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.quit.description = "Quit Mango";

    # Maximize
    # @option widget = "list"; label = "Maximize: Modifiers"; group = "Window manager";
    desktop.ojuny.mango.binds.default.maximize.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Maximize: Keys"; group = "Window manager";
    desktop.ojuny.mango.binds.default.maximize.keys = [ "F" ];
    # @option widget = "text"; label = "Maximize: Dispatcher"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.maximize.dispatcher = "togglemaximizescreen";
    # @option widget = "text"; label = "Maximize: Arguments"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.maximize.args = [ ];
    # @option widget = "text"; label = "Maximize: Description"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.maximize.description = "Toggle Maximize";

    # Fullscreen
    # @option widget = "list"; label = "Fullscreen: Modifiers"; group = "Window manager";
    desktop.ojuny.mango.binds.default.fullscreen.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Fullscreen: Keys"; group = "Window manager";
    desktop.ojuny.mango.binds.default.fullscreen.keys = [ "F11" ];
    # @option widget = "text"; label = "Fullscreen: Dispatcher"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.fullscreen.dispatcher = "togglefullscreen";
    # @option widget = "text"; label = "Fullscreen: Arguments"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.fullscreen.args = [ ];
    # @option widget = "text"; label = "Fullscreen: Description"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.fullscreen.description = "Toggle Fullscreen";

    # Floating
    # @option widget = "list"; label = "Floating: Modifiers"; group = "Window manager";
    desktop.ojuny.mango.binds.default.floating.modifier = [
        "SUPER"
        "ALT"
        "CTRL"
      ];
    # @option widget = "list"; label = "Floating: Keys"; group = "Window manager";
    desktop.ojuny.mango.binds.default.floating.keys = [ "O" ];
    # @option widget = "text"; label = "Floating: Dispatcher"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.floating.dispatcher = "togglefloating";
    # @option widget = "text"; label = "Floating: Arguments"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.floating.args = [ ];
    # @option widget = "text"; label = "Floating: Description"; group = "Window manager"; hidden = true;
    desktop.ojuny.mango.binds.default.floating.description = "Toggle Floating";

    # Focus left
    # @option widget = "list"; label = "Focus left: Modifiers"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusLeft.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Focus left: Keys"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusLeft.keys = [ "A" ];
    # @option widget = "text"; label = "Focus left: Dispatcher"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusLeft.dispatcher = "focusdir";
    # @option widget = "text"; label = "Focus left: Arguments"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusLeft.args = "left";
    # @option widget = "text"; label = "Focus left: Description"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusLeft.description = "Focus Left";

    # Focus down
    # @option widget = "list"; label = "Focus down: Modifiers"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusDown.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Focus down: Keys"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusDown.keys = [ "S" ];
    # @option widget = "text"; label = "Focus down: Dispatcher"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusDown.dispatcher = "focusdir";
    # @option widget = "text"; label = "Focus down: Arguments"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusDown.args = "down";
    # @option widget = "text"; label = "Focus down: Description"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusDown.description = "Focus Down";

    # Focus up
    # @option widget = "list"; label = "Focus up: Modifiers"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusUp.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Focus up: Keys"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusUp.keys = [ "W" ];
    # @option widget = "text"; label = "Focus up: Dispatcher"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusUp.dispatcher = "focusdir";
    # @option widget = "text"; label = "Focus up: Arguments"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusUp.args = "up";
    # @option widget = "text"; label = "Focus up: Description"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusUp.description = "Focus Up";

    # Focus right
    # @option widget = "list"; label = "Focus right: Modifiers"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusRight.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Focus right: Keys"; group = "Focus";
    desktop.ojuny.mango.binds.default.focusRight.keys = [ "D" ];
    # @option widget = "text"; label = "Focus right: Dispatcher"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusRight.dispatcher = "focusdir";
    # @option widget = "text"; label = "Focus right: Arguments"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusRight.args = "right";
    # @option widget = "text"; label = "Focus right: Description"; group = "Focus"; hidden = true;
    desktop.ojuny.mango.binds.default.focusRight.description = "Focus Right";

    # Move window up
    # @option widget = "list"; label = "Move window up: Modifiers"; group = "Move";
    desktop.ojuny.mango.binds.default.moveUp.modifier = [
        "SUPER"
        "SHIFT"
      ];
    # @option widget = "list"; label = "Move window up: Keys"; group = "Move";
    desktop.ojuny.mango.binds.default.moveUp.keys = [ "W" ];
    # @option widget = "text"; label = "Move window up: Dispatcher"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveUp.dispatcher = "move_client";
    # @option widget = "text"; label = "Move window up: Arguments"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveUp.args = "up";
    # @option widget = "text"; label = "Move window up: Description"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveUp.description = "Move Client Up";

    # Move window left
    # @option widget = "list"; label = "Move window left: Modifiers"; group = "Move";
    desktop.ojuny.mango.binds.default.moveLeft.modifier = [
        "SUPER"
        "SHIFT"
      ];
    # @option widget = "list"; label = "Move window left: Keys"; group = "Move";
    desktop.ojuny.mango.binds.default.moveLeft.keys = [ "A" ];
    # @option widget = "text"; label = "Move window left: Dispatcher"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveLeft.dispatcher = "move_client";
    # @option widget = "text"; label = "Move window left: Arguments"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveLeft.args = "left";
    # @option widget = "text"; label = "Move window left: Description"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveLeft.description = "Move Client Left";

    # Move window down
    # @option widget = "list"; label = "Move window down: Modifiers"; group = "Move";
    desktop.ojuny.mango.binds.default.moveDown.modifier = [
        "SUPER"
        "SHIFT"
      ];
    # @option widget = "list"; label = "Move window down: Keys"; group = "Move";
    desktop.ojuny.mango.binds.default.moveDown.keys = [ "S" ];
    # @option widget = "text"; label = "Move window down: Dispatcher"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveDown.dispatcher = "move_client";
    # @option widget = "text"; label = "Move window down: Arguments"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveDown.args = "down";
    # @option widget = "text"; label = "Move window down: Description"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveDown.description = "Move Client Down";

    # Move window right
    # @option widget = "list"; label = "Move window right: Modifiers"; group = "Move";
    desktop.ojuny.mango.binds.default.moveRight.modifier = [
        "SUPER"
        "SHIFT"
      ];
    # @option widget = "list"; label = "Move window right: Keys"; group = "Move";
    desktop.ojuny.mango.binds.default.moveRight.keys = [ "D" ];
    # @option widget = "text"; label = "Move window right: Dispatcher"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveRight.dispatcher = "move_client";
    # @option widget = "text"; label = "Move window right: Arguments"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveRight.args = "right";
    # @option widget = "text"; label = "Move window right: Description"; group = "Move"; hidden = true;
    desktop.ojuny.mango.binds.default.moveRight.description = "Move Client Right";

    # Previous tag
    # @option widget = "list"; label = "Previous tag: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.viewLeft.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Previous tag: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.viewLeft.keys = [ "Left" ];
    # @option widget = "text"; label = "Previous tag: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.viewLeft.dispatcher = "viewtoleft";
    # @option widget = "text"; label = "Previous tag: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.viewLeft.args = [ "0" ];
    # @option widget = "text"; label = "Previous tag: Description"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.viewLeft.description = "Previous Tag";

    # Next tag
    # @option widget = "list"; label = "Next tag: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.viewRight.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Next tag: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.viewRight.keys = [ "Right" ];
    # @option widget = "text"; label = "Next tag: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.viewRight.dispatcher = "viewtoright";
    # @option widget = "text"; label = "Next tag: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.viewRight.args = [ "0" ];
    # @option widget = "text"; label = "Next tag: Description"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.viewRight.description = "Next Tag";

    # Workspace 1
    # @option widget = "list"; label = "Workspace 1: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace1.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 1: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace1.keys = [ "1" ];
    # @option widget = "text"; label = "Workspace 1: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace1.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 1: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace1.args = [ "1" ];

    # Workspace 2
    # @option widget = "list"; label = "Workspace 2: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace2.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 2: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace2.keys = [ "2" ];
    # @option widget = "text"; label = "Workspace 2: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace2.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 2: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace2.args = [ "2" ];

    # Workspace 3
    # @option widget = "list"; label = "Workspace 3: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace3.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 3: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace3.keys = [ "3" ];
    # @option widget = "text"; label = "Workspace 3: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace3.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 3: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace3.args = [ "3" ];

    # Workspace 4
    # @option widget = "list"; label = "Workspace 4: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace4.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 4: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace4.keys = [ "4" ];
    # @option widget = "text"; label = "Workspace 4: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace4.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 4: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace4.args = [ "4" ];

    # Workspace 5
    # @option widget = "list"; label = "Workspace 5: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace5.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 5: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace5.keys = [ "5" ];
    # @option widget = "text"; label = "Workspace 5: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace5.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 5: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace5.args = [ "5" ];

    # Workspace 6
    # @option widget = "list"; label = "Workspace 6: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace6.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 6: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace6.keys = [ "6" ];
    # @option widget = "text"; label = "Workspace 6: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace6.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 6: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace6.args = [ "6" ];

    # Workspace 7
    # @option widget = "list"; label = "Workspace 7: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace7.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 7: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace7.keys = [ "7" ];
    # @option widget = "text"; label = "Workspace 7: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace7.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 7: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace7.args = [ "7" ];

    # Workspace 8
    # @option widget = "list"; label = "Workspace 8: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace8.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 8: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace8.keys = [ "8" ];
    # @option widget = "text"; label = "Workspace 8: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace8.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 8: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace8.args = [ "8" ];

    # Workspace 9
    # @option widget = "list"; label = "Workspace 9: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace9.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 9: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace9.keys = [ "9" ];
    # @option widget = "text"; label = "Workspace 9: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace9.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 9: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace9.args = [ "9" ];

    # Workspace 10
    # @option widget = "list"; label = "Workspace 10: Modifiers"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace10.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Workspace 10: Keys"; group = "Workspaces";
    desktop.ojuny.mango.binds.default.workspace10.keys = [ "0" ];
    # @option widget = "text"; label = "Workspace 10: Dispatcher"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace10.dispatcher = "comboview";
    # @option widget = "text"; label = "Workspace 10: Arguments"; group = "Workspaces"; hidden = true;
    desktop.ojuny.mango.binds.default.workspace10.args = [ "10" ];

    # Screenshot (selection)
    # @option widget = "list"; label = "Screenshot (selection): Modifiers"; group = "Screenshots";
    desktop.ojuny.mango.binds.default.screenshot.modifier = [ ];
    # @option widget = "list"; label = "Screenshot (selection): Keys"; group = "Screenshots";
    desktop.ojuny.mango.binds.default.screenshot.keys = [ "PRINT" ];
    # @option widget = "text"; label = "Screenshot (selection): Dispatcher"; group = "Screenshots"; hidden = true;
    desktop.ojuny.mango.binds.default.screenshot.dispatcher = "spawn";
    # @option widget = "text"; label = "Screenshot (selection): Arguments"; group = "Screenshots"; hidden = true;
    desktop.ojuny.mango.binds.default.screenshot.args = "dms screenshot";
    # @option widget = "text"; label = "Screenshot (selection): Description"; group = "Screenshots"; hidden = true;
    desktop.ojuny.mango.binds.default.screenshot.description = "Selection Screenshot";

    # Screenshot (window)
    # @option widget = "list"; label = "Screenshot (window): Modifiers"; group = "Screenshots";
    desktop.ojuny.mango.binds.default.screenshotWindow.modifier = [ "SUPER" ];
    # @option widget = "list"; label = "Screenshot (window): Keys"; group = "Screenshots";
    desktop.ojuny.mango.binds.default.screenshotWindow.keys = [ "PRINT" ];
    # @option widget = "text"; label = "Screenshot (window): Dispatcher"; group = "Screenshots"; hidden = true;
    desktop.ojuny.mango.binds.default.screenshotWindow.dispatcher = "spawn";
    # @option widget = "text"; label = "Screenshot (window): Arguments"; group = "Screenshots"; hidden = true;
    desktop.ojuny.mango.binds.default.screenshotWindow.args = "dms screenshot window";
    # @option widget = "text"; label = "Screenshot (window): Description"; group = "Screenshots"; hidden = true;
    desktop.ojuny.mango.binds.default.screenshotWindow.description = "Window Screenshot";

    # Screenshot (full)
    # @option widget = "list"; label = "Screenshot (full): Modifiers"; group = "Screenshots";
    desktop.ojuny.mango.binds.default.screenshotFull.modifier = [ "ALT" ];
    # @option widget = "list"; label = "Screenshot (full): Keys"; group = "Screenshots";
    desktop.ojuny.mango.binds.default.screenshotFull.keys = [ "PRINT" ];
    # @option widget = "text"; label = "Screenshot (full): Dispatcher"; group = "Screenshots"; hidden = true;
    desktop.ojuny.mango.binds.default.screenshotFull.dispatcher = "spawn";
    # @option widget = "text"; label = "Screenshot (full): Arguments"; group = "Screenshots"; hidden = true;
    desktop.ojuny.mango.binds.default.screenshotFull.args = "dms screenshot full";
    # @option widget = "text"; label = "Screenshot (full): Description"; group = "Screenshots"; hidden = true;
    desktop.ojuny.mango.binds.default.screenshotFull.description = "Full Screenshot";

    # Move window (mouse)
    # @option widget = "list"; label = "Move window (mouse): Modifiers"; group = "Mouse";
    desktop.ojuny.mango.mousebind.default.move.modifier = [ "SUPER" ];
    # @option widget = "text"; label = "Move window (mouse): Button"; group = "Mouse";
    desktop.ojuny.mango.mousebind.default.move.keys = [ "btn_left" ];
    # @option widget = "text"; label = "Move window (mouse): Dispatcher"; group = "Mouse"; hidden = true;
    desktop.ojuny.mango.mousebind.default.move.dispatcher = "moveresize";
    # @option widget = "text"; label = "Move window (mouse): Arguments"; group = "Mouse"; hidden = true;
    desktop.ojuny.mango.mousebind.default.move.args = "curmove";
    # @option widget = "text"; label = "Move window (mouse): Description"; group = "Mouse"; hidden = true;
    desktop.ojuny.mango.mousebind.default.move.description = "Move Window";

    # Resize window (mouse)
    # @option widget = "list"; label = "Resize window (mouse): Modifiers"; group = "Mouse";
    desktop.ojuny.mango.mousebind.default.resize.modifier = [ "SUPER" ];
    # @option widget = "text"; label = "Resize window (mouse): Button"; group = "Mouse";
    desktop.ojuny.mango.mousebind.default.resize.keys = [ "btn_right" ];
    # @option widget = "text"; label = "Resize window (mouse): Dispatcher"; group = "Mouse"; hidden = true;
    desktop.ojuny.mango.mousebind.default.resize.dispatcher = "moveresize";
    # @option widget = "text"; label = "Resize window (mouse): Arguments"; group = "Mouse"; hidden = true;
    desktop.ojuny.mango.mousebind.default.resize.args = "curresize";
    # @option widget = "text"; label = "Resize window (mouse): Description"; group = "Mouse"; hidden = true;
    desktop.ojuny.mango.mousebind.default.resize.description = "Resize Window";

    # Maximize (middle click)
    # @option widget = "list"; label = "Maximize (middle click): Modifiers"; group = "Mouse";
    desktop.ojuny.mango.mousebind.default.maximize.modifier = [ ];
    # @option widget = "text"; label = "Maximize (middle click): Button"; group = "Mouse";
    desktop.ojuny.mango.mousebind.default.maximize.keys = [ "btn_middle" ];
    # @option widget = "text"; label = "Maximize (middle click): Dispatcher"; group = "Mouse"; hidden = true;
    desktop.ojuny.mango.mousebind.default.maximize.dispatcher = "togglemaximizescreen";
    # @option widget = "text"; label = "Maximize (middle click): Arguments"; group = "Mouse"; hidden = true;
    desktop.ojuny.mango.mousebind.default.maximize.args = "0";
    # @option widget = "text"; label = "Maximize (middle click): Description"; group = "Mouse"; hidden = true;
    desktop.ojuny.mango.mousebind.default.maximize.description = "Toggle Maximize";

    # Previous tag (scroll)
    # @option widget = "list"; label = "Previous tag (scroll): Modifiers"; group = "Scroll";
    desktop.ojuny.mango.axisbind.default.viewPrev.modifier = [ "SUPER" ];
    # @option widget = "text"; label = "Previous tag (scroll): Axis"; group = "Scroll";
    desktop.ojuny.mango.axisbind.default.viewPrev.keys = [ "UP" ];
    # @option widget = "text"; label = "Previous tag (scroll): Dispatcher"; group = "Scroll"; hidden = true;
    desktop.ojuny.mango.axisbind.default.viewPrev.dispatcher = "viewtoleft_have_client";
    # @option widget = "text"; label = "Previous tag (scroll): Arguments"; group = "Scroll"; hidden = true;
    desktop.ojuny.mango.axisbind.default.viewPrev.args = [ ];
    # @option widget = "text"; label = "Previous tag (scroll): Description"; group = "Scroll"; hidden = true;
    desktop.ojuny.mango.axisbind.default.viewPrev.description = "Previous Tag";

    # Next tag (scroll)
    # @option widget = "list"; label = "Next tag (scroll): Modifiers"; group = "Scroll";
    desktop.ojuny.mango.axisbind.default.viewNext.modifier = [ "SUPER" ];
    # @option widget = "text"; label = "Next tag (scroll): Axis"; group = "Scroll";
    desktop.ojuny.mango.axisbind.default.viewNext.keys = [ "DOWN" ];
    # @option widget = "text"; label = "Next tag (scroll): Dispatcher"; group = "Scroll"; hidden = true;
    desktop.ojuny.mango.axisbind.default.viewNext.dispatcher = "viewtoright_have_client";
    # @option widget = "text"; label = "Next tag (scroll): Arguments"; group = "Scroll"; hidden = true;
    desktop.ojuny.mango.axisbind.default.viewNext.args = [ ];
    # @option widget = "text"; label = "Next tag (scroll): Description"; group = "Scroll"; hidden = true;
    desktop.ojuny.mango.axisbind.default.viewNext.description = "Next Tag";

    # Touch gestures (desktop.ojuny.mango.gesturebind) live on the Gestures page.

    /*
      @insert
      name = "keybind";
      group = "Custom binds";
      order = 10;
    */

  };

}
