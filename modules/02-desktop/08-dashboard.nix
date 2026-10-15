/*
  @menu
  displayname = "Dashboard";
  icon = "view-grid-symbolic";
  order = 80;
  description = "Dashboard cards, tabs and their placement";
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

    # Card placement: col/row are the grid cell, w/h the size in cells.

    # Clock card
    # @option widget = "spin"; label = "Column"; group = "Clock card"; min = 0; max = 6;
    desktop.ojuny.dms.dashCards.clock.col = 2;

    # @option widget = "spin"; label = "Row"; group = "Clock card"; min = 0; max = 12;
    desktop.ojuny.dms.dashCards.clock.row = 0;

    # @option widget = "spin"; label = "Width"; group = "Clock card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.clock.w = 1;

    # @option widget = "spin"; label = "Height"; group = "Clock card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.clock.h = 1;

    # Weather card
    # @option widget = "spin"; label = "Column"; group = "Weather card"; min = 0; max = 6;
    desktop.ojuny.dms.dashCards.weather.col = 0;

    # @option widget = "spin"; label = "Row"; group = "Weather card"; min = 0; max = 12;
    desktop.ojuny.dms.dashCards.weather.row = 0;

    # @option widget = "spin"; label = "Width"; group = "Weather card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.weather.w = 2;

    # @option widget = "spin"; label = "Height"; group = "Weather card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.weather.h = 1;

    # Notifications card
    # @option widget = "spin"; label = "Column"; group = "Notifications card"; min = 0; max = 6;
    desktop.ojuny.dms.dashCards.notifications.col = 0;

    # @option widget = "spin"; label = "Row"; group = "Notifications card"; min = 0; max = 12;
    desktop.ojuny.dms.dashCards.notifications.row = 4;

    # @option widget = "spin"; label = "Width"; group = "Notifications card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.notifications.w = 6;

    # @option widget = "spin"; label = "Height"; group = "Notifications card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.notifications.h = 2;

    # Calendar card
    # @option widget = "spin"; label = "Column"; group = "Calendar card"; min = 0; max = 6;
    desktop.ojuny.dms.dashCards.calendar.col = 0;

    # @option widget = "spin"; label = "Row"; group = "Calendar card"; min = 0; max = 12;
    desktop.ojuny.dms.dashCards.calendar.row = 1;

    # @option widget = "spin"; label = "Width"; group = "Calendar card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.calendar.w = 3;

    # @option widget = "spin"; label = "Height"; group = "Calendar card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.calendar.h = 3;

    # Media card
    # @option widget = "spin"; label = "Column"; group = "Media card"; min = 0; max = 6;
    desktop.ojuny.dms.dashCards.media.col = 3;

    # @option widget = "spin"; label = "Row"; group = "Media card"; min = 0; max = 12;
    desktop.ojuny.dms.dashCards.media.row = 3;

    # @option widget = "spin"; label = "Width"; group = "Media card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.media.w = 3;

    # @option widget = "spin"; label = "Height"; group = "Media card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.media.h = 1;

    # System monitor card
    # @option widget = "spin"; label = "Column"; group = "System monitor card"; min = 0; max = 6;
    desktop.ojuny.dms.dashCards.sysmon.col = 3;

    # @option widget = "spin"; label = "Row"; group = "System monitor card"; min = 0; max = 12;
    desktop.ojuny.dms.dashCards.sysmon.row = 1;

    # @option widget = "spin"; label = "Width"; group = "System monitor card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.sysmon.w = 3;

    # @option widget = "spin"; label = "Height"; group = "System monitor card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.sysmon.h = 1;

    # Network card
    # @option widget = "spin"; label = "Column"; group = "Network card"; min = 0; max = 6;
    desktop.ojuny.dms.dashCards.network.col = 3;

    # @option widget = "spin"; label = "Row"; group = "Network card"; min = 0; max = 12;
    desktop.ojuny.dms.dashCards.network.row = 2;

    # @option widget = "spin"; label = "Width"; group = "Network card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.network.w = 3;

    # @option widget = "spin"; label = "Height"; group = "Network card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.network.h = 1;

    # User card
    # @option widget = "spin"; label = "Column"; group = "User card"; min = 0; max = 6;
    desktop.ojuny.dms.dashCards.user.col = 3;

    # @option widget = "spin"; label = "Row"; group = "User card"; min = 0; max = 12;
    desktop.ojuny.dms.dashCards.user.row = 0;

    # @option widget = "spin"; label = "Width"; group = "User card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.user.w = 3;

    # @option widget = "spin"; label = "Height"; group = "User card"; min = 1; max = 6;
    desktop.ojuny.dms.dashCards.user.h = 1;

    # Weather widget placement (inside the weather card).

    # @option widget = "spin"; label = "Conditions column"; group = "Weather widgets"; min = 0; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.conditions.col = 0;

    # @option widget = "spin"; label = "Conditions row"; group = "Weather widgets"; min = 0; max = 12;
    desktop.ojuny.dms.dashOptions.weather.widgets.conditions.row = 2;

    # @option widget = "spin"; label = "Conditions width"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.conditions.w = 2;

    # @option widget = "spin"; label = "Conditions height"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.conditions.h = 2;

    # @option widget = "spin"; label = "Hourly column"; group = "Weather widgets"; min = 0; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.hourly.col = 2;

    # @option widget = "spin"; label = "Hourly row"; group = "Weather widgets"; min = 0; max = 12;
    desktop.ojuny.dms.dashOptions.weather.widgets.hourly.row = 2;

    # @option widget = "spin"; label = "Hourly width"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.hourly.w = 2;

    # @option widget = "spin"; label = "Hourly height"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.hourly.h = 2;

    # @option widget = "spin"; label = "Humidity column"; group = "Weather widgets"; min = 0; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.humidity.col = 2;

    # @option widget = "spin"; label = "Humidity row"; group = "Weather widgets"; min = 0; max = 12;
    desktop.ojuny.dms.dashOptions.weather.widgets.humidity.row = 4;

    # @option widget = "spin"; label = "Humidity width"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.humidity.w = 1;

    # @option widget = "spin"; label = "Humidity height"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.humidity.h = 2;

    # @option widget = "spin"; label = "Wind column"; group = "Weather widgets"; min = 0; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.wind.col = 3;

    # @option widget = "spin"; label = "Wind row"; group = "Weather widgets"; min = 0; max = 12;
    desktop.ojuny.dms.dashOptions.weather.widgets.wind.row = 4;

    # @option widget = "spin"; label = "Wind width"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.wind.w = 1;

    # @option widget = "spin"; label = "Wind height"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.wind.h = 2;

    # @option widget = "spin"; label = "Daily column"; group = "Weather widgets"; min = 0; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets."daily ".col = 0;

    # @option widget = "spin"; label = "Daily row"; group = "Weather widgets"; min = 0; max = 12;
    desktop.ojuny.dms.dashOptions.weather.widgets."daily ".row = 0;

    # @option widget = "spin"; label = "Daily width"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets."daily ".w = 4;

    # @option widget = "spin"; label = "Daily height"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets."daily ".h = 2;

    # @option widget = "spin"; label = "Precipitation column"; group = "Weather widgets"; min = 0; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.precipitation.col = 1;

    # @option widget = "spin"; label = "Precipitation row"; group = "Weather widgets"; min = 0; max = 12;
    desktop.ojuny.dms.dashOptions.weather.widgets.precipitation.row = 4;

    # @option widget = "spin"; label = "Precipitation width"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.precipitation.w = 1;

    # @option widget = "spin"; label = "Precipitation height"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.precipitation.h = 2;

    # @option widget = "spin"; label = "UV column"; group = "Weather widgets"; min = 0; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.uv.col = 0;

    # @option widget = "spin"; label = "UV row"; group = "Weather widgets"; min = 0; max = 12;
    desktop.ojuny.dms.dashOptions.weather.widgets.uv.row = 4;

    # @option widget = "spin"; label = "UV width"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.uv.w = 1;

    # @option widget = "spin"; label = "UV height"; group = "Weather widgets"; min = 1; max = 6;
    desktop.ojuny.dms.dashOptions.weather.widgets.uv.h = 2;

  };

}
