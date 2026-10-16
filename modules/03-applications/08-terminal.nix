/*
  @menu
  displayname = "Terminal";
  icon = "utilities-terminal-symbolic";
  order = 80;
  description = "Terminal emulator and multiplexer";
  category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-terminal =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.ojuny.apps.terminal.enable = lib.mkEnableOption "the terminal application set";

      config = {
        # @option widget = "switch"; label = "Ghostty"; group = "Terminal"; description = "GPU-accelerated terminal emulator.";
        ojuny.apps.terminal.enable = true;

        # @option widget = "packages"; label = "Packages"; group = "Packages"; description = "Multiplexers, shell prompt and command line tools.";
        environment.systemPackages = with pkgs; [
          zellij
          tmux
          zsh-powerlevel10k
          zoxide
          eza
          fzf
          bat
          fastfetch
          btop
        ];

        # @option widget = "text"; label = "Multiplexer"; group = "Multiplexer"; description = "Terminal multiplexer used by the desktop shell.";
        desktop.ojuny.dms.settings.muxType = "zellij";

        # Shell
        # @option widget = "switch"; label = "zsh"; group = "Shell";
        programs.zsh.enable = true;

        # @option widget = "switch"; label = "Autosuggestions"; group = "Shell"; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.autosuggestions.enable = true;

        # @option widget = "switch"; label = "Async suggestions"; group = "Shell"; visibleWhen.path = "programs.zsh.autosuggestions.enable"; visibleWhen.equals = true;
        programs.zsh.autosuggestions.async = true;

        # @option widget = "switch"; label = "Syntax highlighting"; group = "Shell"; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.syntaxHighlighting.enable = true;

        # @option widget = "switch"; label = "oh-my-zsh"; group = "Shell"; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.ohMyZsh.enable = true;

        # @option widget = "list"; label = "oh-my-zsh plugins"; group = "Shell"; visibleWhen.path = "programs.zsh.ohMyZsh.enable"; visibleWhen.equals = true;
        programs.zsh.ohMyZsh.plugins = [
          "git"
          "sudo"
        ];

        # @option widget = "spin"; label = "History size"; group = "Shell"; min = 1000; max = 100000; step = 1000; unit = "lines"; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.histSize = 10000;

        programs.zsh.promptInit = ''
          nixupdatesrc=${builtins.path { name = "nixupdate.sh"; path = ./terminal/nixupdate.sh; }}
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          source ${builtins.path { name = "config.zsh"; path = ./terminal/config.zsh; }}
          source ${builtins.path { name = "functions.zsh"; path = ./terminal/functions.zsh; }}
          POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
        '';

        programs.zsh.interactiveShellInit = ''
          eval "$(zoxide init --cmd cd zsh)"
          source <(fzf --zsh)
          if [ "$TERM_PROGRAM" != "vscode" ]; then
            if which fastfetch 2>&1 > /dev/null; then fastfetch; else nix-shell -p fastfetch --run "fastfetch"; fi
          fi
        '';

        # Aliases
        # @option widget = "text"; label = "ls"; group = "Aliases";
        environment.shellAliases.ls = "eza -al --color=always --group-directories-first --icons=always";

        # @option widget = "text"; label = "la"; group = "Aliases";
        environment.shellAliases.la = "eza -a --color=always --group-directories-first --icons=always";

        # @option widget = "text"; label = "ll"; group = "Aliases";
        environment.shellAliases.ll = "eza -l --color=always --group-directories-first --icons=always";

        # @option widget = "text"; label = "lt"; group = "Aliases";
        environment.shellAliases.lt = "eza -aT --level=4 --color=always --group-directories-first --icons=always";

        # @option widget = "text"; label = "l."; group = "Aliases";
        environment.shellAliases."l." = "eza -a | grep -e '^\\.'";

        # @option widget = "text"; label = "reloaddms"; group = "Aliases";
        environment.shellAliases.reloaddms = "dms kill && mmsg dispatch spawn_shell,dms run";

        # @option widget = "text"; label = "find"; group = "Aliases";
        environment.shellAliases.find = "fzf --layout=reverse --preview='bat {}'";

        # @option widget = "text"; label = "nixupdate"; group = "Aliases";
        environment.shellAliases.nixupdate = "${builtins.path { name = "nixupdate.sh"; path = ./terminal/nixupdate.sh; }}";

        # @option widget = "text"; label = ".."; group = "Aliases";
        environment.shellAliases.".." = "cd ..";

        # @option widget = "text"; label = "..."; group = "Aliases";
        environment.shellAliases."..." = "cd ../..";

        # @option widget = "text"; label = "...."; group = "Aliases";
        environment.shellAliases."...." = "cd ../../..";

        # @option widget = "text"; label = "....."; group = "Aliases";
        environment.shellAliases."....." = "cd ../../../..";

        # @option widget = "text"; label = "......"; group = "Aliases";
        environment.shellAliases."......" = "cd ../../../../..";

        # @option widget = "text"; label = "dir"; group = "Aliases";
        environment.shellAliases.dir = "dir --color=auto";

        # @option widget = "text"; label = "vdir"; group = "Aliases";
        environment.shellAliases.vdir = "vdir --color=auto";

        # @option widget = "text"; label = "grep"; group = "Aliases";
        environment.shellAliases.grep = "grep --color=auto";

        # @option widget = "text"; label = "fgrep"; group = "Aliases";
        environment.shellAliases.fgrep = "fgrep --color=auto";

        # @option widget = "text"; label = "egrep"; group = "Aliases";
        environment.shellAliases.egrep = "egrep --color=auto";
      };
    };

  # Ghostty is installed and configured through home-manager, gated by the
  # system switch above. Every leaf carries an @option so the settings GUI can
  # render and edit it.
  flake.modules.homeManager.applications-terminal-ghostty =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    {
      config = lib.mkIf (osConfig.ojuny.apps.terminal.enable or false) {
        programs.ghostty = {
          # Derived, no @option: mirrors the system switch.
          enable = true;

          # @option widget = "switch"; label = "bat syntax"; group = "Ghostty";
          installBatSyntax = true;

          # @option widget = "switch"; label = "zsh integration"; group = "Ghostty";
          enableZshIntegration = true;

          # @option widget = "switch"; label = "Keep default keybinds"; group = "Ghostty";
          clearDefaultKeybinds = false;

          # @option widget = "switch"; label = "systemd service"; group = "Ghostty";
          systemd.enable = true;

          settings = {
            # @option widget = "text"; label = "Command"; group = "Ghostty"; hidden = true;
            command = "${pkgs.zsh}/bin/zsh";

            # @option widget = "spin"; label = "Scrollback limit"; group = "Ghostty"; min = 0; max = 2000000000; unit = "lines";
            scrollback-limit = 1048576000;

            # @option widget = "slider"; label = "Background opacity"; group = "Ghostty"; min = 0.0; max = 1.0; step = 0.05;
            background-opacity = 0.5;

            # @option widget = "switch"; label = "Clickable links"; group = "Ghostty";
            link-url = true;

            # @option widget = "switch"; label = "Link previews"; group = "Ghostty";
            link-previews = true;

            # @option widget = "switch"; label = "Focus follows mouse"; group = "Ghostty";
            focus-follows-mouse = true;

            # @option widget = "switch"; label = "New windows start in home"; group = "Ghostty";
            window-inherit-working-directory = false;

            # @option widget = "switch"; label = "New tabs inherit directory"; group = "Ghostty";
            tab-inherit-working-directory = true;

            # @option widget = "switch"; label = "New splits inherit directory"; group = "Ghostty";
            split-inherit-working-directory = true;

            # @option widget = "text"; label = "Font family"; group = "Ghostty";
            font-family = "CaskaydiaCove Nerd Font Mono";

            # @option widget = "dropdown"; label = "Window decoration"; group = "Ghostty"; choices = [ "auto" "client" "server" "none" ];
            window-decoration = "none";

            # @option widget = "switch"; label = "Confirm close"; group = "Ghostty";
            confirm-close-surface = false;

            # @option widget = "switch"; label = "GTK single instance"; group = "Ghostty";
            gtk-single-instance = false;

            # @option widget = "dropdown"; label = "Clipboard read"; group = "Ghostty"; choices = [ "ask" "allow" "deny" ];
            clipboard-read = "allow";

            # @option widget = "dropdown"; label = "Clipboard write"; group = "Ghostty"; choices = [ "ask" "allow" "deny" ];
            clipboard-write = "allow";

            # @option widget = "list"; label = "Keybindings"; group = "Ghostty";
            keybind = [
              "alt+up=new_split:up"
              "alt+down=new_split:down"
              "alt+left=new_split:left"
              "alt+right=new_split:right"
              "ctrl+alt+r=reload_config"
              "ctrl+shift+r=reset"
              "ctrl+shift+c=copy_to_clipboard"
              "ctrl+shift+v=paste_from_clipboard"
              "ctrl+a=select_all"
              "shift+left=adjust_selection:left"
              "shift+right=adjust_selection:right"
              "shift+up=adjust_selection:up"
              "shift+down=adjust_selection:down"
            ];
          };
        };
      };
    };

  flake.modules.homeManager.applications-terminal-fastfetch =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    let
      colors = self.colors config.lib.stylix.colors;
    in
    {
      config = lib.mkIf (osConfig.ojuny.apps.terminal.enable or false) {
        programs.fastfetch = {
          enable = true;

          settings = {
            display = {
              separator = " ";
            };

            logo = {
              type = "auto";
              source = "nixos";
              width = 40;
              padding = {
                top = 0;
                left = 0;
                right = 2;
              };
              color = {
                "1" = colors.selectionBackground.hex;
                "2" = colors.variables.hex;
                "3" = colors.selectionBackground.hex;
                "4" = colors.classes.hex;
                "5" = colors.selectionBackground.hex;
                "6" = colors.functions.hex;
              };
            };

            modules = [
              {
                type = "title";
                keyWidth = 10;
              }
              "break"
              {
                type = "os";
                key = " OS";
                keyColor = colors.variables.hex;
              }
              {
                type = "kernel";
                key = "├ Kernel";
                keyColor = colors.variables.hex;
              }
              {
                type = "packages";
                key = "├󰏖 Packages";
                keyColor = colors.variables.hex;
              }
              {
                type = "shell";
                key = "├ Shell";
                keyColor = colors.variables.hex;
              }
              {
                type = "localIP";
                key = "├󰩟 Local IP";
                keyColor = colors.variables.hex;
              }
              {
                type = "uptime";
                key = "└󰅐 Start Time";
                keyColor = colors.variables.hex;
              }
              "break"
              {
                type = "wm";
                key = "󰧨 Window Manager";
                keyColor = colors.classes.hex;
              }
              {
                type = "custom";
                key = "├󱂬 Desktop Shell";
                keyColor = colors.classes.hex;
                format = "DankMaterialShell";
              }
              {
                type = "lm";
                key = "├󰧨 Login Manager";
                keyColor = colors.classes.hex;
              }
              {
                type = "wmtheme";
                key = "├󰉼 WM Theme";
                keyColor = colors.classes.hex;
              }
              {
                type = "theme";
                key = "├󰉼 Color Themes";
                keyColor = colors.classes.hex;
              }
              {
                type = "icons";
                key = "├󰸉 System Icons";
                keyColor = colors.classes.hex;
              }
              {
                type = "terminal";
                key = "├ Terminal";
                keyColor = colors.classes.hex;
              }
              {
                type = "terminalfont";
                key = "└ Terminal Font";
                keyColor = colors.classes.hex;
              }
              "break"
              {
                type = "chassis";
                key = "󰌢 PC";
                keyColor = colors.functions.hex;
              }
              {
                type = "board";
                key = "├ Board";
                keyColor = colors.functions.hex;
              }
              {
                type = "cpu";
                key = "├󰻠 CPU";
                keyColor = colors.functions.hex;
                temp = true;
                freqNdigits = 1;
              }
              {
                type = "memory";
                key = "├󰑭 RAM";
                keyColor = colors.functions.hex;
                percent = {
                  type = 3;
                  green = 30;
                  yellow = 70;
                };
              }
              {
                type = "swap";
                key = "├󰓡 Zram";
                keyColor = colors.functions.hex;
                percent = {
                  type = 3;
                  green = 30;
                  yellow = 70;
                };
              }
              {
                type = "disk";
                key = "├ Disk";
                keyColor = colors.functions.hex;
                percent = {
                  type = 3;
                  green = 30;
                  yellow = 70;
                };
              }
              {
                type = "display";
                key = "├󰍹 Display(s)";
                keyColor = colors.functions.hex;
              }
              {
                type = "gpu";
                key = "├󰍛 GPU";
                keyColor = colors.functions.hex;
              }
              {
                type = "opengl";
                key = "├󰍛 OpenGL";
                keyColor = colors.functions.hex;
              }
              {
                type = "vulkan";
                key = "└󰍛 Vulkan";
                keyColor = colors.functions.hex;
              }
            ];
          };
        };
      };
    };

}
