/*
  @menu
  displayname = "Screensaver";
  icon = "preferences-desktop-screensaver-symbolic";
  order = 65;
  description = "ASCII screensaver before the lock screen";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-screensaver =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.ojuny.screensaver;
    in
    {
      options.ojuny.screensaver = {
        enable = lib.mkEnableOption "the ASCII screensaver";
        idleSeconds = lib.mkOption {
          type = lib.types.int;
          default = 120;
        };
        terminal = lib.mkOption {
          type = lib.types.str;
          default = "ghostty --class=ojuny-screensaver -e";
        };
        command = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.cmatrix}/bin/cmatrix -b";
        };
      };

      config = {
        # @option widget = "switch"; label = "Screensaver"; group = "Screensaver"; description = "Show a terminal screensaver before the DMS lock.";
        ojuny.screensaver.enable = false;

        # @option widget = "spin"; label = "Idle seconds"; group = "Screensaver"; min = 10; description = "Must be lower than the DMS lock timeout.";
        ojuny.screensaver.idleSeconds = 120;

        # @option widget = "text"; label = "Terminal command prefix"; group = "Screensaver"; description = "Include the terminal execute flag, e.g. ghostty --class=ojuny-screensaver -e.";
        ojuny.screensaver.terminal = "ghostty --class=ojuny-screensaver -e";

        # @option widget = "text"; label = "Screensaver command"; group = "Screensaver"; description = "Command run inside the terminal, e.g. cmatrix -b or pipes.sh.";
        ojuny.screensaver.command = "${pkgs.cmatrix}/bin/cmatrix -b";

        environment.systemPackages = lib.mkIf cfg.enable (
          with pkgs;
          [
            cmatrix
            ghostty
            swayidle
            (writeShellScriptBin "ojuny-screensaver" ''
              set -euo pipefail
              pid_file="''${XDG_RUNTIME_DIR:-/tmp}/ojuny-screensaver.pid"
              case "''${1:-start}" in
                start)
                  [ -f "$pid_file" ] && exit 0
                  ${cfg.terminal} ${lib.getExe pkgs.bash} -c ${lib.escapeShellArg cfg.command} &
                  echo "$!" > "$pid_file"
                  ;;
                stop)
                  [ -f "$pid_file" ] || exit 0
                  kill "$(cat "$pid_file")" 2>/dev/null || true
                  rm -f "$pid_file"
                  ;;
              esac
            '')
          ]
        );

        desktop.ojuny.mango.execOnce = lib.mkIf cfg.enable [
          "${pkgs.swayidle}/bin/swayidle -w timeout ${toString cfg.idleSeconds} 'ojuny-screensaver start' resume 'ojuny-screensaver stop'"
        ];
      };
    };
}
