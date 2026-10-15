/*
  @menu
  displayname = "Plugins";
  icon = "application-x-addon-symbolic";
  order = 110;
  description = "DMS plugins and built-in plugin keys";
  category = "Desktop";
*/

/*
  @snippet
  name = "plugin";
  label = "Add plugin";
  snippet = ''
    # @option widget = "submodule"; label = "%%name%%"; group = "Third-party plugins";
    desktop.ojuny.dms.plugins.%%name%% = {
      # @option widget = "switch"; label = "Enabled"; group = "Third-party plugins";
      enable = true;
      # @option widget = "path"; label = "Source"; group = "Third-party plugins"; nullable = true;
      src = "%%src%%";
      # @option widget = "raw"; label = "Settings (JSON)"; group = "Third-party plugins"; rows = 6;
      settings = {};
    };
  '';
  placeholders.name.label = "Plugin name";
  placeholders.name.default = "dms-example";
  placeholders.src.label = "Source path";
  placeholders.src.default = "./plugins/dms-example";
*/

/*
  @snippet
  name = "builtin-plugin";
  label = "Add built-in plugin key";
  snippet = ''
    # @option widget = "submodule"; label = "%%name%%"; group = "Built-in plugins";
    desktop.ojuny.dms.settings.builtInPluginSettings.%%name%% = {
      # @option widget = "text"; label = "Trigger"; group = "Built-in plugins";
      trigger = "%%trigger%%";
    };
  '';
  placeholders.name.label = "Plugin id";
  placeholders.name.default = "dms_example";
  placeholders.trigger.label = "Trigger";
  placeholders.trigger.default = "xx";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-plugins = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Manage plugin settings"; group = "Plugins"; description = "Write DMS plugin settings from this flake.";
    desktop.ojuny.dms.managePluginSettings = true;

    # Built-in plugins: each is a small submodule with the key that opens it.
    # @option widget = "submodule"; label = "Clipboard search"; group = "Built-in plugins";
    desktop.ojuny.dms.settings.builtInPluginSettings.dms_clipboard_search = {
      # @option widget = "text"; label = "Trigger"; group = "Built-in plugins";
      trigger = "cb";
    };

    # @option widget = "submodule"; label = "Power menu"; group = "Built-in plugins";
    desktop.ojuny.dms.settings.builtInPluginSettings.dms_power = {
      # @option widget = "text"; label = "Trigger"; group = "Built-in plugins";
      trigger = "pw";
    };

    # @option widget = "submodule"; label = "QR generator"; group = "Built-in plugins";
    desktop.ojuny.dms.settings.builtInPluginSettings.dms_qr_generator = {
      # @option widget = "text"; label = "Trigger"; group = "Built-in plugins";
      trigger = "qrg";
    };

    # @option widget = "submodule"; label = "Settings search"; group = "Built-in plugins";
    desktop.ojuny.dms.settings.builtInPluginSettings.dms_settings_search = {
      # @option widget = "text"; label = "Trigger"; group = "Built-in plugins";
      trigger = "?";
    };

    # Third-party plugins: desktop.ojuny.dms.plugins.<name> takes enable, src
    # (path) and settings. Nothing is installed by default, so define them
    # here once you have a plugin package to point at.

    /*
      @insert
      name = "builtin-plugin";
      group = "Built-in plugins";
      order = 100;
    */

    /*
      @insert
      name = "plugin";
      group = "Third-party plugins";
      order = 1000;
    */

  };

}
