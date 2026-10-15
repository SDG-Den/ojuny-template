/* @menu
   displayname = "Display";
   icon = "preferences-system-displays-symbolic";
   order = 30;
   description = "Monitors and input layout";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-display = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    /* @option widget = "list"; label = "Monitor rules"; group = "Monitors"; description = "One entry per output in mango's rule format, e.g. \"name:DP-1,width:1920,height:1080,refresh:60,x:0,y:0\". Empty means mango auto-detects."; */
    desktop.ojuny.mango.rules.monitor_rule = [ ];

    /* @option widget = "text"; label = "Keyboard layout"; group = "Keyboard"; description = "xkb layout, e.g. us, de, gb."; */
    desktop.ojuny.mango.global.xkb_rules_layout = "us";

  };

}
