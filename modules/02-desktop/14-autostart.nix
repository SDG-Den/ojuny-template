/* @menu
   displayname = "Startup";
   icon = "system-run-symbolic";
   order = 140;
   description = "Commands run at login and on reload";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-autostart = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    /* @option widget = "list"; label = "Run once at login"; group = "Commands"; description = "Started once when the session starts."; */
    desktop.ojuny.mango.execOnce = [
      "dms run"
      "wl-clip-persist --clipboard both"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];

    /* @option widget = "list"; label = "Run on every reload"; group = "Commands"; */
    desktop.ojuny.mango.exec = [ ];

    /* @option widget = "list"; label = "Extra config files"; group = "Commands"; */
    desktop.ojuny.mango.source = [ ];

    /* @option widget = "text"; label = "Session desktop"; group = "Environment"; */
    desktop.ojuny.mango.env.XDG_SESSION_DESKTOP = "wlroots";

    /* @option widget = "text"; label = "Current desktop"; group = "Environment"; */
    desktop.ojuny.mango.env.XDG_CURRENT_DESKTOP = "wlroots";

    /* @option widget = "text"; label = "Qt platform"; group = "Environment"; */
    desktop.ojuny.mango.env.QT_QPA_PLATFORM = "wayland;xcb";

    /* @option widget = "text"; label = "Firefox Wayland"; group = "Environment"; */
    desktop.ojuny.mango.env.MOZ_ENABLE_WAYLAND = "1";

    /* @option widget = "text"; label = "Ozone platform"; group = "Environment"; */
    desktop.ojuny.mango.env.OZONE_PLATFORM = "wayland";

    /* @option widget = "text"; label = "Electron Wayland"; group = "Environment"; */
    desktop.ojuny.mango.env.NIXOS_OZONE_WL = "1";

  };

}
