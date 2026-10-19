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

    # @option widget = "list"; label = "Excluded media players"; group = "Cards"; groupOrder = 20; order = 30; description = "Player identity or desktop file name (e.g. firefox), case-insensitive.";
    desktop.ojuny.dms.settings.mediaExcludePlayers = [ ];

    # @option widget = "text"; label = "Clock date format"; group = "Date and weather"; groupOrder = 25; order = 10; description = "Qt format for the clock/bar date; empty = system default. Presets: ddd d, ddd MMM d, MMM d, M/d, d/M, ddd d MMM yyyy, yyyy-MM-dd, dddd, MMMM d.";
    desktop.ojuny.dms.settings.clockDateFormat = "";

    # @option widget = "switch"; label = "Show week number"; group = "Date and weather"; groupOrder = 25; order = 20;
    desktop.ojuny.dms.settings.showWeekNumber = false;

    # @option widget = "dropdown"; label = "First day of week"; group = "Date and weather"; groupOrder = 25; order = 30; choices = [ "-1" "0" "1" "2" "3" "4" "5" "6" ]; description = "-1 = system locale, 0 = Sunday ... 6 = Saturday.";
    desktop.ojuny.dms.settings.firstDayOfWeek = -1;

    # @option widget = "dropdown"; label = "Calendar backend"; group = "Date and weather"; groupOrder = 25; order = 40; choices = [ "auto" "khal" "dankcal" ]; advanced = true; description = "auto uses khal or DankCalendar when available.";
    desktop.ojuny.dms.settings.calendarBackend = "auto";

    # @option widget = "dropdown"; label = "Wind speed unit"; group = "Date and weather"; groupOrder = 25; order = 50; choices = [ "kmh" "ms" ]; description = "kmh = km/h, ms = m/s. DMS hides this while Fahrenheit is on.";
    desktop.ojuny.dms.settings.windSpeedUnit = "kmh";

    # Card placement: col/row are the grid cell, w/h the size in cells.

    # @option widget = "grid-configuration"; label = "Card layout"; group = "Cards"; groupOrder = 30; order = 30; gridColumns = 6;
    desktop.ojuny.dms.dashCards = {
      clock = {
        _order = 10;
        col = 2;
        row = 0;
        w = 1;
        h = 1;
      };
      weather = {
        _order = 20;
        col = 0;
        row = 0;
        w = 2;
        h = 1;
      };
      notifications = {
        _order = 30;
        col = 0;
        row = 4;
        w = 6;
        h = 2;
      };
      calendar = {
        _order = 40;
        col = 0;
        row = 1;
        w = 3;
        h = 3;
      };
      media = {
        _order = 50;
        col = 3;
        row = 3;
        w = 3;
        h = 1;
      };
      sysmon = {
        _order = 60;
        col = 3;
        row = 1;
        w = 3;
        h = 1;
      };
      network = {
        _order = 70;
        col = 3;
        row = 2;
        w = 3;
        h = 1;
      };
      user = {
        _order = 80;
        col = 3;
        row = 0;
        w = 3;
        h = 1;
      };
    };

    # Weather widget placement (inside the weather card).

    # @option widget = "grid-configuration"; label = "Weather widgets"; group = "Weather widgets"; groupOrder = 40; order = 10; gridColumns = 4;
    desktop.ojuny.dms.dashOptions.weather.widgets = {
      conditions = {
        col = 0;
        row = 2;
        w = 2;
        h = 2;
      };
      hourly = {
        col = 2;
        row = 2;
        w = 2;
        h = 2;
      };
      humidity = {
        col = 2;
        row = 4;
        w = 1;
        h = 2;
      };
      wind = {
        col = 3;
        row = 4;
        w = 1;
        h = 2;
      };
      "daily " = {
        col = 0;
        row = 0;
        w = 4;
        h = 2;
      };
      precipitation = {
        col = 1;
        row = 4;
        w = 1;
        h = 2;
      };
      uv = {
        col = 0;
        row = 4;
        w = 1;
        h = 2;
      };
    };

  };

}
