/*
  @menu
  displayname = "Sounds";
  icon = "preferences-desktop-sound-symbolic";
  order = 100;
  description = "System sound effects";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-sounds = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "System sounds"; group = "Sounds"; groupOrder = 10; order = 10;
    desktop.ojuny.dms.settings.soundsEnabled = true;

    # @option widget = "switch"; label = "Use system sound theme"; group = "Sounds"; groupOrder = 10; order = 20; visibleWhen.path = "desktop.ojuny.dms.settings.soundsEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.useSystemSoundTheme = false;

    # @option widget = "switch"; label = "Login"; group = "Sounds"; groupOrder = 10; order = 30; visibleWhen.path = "desktop.ojuny.dms.settings.soundsEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.soundLogin = false;

    # @option widget = "switch"; label = "New notification"; group = "Sounds"; groupOrder = 10; order = 40; visibleWhen.path = "desktop.ojuny.dms.settings.soundsEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.soundNewNotification = true;

    # @option widget = "switch"; label = "Volume changed"; group = "Sounds"; groupOrder = 10; order = 50; visibleWhen.path = "desktop.ojuny.dms.settings.soundsEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.soundVolumeChanged = true;

    # @option widget = "switch"; label = "Plugged in"; group = "Sounds"; groupOrder = 10; order = 60; description = "Needs a battery."; visibleWhen.path = "desktop.ojuny.dms.settings.soundsEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.soundPluggedIn = true;

    # @option widget = "switch"; label = "Mute during media playback"; group = "Sounds"; groupOrder = 10; order = 70; visibleWhen.path = "desktop.ojuny.dms.settings.soundsEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.muteSoundsWhenMediaPlaying = true;

    # @option widget = "switch"; label = "Mono audio"; group = "Advanced audio"; groupOrder = 20; order = 10; advanced = true; description = "Mix all stereo content into a single channel.";
    desktop.ojuny.dms.settings.audioMono = false;

    # @option widget = "switch"; label = "Show virtual devices"; group = "Advanced audio"; groupOrder = 20; order = 20; advanced = true;
    desktop.ojuny.dms.settings.audioShowStreamDevices = false;

    # @option widget = "switch"; label = "Audio visualizer"; group = "Advanced audio"; groupOrder = 20; order = 30; advanced = true;
    desktop.ojuny.dms.settings.audioVisualizerEnabled = true;

    # @option widget = "spin"; label = "Volume step"; group = "Advanced audio"; groupOrder = 20; order = 40; min = 0; max = 99; advanced = true; description = "Wheel scroll volume increment.";
    desktop.ojuny.dms.settings.audioWheelScrollAmount = 5;

  };

}
