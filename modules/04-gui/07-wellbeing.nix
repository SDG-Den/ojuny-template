/*
  @menu
  displayname = "Digital wellbeing";
  icon = "alarm-symbolic";
  order = 70;
  description = "Screen time limits and per-app limits";
  category = "04-GUI";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-wellbeing = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Digital wellbeing"; group = "Limits"; groupOrder = 10; order = 10; description = "Track screen time and notify when a limit is reached."; applyCommand = "dms ipc call settings set wellbeingEnabled %%val%%";
    desktop.ojuny.dux.settings.wellbeingEnabled = true;

    # @option widget = "spin"; label = "Daily limit"; group = "Limits"; groupOrder = 10; order = 20; min = 0; max = 1440; unit = "min"; visibleWhen.path = "desktop.ojuny.dux.settings.wellbeingEnabled"; visibleWhen.equals = true; description = "Total screen time per day before a notification. 0 turns the limit off."; applyCommand = "dms ipc call settings set wellbeingDailyLimit %%val%%";
    desktop.ojuny.dux.settings.wellbeingDailyLimit = 0;

    # @option widget = "raw"; label = "Per-app limits"; group = "Limits"; groupOrder = 10; order = 30; rows = 6; visibleWhen.path = "desktop.ojuny.dux.settings.wellbeingEnabled"; visibleWhen.equals = true; description = "Application id to daily limit in minutes.";
    desktop.ojuny.dux.settings.wellbeingAppLimits = { };

  };

}
