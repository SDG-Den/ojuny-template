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

        # @option widget = "packages"; label = "Terminal packages"; group = "Packages";
        environment.systemPackages = with pkgs; [
          zellij
          tmux
        ];

        # @option widget = "text"; label = "Multiplexer"; group = "Multiplexer"; description = "Terminal multiplexer used by the desktop shell.";
        desktop.ojuny.dms.settings.muxType = "zellij";
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
