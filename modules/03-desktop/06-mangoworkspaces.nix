/*
  @menu
  displayname = "Workspaces";
  icon = "preferences-desktop-workspaces-symbolic";
  order = 60;
  description = "Workspace and tag settings";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-mangoworkspaces =
    { config, lib, ... }:

    let
      # mango stores booleans as the integers 0 and 1, so these are exposed as
      # switches under ojuny.mango.* and written back as 0/1 in the derived
      # assignments at the bottom of this module.
      flagDefaults = {
        tag_gather = true;
        tag_carousel = false;
        scratchpad_cross_monitor = true;
        single_scratchpad = false;
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

      options.ojuny.quake = {
        enable = lib.mkEnableOption "the quake-style scratchpad terminal";
        widthRatio = lib.mkOption {
          type = lib.types.float;
          default = 0.8;
        };
        heightRatio = lib.mkOption {
          type = lib.types.float;
          default = 0.4;
        };
      };

      config = {
        # @option widget = "switch"; label = "Quake console"; group = "Quake";
        ojuny.quake.enable = true;

        # @option widget = "slider"; label = "Width ratio"; group = "Quake"; min = 0.1; max = 1.0; step = 0.05;
        ojuny.quake.widthRatio = 0.8;

        # @option widget = "slider"; label = "Height ratio"; group = "Quake"; min = 0.1; max = 1.0; step = 0.05; description = "Global scratchpad height, so it also affects other named scratchpads.";
        ojuny.quake.heightRatio = 0.4;

        desktop.ojuny.mango.global.scratchpad_width_ratio = config.ojuny.quake.widthRatio;
        desktop.ojuny.mango.global.scratchpad_height_ratio = config.ojuny.quake.heightRatio;

        # Workspaces
        # @option widget = "spin"; label = "Tag count"; group = "Workspaces"; min = 1;
        desktop.ojuny.mango.global.tag_num = 10;

        # @option widget = "switch"; label = "Gather occupied tags"; group = "Workspaces"; applyCommand = "mmsg dispatch setoption,tag_gather,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.tag_gather = true;

        # @option widget = "switch"; label = "Share scratchpad across monitors"; group = "Workspaces"; applyCommand = "mmsg dispatch setoption,scratchpad_cross_monitor,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.scratchpad_cross_monitor = true;

        # @option widget = "switch"; label = "Tag carousel"; group = "Workspaces"; hidden = true; applyCommand = "mmsg dispatch setoption,tag_carousel,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.tag_carousel = false;

        # @option widget = "switch"; label = "Single scratchpad at a time"; group = "Workspaces"; hidden = true; applyCommand = "mmsg dispatch setoption,single_scratchpad,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.single_scratchpad = false;

        # Special workspace (tag 0)
        # @option widget = "slider"; label = "Background dim"; group = "Special workspace"; min = 0.0; max = 1.0; step = 0.05; applyCommand = "mmsg dispatch setoption,special_dim,%%val%%";
        desktop.ojuny.mango.global.special_dim = 0.5;

        # @option widget = "spin"; label = "Inner gap (horizontal)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,special_gap_inner_horizontal,%%val%%";
        desktop.ojuny.mango.global.special_gap_inner_horizontal = 5;

        # @option widget = "spin"; label = "Inner gap (vertical)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,special_gap_inner_vertical,%%val%%";
        desktop.ojuny.mango.global.special_gap_inner_vertical = 5;

        # @option widget = "spin"; label = "Outer gap (horizontal)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,special_gap_outer_horizontal,%%val%%";
        desktop.ojuny.mango.global.special_gap_outer_horizontal = 30;

        # @option widget = "spin"; label = "Outer gap (vertical)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,special_gap_outer_vertical,%%val%%";
        desktop.ojuny.mango.global.special_gap_outer_vertical = 30;

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.tag_gather = if config.ojuny.mango.flag.tag_gather then 1 else 0;
        desktop.ojuny.mango.global.tag_carousel = if config.ojuny.mango.flag.tag_carousel then 1 else 0;
        desktop.ojuny.mango.global.scratchpad_cross_monitor =
          if config.ojuny.mango.flag.scratchpad_cross_monitor then 1 else 0;
        desktop.ojuny.mango.global.single_scratchpad =
          if config.ojuny.mango.flag.single_scratchpad then 1 else 0;
      };
    };
}
