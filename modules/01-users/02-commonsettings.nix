/*
  @menu
  displayname = "Common settings";
  icon = "emblem-system-symbolic";
  order = 20;
  description = "Defaults every user account inherits";
  category = "01-Users";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.users-commonsettings = { config, pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager.useGlobalPkgs = true;

    home-manager.useUserPackages = true;

    # @option widget = "text"; label = "Backup extension"; group = "Home Manager"; description = "Files that would be overwritten are renamed with this suffix.";
    home-manager.backupFileExtension = "bck-old-file";

    # @option widget = "switch"; label = "Mutable users"; group = "Accounts"; description = "Allow passwords and other account details to be changed at runtime.";
    users.mutableUsers = false;

    # Shell configuration and aliases live on the Terminal page.

  };

}
