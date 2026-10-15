/*
  @menu
  displayname = "Vesktop";
  icon = "internet-chat-symbolic";
  order = 60;
  description = "Discord client";
  category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-vesktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      options.ojuny.apps.vesktop.enable = lib.mkEnableOption "the Vesktop Discord client";

      config = {
        # @option widget = "switch"; label = "Vesktop (Discord)"; group = "Vesktop";
        ojuny.apps.vesktop.enable = false;

        environment.systemPackages = lib.mkIf config.ojuny.apps.vesktop.enable [ pkgs.vesktop ];

        # Expose to the launcher and keybinds so `vesktop.desktop` resolves.
        desktop.ojuny.defaultApps = lib.optionals config.ojuny.apps.vesktop.enable [ pkgs.vesktop ];

        # @option widget = "text"; label = "Discord links"; group = "Default applications"; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        xdg.mime.defaultApplications."x-scheme-handler/discord" = "vesktop.desktop";
      };

    };

}
