/*
  @menu
  displayname = "Common settings";
  icon = "emblem-system-symbolic";
  order = 20;
  description = "Defaults every user account inherits";
  category = "Users";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.users-commonsettings = { config, pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    # @option widget = "switch"; label = "Use system packages"; group = "Home Manager";
    home-manager.useGlobalPkgs = true;

    # @option widget = "switch"; label = "Per-user package installs"; group = "Home Manager";
    home-manager.useUserPackages = true;

    # @option widget = "text"; label = "Backup extension"; group = "Home Manager"; description = "Files that would be overwritten are renamed with this suffix.";
    home-manager.backupFileExtension = "bck-old-file";

    # @option widget = "list"; label = "Shared home modules"; group = "Home Manager"; description = "Home modules every account imports. The flake's own home-manager pages, such as Web apps, are added automatically.";
    home-manager.sharedModules = builtins.attrValues self.modules.homeManager;

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

    # promptInit and interactiveShellInit (powerlevel10k, zoxide, fzf, fastfetch)
    # stay unexposed: they are shell code, not values a widget can edit.

    # @option widget = "packages"; label = "Shell packages"; group = "Shell";
    environment.systemPackages = with pkgs; [
      zsh-powerlevel10k
      zoxide
      eza
      fzf
      bat
      fastfetch
    ];

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

}
