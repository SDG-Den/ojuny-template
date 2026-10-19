/*
  @menu
  displayname = "Launcher";
  icon = "system-search-symbolic";
  order = 30;
  description = "App launcher style, behaviour and plugin triggers";
  category = "04-GUI";
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

    # @option widget = "dropdown"; label = "Size"; group = "Appearance"; groupOrder = 10; order = 10; choices = [ "micro" "compact" "medium" "large" ];
    desktop.ojuny.dms.settings.dankLauncherV2Size = "compact";

    # @option widget = "switch"; label = "Show footer"; group = "Appearance"; groupOrder = 10; order = 20; description = "Footer with mode tabs and shortcut hints."; visibleWhen.path = "desktop.ojuny.dms.settings.dankLauncherV2Size"; visibleWhen.notEquals = "micro";
    desktop.ojuny.dms.settings.dankLauncherV2ShowFooter = true;

    # @option widget = "switch"; label = "Show package source badges"; group = "Appearance"; groupOrder = 10; order = 30; description = "Flatpak, Snap, AppImage or Nix badge on each app.";
    desktop.ojuny.dms.settings.dankLauncherV2ShowSourceBadges = true;

    # @option widget = "switch"; label = "Border"; group = "Appearance"; groupOrder = 10; order = 40; description = "Draw a border around the launcher.";
    desktop.ojuny.dms.settings.dankLauncherV2BorderEnabled = false;

    # @option widget = "spin"; label = "Border thickness"; group = "Appearance"; groupOrder = 10; order = 50; min = 1; max = 6; unit = "px"; visibleWhen.path = "desktop.ojuny.dms.settings.dankLauncherV2BorderEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.dankLauncherV2BorderThickness = 2;

    # @option widget = "dropdown"; label = "Border color"; group = "Appearance"; groupOrder = 10; order = 60; choices = [ "primary" "secondary" "outline" "surfaceText" ]; visibleWhen.path = "desktop.ojuny.dms.settings.dankLauncherV2BorderEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.dankLauncherV2BorderColor = "primary";

    # @option widget = "switch"; label = "History"; group = "Search"; groupOrder = 20; order = 10; description = "Record app usage and past queries. Turning this off clears what is stored.";
    desktop.ojuny.dms.settings.launcherHistoryEnabled = true;

    # @option widget = "switch"; label = "Include files in All tab"; group = "Search"; groupOrder = 20; order = 30;
    desktop.ojuny.dms.settings.dankLauncherV2IncludeFilesInAll = false;

    # @option widget = "switch"; label = "Include folders in All tab"; group = "Search"; groupOrder = 20; order = 40;
    desktop.ojuny.dms.settings.dankLauncherV2IncludeFoldersInAll = false;

    # @option widget = "switch"; label = "Use overlay layer"; group = "Advanced"; groupOrder = 30; order = 10; advanced = true; description = "Show the launcher above fullscreen windows.";
    desktop.ojuny.dms.settings.launcherUseOverlayLayer = false;

    # @option widget = "switch"; label = "Unload on close"; group = "Advanced"; groupOrder = 30; order = 20; advanced = true; description = "Frees the launcher when closed and rebuilds it on open.";
    desktop.ojuny.dms.settings.dankLauncherV2UnloadOnClose = false;

    # @option widget = "dropdown"; label = "App picker view"; group = "Advanced"; groupOrder = 30; order = 30; choices = [ "grid" "list" ]; advanced = true;
    desktop.ojuny.dms.settings.appPickerViewMode = "grid";

    # @option widget = "dropdown"; label = "Browser picker view"; group = "Advanced"; groupOrder = 30; order = 40; choices = [ "grid" "list" ]; advanced = true;
    desktop.ojuny.dms.settings.browserPickerViewMode = "grid";

    # @option widget = "dropdown"; label = "Default mode"; group = "Notepad"; groupOrder = 40; order = 10; choices = [ "slideout" "popout" ];
    desktop.ojuny.dms.settings.notepadDefaultMode = "slideout";

    # @option widget = "dropdown"; label = "Open from"; group = "Notepad"; groupOrder = 40; order = 20; choices = [ "right" "left" ]; description = "Screen edge the slideout opens from."; visibleWhen.path = "desktop.ojuny.dms.settings.notepadDefaultMode"; visibleWhen.equals = "slideout";
    desktop.ojuny.dms.settings.notepadSlideoutSide = "right";

    # @option widget = "switch"; label = "Show line numbers"; group = "Notepad"; groupOrder = 40; order = 30;
    desktop.ojuny.dms.settings.notepadShowLineNumbers = false;

    # @option widget = "switch"; label = "Auto-save to disk"; group = "Notepad"; groupOrder = 40; order = 40; description = "Automatically save changes to opened files as you type.";
    desktop.ojuny.dms.settings.notepadAutoSave = false;

    # @option widget = "switch"; label = "Use monospace font"; group = "Notepad"; groupOrder = 40; order = 50; description = "Use the global monospace font from Personalization.";
    desktop.ojuny.dms.settings.notepadUseMonospace = true;

    # @option widget = "text"; label = "Font family"; group = "Notepad"; groupOrder = 40; order = 60; advanced = true; description = "Empty uses the global UI font."; visibleWhen.path = "desktop.ojuny.dms.settings.notepadUseMonospace"; visibleWhen.equals = false;
    desktop.ojuny.dms.settings.notepadFontFamily = "";

    # @option widget = "spin"; label = "Font size"; group = "Notepad"; groupOrder = 40; order = 70; min = 8; max = 48; unit = "px";
    desktop.ojuny.dms.settings.notepadFontSize = 14;

    # @option widget = "switch"; label = "Auto compositor gaps"; group = "Notepad"; groupOrder = 40; order = 80; description = "Inset the notepad from screen edges using the compositor's configured gaps.";
    desktop.ojuny.dms.settings.notepadUseCompositorGap = false;

    # @option widget = "spin"; label = "Manual edge gap"; group = "Notepad"; groupOrder = 40; order = 90; min = 0; max = 64; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.settings.notepadUseCompositorGap"; visibleWhen.equals = false;
    desktop.ojuny.dms.settings.notepadEdgeGap = 0;

  };

}
