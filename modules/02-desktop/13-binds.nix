/* @menu
   displayname = "Keybinds";
   icon = "preferences-desktop-keyboard-symbolic";
   order = 130;
   description = "Key, mouse, axis and gesture bindings";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-binds = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    # Binds live here in full so every field can be edited from the menu.
    # Dispatchers are mango actions; args is what the dispatcher acts on.

    /* @option widget = "submodule"; label = "Terminal"; group = "Applications"; */
    desktop.ojuny.mango.binds.default.terminal = {
      /* @option widget = "list"; label = "Modifiers"; group = "Applications"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Applications"; */
      keys = [ "Return" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Applications"; */
      dispatcher = "spawn";
      /* @option widget = "text"; label = "Arguments"; group = "Applications"; */
      args = "ghostty";
      /* @option widget = "text"; label = "Description"; group = "Applications"; */
      description = "Terminal";
    };

    /* @option widget = "submodule"; label = "Browser"; group = "Applications"; */
    desktop.ojuny.mango.binds.default.browser = {
      /* @option widget = "list"; label = "Modifiers"; group = "Applications"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Applications"; */
      keys = [ "B" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Applications"; */
      dispatcher = "spawn";
      /* @option widget = "text"; label = "Arguments"; group = "Applications"; */
      args = "firefox --new-window";
      /* @option widget = "text"; label = "Description"; group = "Applications"; */
      description = "Open Browser";
    };

    /* @option widget = "submodule"; label = "Files"; group = "Applications"; */
    desktop.ojuny.mango.binds.default.files = {
      /* @option widget = "list"; label = "Modifiers"; group = "Applications"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Applications"; */
      keys = [ "E" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Applications"; */
      dispatcher = "spawn";
      /* @option widget = "text"; label = "Arguments"; group = "Applications"; */
      args = "nautilus --new-window";
      /* @option widget = "text"; label = "Description"; group = "Applications"; */
      description = "Open Files";
    };

    /* @option widget = "submodule"; label = "Launcher"; group = "Applications"; */
    desktop.ojuny.mango.binds.default.launcher = {
      /* @option widget = "list"; label = "Modifiers"; group = "Applications"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Applications"; */
      keys = [ "SPACE" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Applications"; */
      dispatcher = "spawn";
      /* @option widget = "text"; label = "Arguments"; group = "Applications"; */
      args = "dms ipc call spotlight toggle";
      /* @option widget = "text"; label = "Description"; group = "Applications"; */
      description = "Launcher";
    };

    /* @option widget = "submodule"; label = "Settings menu"; group = "Applications"; */
    desktop.ojuny.mango.binds.default.settings = {
      /* @option widget = "list"; label = "Modifiers"; group = "Applications"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Applications"; */
      keys = [ "X" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Applications"; */
      dispatcher = "spawn";
      /* @option widget = "text"; label = "Arguments"; group = "Applications"; */
      args = "dms ipc call dankMenu toggle root";
      /* @option widget = "text"; label = "Description"; group = "Applications"; */
      description = "Toggle Settings";
    };

    /* @option widget = "submodule"; label = "Keybind overview"; group = "Applications"; */
    desktop.ojuny.mango.binds.default.keybinds = {
      /* @option widget = "list"; label = "Modifiers"; group = "Applications"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Applications"; */
      keys = [ "K" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Applications"; */
      dispatcher = "spawn";
      /* @option widget = "text"; label = "Arguments"; group = "Applications"; */
      args = "dms ipc call keybinds open binds";
      /* @option widget = "text"; label = "Description"; group = "Applications"; */
      description = "Show Keybinds";
    };

    /* @option widget = "submodule"; label = "Reload config"; group = "Window manager"; */
    desktop.ojuny.mango.binds.default.reload = {
      /* @option widget = "list"; label = "Modifiers"; group = "Window manager"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Window manager"; */
      keys = [ "R" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Window manager"; */
      dispatcher = "reload_config";
      /* @option widget = "text"; label = "Arguments"; group = "Window manager"; */
      args = [ ];
      /* @option widget = "text"; label = "Description"; group = "Window manager"; */
      description = "Reload Config";
    };

    /* @option widget = "submodule"; label = "Close window"; group = "Window manager"; */
    desktop.ojuny.mango.binds.default.close = {
      /* @option widget = "list"; label = "Modifiers"; group = "Window manager"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Window manager"; */
      keys = [ "Q" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Window manager"; */
      dispatcher = "killclient";
      /* @option widget = "text"; label = "Arguments"; group = "Window manager"; */
      args = [ ];
      /* @option widget = "text"; label = "Description"; group = "Window manager"; */
      description = "Kill Client";
    };

    /* @option widget = "submodule"; label = "Quit mango"; group = "Window manager"; */
    desktop.ojuny.mango.binds.default.quit = {
      /* @option widget = "list"; label = "Modifiers"; group = "Window manager"; */
      modifier = [ "SUPER" "SHIFT" ];
      /* @option widget = "list"; label = "Keys"; group = "Window manager"; */
      keys = [ "Escape" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Window manager"; */
      dispatcher = "quit";
      /* @option widget = "text"; label = "Arguments"; group = "Window manager"; */
      args = [ ];
      /* @option widget = "text"; label = "Description"; group = "Window manager"; */
      description = "Quit Mango";
    };

    /* @option widget = "submodule"; label = "Maximize"; group = "Window manager"; */
    desktop.ojuny.mango.binds.default.maximize = {
      /* @option widget = "list"; label = "Modifiers"; group = "Window manager"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Window manager"; */
      keys = [ "F" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Window manager"; */
      dispatcher = "togglemaximizescreen";
      /* @option widget = "text"; label = "Arguments"; group = "Window manager"; */
      args = [ ];
      /* @option widget = "text"; label = "Description"; group = "Window manager"; */
      description = "Toggle Maximize";
    };

    /* @option widget = "submodule"; label = "Fullscreen"; group = "Window manager"; */
    desktop.ojuny.mango.binds.default.fullscreen = {
      /* @option widget = "list"; label = "Modifiers"; group = "Window manager"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Window manager"; */
      keys = [ "F11" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Window manager"; */
      dispatcher = "togglefullscreen";
      /* @option widget = "text"; label = "Arguments"; group = "Window manager"; */
      args = [ ];
      /* @option widget = "text"; label = "Description"; group = "Window manager"; */
      description = "Toggle Fullscreen";
    };

    /* @option widget = "submodule"; label = "Floating"; group = "Window manager"; */
    desktop.ojuny.mango.binds.default.floating = {
      /* @option widget = "list"; label = "Modifiers"; group = "Window manager"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Window manager"; */
      keys = [ "V" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Window manager"; */
      dispatcher = "togglefloating";
      /* @option widget = "text"; label = "Arguments"; group = "Window manager"; */
      args = [ ];
      /* @option widget = "text"; label = "Description"; group = "Window manager"; */
      description = "Toggle Floating";
    };

    /* @option widget = "submodule"; label = "Focus left"; group = "Focus"; */
    desktop.ojuny.mango.binds.default.focusLeft = {
      /* @option widget = "list"; label = "Modifiers"; group = "Focus"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Focus"; */
      keys = [ "A" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Focus"; */
      dispatcher = "focusdir";
      /* @option widget = "text"; label = "Arguments"; group = "Focus"; */
      args = "left";
      /* @option widget = "text"; label = "Description"; group = "Focus"; */
      description = "Focus Left";
    };

    /* @option widget = "submodule"; label = "Focus down"; group = "Focus"; */
    desktop.ojuny.mango.binds.default.focusDown = {
      /* @option widget = "list"; label = "Modifiers"; group = "Focus"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Focus"; */
      keys = [ "S" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Focus"; */
      dispatcher = "focusdir";
      /* @option widget = "text"; label = "Arguments"; group = "Focus"; */
      args = "down";
      /* @option widget = "text"; label = "Description"; group = "Focus"; */
      description = "Focus Down";
    };

    /* @option widget = "submodule"; label = "Focus up"; group = "Focus"; */
    desktop.ojuny.mango.binds.default.focusUp = {
      /* @option widget = "list"; label = "Modifiers"; group = "Focus"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Focus"; */
      keys = [ "W" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Focus"; */
      dispatcher = "focusdir";
      /* @option widget = "text"; label = "Arguments"; group = "Focus"; */
      args = "up";
      /* @option widget = "text"; label = "Description"; group = "Focus"; */
      description = "Focus Up";
    };

    /* @option widget = "submodule"; label = "Focus right"; group = "Focus"; */
    desktop.ojuny.mango.binds.default.focusRight = {
      /* @option widget = "list"; label = "Modifiers"; group = "Focus"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Focus"; */
      keys = [ "D" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Focus"; */
      dispatcher = "focusdir";
      /* @option widget = "text"; label = "Arguments"; group = "Focus"; */
      args = "right";
      /* @option widget = "text"; label = "Description"; group = "Focus"; */
      description = "Focus Right";
    };

    /* @option widget = "submodule"; label = "Move window up"; group = "Move"; */
    desktop.ojuny.mango.binds.default.moveUp = {
      /* @option widget = "list"; label = "Modifiers"; group = "Move"; */
      modifier = [ "SUPER" "SHIFT" ];
      /* @option widget = "list"; label = "Keys"; group = "Move"; */
      keys = [ "W" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Move"; */
      dispatcher = "move_client";
      /* @option widget = "text"; label = "Arguments"; group = "Move"; */
      args = "up";
      /* @option widget = "text"; label = "Description"; group = "Move"; */
      description = "Move Client Up";
    };

    /* @option widget = "submodule"; label = "Move window left"; group = "Move"; */
    desktop.ojuny.mango.binds.default.moveLeft = {
      /* @option widget = "list"; label = "Modifiers"; group = "Move"; */
      modifier = [ "SUPER" "SHIFT" ];
      /* @option widget = "list"; label = "Keys"; group = "Move"; */
      keys = [ "A" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Move"; */
      dispatcher = "move_client";
      /* @option widget = "text"; label = "Arguments"; group = "Move"; */
      args = "left";
      /* @option widget = "text"; label = "Description"; group = "Move"; */
      description = "Move Client Left";
    };

    /* @option widget = "submodule"; label = "Move window down"; group = "Move"; */
    desktop.ojuny.mango.binds.default.moveDown = {
      /* @option widget = "list"; label = "Modifiers"; group = "Move"; */
      modifier = [ "SUPER" "SHIFT" ];
      /* @option widget = "list"; label = "Keys"; group = "Move"; */
      keys = [ "S" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Move"; */
      dispatcher = "move_client";
      /* @option widget = "text"; label = "Arguments"; group = "Move"; */
      args = "down";
      /* @option widget = "text"; label = "Description"; group = "Move"; */
      description = "Move Client Down";
    };

    /* @option widget = "submodule"; label = "Move window right"; group = "Move"; */
    desktop.ojuny.mango.binds.default.moveRight = {
      /* @option widget = "list"; label = "Modifiers"; group = "Move"; */
      modifier = [ "SUPER" "SHIFT" ];
      /* @option widget = "list"; label = "Keys"; group = "Move"; */
      keys = [ "D" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Move"; */
      dispatcher = "move_client";
      /* @option widget = "text"; label = "Arguments"; group = "Move"; */
      args = "right";
      /* @option widget = "text"; label = "Description"; group = "Move"; */
      description = "Move Client Right";
    };

    /* @option widget = "submodule"; label = "Previous tag"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.viewLeft = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "Left" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "viewtoleft";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "0" ];
      /* @option widget = "text"; label = "Description"; group = "Workspaces"; */
      description = "Previous Tag";
    };

    /* @option widget = "submodule"; label = "Next tag"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.viewRight = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "Right" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "viewtoright";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "0" ];
      /* @option widget = "text"; label = "Description"; group = "Workspaces"; */
      description = "Next Tag";
    };

    /* @option widget = "submodule"; label = "Workspace 1"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace1 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "1" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "1" ];
    };

    /* @option widget = "submodule"; label = "Workspace 2"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace2 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "2" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "2" ];
    };

    /* @option widget = "submodule"; label = "Workspace 3"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace3 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "3" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "3" ];
    };

    /* @option widget = "submodule"; label = "Workspace 4"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace4 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "4" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "4" ];
    };

    /* @option widget = "submodule"; label = "Workspace 5"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace5 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "5" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "5" ];
    };

    /* @option widget = "submodule"; label = "Workspace 6"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace6 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "6" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "6" ];
    };

    /* @option widget = "submodule"; label = "Workspace 7"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace7 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "7" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "7" ];
    };

    /* @option widget = "submodule"; label = "Workspace 8"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace8 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "8" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "8" ];
    };

    /* @option widget = "submodule"; label = "Workspace 9"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace9 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "9" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "9" ];
    };

    /* @option widget = "submodule"; label = "Workspace 10"; group = "Workspaces"; */
    desktop.ojuny.mango.binds.default.workspace10 = {
      /* @option widget = "list"; label = "Modifiers"; group = "Workspaces"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Workspaces"; */
      keys = [ "0" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Workspaces"; */
      dispatcher = "comboview";
      /* @option widget = "text"; label = "Arguments"; group = "Workspaces"; */
      args = [ "10" ];
    };

    /* @option widget = "submodule"; label = "Screenshot (selection)"; group = "Screenshots"; */
    desktop.ojuny.mango.binds.default.screenshot = {
      /* @option widget = "list"; label = "Modifiers"; group = "Screenshots"; */
      modifier = [ ];
      /* @option widget = "list"; label = "Keys"; group = "Screenshots"; */
      keys = [ "PRINT" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Screenshots"; */
      dispatcher = "spawn";
      /* @option widget = "text"; label = "Arguments"; group = "Screenshots"; */
      args = "dms screenshot";
      /* @option widget = "text"; label = "Description"; group = "Screenshots"; */
      description = "Selection Screenshot";
    };

    /* @option widget = "submodule"; label = "Screenshot (window)"; group = "Screenshots"; */
    desktop.ojuny.mango.binds.default.screenshotWindow = {
      /* @option widget = "list"; label = "Modifiers"; group = "Screenshots"; */
      modifier = [ "SUPER" ];
      /* @option widget = "list"; label = "Keys"; group = "Screenshots"; */
      keys = [ "PRINT" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Screenshots"; */
      dispatcher = "spawn";
      /* @option widget = "text"; label = "Arguments"; group = "Screenshots"; */
      args = "dms screenshot window";
      /* @option widget = "text"; label = "Description"; group = "Screenshots"; */
      description = "Window Screenshot";
    };

    /* @option widget = "submodule"; label = "Screenshot (full)"; group = "Screenshots"; */
    desktop.ojuny.mango.binds.default.screenshotFull = {
      /* @option widget = "list"; label = "Modifiers"; group = "Screenshots"; */
      modifier = [ "ALT" ];
      /* @option widget = "list"; label = "Keys"; group = "Screenshots"; */
      keys = [ "PRINT" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Screenshots"; */
      dispatcher = "spawn";
      /* @option widget = "text"; label = "Arguments"; group = "Screenshots"; */
      args = "dms screenshot full";
      /* @option widget = "text"; label = "Description"; group = "Screenshots"; */
      description = "Full Screenshot";
    };

    /* @option widget = "submodule"; label = "Move window (mouse)"; group = "Mouse"; */
    desktop.ojuny.mango.mousebind.default.move = {
      /* @option widget = "list"; label = "Modifiers"; group = "Mouse"; */
      modifier = [ "SUPER" ];
      /* @option widget = "text"; label = "Button"; group = "Mouse"; */
      keys = [ "btn_left" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Mouse"; */
      dispatcher = "moveresize";
      /* @option widget = "text"; label = "Arguments"; group = "Mouse"; */
      args = "curmove";
      /* @option widget = "text"; label = "Description"; group = "Mouse"; */
      description = "Move Window";
    };

    /* @option widget = "submodule"; label = "Resize window (mouse)"; group = "Mouse"; */
    desktop.ojuny.mango.mousebind.default.resize = {
      /* @option widget = "list"; label = "Modifiers"; group = "Mouse"; */
      modifier = [ "SUPER" ];
      /* @option widget = "text"; label = "Button"; group = "Mouse"; */
      keys = [ "btn_right" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Mouse"; */
      dispatcher = "moveresize";
      /* @option widget = "text"; label = "Arguments"; group = "Mouse"; */
      args = "curresize";
      /* @option widget = "text"; label = "Description"; group = "Mouse"; */
      description = "Resize Window";
    };

    /* @option widget = "submodule"; label = "Maximize (middle click)"; group = "Mouse"; */
    desktop.ojuny.mango.mousebind.default.maximize = {
      /* @option widget = "list"; label = "Modifiers"; group = "Mouse"; */
      modifier = [ ];
      /* @option widget = "text"; label = "Button"; group = "Mouse"; */
      keys = [ "btn_middle" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Mouse"; */
      dispatcher = "togglemaximizescreen";
      /* @option widget = "text"; label = "Arguments"; group = "Mouse"; */
      args = "0";
      /* @option widget = "text"; label = "Description"; group = "Mouse"; */
      description = "Toggle Maximize";
    };

    /* @option widget = "submodule"; label = "Previous tag (scroll)"; group = "Scroll"; */
    desktop.ojuny.mango.axisbind.default.viewPrev = {
      /* @option widget = "list"; label = "Modifiers"; group = "Scroll"; */
      modifier = [ "SUPER" ];
      /* @option widget = "text"; label = "Axis"; group = "Scroll"; */
      keys = [ "UP" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Scroll"; */
      dispatcher = "viewtoleft_have_client";
      /* @option widget = "text"; label = "Arguments"; group = "Scroll"; */
      args = [ ];
      /* @option widget = "text"; label = "Description"; group = "Scroll"; */
      description = "Previous Tag";
    };

    /* @option widget = "submodule"; label = "Next tag (scroll)"; group = "Scroll"; */
    desktop.ojuny.mango.axisbind.default.viewNext = {
      /* @option widget = "list"; label = "Modifiers"; group = "Scroll"; */
      modifier = [ "SUPER" ];
      /* @option widget = "text"; label = "Axis"; group = "Scroll"; */
      keys = [ "DOWN" ];
      /* @option widget = "text"; label = "Dispatcher"; group = "Scroll"; */
      dispatcher = "viewtoright_have_client";
      /* @option widget = "text"; label = "Arguments"; group = "Scroll"; */
      args = [ ];
      /* @option widget = "text"; label = "Description"; group = "Scroll"; */
      description = "Next Tag";
    };

    # Touch gestures (desktop.ojuny.mango.gesturebind) are empty by default;
    # add entries here in the same shape if the machine has a touchscreen.

  };

}
