/*
  @menu
  displayname = "On-screen display";
  icon = "video-display-symbolic";
  order = 90;
  description = "On-screen display popups";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-osd = { config, pkgs, ... }: {

    # @option widget = "dropdown"; label = "Position"; group = "General"; groupOrder = 10; order = 10; choices = [ "2" "4" "0" "6" "7" "1" "5" "3" ]; description = "2 = top left, 4 = top center, 0 = top right, 6 = left center, 7 = right center, 1 = bottom left, 5 = bottom center, 3 = bottom right.";
    desktop.ojuny.dms.settings.osdPosition = 5;

    # @option widget = "switch"; label = "Always show percentage"; group = "General"; groupOrder = 10; order = 20; description = "Keep the on-screen volume and brightness readout visible.";
    desktop.ojuny.dms.settings.osdAlwaysShowValue = true;

    # @option widget = "switch"; label = "Volume"; group = "Events"; groupOrder = 20; order = 10;
    desktop.ojuny.dms.settings.osdVolumeEnabled = true;

    # @option widget = "switch"; label = "Media volume"; group = "Events"; groupOrder = 20; order = 20;
    desktop.ojuny.dms.settings.osdMediaVolumeEnabled = true;

    # @option widget = "switch"; label = "Media playback"; group = "Events"; groupOrder = 20; order = 30;
    desktop.ojuny.dms.settings.osdMediaPlaybackEnabled = false;

    # @option widget = "switch"; label = "Brightness"; group = "Events"; groupOrder = 20; order = 40;
    desktop.ojuny.dms.settings.osdBrightnessEnabled = true;

    # @option widget = "switch"; label = "Idle inhibitor"; group = "Events"; groupOrder = 20; order = 50;
    desktop.ojuny.dms.settings.osdIdleInhibitorEnabled = true;

    # @option widget = "switch"; label = "Microphone mute"; group = "Events"; groupOrder = 20; order = 60;
    desktop.ojuny.dms.settings.osdMicMuteEnabled = true;

    # @option widget = "switch"; label = "Microphone volume"; group = "Events"; groupOrder = 20; order = 70;
    desktop.ojuny.dms.settings.osdMicVolumeEnabled = true;

    # @option widget = "switch"; label = "Caps lock"; group = "Events"; groupOrder = 20; order = 80;
    desktop.ojuny.dms.settings.osdCapsLockEnabled = true;

    # @option widget = "switch"; label = "Touchpad"; group = "Events"; groupOrder = 20; order = 90; description = "Niri only.";
    desktop.ojuny.dms.settings.osdTouchpadEnabled = true;

    # @option widget = "switch"; label = "Power profile"; group = "Events"; groupOrder = 20; order = 100;
    desktop.ojuny.dms.settings.osdPowerProfileEnabled = false;

    # @option widget = "switch"; label = "Audio output switch"; group = "Events"; groupOrder = 20; order = 110;
    desktop.ojuny.dms.settings.osdAudioOutputEnabled = true;

    # @option widget = "switch"; label = "Workspace switch"; group = "Events"; groupOrder = 20; order = 120;
    desktop.ojuny.dms.settings.osdWorkspaceEnabled = false;

  };

}
