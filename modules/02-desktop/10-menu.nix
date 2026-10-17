/*
  @menu
  displayname = "Ojuny menu";
  icon = "open-menu-symbolic";
  order = 60;
  description = "Nix managed application menu";
  category = "04-GUI";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-menu = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Manage menu with Nix"; group = "Menu"; groupOrder = 10; order = 10;
    desktop.ojuny.dankMenu.enable = true;

    # @option widget = "raw"; label = "Extra plugin settings"; group = "Menu"; rows = 6; groupOrder = 20; order = 20;
    desktop.ojuny.dankMenu.settings = { };

    # @option widget = "menu"; label = "Menu tree"; group = "Menu"; groupOrder = 30; order = 30;
    desktop.ojuny.dankMenu.menu = {
      "apps" = { icon = "apps"; label = "Apps"; aliases = [ "app" "applications" ]; provider = "apps"; };
      "learn" = { icon = "school"; label = "Learn"; };
      "trigger" = { icon = "bolt"; label = "Utils"; };
      "setup" = { icon = "settings"; label = "Settings"; aliases = [ "settings" ]; };
      "system" = { icon = "power_settings_new"; label = "System"; aliases = [ "power-menu" ]; };

      "learn.keybinds" = { icon = "keyboard"; label = "Keybinds"; aliases = [ "keys" "bindings" ]; action = "dms ipc call keybinds open binds"; };
      "learn.nixos" = { icon = "menu_book"; label = "NixOS Manual"; target = "https://nixos.org/manual/nixos/stable/"; };
      "learn.home-manager" = { icon = "home"; label = "Home Manager Options"; target = "https://nix-community.github.io/home-manager/options.xhtml"; };
      "learn.packages" = { icon = "search"; label = "Search Packages"; target = "https://search.nixos.org/packages"; };
      "learn.options" = { icon = "search"; label = "Search options"; target = "https://search.nixos.org/options"; };

      "trigger.capture" = { icon = "screenshot_region"; label = "Capture"; aliases = [ "screenshot" "screenrecord" ]; action = "dms ipc call screenCaptureToolbar toggle"; };
      "trigger.clipboard" = { icon = "content_paste"; label = "Clipboard"; aliases = [ "clip" ]; action = "dms ipc call clipboard toggle"; };
      "trigger.notepad" = { icon = "edit_note"; label = "Notepad"; aliases = [ "notes" ]; action = "dms ipc call notepad toggle"; };
      "trigger.websearch" = { icon = "search"; label = "Web Search"; aliases = [ "google" "search" ]; action = "dms ipc call spotlight toggleQuery '@ '"; };
      "trigger.toggle" = { icon = "toggle_on"; label = "Toggle"; aliases = [ "toggle" "toggles" ]; };
      "trigger.toggle.idle" = { icon = "coffee"; label = "Stay Awake"; aliases = [ "caffeine" "inhibit" ]; checked = "dms ipc call inhibit status | grep -q enabled"; action = "dms ipc call inhibit toggle"; };
      "trigger.toggle.night" = { icon = "nightlight"; label = "Night Mode"; aliases = [ "nightlight" ]; checked = "dms ipc call night status | grep -q enabled"; action = "dms ipc call night toggle"; };
      "trigger.toggle.battery" = { icon = "battery_std"; label = "Battery Percentage"; when = "test -d /sys/class/power_supply/BAT0"; action = "dms ipc call bar toggle"; };
      "trigger.toggle.float" = { icon = "screenshot_region"; label = "Float Window"; aliases = [ "float" "hover" ]; action = "sleep 0.5 && mmsg dispatch togglefloating"; };
      "trigger.toggle.maximize" = { icon = "screenshot_region"; label = "Maximize Window"; action = "sleep 0.5 && mmsg dispatch togglemaximizescreen"; };
      "trigger.toggle.floatall" = { icon = "screenshot_region"; label = "Float All Windows"; aliases = [ "floatall" "hoverall" ]; action = "sleep 0.5 && mmsg dispatch toggle_all_floating"; };
      "trigger.toggle.fullscreen" = { icon = "screenshot_region"; label = "Fullscreen Window"; aliases = [ "full screen" ]; action = "sleep 0.5 && mmsg dispatch togglefullscreen"; };
      "trigger.toggle.minimize" = { icon = "screenshot_region"; label = "Minimize Window"; aliases = [ "scratchpad" "hide" ]; action = "sleep 0.5 && mmsg dispatch minimized"; };
      "trigger.toggle.recover" = { icon = "screenshot_region"; label = "Restore Minimized Window"; aliases = [ "restore" "recover" ]; action = "sleep 0.5 && mmsg dispatch restore_minimized"; };

      "setup.network" = { icon = "wifi"; label = "Network"; aliases = [ "wifi" "wlan" ]; action = "dms ipc call settings focusOrToggleWith network"; };
      "setup.control-center" = { icon = "tune"; label = "Control Center"; aliases = [ "audio" "bluetooth" ]; action = "dms ipc call control-center toggle"; };
      "setup.rebuild" = { icon = "restart_alt"; label = "Rebuild System"; action = "ghostty --title='Floating-Menu' -e zsh -c 'echo \"Initializing Update\"; source /etc/zshrc; sudo echo \"nixupdate source is $nixupdatesrc\"; $nixupdatesrc; echo \"press enter to exit\"; read -n 1'"; };
      "setup.update" = { icon = "restart_alt"; label = "Update and Rebuild System"; action = "ghostty --title='Floating-Menu' -e zsh -c 'echo \"Initializing Update\"; source /etc/zshrc; sudo echo \"pulling git update\"; git -C $HOME/repos/ojuny-template pull; echo \"nixupdate source is $nixupdatesrc\"; $nixupdatesrc; echo \"press enter to exit\"; read -n 1'"; };

      "system.lock" = { icon = "lock"; label = "Lock"; action = "loginctl lock-session"; };
      "system.suspend" = { icon = "bedtime"; label = "Suspend"; action = "systemctl suspend"; };
      "system.logout" = { icon = "logout"; label = "Logout"; action = "loginctl terminate-session \"$XDG_SESSION_ID\""; };
      "system.reboot" = { icon = "restart_alt"; label = "Reboot"; action = "systemctl reboot"; };
      "system.shutdown" = { icon = "power_settings_new"; label = "Shutdown"; action = "systemctl poweroff"; };
    };

  };

}
