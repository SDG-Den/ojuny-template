/*
  @menu
  displayname = "Gaming";
  icon = "applications-games-symbolic";
  order = 70;
  description = "Steam and gaming";
  category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-steam =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      options.ojuny.steam.compat = lib.mkEnableOption "Wine, winetricks, protontricks and gamescope";

      config = {
        # @option widget = "switch"; label = "Steam"; group = "Steam";
        programs.steam.enable = true;

        # @option widget = "switch"; label = "Windows compatibility tools"; group = "Steam"; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        ojuny.steam.compat = true;

        environment.systemPackages = lib.mkIf config.ojuny.steam.compat [
          pkgs.wineWow64Packages.stable
          pkgs.winetricks
          pkgs.protontricks
          pkgs.gamescope
        ];
      };

    };

}
