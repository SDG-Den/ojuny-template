/*
  @menu
  displayname = "Clipboard";
  icon = "edit-paste-symbolic";
  order = 80;
  description = "Clipboard history settings";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-clipboard = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Keep history"; group = "Clipboard"; groupOrder = 20; order = 10;
    desktop.ojuny.dms.clipboardSettings.disableHistory = false;

    # @option widget = "switch"; label = "Persist across reboots"; group = "Clipboard"; groupOrder = 20; order = 20; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.disablePersist = false;

    # @option widget = "switch"; label = "Clear at startup"; group = "Clipboard"; groupOrder = 20; order = 30; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.clearAtStartup = true;

    # @option widget = "spin"; label = "Auto clear after"; group = "Clipboard"; groupOrder = 20; order = 40; min = 0; unit = "days"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.autoClearDays = 1;

    # @option widget = "spin"; label = "History size"; group = "Clipboard"; groupOrder = 20; order = 50; min = 1; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.maxHistory = 25;

    # @option widget = "spin"; label = "Max entry size"; group = "Clipboard"; groupOrder = 20; order = 60; min = 0; step = 1024; unit = "bytes"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.maxEntrySize = 5242880;

    # @option widget = "switch"; label = "Click to paste"; group = "Behavior"; groupOrder = 30; order = 10; description = "Clicking an entry pastes it immediately.";
    desktop.ojuny.dms.settings.clipboardClickToPaste = false;

    # @option widget = "switch"; label = "Enter to paste"; group = "Behavior"; groupOrder = 30; order = 20;
    desktop.ojuny.dms.settings.clipboardEnterToPaste = false;

    # @option widget = "dropdown"; label = "Size"; group = "Appearance"; groupOrder = 40; order = 10; choices = [ "micro" "compact" "medium" "large" ];
    desktop.ojuny.dms.settings.clipboardSize = "compact";

    # @option widget = "switch"; label = "Remember type filter"; group = "Advanced"; groupOrder = 50; order = 10; advanced = true; description = "Keep the type filter chosen in the clipboard between opens."; applyCommand = "dms ipc call settings set clipboardRememberTypeFilter %%val%%";
    desktop.ojuny.dms.settings.clipboardRememberTypeFilter = false;

    # @option widget = "switch"; label = "Use overlay layer"; group = "Advanced"; groupOrder = 50; order = 20; advanced = true; applyCommand = "dms ipc call settings set clipboardUseOverlayLayer %%val%%";
    desktop.ojuny.dms.settings.clipboardUseOverlayLayer = false;

    # @option widget = "list"; label = "Visible entry actions"; group = "Advanced"; groupOrder = 50; order = 30; advanced = true; description = "Action buttons shown on each entry: copy, paste, pin, edit, delete.";
    desktop.ojuny.dms.settings.clipboardVisibleEntryActions = [ "pin" "edit" "delete" ];

    # @option widget = "dropdown"; label = "Type filter"; group = "Advanced"; groupOrder = 50; order = 40; choices = [ "all" "text" "long_text" "image" ]; advanced = true; visibleWhen.path = "desktop.ojuny.dms.settings.clipboardRememberTypeFilter"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set clipboardTypeFilter %%val%%";
    desktop.ojuny.dms.settings.clipboardTypeFilter = "all";

  };

}
