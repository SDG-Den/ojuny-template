/*
  @menu
  displayname = "Gaming";
  icon = "applications-games-symbolic";
  order = 50;
  description = "Steam and gaming";
  category = "05-Applications";
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

      options.ojuny.steam = {
        compat = lib.mkEnableOption "Wine, winetricks, protontricks and gamescope";

        protonGE = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Add Proton GE to Steam's compatibility tools.";
        };
      };

      config = {
        # @option widget = "switch"; label = "Steam"; group = "Steam"; groupOrder = 10; order = 1;
        programs.steam.enable = true;

        # @option widget = "switch"; label = "Windows compatibility tools"; group = "Steam"; description = "Install Wine, winetricks, protontricks and gamescope so non-Steam Windows games and launchers can run."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        ojuny.steam.compat = true;

        # @option widget = "switch"; label = "Proton GE"; group = "Steam"; description = "Community Proton build with extra codec and performance patches, offered alongside the official Proton versions in Steam Play."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        ojuny.steam.protonGE = true;

        # Derived, no @option: feeds Steam's compatibility tool list.
        programs.steam.extraCompatPackages = lib.optionals config.ojuny.steam.protonGE [ pkgs.proton-ge-bin ];

        # @option widget = "switch"; label = "Gamescope session"; group = "Steam"; description = "Add a sessions entry that boots straight into Steam Big Picture through gamescope."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.gamescopeSession.enable = false;

        # @option widget = "switch"; label = "GameMode"; group = "Steam"; description = "Lets games request a temporary performance profile (governor, niceness, IO priority).";
        programs.gamemode.enable = true;

        # @option widget = "switch"; label = "Remote Play firewall"; group = "Steam"; description = "Open the ports Steam Remote Play uses on the local network."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.remotePlay.openFirewall = true;

        # @option widget = "switch"; label = "LAN game transfers"; group = "Steam"; description = "Allow Steam to copy game downloads between PCs on the local network."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.localNetworkGameTransfers.openFirewall = true;

        # @option widget = "switch"; label = "Dedicated server firewall"; group = "Steam"; advanced = true; description = "Open ports for hosted game servers."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.dedicatedServer.openFirewall = false;

        environment.systemPackages = lib.mkIf config.ojuny.steam.compat [
          pkgs.wineWow64Packages.stable
          pkgs.winetricks
          pkgs.protontricks
          pkgs.gamescope
        ];
      };

    };

}
