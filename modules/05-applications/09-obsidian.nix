/*
  @menu
  displayname = "Obsidian";
  icon = "x-office-document-symbolic";
  order = 90;
  description = "Obsidian notes with per-vault Stylix theming";
  category = "05-Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-obsidian =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.ojuny.apps.obsidian = {
        enable = lib.mkEnableOption "the Obsidian note application";

        vaults = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Vault names that receive per-vault Stylix theming.";
        };
      };

      config = {
        # @option widget = "switch"; label = "Obsidian"; group = "Obsidian"; groupOrder = 10; order = 10; description = "Install Obsidian. Off by default because it is proprietary.";
        ojuny.apps.obsidian.enable = false;

        # @option widget = "list"; label = "Vault names"; group = "Obsidian"; groupOrder = 10; order = 20; visibleWhen.path = "ojuny.apps.obsidian.enable"; visibleWhen.equals = true; description = "Exact vault names to theme. A vault created after the last rebuild is not themed until its name is added.";
        ojuny.apps.obsidian.vaults = [ ];

        environment.systemPackages =
          lib.optionals config.ojuny.apps.obsidian.enable [ pkgs.obsidian ];

        desktop.ojuny.defaultApps =
          lib.optionals config.ojuny.apps.obsidian.enable [ pkgs.obsidian ];
      };
    };

  # Obsidian reads per-vault appearance files. The Stylix target writes the
  # default appearance and one CSS snippet per vault name. Existing vaults not
  # listed in `ojuny.apps.obsidian.vaults` keep their own settings until their
  # name is added. Vault contents are user data and never enter the Nix store.
  #
  # The Home Manager Obsidian module in the pinned checkout has no
  # `mutableSettings` option, so appearance files for listed vaults remain
  # declarative and can be rewritten on activation.
  flake.modules.homeManager.applications-obsidian =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    {
      config = {
        programs.obsidian.enable = osConfig.ojuny.apps.obsidian.enable or false;


        stylix.targets.obsidian.vaultNames =
          osConfig.ojuny.apps.obsidian.vaults or [ ];
      };
    };

}
