/*
  @menu
  displayname = "Dashboard";
  icon = "view-grid-symbolic";
  order = 80;
  description = "Dashboard cards and tabs";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dashboard = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Overview tab"; group = "Tabs";
    desktop.ojuny.dms.dashTabs.overview.enabled = false;

    # @option widget = "switch"; label = "Media tab"; group = "Tabs";
    desktop.ojuny.dms.dashTabs.media.enabled = true;

    # @option widget = "switch"; label = "Wallpaper tab"; group = "Tabs";
    desktop.ojuny.dms.dashTabs.wallpaper.enabled = true;

    # @option widget = "switch"; label = "Weather tab"; group = "Tabs";
    desktop.ojuny.dms.dashTabs.weather.enabled = true;

    # @option widget = "switch"; label = "Wellbeing tab"; group = "Tabs";
    desktop.ojuny.dms.dashTabs.wellbeing.enabled = true;

    # @option widget = "switch"; label = "Notifications tab"; group = "Tabs";
    desktop.ojuny.dms.dashTabs.notifications.enabled = true;

    # @option widget = "switch"; label = "Calendar weekends"; group = "Cards";
    desktop.ojuny.dms.dashOptions.calendar.weekends = true;

    # @option widget = "dropdown"; label = "Media player style"; group = "Cards"; description = "DMS media card style."; choices = [ "material" "compact" "minimal" ];
    desktop.ojuny.dms.dashOptions.media.playerStyle = "material";

    # Card placement (col/row/w/h per card in desktop.ojuny.dms.dashCards) and
    # the weather widget grid stay at their defaults; edit them in this file.

  };

}
