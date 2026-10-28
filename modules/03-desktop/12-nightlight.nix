/*
  @menu
  displayname = "Night light";
  icon = "nightlight-symbolic";
  order = 120;
  description = "Automatic night mode scheduling";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-nightlight = { config, lib, ... }: {

    desktop.ojuny.dux.session = {
      # @option widget = "switch"; label = "Night mode"; group = "Schedule"; groupOrder = 10; order = 5; description = "Enable night mode now, independent of the schedule.";
      nightModeEnabled = false;

      # @option widget = "switch"; label = "Automatic night mode"; group = "Schedule"; groupOrder = 10; order = 10; description = "Enable the scheduled night mode.";
      nightModeAutoEnabled = false;

      # @option widget = "dropdown"; label = "Schedule mode"; group = "Schedule"; groupOrder = 10; order = 20; choices = [ "time" "location" ]; description = "Use fixed hours or sunrise and sunset.";
      nightModeAutoMode = "time";

      # @option widget = "spin"; label = "Start hour"; group = "Schedule"; groupOrder = 10; order = 30; min = 0; max = 23; visibleWhen.path = "desktop.ojuny.dux.session.nightModeAutoMode"; visibleWhen.equals = "time";
      nightModeStartHour = 18;

      # @option widget = "spin"; label = "Start minute"; group = "Schedule"; groupOrder = 10; order = 40; min = 0; max = 59; visibleWhen.path = "desktop.ojuny.dux.session.nightModeAutoMode"; visibleWhen.equals = "time";
      nightModeStartMinute = 0;

      # @option widget = "spin"; label = "End hour"; group = "Schedule"; groupOrder = 10; order = 50; min = 0; max = 23; visibleWhen.path = "desktop.ojuny.dux.session.nightModeAutoMode"; visibleWhen.equals = "time";
      nightModeEndHour = 6;

      # @option widget = "spin"; label = "End minute"; group = "Schedule"; groupOrder = 10; order = 60; min = 0; max = 59; visibleWhen.path = "desktop.ojuny.dux.session.nightModeAutoMode"; visibleWhen.equals = "time";
      nightModeEndMinute = 0;

      # @option widget = "spin"; label = "Transition duration"; group = "Schedule"; groupOrder = 10; order = 70; min = 0; max = 180; unit = "min";
      nightModeTransitionMinutes = 60;

      # @option widget = "spin"; label = "Night temperature"; group = "Colour"; groupOrder = 20; order = 10; min = 1000; max = 6000; step = 100; unit = "K";
      nightModeTemperature = 4500;

      # @option widget = "spin"; label = "Day temperature"; group = "Colour"; groupOrder = 20; order = 20; min = 1000; max = 10000; step = 100; unit = "K";
      nightModeHighTemperature = 6500;

      # @option widget = "switch"; label = "Pause in fullscreen"; group = "Behaviour"; groupOrder = 30; order = 10; description = "Disable night mode while a fullscreen app is focused.";
      nightModeExcludeFullscreen = false;

      # @option widget = "switch"; label = "Use IP location"; group = "Location"; groupOrder = 40; order = 10; visibleWhen.path = "desktop.ojuny.dux.session.nightModeAutoMode"; visibleWhen.equals = "location";
      nightModeUseIPLocation = false;

      # @option widget = "text"; label = "Location name"; group = "Location"; groupOrder = 40; order = 20; visibleWhen.path = "desktop.ojuny.dux.session.nightModeAutoMode"; visibleWhen.equals = "location";
      nightModeLocationName = "";

      # @option widget = "raw"; label = "Monitor cycling settings"; group = "Wallpaper cycling"; groupOrder = 50; order = 10; rows = 6; description = "Per-monitor wallpaper cycling settings keyed by output name.";
      monitorCyclingSettings = { };
    };

    desktop.ojuny.dux.settings = {
      # @option widget = "list"; label = "Excluded applications"; group = "Behaviour"; groupOrder = 30; order = 20; description = "Application IDs that pause night mode while focused.";
      nightModeExcludedApps = [ ];
    };

  };

}
