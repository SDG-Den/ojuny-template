/*
  @menu
  displayname = "Input";
  icon = "input-keyboard-symbolic";
  order = 35;
  description = "Keyboard, mouse, trackpad and touch";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-input =
    { config, lib, ... }:

    let
      # mango stores these as 0/1 integers; see the derived assignments at the end.
      flagDefaults = {
        numlock_on = true;
        mouse_natural_scrolling = false;
        mouse_left_handed = false;
        mouse_middle_button_emulation = false;
        disable_trackpad = false;
        tap_to_click = true;
        tap_and_drag = true;
        drag_lock = true;
        trackpad_natural_scrolling = true;
        trackpad_disable_while_typing = true;
        trackpad_left_handed = false;
        trackpad_middle_button_emulation = false;
        touch_enable = true;
        touch_enable_mouse_emulation = true;
        cursor_hide_on_keypress = false;
        drag_tile_to_tile = true;
        drag_tile_small = true;
        drag_warp_cursor = true;
      };

      # mango mode integers, exposed as named choices and mapped back below.
      enumSpecs = {
        mouse_accel_profile = {
          default = "flat";
          choices = {
            "none" = 0;
            "flat" = 1;
            "adaptive" = 2;
          };
        };
        mouse_scroll_method = {
          default = "two-finger";
          choices = {
            "never" = 0;
            "two-finger" = 1;
            "edge" = 2;
            "button" = 4;
          };
        };
        mouse_click_method = {
          default = "button-areas";
          choices = {
            "none" = 0;
            "button-areas" = 1;
            "clickfinger" = 2;
          };
        };
        mouse_send_events_mode = {
          default = "enabled";
          choices = {
            "enabled" = 0;
            "disabled" = 1;
            "disabled-with-external-mouse" = 2;
          };
        };
        trackpad_accel_profile = {
          default = "adaptive";
          choices = {
            "none" = 0;
            "flat" = 1;
            "adaptive" = 2;
          };
        };
        trackpad_scroll_method = {
          default = "two-finger";
          choices = {
            "never" = 0;
            "two-finger" = 1;
            "edge" = 2;
            "button" = 4;
          };
        };
        trackpad_click_method = {
          default = "button-areas";
          choices = {
            "none" = 0;
            "button-areas" = 1;
            "clickfinger" = 2;
          };
        };
        trackpad_send_events_mode = {
          default = "enabled";
          choices = {
            "enabled" = 0;
            "disabled" = 1;
            "disabled-with-external-mouse" = 2;
          };
        };
        button_map = {
          default = "left-middle-right";
          choices = {
            "left-right-middle" = 0;
            "left-middle-right" = 1;
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

        # Keyboard
        # @option widget = "spin"; label = "Repeat rate"; group = "Keyboard"; min = 1; max = 200; unit = "Hz";
        desktop.ojuny.mango.global.repeat_rate = 25;

        # @option widget = "spin"; label = "Repeat delay"; group = "Keyboard"; min = 100; max = 2000; step = 50; unit = "ms";
        desktop.ojuny.mango.global.repeat_delay = 600;

        # @option widget = "switch"; label = "Num lock on start"; group = "Keyboard";
        ojuny.mango.flag.numlock_on = true;

        # @option widget = "text"; label = "Layout"; group = "Keyboard"; description = "xkb layout codes, comma separated, e.g. us,de.";
        desktop.ojuny.mango.global.xkb_rules_layout = "us";

        # @option widget = "text"; label = "Variant"; group = "Keyboard"; hidden = true;
        desktop.ojuny.mango.global.xkb_rules_variant = "";

        # @option widget = "text"; label = "Options"; group = "Keyboard"; hidden = true; description = "xkb options, comma separated, e.g. caps:escape.";
        desktop.ojuny.mango.global.xkb_rules_options = "";

        # @option widget = "text"; label = "Model"; group = "Keyboard"; hidden = true;
        desktop.ojuny.mango.global.xkb_rules_model = "";

        # @option widget = "text"; label = "Rules file"; group = "Keyboard"; hidden = true; description = "Usually auto-detected.";
        desktop.ojuny.mango.global.xkb_rules_rules = "";

        # Mouse
        # @option widget = "switch"; label = "Natural scrolling"; group = "Mouse";
        ojuny.mango.flag.mouse_natural_scrolling = false;

        # @option widget = "dropdown"; label = "Acceleration profile"; group = "Mouse"; choices = [ "none" "flat" "adaptive" ];
        ojuny.mango.enum.mouse_accel_profile = "flat";

        # @option widget = "spin"; label = "Acceleration speed"; group = "Mouse"; min = -1.0; max = 1.0; step = 0.05; advanced = true;
        desktop.ojuny.mango.global.mouse_accel_speed = 0.0;

        # @option widget = "switch"; label = "Left handed"; group = "Mouse";
        ojuny.mango.flag.mouse_left_handed = false;

        # @option widget = "switch"; label = "Middle button emulation"; group = "Mouse"; hidden = true;
        ojuny.mango.flag.mouse_middle_button_emulation = false;

        # @option widget = "dropdown"; label = "Scroll method"; group = "Mouse"; choices = [ "never" "two-finger" "edge" "button" ];
        ojuny.mango.enum.mouse_scroll_method = "two-finger";

        # @option widget = "spin"; label = "Scroll button"; group = "Mouse"; min = 272; max = 279; advanced = true;
        desktop.ojuny.mango.global.mouse_scroll_button = 274;

        # @option widget = "dropdown"; label = "Click method"; group = "Mouse"; choices = [ "none" "button-areas" "clickfinger" ]; hidden = true;
        ojuny.mango.enum.mouse_click_method = "button-areas";

        # @option widget = "dropdown"; label = "Send events"; group = "Mouse"; choices = [ "enabled" "disabled" "disabled-with-external-mouse" ]; hidden = true;
        ojuny.mango.enum.mouse_send_events_mode = "enabled";

        # @option widget = "spin"; label = "Axis scroll factor"; group = "Mouse"; min = 0.1; max = 10.0; step = 0.1; advanced = true;
        desktop.ojuny.mango.global.axis_scroll_factor = 1.0;

        # @option widget = "spin"; label = "Axis bind apply timeout"; group = "Mouse"; min = 0; max = 1000; step = 10; unit = "ms"; advanced = true;
        desktop.ojuny.mango.global.axis_bind_apply_timeout = 100;

        # Trackpad
        # @option widget = "switch"; label = "Disable trackpad"; group = "Trackpad";
        ojuny.mango.flag.disable_trackpad = false;

        # @option widget = "switch"; label = "Tap to click"; group = "Trackpad";
        ojuny.mango.flag.tap_to_click = true;

        # @option widget = "switch"; label = "Tap and drag"; group = "Trackpad";
        ojuny.mango.flag.tap_and_drag = true;

        # @option widget = "switch"; label = "Drag lock"; group = "Trackpad"; hidden = true;
        ojuny.mango.flag.drag_lock = true;

        # @option widget = "switch"; label = "Natural scrolling"; group = "Trackpad";
        ojuny.mango.flag.trackpad_natural_scrolling = true;

        # @option widget = "dropdown"; label = "Acceleration profile"; group = "Trackpad"; choices = [ "none" "flat" "adaptive" ];
        ojuny.mango.enum.trackpad_accel_profile = "adaptive";

        # @option widget = "spin"; label = "Acceleration speed"; group = "Trackpad"; min = -1.0; max = 1.0; step = 0.05; advanced = true;
        desktop.ojuny.mango.global.trackpad_accel_speed = 0.0;

        # @option widget = "dropdown"; label = "Scroll method"; group = "Trackpad"; choices = [ "never" "two-finger" "edge" "button" ];
        ojuny.mango.enum.trackpad_scroll_method = "two-finger";

        # @option widget = "spin"; label = "Scroll button"; group = "Trackpad"; min = 272; max = 279; advanced = true;
        desktop.ojuny.mango.global.trackpad_scroll_button = 274;

        # @option widget = "dropdown"; label = "Click method"; group = "Trackpad"; choices = [ "none" "button-areas" "clickfinger" ]; hidden = true;
        ojuny.mango.enum.trackpad_click_method = "button-areas";

        # @option widget = "dropdown"; label = "Send events"; group = "Trackpad"; choices = [ "enabled" "disabled" "disabled-with-external-mouse" ]; hidden = true;
        ojuny.mango.enum.trackpad_send_events_mode = "enabled";

        # @option widget = "switch"; label = "Disable while typing"; group = "Trackpad";
        ojuny.mango.flag.trackpad_disable_while_typing = true;

        # @option widget = "switch"; label = "Left handed"; group = "Trackpad";
        ojuny.mango.flag.trackpad_left_handed = false;

        # @option widget = "switch"; label = "Middle button emulation"; group = "Trackpad"; hidden = true;
        ojuny.mango.flag.trackpad_middle_button_emulation = false;

        # @option widget = "dropdown"; label = "Button map"; group = "Trackpad"; choices = [ "left-right-middle" "left-middle-right" ]; hidden = true;
        ojuny.mango.enum.button_map = "left-middle-right";

        # @option widget = "spin"; label = "Scroll factor"; group = "Trackpad"; min = 0.1; max = 10.0; step = 0.1; advanced = true;
        desktop.ojuny.mango.global.trackpad_scroll_factor = 1.0;

        # Cursor
        # @option widget = "spin"; label = "Hide cursor after"; group = "Cursor"; min = 0; max = 300; unit = "s";
        desktop.ojuny.mango.global.cursor_hide_timeout = 30;

        # @option widget = "switch"; label = "Hide cursor on keypress"; group = "Cursor"; hidden = true;
        ojuny.mango.flag.cursor_hide_on_keypress = false;

        # Dragging
        # @option widget = "switch"; label = "Drag tiled window onto another to swap"; group = "Dragging";
        ojuny.mango.flag.drag_tile_to_tile = true;

        # @option widget = "switch"; label = "Allow small drag preview"; group = "Dragging"; hidden = true;
        ojuny.mango.flag.drag_tile_small = true;

        # @option widget = "spin"; label = "Drag-to-tile corner"; group = "Dragging"; min = 0; max = 4; description = "0 none, 1-3 corner, 4 auto-detect."; advanced = true;
        desktop.ojuny.mango.global.drag_corner = 0;

        # @option widget = "switch"; label = "Warp cursor while dragging"; group = "Dragging"; hidden = true;
        ojuny.mango.flag.drag_warp_cursor = true;

        # Swipe gesture tuning lives on the Gestures page (17-gestures.nix).

        # Touch
        # @option widget = "switch"; label = "Enable touchscreen"; group = "Touch";
        ojuny.mango.flag.touch_enable = true;

        # @option widget = "switch"; label = "Mouse emulation for touch"; group = "Touch"; hidden = true;
        ojuny.mango.flag.touch_enable_mouse_emulation = true;

        # Device rules (structured tables, edited in Nix)
        # @option widget = "raw"; label = "Device rules"; group = "Devices"; rows = 4; readonly = true; advanced = true; description = "mango device_rule tables, e.g. { name = \"...\"; tap_to_click = 1; }.";
        desktop.ojuny.mango.rules.device_rule = [ ];

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.numlock_on = if config.ojuny.mango.flag.numlock_on then 1 else 0;
        desktop.ojuny.mango.global.mouse_natural_scrolling =
          if config.ojuny.mango.flag.mouse_natural_scrolling then 1 else 0;
        desktop.ojuny.mango.global.mouse_left_handed =
          if config.ojuny.mango.flag.mouse_left_handed then 1 else 0;
        desktop.ojuny.mango.global.mouse_middle_button_emulation =
          if config.ojuny.mango.flag.mouse_middle_button_emulation then 1 else 0;
        desktop.ojuny.mango.global.disable_trackpad =
          if config.ojuny.mango.flag.disable_trackpad then 1 else 0;
        desktop.ojuny.mango.global.tap_to_click = if config.ojuny.mango.flag.tap_to_click then 1 else 0;
        desktop.ojuny.mango.global.tap_and_drag = if config.ojuny.mango.flag.tap_and_drag then 1 else 0;
        desktop.ojuny.mango.global.drag_lock = if config.ojuny.mango.flag.drag_lock then 1 else 0;
        desktop.ojuny.mango.global.trackpad_natural_scrolling =
          if config.ojuny.mango.flag.trackpad_natural_scrolling then 1 else 0;
        desktop.ojuny.mango.global.trackpad_disable_while_typing =
          if config.ojuny.mango.flag.trackpad_disable_while_typing then 1 else 0;
        desktop.ojuny.mango.global.trackpad_left_handed =
          if config.ojuny.mango.flag.trackpad_left_handed then 1 else 0;
        desktop.ojuny.mango.global.trackpad_middle_button_emulation =
          if config.ojuny.mango.flag.trackpad_middle_button_emulation then 1 else 0;
        desktop.ojuny.mango.global.touch_enable = if config.ojuny.mango.flag.touch_enable then 1 else 0;
        desktop.ojuny.mango.global.touch_enable_mouse_emulation =
          if config.ojuny.mango.flag.touch_enable_mouse_emulation then 1 else 0;
        desktop.ojuny.mango.global.cursor_hide_on_keypress =
          if config.ojuny.mango.flag.cursor_hide_on_keypress then 1 else 0;
        desktop.ojuny.mango.global.drag_tile_to_tile =
          if config.ojuny.mango.flag.drag_tile_to_tile then 1 else 0;
        desktop.ojuny.mango.global.drag_tile_small =
          if config.ojuny.mango.flag.drag_tile_small then 1 else 0;
        desktop.ojuny.mango.global.drag_warp_cursor =
          if config.ojuny.mango.flag.drag_warp_cursor then 1 else 0;

        desktop.ojuny.mango.global.mouse_accel_profile =
          enumSpecs.mouse_accel_profile.choices.${config.ojuny.mango.enum.mouse_accel_profile};
        desktop.ojuny.mango.global.mouse_scroll_method =
          enumSpecs.mouse_scroll_method.choices.${config.ojuny.mango.enum.mouse_scroll_method};
        desktop.ojuny.mango.global.mouse_click_method =
          enumSpecs.mouse_click_method.choices.${config.ojuny.mango.enum.mouse_click_method};
        desktop.ojuny.mango.global.mouse_send_events_mode =
          enumSpecs.mouse_send_events_mode.choices.${config.ojuny.mango.enum.mouse_send_events_mode};
        desktop.ojuny.mango.global.trackpad_accel_profile =
          enumSpecs.trackpad_accel_profile.choices.${config.ojuny.mango.enum.trackpad_accel_profile};
        desktop.ojuny.mango.global.trackpad_scroll_method =
          enumSpecs.trackpad_scroll_method.choices.${config.ojuny.mango.enum.trackpad_scroll_method};
        desktop.ojuny.mango.global.trackpad_click_method =
          enumSpecs.trackpad_click_method.choices.${config.ojuny.mango.enum.trackpad_click_method};
        desktop.ojuny.mango.global.trackpad_send_events_mode =
          enumSpecs.trackpad_send_events_mode.choices.${config.ojuny.mango.enum.trackpad_send_events_mode};
        desktop.ojuny.mango.global.button_map =
          enumSpecs.button_map.choices.${config.ojuny.mango.enum.button_map};
      };
    };

}
