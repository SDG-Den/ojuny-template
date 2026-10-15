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
    # @option widget = "list"; label = "Run once at login"; group = "Commands";
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
    # @option widget = "list"; label = "Run on every reload"; group = "Commands";
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
    # @option widget = "list"; label = "Extra config files"; group = "Commands";
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

    # The session commands (dms run, the clipboard helpers) and the Wayland
    # environment variables already come from ojuny-desktop defaults, so they
    # are not repeated here. Add extra ones with the snippets below; the lists
    # and the env set concatenate with those defaults.

    /*
      @insert
      name = "exec-once";
      group = "Commands";
      order = 100;
    */

    /*
      @insert
      name = "exec";
      group = "Commands";
      order = 200;
    */

    /*
      @insert
      name = "source";
      group = "Commands";
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
