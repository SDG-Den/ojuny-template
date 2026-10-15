/*
  @menu
  displayname = "Launcher";
  icon = "system-search-symbolic";
  order = 70;
  description = "App launcher style, behaviour and plugin triggers";
  category = "Desktop";
*/

/*
  @snippet
  name = "plugin-trigger";
  label = "Add plugin trigger";
  snippet = ''
    # @option widget = "text"; label = "%%label%%"; group = "Plugin triggers";
    desktop.ojuny.dms.settings.builtInPluginSettings.%%id%%.trigger = "%%trigger%%";
  '';
  placeholders.id.label = "Plugin id";
  placeholders.id.default = "dms_example";
  placeholders.label.label = "Label";
  placeholders.label.default = "My plugin";
  placeholders.trigger.label = "Trigger";
  placeholders.trigger.default = "xx";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-launcher = { config, pkgs, ... }: {

    # @option widget = "dropdown"; label = "Launcher style"; group = "Launcher"; description = "DMS launcher style."; choices = [ "island" "bar" "floating" "compact" ];
    desktop.ojuny.dms.settings.launcherStyle = "island";

    # @option widget = "switch"; label = "Show mode chips"; group = "Launcher";
    desktop.ojuny.dms.settings.spotlightBarShowModeChips = true;

    # Plugin triggers: the key you type in the launcher to open a built-in plugin.
    # @option widget = "text"; label = "Clipboard search"; group = "Plugin triggers"; description = "Opens the clipboard history in the launcher.";
    desktop.ojuny.dms.settings.builtInPluginSettings.dms_clipboard_search.trigger = "cb";

    # @option widget = "text"; label = "Power menu"; group = "Plugin triggers"; description = "Opens the power menu in the launcher.";
    desktop.ojuny.dms.settings.builtInPluginSettings.dms_power.trigger = "pw";

    # @option widget = "text"; label = "QR generator"; group = "Plugin triggers"; description = "Generates a QR code from the query.";
    desktop.ojuny.dms.settings.builtInPluginSettings.dms_qr_generator.trigger = "qrg";

    # @option widget = "text"; label = "Settings search"; group = "Plugin triggers"; description = "Searches the settings menu from the launcher.";
    desktop.ojuny.dms.settings.builtInPluginSettings.dms_settings_search.trigger = "?";

    /*
      @insert
      name = "plugin-trigger";
      group = "Plugin triggers";
      order = 1000;
    */

    # The dock's own launcher button and logo options live on the Dock page.

  };

}
