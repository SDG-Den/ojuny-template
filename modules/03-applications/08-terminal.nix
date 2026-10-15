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

        # promptInit and interactiveShellInit (powerlevel10k, zoxide, fzf,
        # fastfetch) stay unexposed: they are shell code, not widget values.

        # Aliases
        # @option widget = "text"; label = "ls"; group = "Aliases";
        environment.shellAliases.ls = "eza -al --color=always --group-directories-first --icons=always";

        # @option widget = "text"; label = "la"; group = "Aliases";
        environment.shellAliases.la = "eza -a --color=always --group-directories-first --icons=always";

        # @option widget = "text"; label = "ll"; group = "Aliases";
        environment.shellAliases.ll = "eza -l --color=always --group-directories-first --icons=always";

        # @option widget = "text"; label = "lt"; group = "Aliases";
        environment.shellAliases.lt = "eza -aT --level=4 --color=always --group-directories-first --icons=always";

        # @option widget = "text"; label = ".."; group = "Aliases";
        environment.shellAliases.".." = "cd ..";

        # @option widget = "text"; label = "..."; group = "Aliases";
        environment.shellAliases."..." = "cd ../..";

        # @option widget = "text"; label = "grep"; group = "Aliases";
        environment.shellAliases.grep = "grep --color=auto";
      };
    };

  # Ghostty is installed conditionally. It carries no @option so the packages
  # widget above stays a plain literal the GUI can render.
  flake.modules.nixos.applications-terminal-ghostty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = lib.optionals config.ojuny.apps.terminal.enable [ pkgs.ghostty ];
    };

}
