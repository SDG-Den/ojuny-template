/*
  @menu
  displayname = "Window management";
  icon = "preferences-system-windows-symbolic";
  order = 20;
  description = "Layouts, focus, tiling and workspaces";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-mangosettings =
    { config, lib, ... }:

    let
      # mango stores booleans as the integers 0 and 1, so these are exposed as
      # switches under ojuny.mango.* and written back as 0/1 in the derived
      # assignments at the bottom of this module.
      flagDefaults = {
        new_is_master = true;
        center_master_overspread = true;
        center_when_single_stack = true;
        dwindle_smart_split = false;
        dwindle_preserve_split = true;
        dwindle_smart_resize = false;
        dwindle_drop_simple_split = false;
        dwindle_manual_split = false;
        focus_on_activate = false;
        sloppy_focus = true;
        warp_cursor = true;
        allow_lock_transparent = true;
        focus_cross_monitor = true;
        focus_cross_tag = false;
        focus_direction_only_zone_overlap = true;
        exchange_cross_monitor = true;
        view_current_to_back = true;
        enable_floating_snap = true;
        float_full_to_top = false;
        enable_border_resize = true;
        idle_inhibit_ignore_visible = false;
        idle_inhibit_when_fullscreen = false;
        tag_gather = true;
        tag_carousel = false;
        scratchpad_cross_monitor = true;
        single_scratchpad = false;
        enable_hotarea = false;
        hotarea_disable_on_fullscreen = true;
      };

      # mango mode integers, exposed as named choices under ojuny.mango.enum and
      # mapped back to their integers in the derived assignments below.
      enumSpecs = {
        dwindle_horizontal_split = {
          default = "right";
          choices = {
            "follow-cursor" = 0;
            "right" = 1;
            "left" = 2;
          };
        };
        dwindle_vertical_split = {
          default = "below";
          choices = {
            "follow-cursor" = 0;
            "below" = 1;
            "above" = 2;
          };
        };
        hotarea_corner = {
          default = "bottom-left";
          choices = {
            "top-left" = 0;
            "top-right" = 1;
            "bottom-left" = 2;
            "bottom-right" = 3;
          };
        };
      };
    in
    {

      options.ojuny.mango.flag = lib.mapAttrs (
        name: default:
        lib.mkOption {
          type = lib.types.bool;
          inherit default;
          description = "mango global ${name}, stored as 0/1.";
        }
      ) flagDefaults;

      options.ojuny.mango.enum = lib.mapAttrs (
        name: spec:
        lib.mkOption {
          type = lib.types.enum (lib.attrNames spec.choices);
          default = spec.default;
          description = "mango global ${name}.";
        }
      ) enumSpecs;

      config = {

        # Master/stack layout
        # @option widget = "switch"; label = "New window becomes master"; group = "Master layout";
        ojuny.mango.flag.new_is_master = true;

        # @option widget = "slider"; label = "Master factor"; group = "Master layout"; min = 0.1; max = 1.0; step = 0.05;
        desktop.ojuny.mango.global.default_master_factor = 0.65;

        # @option widget = "spin"; label = "Master count"; group = "Master layout"; min = 1; max = 8;
        desktop.ojuny.mango.global.default_master_count = 1;

        # @option widget = "switch"; label = "Master spreads when no stack"; group = "Master layout"; hidden = true;
        ojuny.mango.flag.center_master_overspread = true;

        # @option widget = "switch"; label = "Center master with single stack window"; group = "Master layout"; hidden = true;
        ojuny.mango.flag.center_when_single_stack = true;

        # Scroller layout moved to its own page (02b-scroller.nix).

        # Dwindle layout
        # @option widget = "slider"; label = "Split ratio"; group = "Dwindle layout"; min = 0.05; max = 0.95; step = 0.05; advanced = true;
        desktop.ojuny.mango.global.dwindle_split_ratio = 0.5;

        # @option widget = "switch"; label = "Split axis from cursor"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_smart_split = false;

        # @option widget = "dropdown"; label = "Horizontal split position"; group = "Dwindle layout"; choices = [ "follow-cursor" "right" "left" ]; hidden = true;
        ojuny.mango.enum.dwindle_horizontal_split = "right";

        # @option widget = "dropdown"; label = "Vertical split position"; group = "Dwindle layout"; choices = [ "follow-cursor" "below" "above" ]; hidden = true;
        ojuny.mango.enum.dwindle_vertical_split = "below";

        # @option widget = "switch"; label = "Preserve sibling split on close"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_preserve_split = true;

        # @option widget = "switch"; label = "Smart resize toward cursor"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_smart_resize = false;

        # @option widget = "switch"; label = "Two-zone drop preview"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_drop_simple_split = false;

        # @option widget = "switch"; label = "Manual split mode"; group = "Dwindle layout"; hidden = true;
        ojuny.mango.flag.dwindle_manual_split = false;

        # Focus
        # @option widget = "switch"; label = "Focus on activate"; group = "Focus";
        ojuny.mango.flag.focus_on_activate = false;

        # @option widget = "switch"; label = "Sloppy focus (follow cursor)"; group = "Focus";
        ojuny.mango.flag.sloppy_focus = true;

        # @option widget = "switch"; label = "Warp cursor on keyboard focus"; group = "Focus";
        ojuny.mango.flag.warp_cursor = true;

        # @option widget = "switch"; label = "Allow transparency over lock screen"; group = "Focus"; hidden = true;
        ojuny.mango.flag.allow_lock_transparent = true;

        # @option widget = "switch"; label = "Focus across monitors"; group = "Focus";
        ojuny.mango.flag.focus_cross_monitor = true;

        # @option widget = "switch"; label = "Exchange across monitors"; group = "Focus";
        ojuny.mango.flag.exchange_cross_monitor = true;

        # @option widget = "switch"; label = "Toggle returns to previous tag"; group = "Focus";
        ojuny.mango.flag.view_current_to_back = true;


        # @option widget = "switch"; label = "Focus across tags"; group = "Focus"; hidden = true;
        ojuny.mango.flag.focus_cross_tag = false;

        # @option widget = "switch"; label = "Directional focus requires overlap"; group = "Focus"; hidden = true;
        ojuny.mango.flag.focus_direction_only_zone_overlap = true;

        # Windows
        # @option widget = "switch"; label = "Snap floating windows"; group = "Windows";
        ojuny.mango.flag.enable_floating_snap = true;

        # @option widget = "spin"; label = "Snap distance"; group = "Windows"; min = 0; max = 200; unit = "px";
        desktop.ojuny.mango.global.snap_distance = 30;

        # @option widget = "switch"; label = "Resize by dragging border"; group = "Windows";
        ojuny.mango.flag.enable_border_resize = true;

        # @option widget = "switch"; label = "Share fullscreen and floating top layer"; group = "Windows"; hidden = true;
        ojuny.mango.flag.float_full_to_top = false;

        # @option widget = "spin"; label = "Border grab strip"; group = "Windows"; min = 0; max = 64; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.border_resize_size = 10;

        # @option widget = "switch"; label = "Idle inhibit for invisible clients"; group = "Windows"; hidden = true;
        ojuny.mango.flag.idle_inhibit_ignore_visible = false;

        # @option widget = "switch"; label = "Idle inhibit while fullscreen"; group = "Windows"; hidden = true;
        ojuny.mango.flag.idle_inhibit_when_fullscreen = false;

        # Workspaces
        # @option widget = "spin"; label = "Tag count"; group = "Workspaces"; min = 1; max = 31;
        desktop.ojuny.mango.global.tag_num = 10;

        # @option widget = "switch"; label = "Gather occupied tags"; group = "Workspaces";
        ojuny.mango.flag.tag_gather = true;

        # @option widget = "switch"; label = "Share scratchpad across monitors"; group = "Workspaces";
        ojuny.mango.flag.scratchpad_cross_monitor = true;

        # @option widget = "switch"; label = "Tag carousel"; group = "Workspaces"; hidden = true;
        ojuny.mango.flag.tag_carousel = false;

        # @option widget = "switch"; label = "Single scratchpad at a time"; group = "Workspaces"; hidden = true;
        ojuny.mango.flag.single_scratchpad = false;

        # Special workspace (tag 0)
        # @option widget = "slider"; label = "Background dim"; group = "Special workspace"; min = 0.0; max = 1.0; step = 0.05;
        desktop.ojuny.mango.global.special_dim = 0.5;

        # @option widget = "spin"; label = "Inner gap (horizontal)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.special_gap_inner_horizontal = 5;

        # @option widget = "spin"; label = "Inner gap (vertical)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.special_gap_inner_vertical = 5;

        # @option widget = "spin"; label = "Outer gap (horizontal)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.special_gap_outer_horizontal = 30;

        # @option widget = "spin"; label = "Outer gap (vertical)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.special_gap_outer_vertical = 30;

        # Overview
        # @option widget = "switch"; label = "Enable hot corner"; group = "Overview";
        ojuny.mango.flag.enable_hotarea = false;

        # @option widget = "dropdown"; label = "Hot corner"; group = "Overview"; choices = [ "top-left" "top-right" "bottom-left" "bottom-right" ];
        ojuny.mango.enum.hotarea_corner = "bottom-left";

        # @option widget = "switch"; label = "Disable hot corner when fullscreen"; group = "Overview"; hidden = true;
        ojuny.mango.flag.hotarea_disable_on_fullscreen = true;

        # @option widget = "spin"; label = "Hot corner size"; group = "Overview"; min = 0; max = 100; unit = "px"; hidden = true;
        desktop.ojuny.mango.global.hotarea_size = 0;

        # @option widget = "spin"; label = "Inner gap"; group = "Overview"; min = 0; max = 200; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.overview_gap_inner = 5;

        # @option widget = "spin"; label = "Outer gap"; group = "Overview"; min = 0; max = 200; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.overview_gap_outer = 30;

        # @option widget = "slider"; label = "Overcircle center ratio"; group = "Overview"; min = 0.1; max = 0.9; step = 0.05; advanced = true;
        desktop.ojuny.mango.global.overcircle_center_ratio = 0.5;

        # @option widget = "text"; label = "Jump label characters"; group = "Overview"; advanced = true;
        desktop.ojuny.mango.global.jump_labels = "HJKLASDFGQWERTYUIOPZXCVBNM";

        # Rules (structured tables, edited in Nix)
        # @option widget = "raw"; label = "Window rules"; group = "Rules"; rows = 8; readonly = true; advanced = true; description = "mango window_rule tables.";
        desktop.ojuny.mango.rules.window_rule = [
          {
            app_id = "foot";
            focused_opacity = 0.7;
            unfocused_opacity = 0.7;
          }
          {
            title = "Floating-Menu";
            is_floating = 1;
            height = 0.6;
            width = 0.6;
          }
        ];

        # @option widget = "raw"; label = "Tag rules"; group = "Rules"; rows = 4; readonly = true; advanced = true; description = "mango tag_rule tables.";
        desktop.ojuny.mango.rules.tag_rule = [
          {
            id = 0;
            layout_name = "dwindle";
          }
        ];

        # @option widget = "raw"; label = "Layer rules"; group = "Rules"; rows = 4; readonly = true; advanced = true; description = "mango layer_rule tables.";
        desktop.ojuny.mango.rules.layer_rule = [ ];

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.new_is_master = if config.ojuny.mango.flag.new_is_master then 1 else 0;
        desktop.ojuny.mango.global.center_master_overspread =
          if config.ojuny.mango.flag.center_master_overspread then 1 else 0;
        desktop.ojuny.mango.global.center_when_single_stack =
          if config.ojuny.mango.flag.center_when_single_stack then 1 else 0;
        desktop.ojuny.mango.global.dwindle_smart_split =
          if config.ojuny.mango.flag.dwindle_smart_split then 1 else 0;
        desktop.ojuny.mango.global.dwindle_preserve_split =
          if config.ojuny.mango.flag.dwindle_preserve_split then 1 else 0;
        desktop.ojuny.mango.global.dwindle_smart_resize =
          if config.ojuny.mango.flag.dwindle_smart_resize then 1 else 0;
        desktop.ojuny.mango.global.dwindle_drop_simple_split =
          if config.ojuny.mango.flag.dwindle_drop_simple_split then 1 else 0;
        desktop.ojuny.mango.global.dwindle_manual_split =
          if config.ojuny.mango.flag.dwindle_manual_split then 1 else 0;
        desktop.ojuny.mango.global.focus_on_activate =
          if config.ojuny.mango.flag.focus_on_activate then 1 else 0;
        desktop.ojuny.mango.global.sloppy_focus = if config.ojuny.mango.flag.sloppy_focus then 1 else 0;
        desktop.ojuny.mango.global.warp_cursor = if config.ojuny.mango.flag.warp_cursor then 1 else 0;
        desktop.ojuny.mango.global.allow_lock_transparent =
          if config.ojuny.mango.flag.allow_lock_transparent then 1 else 0;
        desktop.ojuny.mango.global.focus_cross_monitor =
          if config.ojuny.mango.flag.focus_cross_monitor then 1 else 0;
        desktop.ojuny.mango.global.focus_cross_tag =
          if config.ojuny.mango.flag.focus_cross_tag then 1 else 0;
        desktop.ojuny.mango.global.focus_direction_only_zone_overlap =
          if config.ojuny.mango.flag.focus_direction_only_zone_overlap then 1 else 0;
        desktop.ojuny.mango.global.exchange_cross_monitor =
          if config.ojuny.mango.flag.exchange_cross_monitor then 1 else 0;
        desktop.ojuny.mango.global.view_current_to_back =
          if config.ojuny.mango.flag.view_current_to_back then 1 else 0;
        desktop.ojuny.mango.global.enable_floating_snap =
          if config.ojuny.mango.flag.enable_floating_snap then 1 else 0;
        desktop.ojuny.mango.global.float_full_to_top =
          if config.ojuny.mango.flag.float_full_to_top then 1 else 0;
        desktop.ojuny.mango.global.enable_border_resize =
          if config.ojuny.mango.flag.enable_border_resize then 1 else 0;
        desktop.ojuny.mango.global.idle_inhibit_ignore_visible =
          if config.ojuny.mango.flag.idle_inhibit_ignore_visible then 1 else 0;
        desktop.ojuny.mango.global.idle_inhibit_when_fullscreen =
          if config.ojuny.mango.flag.idle_inhibit_when_fullscreen then 1 else 0;
        desktop.ojuny.mango.global.tag_gather = if config.ojuny.mango.flag.tag_gather then 1 else 0;
        desktop.ojuny.mango.global.tag_carousel = if config.ojuny.mango.flag.tag_carousel then 1 else 0;
        desktop.ojuny.mango.global.scratchpad_cross_monitor =
          if config.ojuny.mango.flag.scratchpad_cross_monitor then 1 else 0;
        desktop.ojuny.mango.global.single_scratchpad =
          if config.ojuny.mango.flag.single_scratchpad then 1 else 0;
        desktop.ojuny.mango.global.enable_hotarea = if config.ojuny.mango.flag.enable_hotarea then 1 else 0;
        desktop.ojuny.mango.global.hotarea_disable_on_fullscreen =
          if config.ojuny.mango.flag.hotarea_disable_on_fullscreen then 1 else 0;

        desktop.ojuny.mango.global.dwindle_horizontal_split =
          enumSpecs.dwindle_horizontal_split.choices.${config.ojuny.mango.enum.dwindle_horizontal_split};
        desktop.ojuny.mango.global.dwindle_vertical_split =
          enumSpecs.dwindle_vertical_split.choices.${config.ojuny.mango.enum.dwindle_vertical_split};
        desktop.ojuny.mango.global.hotarea_corner =
          enumSpecs.hotarea_corner.choices.${config.ojuny.mango.enum.hotarea_corner};
      };
    };

}
