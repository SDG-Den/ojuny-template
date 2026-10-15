/* @menu
   displayname = "Window manager";
   icon = "preferences-desktop-keyboard-shortcuts-symbolic";
   order = 20;
   description = "mango window manager behaviour";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-mangosettings = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    # Flags below are mango integers: 0 is off, 1 is on.

    /* @option widget = "spin"; label = "Border width"; group = "Appearance"; min = 0; max = 20; unit = "px"; */
    desktop.ojuny.mango.global.border_px = 3;

    /* @option widget = "spin"; label = "Corner radius"; group = "Appearance"; min = 0; max = 40; unit = "px"; */
    desktop.ojuny.mango.global.border_radius = 12;

    /* @option widget = "spin"; label = "Blur (0/1)"; group = "Appearance"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.blur = 1;

    /* @option widget = "spin"; label = "Shadows (0/1)"; group = "Appearance"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.shadows = 0;

    /* @option widget = "slider"; label = "Focused opacity"; group = "Appearance"; min = 0.0; max = 1.0; step = 0.05; */
    desktop.ojuny.mango.global.focused_opacity = 1.0;

    /* @option widget = "slider"; label = "Unfocused opacity"; group = "Appearance"; min = 0.0; max = 1.0; step = 0.05; */
    desktop.ojuny.mango.global.unfocused_opacity = 1.0;

    /* @option widget = "spin"; label = "Inner gaps (horizontal)"; group = "Gaps"; min = 0; max = 64; unit = "px"; */
    desktop.ojuny.mango.global.gap_inner_horizontal = 4;

    /* @option widget = "spin"; label = "Inner gaps (vertical)"; group = "Gaps"; min = 0; max = 64; unit = "px"; */
    desktop.ojuny.mango.global.gap_inner_vertical = 4;

    /* @option widget = "spin"; label = "Outer gaps (horizontal)"; group = "Gaps"; min = 0; max = 64; unit = "px"; */
    desktop.ojuny.mango.global.gap_outer_horizontal = 4;

    /* @option widget = "spin"; label = "Outer gaps (vertical)"; group = "Gaps"; min = 0; max = 64; unit = "px"; */
    desktop.ojuny.mango.global.gap_outer_vertical = 4;

    /* @option widget = "spin"; label = "Smart gaps (0/1)"; group = "Gaps"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.smart_gaps = 0;

    /* @option widget = "spin"; label = "Animations (0/1)"; group = "Animations"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.animations = 1;

    /* @option widget = "spin"; label = "Layer animations (0/1)"; group = "Animations"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.layer_animations = 0;

    /* @option widget = "spin"; label = "Open duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; */
    desktop.ojuny.mango.global.animation_duration_open = 400;

    /* @option widget = "spin"; label = "Close duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; */
    desktop.ojuny.mango.global.animation_duration_close = 300;

    /* @option widget = "spin"; label = "Move duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; */
    desktop.ojuny.mango.global.animation_duration_move = 500;

    /* @option widget = "spin"; label = "Tag switch duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; */
    desktop.ojuny.mango.global.animation_duration_tag = 300;

    /* @option widget = "spin"; label = "Focus duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; */
    desktop.ojuny.mango.global.animation_duration_focus = 200;

    /* @option widget = "spin"; label = "New window becomes master (0/1)"; group = "Layout"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.new_is_master = 1;

    /* @option widget = "slider"; label = "Master factor"; group = "Layout"; min = 0.1; max = 1.0; step = 0.05; */
    desktop.ojuny.mango.global.default_master_factor = 0.65;

    /* @option widget = "spin"; label = "Master count"; group = "Layout"; min = 1; max = 8; */
    desktop.ojuny.mango.global.default_master_count = 1;

    /* @option widget = "slider"; label = "Dwindle split ratio"; group = "Layout"; min = 0.1; max = 1.0; step = 0.05; */
    desktop.ojuny.mango.global.dwindle_split_ratio = 0.5;

    /* @option widget = "spin"; label = "Dwindle smart split (0/1)"; group = "Layout"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.dwindle_smart_split = 0;

    /* @option widget = "spin"; label = "Repeat rate"; group = "Input"; min = 1; max = 200; unit = "Hz"; */
    desktop.ojuny.mango.global.repeat_rate = 25;

    /* @option widget = "spin"; label = "Repeat delay"; group = "Input"; min = 100; max = 2000; step = 50; unit = "ms"; */
    desktop.ojuny.mango.global.repeat_delay = 600;

    /* @option widget = "spin"; label = "Numlock on start (0/1)"; group = "Input"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.numlock_on = 1;

    /* @option widget = "spin"; label = "Sloppy focus (0/1)"; group = "Focus"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.sloppy_focus = 1;

    /* @option widget = "spin"; label = "Focus on activate (0/1)"; group = "Focus"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.focus_on_activate = 0;

    /* @option widget = "spin"; label = "Warp cursor (0/1)"; group = "Focus"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.warp_cursor = 1;

    /* @option widget = "spin"; label = "Floating snap (0/1)"; group = "Windows"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.enable_floating_snap = 1;

    /* @option widget = "spin"; label = "Snap distance"; group = "Windows"; min = 0; max = 100; unit = "px"; */
    desktop.ojuny.mango.global.snap_distance = 30;

    /* @option widget = "spin"; label = "Tag count"; group = "Workspaces"; min = 1; max = 32; */
    desktop.ojuny.mango.global.tag_num = 10;

    /* @option widget = "spin"; label = "Gather tags (0/1)"; group = "Workspaces"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.tag_gather = 1;

    /* @option widget = "spin"; label = "Focus across monitors (0/1)"; group = "Workspaces"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.focus_cross_monitor = 1;

    /* @option widget = "spin"; label = "Exchange across monitors (0/1)"; group = "Workspaces"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.exchange_cross_monitor = 1;

    /* @option widget = "spin"; label = "Single scratchpad (0/1)"; group = "Workspaces"; min = 0; max = 1; step = 1; */
    desktop.ojuny.mango.global.single_scratchpad = 0;

    /* @option widget = "slider"; label = "Special tag dim"; group = "Workspaces"; min = 0.0; max = 1.0; step = 0.05; */
    desktop.ojuny.mango.global.special_dim = 0.5;

  };

}
