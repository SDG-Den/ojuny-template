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
    desktop.ojuny.dux.dashTabs.overview.enabled = false;

    # @option widget = "switch"; label = "Media tab"; group = "Tabs"; groupOrder = 10; order = 20;
    desktop.ojuny.dux.dashTabs.media.enabled = true;

    # @option widget = "switch"; label = "Wallpaper tab"; group = "Tabs"; groupOrder = 10; order = 30;
    desktop.ojuny.dux.dashTabs.wallpaper.enabled = true;

    # @option widget = "switch"; label = "Weather tab"; group = "Tabs"; groupOrder = 10; order = 40;
    desktop.ojuny.dux.dashTabs.weather.enabled = true;

    # @option widget = "switch"; label = "Wellbeing tab"; group = "Tabs"; groupOrder = 10; order = 50;
    desktop.ojuny.dux.dashTabs.wellbeing.enabled = true;

    # @option widget = "switch"; label = "Notifications tab"; group = "Tabs"; groupOrder = 10; order = 60;
    desktop.ojuny.dux.dashTabs.notifications.enabled = true;

    # @option widget = "dropdown"; label = "Tab position"; group = "Tabs"; groupOrder = 10; order = 70; choices = [ "auto" "left" "right" "bottom" "center" ]; description = "Where the dashboard tab bar sits."; applyCommand = "dms ipc call settings set dashTabPosition %%val%%";
    desktop.ojuny.dux.settings.dashTabPosition = "auto";

    # @option widget = "switch"; label = "Evenly space tabs"; group = "Tabs"; groupOrder = 10; order = 80; description = "Spread tabs across the full tab bar."; applyCommand = "dms ipc call settings set dashTabsEvenlySpaced %%val%%";
    desktop.ojuny.dux.settings.dashTabsEvenlySpaced = true;

    # @option widget = "dropdown"; label = "Media player style"; group = "Cards"; description = "DMS media card style."; choices = [ "material" "compact" "minimal" ]; groupOrder = 20; order = 20;
    desktop.ojuny.dux.dashOptions.media.playerStyle = "material";

    # @option widget = "list"; label = "Excluded media players"; group = "Cards"; groupOrder = 20; order = 30; description = "Player identity or desktop file name (e.g. firefox), case-insensitive.";
    desktop.ojuny.dux.settings.mediaExcludePlayers = [ ];

    # @option widget = "spin"; label = "Clock weight"; group = "Cards"; groupOrder = 20; order = 41; min = 0; max = 100; description = "Font weight of the clock digits. 0 uses the theme default.";
    desktop.ojuny.dux.dashOptions.clock.weight = 0;

    # @option widget = "dropdown"; label = "Media artwork shape"; group = "Cards"; groupOrder = 20; order = 50; choices = [ "rounded" "circle" "square" "slanted" "cookie" ];
    desktop.ojuny.dux.dashOptions.media.artStyle = "rounded";

    # @option widget = "text"; label = "Media title font"; group = "Cards"; groupOrder = 20; order = 51; description = "Font token: ui, display or a bundled family. Empty uses the media default.";
    desktop.ojuny.dux.dashOptions.media.titleFont = "";

    # @option widget = "switch"; label = "Media show device name"; group = "Cards"; groupOrder = 20; order = 52;
    desktop.ojuny.dux.dashOptions.media.deviceName = true;

    # @option widget = "switch"; label = "Media seekbar"; group = "Cards"; groupOrder = 20; order = 53;
    desktop.ojuny.dux.dashOptions.media.seekbar = true;

    # @option widget = "switch"; label = "Media wave progress"; group = "Cards"; groupOrder = 20; order = 54;
    desktop.ojuny.dux.dashOptions.media.waveProgress = true;

    # @option widget = "switch"; label = "Media album art backdrop"; group = "Cards"; groupOrder = 20; order = 55;
    desktop.ojuny.dux.dashOptions.media.albumArtBackdrop = true;

    # @option widget = "switch"; label = "Media album art accent"; group = "Cards"; groupOrder = 20; order = 56; description = "Tint the card with the album art color.";
    desktop.ojuny.dux.dashOptions.media.albumArtAccent = true;

    # @option widget = "switch"; label = "Media animated art"; group = "Cards"; groupOrder = 20; order = 57; description = "Apple Music animated covers. Sends the artist and album name to Apple.";
    desktop.ojuny.dux.dashOptions.media.animatedArt = false;

    # @option widget = "switch"; label = "Media lyrics"; group = "Cards"; groupOrder = 20; order = 58; description = "Lyrics button. Sends the track, artist and album to enabled lyrics providers.";
    desktop.ojuny.dux.dashOptions.media.lyrics = true;

    # @option widget = "switch"; label = "Media smooth lyrics"; group = "Cards"; groupOrder = 20; order = 59; description = "Fill each sung word gradually instead of highlighting it at once.";
    desktop.ojuny.dux.dashOptions.media.smoothLyrics = true;

    # @option widget = "switch"; label = "System monitor temperature"; group = "Cards"; groupOrder = 20; order = 63;
    desktop.ojuny.dux.dashOptions.sysmon.temperature = true;

    # @option widget = "dropdown"; label = "System monitor tone"; group = "Cards"; groupOrder = 20; order = 64; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
    desktop.ojuny.dux.dashOptions.sysmon.tone = "primary";

    # @option widget = "switch"; label = "NVIDIA GPU temperature"; group = "Cards"; groupOrder = 20; order = 88; description = "Read temperature from NVIDIA GPUs.";
    desktop.ojuny.dux.session.nvidiaGpuTempEnabled = false;

    # @option widget = "switch"; label = "Other GPU temperature"; group = "Cards"; groupOrder = 20; order = 89; description = "Read temperature from non-NVIDIA GPUs.";
    desktop.ojuny.dux.session.nonNvidiaGpuTempEnabled = false;

    # @option widget = "switch"; label = "Network trend"; group = "Cards"; groupOrder = 20; order = 65;
    desktop.ojuny.dux.dashOptions.network.trend = true;

    # @option widget = "dropdown"; label = "Network tone"; group = "Cards"; groupOrder = 20; order = 66; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
    desktop.ojuny.dux.dashOptions.network.tone = "primary";

    # @option widget = "dropdown"; label = "Battery style"; group = "Cards"; groupOrder = 20; order = 67; choices = [ "solid" "outline" "ring" ]; description = "Battery card gauge style.";
    desktop.ojuny.dux.dashOptions.battery.style = "solid";

    # @option widget = "dropdown"; label = "Battery color"; group = "Cards"; groupOrder = 20; order = 68; choices = [ "level" "theme" ]; description = "level colors the gauge by charge level, theme uses the accent color.";
    desktop.ojuny.dux.dashOptions.battery.color = "level";

    # @option widget = "switch"; label = "Battery health"; group = "Cards"; groupOrder = 20; order = 69;
    desktop.ojuny.dux.dashOptions.battery.health = false;

    # @option widget = "dropdown"; label = "Battery tone"; group = "Cards"; groupOrder = 20; order = 70; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
    desktop.ojuny.dux.dashOptions.battery.tone = "";

    # @option widget = "switch"; label = "CPU temperature"; group = "Cards"; groupOrder = 20; order = 71;
    desktop.ojuny.dux.dashOptions.cpu.temperature = true;

    # @option widget = "dropdown"; label = "CPU tone"; group = "Cards"; groupOrder = 20; order = 72; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
    desktop.ojuny.dux.dashOptions.cpu.tone = "";

    # @option widget = "switch"; label = "CPU trend"; group = "Cards"; groupOrder = 20; order = 73;
    desktop.ojuny.dux.dashOptions.cpu.trend = true;

    # @option widget = "switch"; label = "Disk I/O"; group = "Cards"; groupOrder = 20; order = 74;
    desktop.ojuny.dux.dashOptions.disk.io = false;

    # @option widget = "dropdown"; label = "Disk tone"; group = "Cards"; groupOrder = 20; order = 75; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
    desktop.ojuny.dux.dashOptions.disk.tone = "";

    # @option widget = "switch"; label = "Disk trend"; group = "Cards"; groupOrder = 20; order = 76;
    desktop.ojuny.dux.dashOptions.disk.trend = true;

    # @option widget = "switch"; label = "Memory swap"; group = "Cards"; groupOrder = 20; order = 77;
    desktop.ojuny.dux.dashOptions.memory.swap = false;

    # @option widget = "dropdown"; label = "Memory tone"; group = "Cards"; groupOrder = 20; order = 78; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
    desktop.ojuny.dux.dashOptions.memory.tone = "";

    # @option widget = "switch"; label = "Memory trend"; group = "Cards"; groupOrder = 20; order = 79;
    desktop.ojuny.dux.dashOptions.memory.trend = true;

    # @option widget = "switch"; label = "User hostname"; group = "Cards"; groupOrder = 20; order = 80;
    desktop.ojuny.dux.dashOptions.user.hostname = true;

    # @option widget = "switch"; label = "User compositor"; group = "Cards"; groupOrder = 20; order = 81;
    desktop.ojuny.dux.dashOptions.user.compositor = true;

    # @option widget = "switch"; label = "User uptime"; group = "Cards"; groupOrder = 20; order = 82;
    desktop.ojuny.dux.dashOptions.user.uptime = true;

    # @option widget = "switch"; label = "User distro badge"; group = "Cards"; groupOrder = 20; order = 83;
    desktop.ojuny.dux.dashOptions.user.badge = true;

    # @option widget = "dropdown"; label = "Wallpaper layout"; group = "Cards"; groupOrder = 20; order = 84; choices = [ "grid" "carousel" ]; description = "Wallpaper tab layout.";
    desktop.ojuny.dux.dashOptions.wallpaper.layout = "grid";

    # @option widget = "spin"; label = "Wallpaper columns"; group = "Cards"; groupOrder = 20; order = 85; min = 3; max = 6;
    desktop.ojuny.dux.dashOptions.wallpaper.columns = 4;

    # @option widget = "spin"; label = "Wallpaper rows"; group = "Cards"; groupOrder = 20; order = 86; min = 2; max = 5;
    desktop.ojuny.dux.dashOptions.wallpaper.rows = 4;

    # @option widget = "switch"; label = "Wallpaper filename"; group = "Cards"; groupOrder = 20; order = 87;
    desktop.ojuny.dux.dashOptions.wallpaper.filename = true;

    # @option widget = "text"; label = "Clock date format"; group = "Date and weather"; groupOrder = 25; order = 10; description = "Qt format for the clock/bar date; empty = system default. Presets: ddd d, ddd MMM d, MMM d, M/d, d/M, ddd d MMM yyyy, yyyy-MM-dd, dddd, MMMM d."; applyCommand = "dms ipc call settings set clockDateFormat %%val%%";
    desktop.ojuny.dux.settings.clockDateFormat = "";

    # @option widget = "dropdown"; label = "Clock format"; group = "Date and weather"; groupOrder = 25; order = 11; choices = [ "auto" "12h" "24h" ]; description = "auto follows the locale."; applyCommand = "dms ipc call settings set clockFormat %%val%%";
    desktop.ojuny.dux.settings.clockFormat = "auto";

    # @option widget = "switch"; label = "Show seconds"; group = "Date and weather"; groupOrder = 25; order = 12; applyCommand = "dms ipc call settings set showSeconds %%val%%";
    desktop.ojuny.dux.settings.showSeconds = false;

    # @option widget = "switch"; label = "Pad 12-hour hours"; group = "Date and weather"; groupOrder = 25; order = 13; description = "Show 01:30 instead of 1:30 in 12-hour time."; applyCommand = "dms ipc call settings set padHours12Hour %%val%%";
    desktop.ojuny.dux.settings.padHours12Hour = false;

    # @option widget = "switch"; label = "Show week number"; group = "Date and weather"; groupOrder = 25; order = 20; applyCommand = "dms ipc call settings set showWeekNumber %%val%%";
    desktop.ojuny.dux.settings.showWeekNumber = false;

    # @option widget = "dropdown"; label = "First day of week"; group = "Date and weather"; groupOrder = 25; order = 30; choices = [ "-1" "0" "1" "2" "3" "4" "5" "6" ]; description = "-1 = system locale, 0 = Sunday ... 6 = Saturday."; applyCommand = "dms ipc call settings set firstDayOfWeek %%val%%";
    desktop.ojuny.dux.settings.firstDayOfWeek = -1;

    # @option widget = "dropdown"; label = "Calendar backend"; group = "Date and weather"; groupOrder = 25; order = 40; choices = [ "auto" "khal" "dankcal" ]; advanced = true; description = "auto uses khal or Dux Calendar when available."; applyCommand = "dms ipc call settings set calendarBackend %%val%%";
    desktop.ojuny.dux.settings.calendarBackend = "auto";

    # @option widget = "dropdown"; label = "Wind speed unit"; group = "Date and weather"; groupOrder = 25; order = 50; choices = [ "kmh" "ms" ]; description = "kmh = km/h, ms = m/s. DMS hides this while Fahrenheit is on."; applyCommand = "dms ipc call settings set windSpeedUnit %%val%%";
    desktop.ojuny.dux.settings.windSpeedUnit = "kmh";

    # @option widget = "switch"; label = "Use Fahrenheit"; group = "Date and weather"; groupOrder = 25; order = 51; description = "Temperatures in Fahrenheit instead of Celsius."; applyCommand = "dms ipc call settings set useFahrenheit %%val%%";
    desktop.ojuny.dux.settings.useFahrenheit = false;

    # @option widget = "switch"; label = "Weather enabled"; group = "Date and weather"; groupOrder = 25; order = 52; applyCommand = "dms ipc call settings set weatherEnabled %%val%%";
    desktop.ojuny.dux.settings.weatherEnabled = true;

    # @option widget = "text"; label = "Weather location"; group = "Date and weather"; groupOrder = 25; order = 53; description = "Display name shown for the weather location.";
    desktop.ojuny.dux.session.weatherLocation = "New York, NY";

    # @option widget = "text"; label = "Weather coordinates"; group = "Date and weather"; groupOrder = 25; order = 54; description = "Latitude and longitude separated by a comma.";
    desktop.ojuny.dux.session.weatherCoordinates = "40.7128,-74.0060";

    # @option widget = "spin"; label = "Latitude"; group = "Date and weather"; groupOrder = 25; order = 55; min = -90; max = 90; description = "Location latitude used for sunrise and sunset.";
    desktop.ojuny.dux.session.latitude = 0.0;

    # @option widget = "spin"; label = "Longitude"; group = "Date and weather"; groupOrder = 25; order = 56; min = -180; max = 180; description = "Location longitude used for sunrise and sunset.";
    desktop.ojuny.dux.session.longitude = 0.0;

    # @option widget = "switch"; label = "Automatic location"; group = "Date and weather"; groupOrder = 25; order = 57; description = "Detect the weather location instead of using the saved coordinates."; applyCommand = "dms ipc call settings set useAutoLocation %%val%%";
    desktop.ojuny.dux.settings.useAutoLocation = false;

    # @option widget = "text"; label = "Default task calendar"; group = "Date and weather"; groupOrder = 25; order = 60; description = "Calendar id new tasks are added to. Empty uses the first calendar."; applyCommand = "dms ipc call settings set defaultTaskCalendarId %%val%%";
    desktop.ojuny.dux.settings.defaultTaskCalendarId = "";

    # @option widget = "text"; label = "Lock screen date format"; group = "Date and weather"; groupOrder = 25; order = 61; description = "Qt format for the lock screen date; empty = system default."; applyCommand = "dms ipc call settings set lockDateFormat %%val%%";
    desktop.ojuny.dux.settings.lockDateFormat = "";

    # Card placement: col/row are the grid cell, w/h the size in cells.

    # @option widget = "grid-configuration"; label = "Card layout"; group = "Cards"; groupOrder = 30; order = 30; gridColumns = 6;
    desktop.ojuny.dux.dashCards = {
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
    desktop.ojuny.dux.dashOptions.weather.widgets = {
      conditions = {
        col = 0;
        row = 2;
        w = 2;
        h = 2;
        city = false;
        tone = "primary";
      };
      hourly = {
        col = 2;
        row = 2;
        w = 2;
        h = 2;
        forecast = "chart";
        # @option widget = "dropdown"; label = "Hourly tone"; group = "Weather widgets"; groupOrder = 40; order = 21; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
        tone = "primary";
      };
      humidity = {
        col = 2;
        row = 4;
        w = 1;
        h = 2;
        graphics = true;
        tone = "";
      };
      wind = {
        col = 3;
        row = 4;
        w = 1;
        h = 2;
        graphics = true;
        tone = "";
      };
      daily = {
        col = 0;
        row = 0;
        w = 4;
        h = 2;
        forecast = "chart";
        # @option widget = "dropdown"; label = "Daily tone"; group = "Weather widgets"; groupOrder = 40; order = 20; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
        tone = "primary";
      };
      precipitation = {
        col = 1;
        row = 4;
        w = 1;
        h = 2;
        graphics = true;
        tone = "";
      };
      uv = {
        col = 0;
        row = 4;
        w = 1;
        h = 2;
        graphics = true;
        tone = "";
      };
      moon = {
        col = 0;
        row = 6;
        w = 1;
        h = 2;
        # @option widget = "dropdown"; label = "Moon tone"; group = "Weather widgets"; groupOrder = 40; order = 22; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
        tone = "primary";
      };
      sun = {
        col = 1;
        row = 6;
        w = 1;
        h = 2;
        # @option widget = "dropdown"; label = "Sun tone"; group = "Weather widgets"; groupOrder = 40; order = 23; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
        tone = "primary";
      };
      readings = {
        col = 2;
        row = 6;
        w = 2;
        h = 2;
        # @option widget = "switch"; label = "Readings graphics"; group = "Weather widgets"; groupOrder = 40; order = 24; description = "Decorative graphics on the readings widget.";
        graphics = true;
        # @option widget = "dropdown"; label = "Readings tone"; group = "Weather widgets"; groupOrder = 40; order = 25; choices = [ "" "primary" "secondary" "tertiary" ]; description = "Empty uses the surface tone.";
        tone = "primary";
      };
    };

    # @option widget = "table-attrset"; label = "Desktop widget grid"; group = "Desktop widgets"; groupOrder = 45; order = 5; keyEditable = true; columns = [ "enabled" "size" ]; columnTypes = [ "bool" "int" ]; description = "Per-screen snap-to-grid settings for desktop widgets, keyed by screen name. size is the grid step in pixels.";
    desktop.ojuny.dux.session.desktopWidgetGridSettings = { };

    # @option widget = "raw"; label = "Desktop widget instances"; group = "Desktop widgets"; groupOrder = 45; order = 10; rows = 12; advanced = true; description = "Desktop widget instances with id, widgetType, enabled and config. Save and Rebuild is required.";
    desktop.ojuny.dux.settings.desktopWidgetInstances = [ ];

    # @option widget = "raw"; label = "Desktop widget groups"; group = "Desktop widgets"; groupOrder = 45; order = 20; rows = 6; advanced = true; description = "Desktop widget groups with id, name and member instances. Save and Rebuild is required.";
    desktop.ojuny.dux.settings.desktopWidgetGroups = [ ];

    # @option widget = "dropdown"; label = "Desktop context menu"; group = "Desktop widgets"; groupOrder = 45; order = 30; choices = [ "auto" "on" "off" ]; description = "Right-click menu on the desktop."; applyCommand = "dms ipc call settings set desktopContextMenu %%val%%";
    desktop.ojuny.dux.settings.desktopContextMenu = "auto";

  };

}
