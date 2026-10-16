/*
  @menu
  displayname = "Menu";
  icon = "open-menu-symbolic";
  order = 100;
  description = "Nix managed application menu";
  category = "Desktop";
*/

/*
  @snippet
  name = "menu-row";
  label = "Add menu row";
  snippet = ''
    # @option widget = "text"; label = "Icon"; group = "Custom rows";
    desktop.ojuny.dankMenu.menu."%%id%%".icon = "%%icon%%";
    # @option widget = "text"; label = "Label"; group = "Custom rows";
    desktop.ojuny.dankMenu.menu."%%id%%".label = "%%label%%";
    # @option widget = "list"; label = "Aliases"; group = "Custom rows";
    desktop.ojuny.dankMenu.menu."%%id%%".aliases = [ ];
    # @option widget = "text"; label = "Provider"; group = "Custom rows"; nullable = true;
    desktop.ojuny.dankMenu.menu."%%id%%".provider = null;
    # @option widget = "text"; label = "Target"; group = "Custom rows"; nullable = true;
    desktop.ojuny.dankMenu.menu."%%id%%".target = null;
    # @option widget = "text"; label = "Action"; group = "Custom rows"; nullable = true;
    desktop.ojuny.dankMenu.menu."%%id%%".action = null;
  '';
  placeholders.id.label = "Row id";
  placeholders.id.default = "learn.keybinds";
  placeholders.label.label = "Label";
  placeholders.label.default = "Keybinds";
  placeholders.icon.label = "Icon";
  placeholders.icon.default = "keyboard";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-menu = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Manage menu with Nix"; group = "Menu"; description = "Installs the dankMenu plugin and manages its menu from this flake.";
    desktop.ojuny.dankMenu.enable = true;

    # @option widget = "raw"; label = "Extra plugin settings"; group = "Menu"; rows = 6; description = "Additional dankMenu plugin settings merged into plugin_settings.json.";
    desktop.ojuny.dankMenu.settings = { };

    # Root rows. A non-empty tree overrides the plugin's bundled menu.

    # @option widget = "text"; label = "Icon"; group = "Apps";
    desktop.ojuny.dankMenu.menu."apps".icon = "apps";

    # @option widget = "text"; label = "Label"; group = "Apps";
    desktop.ojuny.dankMenu.menu."apps".label = "Apps";

    # @option widget = "list"; label = "Aliases"; group = "Apps";
    desktop.ojuny.dankMenu.menu."apps".aliases = [ "app" "applications" ];

    # @option widget = "text"; label = "Provider"; group = "Apps"; nullable = true;
    desktop.ojuny.dankMenu.menu."apps".provider = "apps";

    # @option widget = "text"; label = "Icon"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn".icon = "school";

    # @option widget = "text"; label = "Label"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn".label = "Learn";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger".icon = "bolt";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger".label = "Utils";

    # @option widget = "text"; label = "Icon"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup".icon = "settings";

    # @option widget = "text"; label = "Label"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup".label = "Settings";

    # @option widget = "list"; label = "Aliases"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup".aliases = [ "settings" ];

    # @option widget = "text"; label = "Icon"; group = "System";
    desktop.ojuny.dankMenu.menu."system".icon = "power_settings_new";

    # @option widget = "text"; label = "Label"; group = "System";
    desktop.ojuny.dankMenu.menu."system".label = "System";

    # @option widget = "list"; label = "Aliases"; group = "System";
    desktop.ojuny.dankMenu.menu."system".aliases = [ "power-menu" ];

    # Learn rows
    # @option widget = "text"; label = "Icon"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.keybinds".icon = "keyboard";

    # @option widget = "text"; label = "Label"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.keybinds".label = "Keybinds";

    # @option widget = "list"; label = "Aliases"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.keybinds".aliases = [ "keys" "bindings" ];

    # @option widget = "text"; label = "Action"; group = "Learn"; nullable = true;
    desktop.ojuny.dankMenu.menu."learn.keybinds".action = "dms ipc call keybinds open binds";

    # @option widget = "text"; label = "Icon"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.nixos".icon = "menu_book";

    # @option widget = "text"; label = "Label"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.nixos".label = "NixOS Manual";

    # @option widget = "text"; label = "Target"; group = "Learn"; nullable = true;
    desktop.ojuny.dankMenu.menu."learn.nixos".target = "https://nixos.org/manual/nixos/stable/";

    # @option widget = "text"; label = "Icon"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.home-manager".icon = "home";

    # @option widget = "text"; label = "Label"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.home-manager".label = "Home Manager Options";

    # @option widget = "text"; label = "Target"; group = "Learn"; nullable = true;
    desktop.ojuny.dankMenu.menu."learn.home-manager".target = "https://nix-community.github.io/home-manager/options.xhtml";

    # @option widget = "text"; label = "Icon"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.packages".icon = "search";

    # @option widget = "text"; label = "Label"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.packages".label = "Search Packages";

    # @option widget = "text"; label = "Target"; group = "Learn"; nullable = true;
    desktop.ojuny.dankMenu.menu."learn.packages".target = "https://search.nixos.org/packages";

    # @option widget = "text"; label = "Icon"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.options".icon = "search";

    # @option widget = "text"; label = "Label"; group = "Learn";
    desktop.ojuny.dankMenu.menu."learn.options".label = "Search options";

    # @option widget = "text"; label = "Target"; group = "Learn"; nullable = true;
    desktop.ojuny.dankMenu.menu."learn.options".target = "https://search.nixos.org/options";

    # Utils rows
    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.capture".icon = "screenshot_region";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.capture".label = "Capture";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.capture".aliases = [ "screenshot" "screenrecord" ];

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.capture".action = "dms ipc call screenCaptureToolbar toggle";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.clipboard".icon = "content_paste";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.clipboard".label = "Clipboard";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.clipboard".aliases = [ "clip" ];

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.clipboard".action = "dms ipc call clipboard toggle";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.notepad".icon = "edit_note";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.notepad".label = "Notepad";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.notepad".aliases = [ "notes" ];

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.notepad".action = "dms ipc call notepad toggle";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.websearch".icon = "search";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.websearch".label = "Web Search";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.websearch".aliases = [ "google" "search" ];

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.websearch".action = "dms ipc call spotlight toggleQuery '@ '";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle".icon = "toggle_on";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle".label = "Toggle";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle".aliases = [ "toggle" "toggles" ];

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.idle".icon = "coffee";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.idle".label = "Stay Awake";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.idle".aliases = [ "caffeine" "inhibit" ];

    # @option widget = "text"; label = "Checked"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.idle".checked = "dms ipc call inhibit status | grep -q enabled";

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.idle".action = "dms ipc call inhibit toggle";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.night".icon = "nightlight";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.night".label = "Night Mode";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.night".aliases = [ "nightlight" ];

    # @option widget = "text"; label = "Checked"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.night".checked = "dms ipc call night status | grep -q enabled";

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.night".action = "dms ipc call night toggle";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.battery".icon = "battery_std";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.battery".label = "Battery Percentage";

    # @option widget = "text"; label = "When"; group = "Utils"; nullable = true; description = "Shell condition that hides the row, e.g. a laptop-only check.";
    desktop.ojuny.dankMenu.menu."trigger.toggle.battery".when = "test -d /sys/class/power_supply/BAT0";

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.battery".action = "dms ipc call bar toggle";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.float".icon = "screenshot_region";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.float".label = "Float Window";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.float".aliases = [ "float" "hover" ];

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.float".action = "sleep 0.5 && mmsg dispatch togglefloating";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.maximize".icon = "screenshot_region";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.maximize".label = "Maximize Window";

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.maximize".action = "sleep 0.5 && mmsg dispatch togglemaximizescreen";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.floatall".icon = "screenshot_region";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.floatall".label = "Float All Windows";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.floatall".aliases = [ "floatall" "hoverall" ];

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.floatall".action = "sleep 0.5 && mmsg dispatch toggle_all_floating";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.fullscreen".icon = "screenshot_region";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.fullscreen".label = "Fullscreen Window";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.fullscreen".aliases = [ "full screen" ];

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.fullscreen".action = "sleep 0.5 && mmsg dispatch togglefullscreen";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.minimize".icon = "screenshot_region";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.minimize".label = "Minimize Window";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.minimize".aliases = [ "scratchpad" "hide" ];

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.minimize".action = "sleep 0.5 && mmsg dispatch minimized";

    # @option widget = "text"; label = "Icon"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.recover".icon = "screenshot_region";

    # @option widget = "text"; label = "Label"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.recover".label = "Restore Minimized Window";

    # @option widget = "list"; label = "Aliases"; group = "Utils";
    desktop.ojuny.dankMenu.menu."trigger.toggle.recover".aliases = [ "restore" "recover" ];

    # @option widget = "text"; label = "Action"; group = "Utils"; nullable = true;
    desktop.ojuny.dankMenu.menu."trigger.toggle.recover".action = "sleep 0.5 && mmsg dispatch restore_minimized";

    # Setup rows
    # @option widget = "text"; label = "Icon"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.network".icon = "wifi";

    # @option widget = "text"; label = "Label"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.network".label = "Network";

    # @option widget = "list"; label = "Aliases"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.network".aliases = [ "wifi" "wlan" ];

    # @option widget = "text"; label = "Action"; group = "Setup"; nullable = true;
    desktop.ojuny.dankMenu.menu."setup.network".action = "dms ipc call settings focusOrToggleWith network";

    # @option widget = "text"; label = "Icon"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.control-center".icon = "tune";

    # @option widget = "text"; label = "Label"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.control-center".label = "Control Center";

    # @option widget = "list"; label = "Aliases"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.control-center".aliases = [ "audio" "bluetooth" ];

    # @option widget = "text"; label = "Action"; group = "Setup"; nullable = true;
    desktop.ojuny.dankMenu.menu."setup.control-center".action = "dms ipc call control-center toggle";

    # @option widget = "text"; label = "Icon"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.rebuild".icon = "restart_alt";

    # @option widget = "text"; label = "Label"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.rebuild".label = "Rebuild System";

    # @option widget = "text"; label = "Action"; group = "Setup"; nullable = true; description = "Edit this to match how your machine rebuilds, e.g. with --flake .#hostname.";
    desktop.ojuny.dankMenu.menu."setup.rebuild".action = "ghostty --title='Floating-Menu' -e zsh -c 'echo \"Initializing Update\"; source /etc/zshrc; sudo echo \"nixupdate source is $nixupdatesrc\"; $nixupdatesrc; echo \"press enter to exit\"; read -n 1'";

    # @option widget = "text"; label = "Icon"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.update".icon = "restart_alt";

    # @option widget = "text"; label = "Label"; group = "Setup";
    desktop.ojuny.dankMenu.menu."setup.update".label = "Update and Rebuild System";

    # @option widget = "text"; label = "Action"; group = "Setup"; nullable = true; description = "Edit this to match how your machine updates, e.g. pull the config repo first.";
    desktop.ojuny.dankMenu.menu."setup.update".action = "ghostty --title='Floating-Menu' -e zsh -c 'echo \"Initializing Update\"; source /etc/zshrc; sudo echo \"pulling git update\"; git -C $HOME/repos/ojuny-template pull; echo \"nixupdate source is $nixupdatesrc\"; $nixupdatesrc; echo \"press enter to exit\"; read -n 1'";

    # System rows
    # @option widget = "text"; label = "Icon"; group = "System";
    desktop.ojuny.dankMenu.menu."system.lock".icon = "lock";

    # @option widget = "text"; label = "Label"; group = "System";
    desktop.ojuny.dankMenu.menu."system.lock".label = "Lock";

    # @option widget = "text"; label = "Action"; group = "System"; nullable = true;
    desktop.ojuny.dankMenu.menu."system.lock".action = "loginctl lock-session";

    # @option widget = "text"; label = "Icon"; group = "System";
    desktop.ojuny.dankMenu.menu."system.suspend".icon = "bedtime";

    # @option widget = "text"; label = "Label"; group = "System";
    desktop.ojuny.dankMenu.menu."system.suspend".label = "Suspend";

    # @option widget = "text"; label = "Action"; group = "System"; nullable = true;
    desktop.ojuny.dankMenu.menu."system.suspend".action = "systemctl suspend";

    # @option widget = "text"; label = "Icon"; group = "System";
    desktop.ojuny.dankMenu.menu."system.logout".icon = "logout";

    # @option widget = "text"; label = "Label"; group = "System";
    desktop.ojuny.dankMenu.menu."system.logout".label = "Logout";

    # @option widget = "text"; label = "Action"; group = "System"; nullable = true;
    desktop.ojuny.dankMenu.menu."system.logout".action = "loginctl terminate-session \"$XDG_SESSION_ID\"";

    # @option widget = "text"; label = "Icon"; group = "System";
    desktop.ojuny.dankMenu.menu."system.reboot".icon = "restart_alt";

    # @option widget = "text"; label = "Label"; group = "System";
    desktop.ojuny.dankMenu.menu."system.reboot".label = "Reboot";

    # @option widget = "text"; label = "Action"; group = "System"; nullable = true;
    desktop.ojuny.dankMenu.menu."system.reboot".action = "systemctl reboot";

    # @option widget = "text"; label = "Icon"; group = "System";
    desktop.ojuny.dankMenu.menu."system.shutdown".icon = "power_settings_new";

    # @option widget = "text"; label = "Label"; group = "System";
    desktop.ojuny.dankMenu.menu."system.shutdown".label = "Shutdown";

    # @option widget = "text"; label = "Action"; group = "System"; nullable = true;
    desktop.ojuny.dankMenu.menu."system.shutdown".action = "systemctl poweroff";

    /*
      @insert
      name = "menu-row";
      group = "Custom rows";
      order = 1000;
    */

  };

}
