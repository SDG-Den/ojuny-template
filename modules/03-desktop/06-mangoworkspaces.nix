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

      layoutChoices = [
        "tile"
        "dwindle"
        "scroller"
        "monocle"
        "deck"
        "grid"
        "fair"
        "vertical_scroller"
        "vertical_tile"
        "vertical_fair"
        "vertical_grid"
        "vertical_deck"
        "right_tile"
        "center_tile"
      ];

      tagFields = {
        layout = lib.mkOption {
          type = lib.types.enum layoutChoices;
          default = "tile";
          description = "Mango layout name.";
        };

        masterCount = lib.mkOption {
          type = lib.types.ints.between 0 99;
          default = 0;
          description = "Master count. 0 leaves the Mango per-tag default.";
        };

        masterFactor = lib.mkOption {
          type = lib.types.numbers.between 0.0 0.9;
          default = 0.0;
          description = "Master factor. 0.0 leaves the Mango per-tag default.";
        };

        monitor = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Monitor name. Empty applies to every monitor.";
        };
      };

      tagSpec = lib.types.submodule {
        options = tagFields;
      };

      savedSpec = lib.types.submodule {
        options = tagFields // {
          preset = lib.mkOption {
            type = lib.types.nonEmptyStr;
            description = "Name of the saved layout this row belongs to.";
          };

          tag = lib.mkOption {
            type = lib.types.ints.between 0 99;
            description = "Tag id.";
          };
        };
      };

      mkTagRule =
        { tag, spec }:
        { id = lib.toInt tag; layout_name = spec.layout; }
        // lib.optionalAttrs (spec.masterCount > 0) { master_count = spec.masterCount; }
        // lib.optionalAttrs (spec.masterFactor > 0.0) { master_factor = spec.masterFactor; }
        // lib.optionalAttrs (spec.monitor != "") { monitor_name = spec.monitor; };

      rowToTag = row: {
        name = toString row.tag;
        value = row;
      };

      cfg = config.ojuny.workspaces;
      tagNum = config.desktop.ojuny.mango.global.tag_num or 10;
      savedRows = lib.attrValues cfg.saved;

      presetRows =
        if cfg.preset == null then
          [ ]
        else
          lib.filter (row: row.preset == cfg.preset) savedRows;

      presetTags = lib.listToAttrs (map rowToTag presetRows);
      effectiveTags = presetTags // cfg.tags;
      orderedTags = lib.sort (a: b: lib.toInt a < lib.toInt b) (lib.attrNames effectiveTags);

      tagRules = map (
        tag: mkTagRule { inherit tag; spec = effectiveTags.${tag}; }
      ) orderedTags;

      presetNames = lib.unique (map (row: row.preset) savedRows);

      presetHasDuplicateTags =
        name:
        let
          rows = lib.filter (row: row.preset == name) savedRows;
        in
        lib.length rows != lib.length (lib.unique (map (row: row.tag) rows));
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
          default = 0.7;
          description = "Width of the quake scratchpad as a fraction of the screen.";
        };
        heightRatio = lib.mkOption {
          type = lib.types.float;
          default = 0.55;
          description = "Height of the quake scratchpad as a fraction of the screen. This is global, so it also affects other named scratchpads.";
        };
        modifier = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "SUPER" ];
          description = "Modifier keys that open the quake console.";
        };
        keys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "grave" ];
          description = "Keys that toggle the quake console with the modifiers above.";
        };
      };

      options.ojuny.workspaces = {
        tags = lib.mkOption {
          type = lib.types.attrsOf tagSpec;
          default = { };
          description = "Per-tag layout assignments, keyed by tag id.";
        };

        saved = lib.mkOption {
          type = lib.types.attrsOf savedSpec;
          default = { };
          description = "Saved layout rows, grouped by preset name.";
        };

        preset = lib.mkOption {
          type = lib.types.nullOr lib.types.nonEmptyStr;
          default = null;
          description = "Saved layout name used as the baseline. tags overrides it.";
        };
      };

      config = {
        # @option widget = "switch"; label = "Quake console"; group = "Quake"; description = "Enable the quake-style scratchpad terminal and its keybind.";
        ojuny.quake.enable = true;

        # @option widget = "slider"; label = "Width ratio"; group = "Quake"; min = 0.1; max = 1.0; step = 0.05; description = "Width of the quake scratchpad as a fraction of the screen.";
        ojuny.quake.widthRatio = 0.7;

        # @option widget = "slider"; label = "Height ratio"; group = "Quake"; min = 0.1; max = 1.0; step = 0.05; description = "Height of the quake scratchpad as a fraction of the screen. This is global, so it also affects other named scratchpads.";
        ojuny.quake.heightRatio = 0.55;

        # @option widget = "list"; label = "Modifiers"; group = "Quake"; itemLabel = "Modifier"; addLabel = "Add modifier"; description = "Modifier keys that open the quake console, for example SUPER.";
        ojuny.quake.modifier = [ "SUPER" ];

        # @option widget = "list"; label = "Keys"; group = "Quake"; itemLabel = "Key"; addLabel = "Add key"; description = "Keys that toggle the quake console with the modifiers above.";
        ojuny.quake.keys = [ "grave" ];

        desktop.ojuny.mango.global.scratchpad_width_ratio = config.ojuny.quake.widthRatio;
        desktop.ojuny.mango.global.scratchpad_height_ratio = config.ojuny.quake.heightRatio;

        desktop.ojuny.mango.binds.common = lib.mkIf config.ojuny.quake.enable {
          quake = {
            inherit (config.ojuny.quake) modifier keys;
            dispatcher = "toggle_named_scratchpad";
            args = "org.ojuny.quake,none,ghostty --class=org.ojuny.quake";
            description = "Toggle quake console";
            group = "Windows";
            subcat = "Scratchpad";
          };
        };

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

        # Layout presets
        # @option widget = "text"; label = "Active saved layout"; group = "Layout presets"; groupOrder = 20; order = 10; nullable = true; description = "Saved layout used as the baseline. Per-tag layouts override the same tag. Empty leaves only per-tag layouts.";
        ojuny.workspaces.preset = null;

        # @option widget = "table-attrset"; label = "Per-tag layouts"; group = "Layout presets"; groupOrder = 20; order = 20; columns = [ "layout" "masterCount" "masterFactor" "monitor" ]; columnTypes = [ "str" "int" "float" "str" ]; keyEditable = true; firstValueEditable = true; description = "Tag id to layout. masterCount 0 and masterFactor 0 leave Mango defaults. Empty monitor applies to every monitor.";
        ojuny.workspaces.tags = { };

        # @option widget = "table-attrset"; label = "Saved layouts"; group = "Layout presets"; groupOrder = 20; order = 30; advanced = true; columns = [ "preset" "tag" "layout" "masterCount" "masterFactor" "monitor" ]; columnTypes = [ "str" "int" "str" "int" "float" "str" ]; keyEditable = false; firstValueEditable = true; description = "Rows sharing a preset name form one saved layout. Select it with Active saved layout.";
        ojuny.workspaces.saved = { };

        assertions = [
          {
            assertion = lib.all (tag: builtins.match "[0-9]+" tag != null) (lib.attrNames cfg.tags);
            message = "ojuny.workspaces.tags keys must be numeric tag ids.";
          }
          {
            assertion = lib.all (tag: lib.toInt tag <= tagNum) (lib.attrNames cfg.tags);
            message = "ojuny.workspaces.tags contains a tag id above desktop.ojuny.mango.global.tag_num.";
          }
          {
            assertion = lib.all (row: row.tag <= tagNum) savedRows;
            message = "ojuny.workspaces.saved contains a tag id above desktop.ojuny.mango.global.tag_num.";
          }
          {
            assertion = cfg.preset == null || lib.any (row: row.preset == cfg.preset) savedRows;
            message = "ojuny.workspaces.preset does not name a saved layout.";
          }
          {
            assertion = lib.all (name: !presetHasDuplicateTags name) presetNames;
            message = "ojuny.workspaces.saved has duplicate tag ids inside one preset.";
          }
        ];

        desktop.ojuny.mango.rules.window_rule = lib.mkIf config.ojuny.quake.enable [
          {
            app_id = "org.ojuny.quake";
            is_named_scratchpad = 1;
          }
        ];

        desktop.ojuny.mango.rules.tag_rule = lib.mkIf (tagRules != [ ]) (lib.mkForce tagRules);

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
