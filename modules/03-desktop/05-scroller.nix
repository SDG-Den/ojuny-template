/*
  @menu
  displayname = "Scroller layout";
  icon = "view-list-symbolic";
  order = 50;
  description = "Horizontal scrolling window layout";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-scroller =
    { config, lib, ... }:

    let
      # mango stores booleans as the integers 0 and 1, so these are exposed as
      # switches under ojuny.mango.* and written back as 0/1 below.
      flagDefaults = {
        scroller_focus_center = false;
        scroller_prefer_center = false;
        scroller_prefer_overspread = true;
        scroller_ignore_proportion_single = true;
        edge_scroller_pointer_focus = true;
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

      config = {

        # @option widget = "spin"; label = "Side structs"; group = "Scroller layout"; description = "Thickness of the reserved side columns, in pixels."; min = 0; unit = "px"; applyCommand = "mmsg dispatch setoption,scroller_structs,%%val%%";
        desktop.ojuny.mango.global.scroller_structs = 20;

        # @option widget = "spin"; label = "Default proportion"; group = "Scroller layout"; description = "Fraction of the viewport a window occupies by default."; digits = 2; min = 0.1; applyCommand = "mmsg dispatch set_proportion,%%val%%";
        desktop.ojuny.mango.global.scroller_default_proportion = 0.8;

        # @option widget = "spin"; label = "Single window proportion"; group = "Scroller layout"; description = "Fraction of the viewport used when only one window is open."; digits = 2; min = 0.1; applyCommand = "mmsg dispatch set_proportion,%%val%%";
        desktop.ojuny.mango.global.scroller_default_proportion_single = 1;

        # @option widget = "switch"; label = "Always center focused window"; group = "Scroller layout"; description = "Keep the focused window centered as focus changes."; applyCommand = "mmsg dispatch setoption,scroller_focus_center,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.scroller_focus_center = false;

        # @option widget = "switch"; label = "Center focused window when off-screen"; group = "Scroller layout"; description = "Scroll a focused window back into view when it moves off-screen."; applyCommand = "mmsg dispatch setoption,scroller_prefer_center,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.scroller_prefer_center = false;

        # @option widget = "switch"; label = "Allow overspread"; group = "Scroller layout"; description = "Let the focused window widen into the reserved area."; applyCommand = "mmsg dispatch setoption,scroller_prefer_overspread,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.scroller_prefer_overspread = true;

        # @option widget = "switch"; label = "Ignore proportion for single window"; group = "Scroller layout"; description = "Use the single-window proportion instead of the default proportion."; applyCommand = "mmsg dispatch setoption,scroller_ignore_proportion_single,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.scroller_ignore_proportion_single = true;

        # @option widget = "switch"; label = "Edge pointer focus"; group = "Scroller layout"; description = "Focus the window at the viewport edge the pointer rests on."; applyCommand = "mmsg dispatch setoption,edge_scroller_pointer_focus,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.edge_scroller_pointer_focus = true;

        # @option widget = "spin"; label = "Pointer focus speed floor"; group = "Scroller layout"; description = "Minimum pointer travel before edge focus engages."; min = 0.0; max = 10.0; step = 0.1; applyCommand = "mmsg dispatch setoption,edge_scroller_focus_allow_speed,%%val%%";
        desktop.ojuny.mango.global.edge_scroller_focus_allow_speed = 0.5;

        # @option widget = "list"; label = "Proportion presets"; group = "Scroller layout"; description = "One number per line, cycled by the proportion dispatchers.";
        desktop.ojuny.mango.global.scroller_proportion_preset = [
          0.4
          0.5
          0.8
          1.0
        ];

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.scroller_focus_center =
          if config.ojuny.mango.flag.scroller_focus_center then 1 else 0;
        desktop.ojuny.mango.global.scroller_prefer_center =
          if config.ojuny.mango.flag.scroller_prefer_center then 1 else 0;
        desktop.ojuny.mango.global.scroller_prefer_overspread =
          if config.ojuny.mango.flag.scroller_prefer_overspread then 1 else 0;
        desktop.ojuny.mango.global.scroller_ignore_proportion_single =
          if config.ojuny.mango.flag.scroller_ignore_proportion_single then 1 else 0;
        desktop.ojuny.mango.global.edge_scroller_pointer_focus =
          if config.ojuny.mango.flag.edge_scroller_pointer_focus then 1 else 0;
      };
    };

}
