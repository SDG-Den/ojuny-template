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

    # @option widget = "switch"; label = "Mutable users"; group = "Accounts"; description = "Allow passwords and other account details to be changed at runtime.";
    users.mutableUsers = true;

    # Shell configuration and aliases live on the Terminal page.

  };

}
