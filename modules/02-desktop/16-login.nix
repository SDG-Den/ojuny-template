/*
  @menu
  displayname = "Login";
  icon = "system-log-out-symbolic";
  order = 16;
  description = "Greeter and display manager";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-login =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      rendered = (import "${inputs.ojuny-desktop}/lib/mk-config.nix" { inherit lib; })
        .mkConfig { dms = config.desktop.ojuny.dms; };

      greeterConfig = pkgs.runCommand "ojuny-dms-greeter-config" { } ''
        mkdir -p "$out"
        cp ${pkgs.writeText "settings.json" rendered.dmsJson} "$out/settings.json"
        cp ${pkgs.writeText "session.json" rendered.dmsSessionJson} "$out/session.json"
      '';
    in
    {
      services.displayManager.dms-greeter = {
        enable = true;
        compositor.name = "sway";
        configFiles = [
          "${greeterConfig}/settings.json"
          "${greeterConfig}/session.json"
        ];
      };

      programs.sway.enable = true;
    };

}
