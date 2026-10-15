/*
  @menu
  displayname = "Startup";
  icon = "system-run-symbolic";
  order = 140;
  description = "Commands run at login and on reload";
  category = "Desktop";
*/

/*
  @snippet
  name = "exec-once";
  label = "Add run-once command";
  snippet = ''
    # @option widget = "list"; label = "Run once at login"; group = "Session commands";
    desktop.ojuny.mango.execOnce = [ "%%cmd%%" ];
  '';
  placeholders.cmd.label = "Command";
  placeholders.cmd.default = "my-command";
*/

/*
  @snippet
  name = "exec";
  label = "Add reload command";
  snippet = ''
    # @option widget = "list"; label = "Run on every reload"; group = "Session commands";
    desktop.ojuny.mango.exec = [ "%%cmd%%" ];
  '';
  placeholders.cmd.label = "Command";
  placeholders.cmd.default = "my-command";
*/

/*
  @snippet
  name = "source";
  label = "Add sourced config file";
  snippet = ''
    # @option widget = "list"; label = "Extra config files"; group = "Session commands";
    desktop.ojuny.mango.source = [ "%%path%%" ];
  '';
  placeholders.path.label = "Path";
  placeholders.path.default = "~/.config/mango/extra.conf";
*/

/*
  @snippet
  name = "env-var";
  label = "Add environment variable";
  snippet = ''
    # @option widget = "text"; label = "%%name%%"; group = "Environment";
    desktop.ojuny.mango.env.%%name%% = "%%value%%";
  '';
  placeholders.name.label = "Name";
  placeholders.name.default = "MY_VAR";
  placeholders.value.label = "Value";
  placeholders.value.default = "1";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-autostart = { config, pkgs, ... }: {

    # A plain assignment replaces the option's default, so the upstream
    # startup commands are listed here to keep them (and to make them
    # editable). "dms run" resolves to the configured DankMaterialShell
    # because the session wrapper puts it on PATH. Extra commands added with
    # the snippets below merge into the same definitions.

    # @option widget = "list"; label = "Run once at login"; group = "Session commands"; description = "Started when the session opens.";
    desktop.ojuny.mango.execOnce = [
      "dms run"
      "wl-clip-persist --clipboard both"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];

    # @option widget = "list"; label = "Run on every reload"; group = "Session commands"; description = "Started after each mango config reload.";
    desktop.ojuny.mango.exec = [ ];

    # @option widget = "list"; label = "Extra config files"; group = "Session commands"; description = "Additional mango config files sourced after the generated one.";
    desktop.ojuny.mango.source = [ ];

    # @option widget = "raw"; label = "Environment variables"; group = "Environment"; rows = 8; description = "Wayland session variables every mango child process inherits.";
    desktop.ojuny.mango.env = {
      XDG_SESSION_DESKTOP = "wlroots";
      XDG_CURRENT_DESKTOP = "wlroots";
      QT_QPA_PLATFORM = "wayland;xcb";
      MOZ_ENABLE_WAYLAND = "1";
      OZONE_PLATFORM = "wayland";
      NIXOS_OZONE_WL = "1";
    };

    /*
      @insert
      name = "exec-once";
      group = "Session commands";
      order = 100;
    */

    /*
      @insert
      name = "exec";
      group = "Session commands";
      order = 200;
    */

    /*
      @insert
      name = "source";
      group = "Session commands";
      order = 300;
    */

    /*
      @insert
      name = "env-var";
      group = "Environment";
      order = 1000;
    */

  };

}
