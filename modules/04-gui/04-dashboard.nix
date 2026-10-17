/*
  @menu
  displayname = "Dashboard";
  icon = "view-grid-symbolic";
  order = 40;
  description = "Dashboard cards, tabs and their placement";
  category = "04-GUI";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dashboard = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Overview tab"; group = "Tabs"; groupOrder = 10; order = 10;
    desktop.ojuny.dms.dashTabs.overview.enabled = false;

    # @option widget = "switch"; label = "Media tab"; group = "Tabs"; groupOrder = 10; order = 20;
    desktop.ojuny.dms.dashTabs.media.enabled = true;

    # @option widget = "switch"; label = "Wallpaper tab"; group = "Tabs"; groupOrder = 10; order = 30;
    desktop.ojuny.dms.dashTabs.wallpaper.enabled = true;

    # @option widget = "switch"; label = "Weather tab"; group = "Tabs"; groupOrder = 10; order = 40;
    desktop.ojuny.dms.dashTabs.weather.enabled = true;

    # @option widget = "switch"; label = "Wellbeing tab"; group = "Tabs"; groupOrder = 10; order = 50;
    desktop.ojuny.dms.dashTabs.wellbeing.enabled = true;

    # @option widget = "switch"; label = "Notifications tab"; group = "Tabs"; groupOrder = 10; order = 60;
    desktop.ojuny.dms.dashTabs.notifications.enabled = true;

    # @option widget = "switch"; label = "Calendar weekends"; group = "Cards"; groupOrder = 20; order = 10;
    desktop.ojuny.dms.dashOptions.calendar.weekends = true;

    # @option widget = "dropdown"; label = "Media player style"; group = "Cards"; description = "DMS media card style."; choices = [ "material" "compact" "minimal" ]; groupOrder = 20; order = 20;
    desktop.ojuny.dms.dashOptions.media.playerStyle = "material";

    # Card placement: col/row are the grid cell, w/h the size in cells.

    # @option widget = "horizontal-submodule"; label = "Clock"; group = "Card layout"; groupOrder = 30; order = 10; maxColumns = 4;
    desktop.ojuny.dms.dashCards.clock = { col = 2; row = 0; w = 1; h = 1; };

    # @option widget = "horizontal-submodule"; label = "Weather"; group = "Card layout"; groupOrder = 30; order = 20; maxColumns = 4;
    desktop.ojuny.dms.dashCards.weather = { col = 0; row = 0; w = 2; h = 1; };

    # @option widget = "horizontal-submodule"; label = "Notifications"; group = "Card layout"; groupOrder = 30; order = 30; maxColumns = 4;
    desktop.ojuny.dms.dashCards.notifications = { col = 0; row = 4; w = 6; h = 2; };

    # @option widget = "horizontal-submodule"; label = "Calendar"; group = "Card layout"; groupOrder = 30; order = 40; maxColumns = 4;
    desktop.ojuny.dms.dashCards.calendar = { col = 0; row = 1; w = 3; h = 3; };

    # @option widget = "horizontal-submodule"; label = "Media"; group = "Card layout"; groupOrder = 30; order = 50; maxColumns = 4;
    desktop.ojuny.dms.dashCards.media = { col = 3; row = 3; w = 3; h = 1; };

    # @option widget = "horizontal-submodule"; label = "Sysmon"; group = "Card layout"; groupOrder = 30; order = 60; maxColumns = 4;
    desktop.ojuny.dms.dashCards.sysmon = { col = 3; row = 1; w = 3; h = 1; };

    # @option widget = "horizontal-submodule"; label = "Network"; group = "Card layout"; groupOrder = 30; order = 70; maxColumns = 4;
    desktop.ojuny.dms.dashCards.network = { col = 3; row = 2; w = 3; h = 1; };

    # @option widget = "horizontal-submodule"; label = "User"; group = "Card layout"; groupOrder = 30; order = 80; maxColumns = 4;
    desktop.ojuny.dms.dashCards.user = { col = 3; row = 0; w = 3; h = 1; };

    # Weather widget placement (inside the weather card).

    # @option widget = "horizontal-submodule"; label = "Conditions"; group = "Weather widgets"; groupOrder = 40; order = 10; maxColumns = 4;
    desktop.ojuny.dms.dashOptions.weather.widgets.conditions = { col = 0; row = 2; w = 2; h = 2; };

    # @option widget = "horizontal-submodule"; label = "Hourly"; group = "Weather widgets"; groupOrder = 40; order = 20; maxColumns = 4;
    desktop.ojuny.dms.dashOptions.weather.widgets.hourly = { col = 2; row = 2; w = 2; h = 2; };

    # @option widget = "horizontal-submodule"; label = "Humidity"; group = "Weather widgets"; groupOrder = 40; order = 30; maxColumns = 4;
    desktop.ojuny.dms.dashOptions.weather.widgets.humidity = { col = 2; row = 4; w = 1; h = 2; };

    # @option widget = "horizontal-submodule"; label = "Wind"; group = "Weather widgets"; groupOrder = 40; order = 40; maxColumns = 4;
    desktop.ojuny.dms.dashOptions.weather.widgets.wind = { col = 3; row = 4; w = 1; h = 2; };

    # @option widget = "horizontal-submodule"; label = "Daily"; group = "Weather widgets"; groupOrder = 40; order = 50; maxColumns = 4;
    desktop.ojuny.dms.dashOptions.weather.widgets."daily " = { col = 0; row = 0; w = 4; h = 2; };

    # @option widget = "horizontal-submodule"; label = "Precipitation"; group = "Weather widgets"; groupOrder = 40; order = 60; maxColumns = 4;
    desktop.ojuny.dms.dashOptions.weather.widgets.precipitation = { col = 1; row = 4; w = 1; h = 2; };

    # @option widget = "horizontal-submodule"; label = "UV"; group = "Weather widgets"; groupOrder = 40; order = 70; maxColumns = 4;
    desktop.ojuny.dms.dashOptions.weather.widgets.uv = { col = 0; row = 4; w = 1; h = 2; };

  };

}
