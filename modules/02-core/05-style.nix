/*
  @menu
  displayname = "Style";
  icon = "applications-graphics-symbolic";
  order = 50;
  description = "Theme, colors, fonts, gaps and effects";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-style =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      # mango appearance flags (0/1) exposed as switches.
      flagDefaults = {
        blur = true;
        blur_layer = false;
        blur_optimized = false;
        shadows = false;
        dim_enable = false;
        no_border_when_single = false;
        no_radius_when_single = false;
        smart_gaps = false;
        animations = true;
        layer_animations = false;
        animation_fade_in = true;
        animation_fade_out = true;
        always_show_group_bar = false;
        group_bar_close_button_enable = true;
        monocle_tab_mode = false;
        deck_tab_mode = false;
      };

      # mango appearance strings and mode integers exposed as named choices.
      enumSpecs = {
        animation_type_open = {
          default = "zoom";
          choices = {
            "slide" = "slide";
            "zoom" = "zoom";
            "fade" = "fade";
            "none" = "none";
          };
        };
        animation_type_close = {
          default = "zoom";
          choices = {
            "slide" = "slide";
            "zoom" = "zoom";
            "fade" = "fade";
            "none" = "none";
          };
        };
        layer_animation_type_open = {
          default = "zoom";
          choices = {
            "slide" = "slide";
            "zoom" = "zoom";
            "fade" = "fade";
            "none" = "none";
          };
        };
        layer_animation_type_close = {
          default = "zoom";
          choices = {
            "slide" = "slide";
            "zoom" = "zoom";
            "fade" = "fade";
            "none" = "none";
          };
        };
        tag_animation_direction = {
          default = "vertical";
          choices = {
            "vertical" = 0;
            "horizontal" = 1;
          };
        };
      };
    in
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      options.ojuny.style = {
        customGaps = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use per-edge gaps instead of the single unified gap size.";
        };
        gaps = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Unified gap size used for every edge unless customGaps is on.";
        };
        gapInnerHorizontal = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Inner horizontal gap.";
        };
        gapInnerVertical = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Inner vertical gap.";
        };
        gapOuterHorizontal = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Outer horizontal gap.";
        };
        gapOuterVertical = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Outer vertical gap.";
        };
        customBorders = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use per-surface border thickness instead of the single unified thickness.";
        };
        borderThickness = lib.mkOption {
          type = lib.types.int;
          default = 3;
          description = "Unified border thickness used by mango, the bar and the dock unless customBorders is on.";
        };
        mangoBorderThickness = lib.mkOption {
          type = lib.types.int;
          default = 3;
          description = "mango window border thickness.";
        };
        barBorderThickness = lib.mkOption {
          type = lib.types.int;
          default = 1;
          description = "Bar border thickness.";
        };
        dockBorderThickness = lib.mkOption {
          type = lib.types.int;
          default = 1;
          description = "Dock border thickness.";
        };
        palette = lib.mkOption {
          type = lib.types.str;
          default = "everforest-dark-hard";
          description = "base16 scheme name from pkgs.base16-schemes, without the .yaml suffix.";
        };
        wallpaper = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Wallpaper image. When null, the auto-generated stylix wallpaper is used.";
        };
      };

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
      # Theme
      # @option widget = "switch"; label = "Theme mango from stylix"; group = "Theme"; advanced = true; groupOrder = 10; order = 10;
      desktop.ojuny.stylix.enable = true;

      # @option widget = "switch"; label = "Stylix"; group = "Theme"; advanced = true; groupOrder = 10; order = 20;
      stylix.enable = true;

      # @option widget = "dropdown"; label = "Polarity"; group = "Theme"; choices = [ "dark" "light" ]; groupOrder = 10; order = 30;
      stylix.polarity = "dark";

      # @option widget = "theme"; label = "Color palette"; group = "Theme"; description = "A base16 scheme."; groupOrder = 10; order = 40;
      ojuny.style.palette = "everforest-dark-hard";

      # Derived from the palette name; no @option so a GUI edit cannot lose the store path.
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.ojuny.style.palette}.yaml";

      # @option widget = "path"; label = "Wallpaper"; group = "Theme"; nullable = true; groupOrder = 10; order = 50;
      ojuny.style.wallpaper = null;

      # Derived from the wallpaper option; when null, ojuny's stylix default applies.
      stylix.image = lib.mkIf (config.ojuny.style.wallpaper != null) config.ojuny.style.wallpaper;

      # Fonts
      # @option widget = "text"; label = "Monospace font"; group = "Fonts"; groupOrder = 20; order = 10;
      stylix.fonts.monospace.name = "CaskaydiaCove Nerd Font";

      # @option widget = "package"; label = "Monospace package"; group = "Fonts"; hidden = true; groupOrder = 20; order = 20;
      stylix.fonts.monospace.package = pkgs.nerd-fonts.caskaydia-cove;

      # @option widget = "text"; label = "Sans-serif font"; group = "Fonts"; groupOrder = 20; order = 30;
      stylix.fonts.sansSerif.name = "CaskaydiaCove Nerd Font";

      # @option widget = "package"; label = "Sans-serif package"; group = "Fonts"; hidden = true; groupOrder = 20; order = 40;
      stylix.fonts.sansSerif.package = pkgs.nerd-fonts.caskaydia-cove;

      # @option widget = "text"; label = "Serif font"; group = "Fonts"; hidden = true; groupOrder = 20; order = 50;
      stylix.fonts.serif.name = "CaskaydiaCove Nerd Font";

      # @option widget = "package"; label = "Serif package"; group = "Fonts"; hidden = true; groupOrder = 20; order = 60;
      stylix.fonts.serif.package = pkgs.nerd-fonts.caskaydia-cove;

      # @option widget = "switch"; label = "Icon theme"; group = "Icons and cursor"; groupOrder = 30; order = 10;
      stylix.icons.enable = true;

      # @option widget = "text"; label = "Icon theme (dark)"; group = "Icons and cursor"; groupOrder = 30; order = 20;
      stylix.icons.dark = "Papirus-Dark";

      # @option widget = "text"; label = "Icon theme (light)"; group = "Icons and cursor"; groupOrder = 30; order = 30;
      stylix.icons.light = "Papirus-Light";

      # @option widget = "package"; label = "Icon theme package"; group = "Icons and cursor"; hidden = true; groupOrder = 30; order = 40;
      stylix.icons.package = pkgs.papirus-icon-theme;

      # @option widget = "text"; label = "Cursor theme"; group = "Icons and cursor"; groupOrder = 30; order = 50;
      stylix.cursor.name = "Bibata-Modern-Classic";

      # @option widget = "package"; label = "Cursor package"; group = "Icons and cursor"; hidden = true; groupOrder = 30; order = 60;
      stylix.cursor.package = pkgs.bibata-cursors;

      # @option widget = "spin"; label = "Cursor size"; group = "Icons and cursor"; min = 16; max = 64; groupOrder = 30; order = 70;
      stylix.cursor.size = 24;

      # Gaps
      # @option widget = "spin"; label = "Gap size"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = false; groupOrder = 40; order = 20;
      ojuny.style.gaps = 4;

      # @option widget = "switch"; label = "Set gaps per edge"; group = "Gaps"; groupOrder = 40; order = 10;
      ojuny.style.customGaps = false;

      # @option widget = "spin"; label = "Inner horizontal"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = true; groupOrder = 40; order = 30;
      ojuny.style.gapInnerHorizontal = 4;

      # @option widget = "spin"; label = "Inner vertical"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = true; groupOrder = 40; order = 40;
      ojuny.style.gapInnerVertical = 4;

      # @option widget = "spin"; label = "Outer horizontal"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = true; groupOrder = 40; order = 50;
      ojuny.style.gapOuterHorizontal = 4;

      # @option widget = "spin"; label = "Outer vertical"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = true; groupOrder = 40; order = 60;
      ojuny.style.gapOuterVertical = 4;

      # @option widget = "switch"; label = "Smart gaps (off for single window)"; group = "Gaps"; hidden = true; groupOrder = 40; order = 70;
      ojuny.mango.flag.smart_gaps = false;

      # Borders
      # @option widget = "spin"; label = "Border thickness"; group = "Borders"; min = 0; max = 20; unit = "px"; visibleWhen.path = "ojuny.style.customBorders"; visibleWhen.equals = false; groupOrder = 50; order = 20;
      ojuny.style.borderThickness = 3;

      # @option widget = "switch"; label = "Set border thickness per surface"; group = "Borders"; groupOrder = 50; order = 10;
      ojuny.style.customBorders = false;

      # @option widget = "spin"; label = "Window border"; group = "Borders"; min = 0; max = 20; unit = "px"; visibleWhen.path = "ojuny.style.customBorders"; visibleWhen.equals = true; groupOrder = 50; order = 30;
      ojuny.style.mangoBorderThickness = 3;

      # @option widget = "spin"; label = "Bar border"; group = "Borders"; min = 0; max = 20; unit = "px"; visibleWhen.path = "ojuny.style.customBorders"; visibleWhen.equals = true; groupOrder = 50; order = 40;
      ojuny.style.barBorderThickness = 1;

      # @option widget = "spin"; label = "Dock border"; group = "Borders"; min = 0; max = 20; unit = "px"; visibleWhen.path = "ojuny.style.customBorders"; visibleWhen.equals = true; groupOrder = 50; order = 50;
      ojuny.style.dockBorderThickness = 1;

      # @option widget = "switch"; label = "No border for single window"; group = "Borders"; hidden = true; groupOrder = 50; order = 60;
      ojuny.mango.flag.no_border_when_single = false;

      # Corners and opacity
      # @option widget = "spin"; label = "Corner radius"; group = "Corners and opacity"; min = 0; max = 40; unit = "px"; groupOrder = 60; order = 10;
      desktop.ojuny.mango.global.border_radius = 12;


      # @option widget = "switch"; label = "No radius for single window"; group = "Corners and opacity"; hidden = true; groupOrder = 60; order = 20;
      ojuny.mango.flag.no_radius_when_single = false;

      # @option widget = "slider"; label = "Focused opacity"; group = "Corners and opacity"; min = 0.0; max = 1.0; step = 0.05; groupOrder = 60; order = 30;
      desktop.ojuny.mango.global.focused_opacity = 1.0;

      # @option widget = "slider"; label = "Unfocused opacity"; group = "Corners and opacity"; min = 0.0; max = 1.0; step = 0.05; groupOrder = 60; order = 40;
      desktop.ojuny.mango.global.unfocused_opacity = 1.0;

      # Blur
      # @option widget = "switch"; label = "Blur windows"; group = "Blur"; groupOrder = 70; order = 10;
      ojuny.mango.flag.blur = true;

      # @option widget = "switch"; label = "Blur layer surfaces"; group = "Blur"; hidden = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 20;
      ojuny.mango.flag.blur_layer = false;

      # @option widget = "switch"; label = "Optimized blur"; group = "Blur"; hidden = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 30;
      ojuny.mango.flag.blur_optimized = false;

      # @option widget = "spin"; label = "Radius"; group = "Blur"; min = 0; max = 20; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 40;
      desktop.ojuny.mango.global.blur_params_radius = 4;

      # @option widget = "spin"; label = "Passes"; group = "Blur"; min = 1; max = 6; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 50;
      desktop.ojuny.mango.global.blur_params_num_passes = 2;

      # @option widget = "slider"; label = "Noise"; group = "Blur"; min = 0.0; max = 1.0; step = 0.01; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 60;
      desktop.ojuny.mango.global.blur_params_noise = 0.02;

      # @option widget = "slider"; label = "Brightness"; group = "Blur"; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 70;
      desktop.ojuny.mango.global.blur_params_brightness = 0.8;

      # @option widget = "slider"; label = "Contrast"; group = "Blur"; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 80;
      desktop.ojuny.mango.global.blur_params_contrast = 0.9;

      # @option widget = "slider"; label = "Saturation"; group = "Blur"; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 90;
      desktop.ojuny.mango.global.blur_params_saturation = 1.1;

      # Shadows
      # @option widget = "switch"; label = "Shadows"; group = "Shadows"; groupOrder = 80; order = 10;
      ojuny.mango.flag.shadows = false;

      # @option widget = "spin"; label = "Size"; group = "Shadows"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.mango.flag.shadows"; visibleWhen.equals = true; groupOrder = 80; order = 20;
      desktop.ojuny.mango.global.shadows_size = 10;

      # @option widget = "spin"; label = "Blur"; group = "Shadows"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.mango.flag.shadows"; visibleWhen.equals = true; groupOrder = 80; order = 30;
      desktop.ojuny.mango.global.shadows_blur = 15;

      # @option widget = "spin"; label = "X offset"; group = "Shadows"; min = -64; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.shadows"; visibleWhen.equals = true; groupOrder = 80; order = 40;
      desktop.ojuny.mango.global.shadows_position_x = 0;

      # @option widget = "spin"; label = "Y offset"; group = "Shadows"; min = -64; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.shadows"; visibleWhen.equals = true; groupOrder = 80; order = 50;
      desktop.ojuny.mango.global.shadows_position_y = 0;

      # Dim overlay
      # @option widget = "switch"; label = "Dim overlay"; group = "Dim"; hidden = true; groupOrder = 90; order = 10;
      ojuny.mango.flag.dim_enable = false;

      # Decoration
      # @option widget = "switch"; label = "Always show group bar"; group = "Decoration"; hidden = true; groupOrder = 100; order = 10;
      ojuny.mango.flag.always_show_group_bar = false;

      # @option widget = "switch"; label = "Group bar close button"; group = "Decoration"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 20;
      ojuny.mango.flag.group_bar_close_button_enable = true;

      # @option widget = "spin"; label = "Group bar height"; group = "Decoration"; min = 0; max = 100; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 30;
      desktop.ojuny.mango.global.group_bar_height = 30;

      # @option widget = "spin"; label = "Group bar button size"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 40;
      desktop.ojuny.mango.global.group_bar_button_size = 16;

      # @option widget = "spin"; label = "Group bar button margin"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 50;
      desktop.ojuny.mango.global.group_bar_button_margin = 4;

      # @option widget = "spin"; label = "Group bar border width"; group = "Decoration"; min = 0; max = 20; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 60;
      desktop.ojuny.mango.global.group_bar_decorate_border_width = 2;

      # @option widget = "spin"; label = "Group bar corner radius"; group = "Decoration"; min = 0; max = 40; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 70;
      desktop.ojuny.mango.global.group_bar_decorate_corner_radius = 10;

      # @option widget = "text"; label = "Group bar font"; group = "Decoration"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 80;
      desktop.ojuny.mango.global.group_bar_decorate_font_desc = "CaskaydiaCove Nerd Font Mono 14";

      # @option widget = "spin"; label = "Group bar padding (horizontal)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 90;
      desktop.ojuny.mango.global.group_bar_decorate_padding_x = 0;

      # @option widget = "spin"; label = "Group bar padding (vertical)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 100;
      desktop.ojuny.mango.global.group_bar_decorate_padding_y = 0;

      # @option widget = "switch"; label = "Monocle tab mode"; group = "Decoration"; hidden = true; groupOrder = 100; order = 110;
      ojuny.mango.flag.monocle_tab_mode = false;

      # @option widget = "switch"; label = "Deck tab mode"; group = "Decoration"; hidden = true; groupOrder = 100; order = 120;
      ojuny.mango.flag.deck_tab_mode = false;

      # @option widget = "spin"; label = "Tab bar height"; group = "Decoration"; min = 0; max = 100; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 130;
      desktop.ojuny.mango.global.tab_bar_height = 30;

      # @option widget = "spin"; label = "Tab bar border width"; group = "Decoration"; min = 0; max = 20; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 140;
      desktop.ojuny.mango.global.tab_bar_decorate_border_width = 2;

      # @option widget = "spin"; label = "Tab bar corner radius"; group = "Decoration"; min = 0; max = 40; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 150;
      desktop.ojuny.mango.global.tab_bar_decorate_corner_radius = 10;

      # @option widget = "text"; label = "Tab bar font"; group = "Decoration"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 160;
      desktop.ojuny.mango.global.tab_bar_decorate_font_desc = "CaskaydiaCove Nerd Font Mono 14";

      # @option widget = "spin"; label = "Tab bar padding (horizontal)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 170;
      desktop.ojuny.mango.global.tab_bar_decorate_padding_x = 0;

      # @option widget = "spin"; label = "Tab bar padding (vertical)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 180;
      desktop.ojuny.mango.global.tab_bar_decorate_padding_y = 0;

      # @option widget = "spin"; label = "Jump label border width"; group = "Decoration"; min = 0; max = 20; unit = "px"; hidden = true; groupOrder = 100; order = 190;
      desktop.ojuny.mango.global.jump_label_decorate_border_width = 2;

      # @option widget = "spin"; label = "Jump label corner radius"; group = "Decoration"; min = 0; max = 40; unit = "px"; hidden = true; groupOrder = 100; order = 200;
      desktop.ojuny.mango.global.jump_label_decorate_corner_radius = 5;

      # @option widget = "text"; label = "Jump label font"; group = "Decoration"; hidden = true; groupOrder = 100; order = 210;
      desktop.ojuny.mango.global.jump_label_decorate_font_desc = "CaskaydiaCove Nerd Font Mono 16";

      # @option widget = "spin"; label = "Jump label padding (horizontal)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; groupOrder = 100; order = 220;
      desktop.ojuny.mango.global.jump_label_decorate_padding_x = 10;

      # @option widget = "spin"; label = "Jump label padding (vertical)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; groupOrder = 100; order = 230;
      desktop.ojuny.mango.global.jump_label_decorate_padding_y = 10;

      # Animations
      # @option widget = "switch"; label = "Window animations"; group = "Animations"; groupOrder = 110; order = 10;
      ojuny.mango.flag.animations = true;

      # @option widget = "switch"; label = "Layer animations"; group = "Animations"; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 60;
      ojuny.mango.flag.layer_animations = false;

      # @option widget = "dropdown"; label = "Open animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 20;
      ojuny.mango.enum.animation_type_open = "zoom";

      # @option widget = "dropdown"; label = "Close animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 30;
      ojuny.mango.enum.animation_type_close = "zoom";

      # @option widget = "dropdown"; label = "Layer open animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.layer_animations"; visibleWhen.equals = true; groupOrder = 110; order = 70;
      ojuny.mango.enum.layer_animation_type_open = "zoom";

      # @option widget = "dropdown"; label = "Layer close animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.layer_animations"; visibleWhen.equals = true; groupOrder = 110; order = 80;
      ojuny.mango.enum.layer_animation_type_close = "zoom";

      # @option widget = "switch"; label = "Fade in"; group = "Animations"; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 40;
      ojuny.mango.flag.animation_fade_in = true;

      # @option widget = "switch"; label = "Fade out"; group = "Animations"; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 50;
      ojuny.mango.flag.animation_fade_out = true;

      # @option widget = "slider"; label = "Fade in start opacity"; group = "Animations"; min = 0.0; max = 1.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.animation_fade_in"; visibleWhen.equals = true; groupOrder = 110; order = 90;
      desktop.ojuny.mango.global.fade_in_begin_opacity = 0.5;

      # @option widget = "slider"; label = "Fade out start opacity"; group = "Animations"; min = 0.0; max = 1.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.animation_fade_out"; visibleWhen.equals = true; groupOrder = 110; order = 100;
      desktop.ojuny.mango.global.fade_out_begin_opacity = 0.5;

      # @option widget = "slider"; label = "Zoom start ratio"; group = "Animations"; min = 0.0; max = 1.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 110;
      desktop.ojuny.mango.global.zoom_initial_ratio = 0.4;

      # @option widget = "slider"; label = "Zoom end ratio"; group = "Animations"; min = 0.0; max = 1.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 120;
      desktop.ojuny.mango.global.zoom_end_ratio = 0.9;

      # @option widget = "spin"; label = "Move duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 130;
      desktop.ojuny.mango.global.animation_duration_move = 500;

      # @option widget = "spin"; label = "Open duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 140;
      desktop.ojuny.mango.global.animation_duration_open = 400;

      # @option widget = "spin"; label = "Tag switch duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 150;
      desktop.ojuny.mango.global.animation_duration_tag = 300;

      # @option widget = "spin"; label = "Close duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 160;
      desktop.ojuny.mango.global.animation_duration_close = 300;

      # @option widget = "spin"; label = "Focus duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 170;
      desktop.ojuny.mango.global.animation_duration_focus = 200;

      # @option widget = "dropdown"; label = "Tag animation direction"; group = "Animations"; choices = [ "vertical" "horizontal" ]; hidden = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 180;
      ojuny.mango.enum.tag_animation_direction = "vertical";

      # @option widget = "text"; label = "Open curve"; group = "Animation curves"; description = "Bezier x1,y1,x2,y2."; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 10;
      desktop.ojuny.mango.global.animation_curve_open = "0.46,1.0,0.29,0.99";

      # @option widget = "text"; label = "Move curve"; group = "Animation curves"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 20;
      desktop.ojuny.mango.global.animation_curve_move = "0.46,1.0,0.29,0.99";

      # @option widget = "text"; label = "Tag curve"; group = "Animation curves"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 30;
      desktop.ojuny.mango.global.animation_curve_tag = "0.46,1.0,0.29,0.99";

      # @option widget = "text"; label = "Close curve"; group = "Animation curves"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 40;
      desktop.ojuny.mango.global.animation_curve_close = "0.46,1.0,0.29,0.99";

      # @option widget = "text"; label = "Focus curve"; group = "Animation curves"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 50;
      desktop.ojuny.mango.global.animation_curve_focus = "0.46,1.0,0.29,0.99";

      # Desktop shell style
      # @option widget = "spin"; label = "Shell animation duration"; group = "Desktop shell"; min = 0; max = 2000; step = 10; unit = "ms"; groupOrder = 130; order = 10;
      desktop.ojuny.dms.settings.animationDuration = 350;

      # @option widget = "spin"; label = "Modal animation duration"; group = "Desktop shell"; min = 0; max = 2000; step = 10; unit = "ms"; hidden = true; groupOrder = 130; order = 20;
      desktop.ojuny.dms.settings.modalAnimationDuration = 231;

      # @option widget = "spin"; label = "Popout animation duration"; group = "Desktop shell"; min = 0; max = 2000; step = 10; unit = "ms"; hidden = true; groupOrder = 130; order = 30;
      desktop.ojuny.dms.settings.popoutAnimationDuration = 476;

      # @option widget = "spin"; label = "Motion effect"; group = "Desktop shell"; min = 0; max = 3; hidden = true; groupOrder = 130; order = 40;
      desktop.ojuny.dms.settings.motionEffect = 1;

      # @option widget = "switch"; label = "Sync component animation speeds"; group = "Desktop shell"; hidden = true; groupOrder = 130; order = 50;
      desktop.ojuny.dms.settings.syncComponentAnimationSpeeds = false;

      # @option widget = "text"; label = "System tray icon tint"; group = "Desktop shell"; description = "e.g. primary, secondary, none."; hidden = true; groupOrder = 130; order = 60;
      desktop.ojuny.dms.settings.systemTrayIconTintMode = "primary";

      # @option widget = "text"; label = "Widget background color"; group = "Desktop shell"; description = "A theme role name, e.g. sch for the scheme background."; hidden = true; groupOrder = 130; order = 70;
      desktop.ojuny.dms.settings.widgetBackgroundColor = "sch";

      # Motion
      # @option widget = "switch"; label = "Reduce motion"; group = "Motion"; groupOrder = 150; order = 10;
      desktop.ojuny.dms.settings.reduceMotion = false;

      # @option widget = "dropdown"; label = "Spring bounce"; group = "Motion"; groupOrder = 150; order = 20; choices = [ "0" "1" "2" ]; advanced = true; description = "0 = smooth, 1 = balanced, 2 = playful.";
      desktop.ojuny.dms.settings.springBounce = 1;

      # Surfaces
      # @option widget = "slider"; label = "Popup opacity"; group = "Surfaces"; groupOrder = 160; order = 10; min = 0.0; max = 1.0; step = 0.05; description = "Stored as a fraction, 1 = opaque (DMS shows 0-100%).";
      desktop.ojuny.dms.settings.popupTransparency = 1.0;

      # @option widget = "switch"; label = "Darken modal background"; group = "Surfaces"; groupOrder = 160; order = 20;
      desktop.ojuny.dms.settings.modalDarkenBackground = true;

      # @option widget = "dropdown"; label = "Card surface color"; group = "Surfaces"; groupOrder = 160; order = 30; choices = [ "default" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role; default = the card fallback (sc).";
      desktop.ojuny.dms.settings.cardSurfaceColor = "default";

      # @option widget = "dropdown"; label = "Chip surface color"; group = "Surfaces"; groupOrder = 160; order = 40; choices = [ "default" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role; default = the chip fallback (sch).";
      desktop.ojuny.dms.settings.chipSurfaceColor = "default";

      # @option widget = "dropdown"; label = "Host surface color"; group = "Surfaces"; groupOrder = 160; order = 50; choices = [ "default" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role; default = the host fallback (s).";
      desktop.ojuny.dms.settings.hostSurfaceColor = "default";

      # Color modes
      # @option widget = "dropdown"; label = "Widget text style"; group = "Color modes"; groupOrder = 170; order = 10; choices = [ "default" "colorful" ];
      desktop.ojuny.dms.settings.widgetColorMode = "default";

      # @option widget = "dropdown"; label = "Button color"; group = "Color modes"; groupOrder = 170; order = 20; choices = [ "primary" "primaryContainer" "secondary" "surfaceVariant" ]; description = "DMS resolves only these four; any other value renders as primary.";
      desktop.ojuny.dms.settings.buttonColorMode = "primary";

      # @option widget = "dropdown"; label = "Avatar ring"; group = "Color modes"; groupOrder = 170; order = 30; choices = [ "none" "outline" "primary" "secondary" "tertiary" ]; advanced = true;
      desktop.ojuny.dms.settings.avatarRing = "none";

      # Derived mango values (no @option, hidden in the GUI).
      desktop.ojuny.mango.global.blur = if config.ojuny.mango.flag.blur then 1 else 0;
      desktop.ojuny.mango.global.blur_layer = if config.ojuny.mango.flag.blur_layer then 1 else 0;
      desktop.ojuny.mango.global.blur_optimized = if config.ojuny.mango.flag.blur_optimized then 1 else 0;
      desktop.ojuny.mango.global.shadows = if config.ojuny.mango.flag.shadows then 1 else 0;
      desktop.ojuny.mango.global.dim_enable = if config.ojuny.mango.flag.dim_enable then 1 else 0;
      desktop.ojuny.mango.global.no_border_when_single =
        if config.ojuny.mango.flag.no_border_when_single then 1 else 0;
      desktop.ojuny.mango.global.no_radius_when_single =
        if config.ojuny.mango.flag.no_radius_when_single then 1 else 0;
      desktop.ojuny.mango.global.smart_gaps = if config.ojuny.mango.flag.smart_gaps then 1 else 0;
      desktop.ojuny.mango.global.animations = if config.ojuny.mango.flag.animations then 1 else 0;
      desktop.ojuny.mango.global.layer_animations =
        if config.ojuny.mango.flag.layer_animations then 1 else 0;
      desktop.ojuny.mango.global.animation_fade_in =
        if config.ojuny.mango.flag.animation_fade_in then 1 else 0;
      desktop.ojuny.mango.global.animation_fade_out =
        if config.ojuny.mango.flag.animation_fade_out then 1 else 0;
      desktop.ojuny.mango.global.always_show_group_bar =
        if config.ojuny.mango.flag.always_show_group_bar then 1 else 0;
      desktop.ojuny.mango.global.group_bar_close_button_enable =
        if config.ojuny.mango.flag.group_bar_close_button_enable then 1 else 0;
      desktop.ojuny.mango.global.monocle_tab_mode =
        if config.ojuny.mango.flag.monocle_tab_mode then 1 else 0;
      desktop.ojuny.mango.global.deck_tab_mode = if config.ojuny.mango.flag.deck_tab_mode then 1 else 0;

      desktop.ojuny.mango.global.animation_type_open =
        enumSpecs.animation_type_open.choices.${config.ojuny.mango.enum.animation_type_open};
      desktop.ojuny.mango.global.animation_type_close =
        enumSpecs.animation_type_close.choices.${config.ojuny.mango.enum.animation_type_close};
      desktop.ojuny.mango.global.layer_animation_type_open =
        enumSpecs.layer_animation_type_open.choices.${config.ojuny.mango.enum.layer_animation_type_open};
      desktop.ojuny.mango.global.layer_animation_type_close =
        enumSpecs.layer_animation_type_close.choices.${config.ojuny.mango.enum.layer_animation_type_close};
      desktop.ojuny.mango.global.tag_animation_direction =
        enumSpecs.tag_animation_direction.choices.${config.ojuny.mango.enum.tag_animation_direction};

      desktop.ojuny.mango.global.gap_inner_horizontal =
        if config.ojuny.style.customGaps then
          config.ojuny.style.gapInnerHorizontal
        else
          config.ojuny.style.gaps;
      desktop.ojuny.mango.global.gap_inner_vertical =
        if config.ojuny.style.customGaps then
          config.ojuny.style.gapInnerVertical
        else
          config.ojuny.style.gaps;
      desktop.ojuny.mango.global.gap_outer_horizontal =
        if config.ojuny.style.customGaps then
          config.ojuny.style.gapOuterHorizontal
        else
          config.ojuny.style.gaps;
      desktop.ojuny.mango.global.gap_outer_vertical =
        if config.ojuny.style.customGaps then
          config.ojuny.style.gapOuterVertical
        else
          config.ojuny.style.gaps;
      desktop.ojuny.mango.global.border_px =
        if config.ojuny.style.customBorders then
          config.ojuny.style.mangoBorderThickness
        else
          config.ojuny.style.borderThickness;
      desktop.ojuny.dms.barConfigs.default.borderThickness =
        if config.ojuny.style.customBorders then
          config.ojuny.style.barBorderThickness
        else
          config.ojuny.style.borderThickness;
      desktop.ojuny.dms.dockConfigs.dock.borderThickness =
        if config.ojuny.style.customBorders then
          config.ojuny.style.dockBorderThickness
        else
          config.ojuny.style.borderThickness;
      };
    };

}
