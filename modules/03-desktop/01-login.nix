/*
  @menu
  displayname = "Login";
  icon = "system-log-out-symbolic";
  order = 10;
  description = "Greeter and display manager";
  category = "03-Desktop";
  hidden = true;
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

      swayGreeterOnly = pkgs.sway.overrideAttrs (old: {
        postBuild = (old.postBuild or "") + ''
          mkdir -p "$out/share/wayland-sessions"
          rm -f "$out/share/wayland-sessions/sway.desktop"
          printf '%s\n' '# Disabled: sway is used only to run the greeter.' > "$out/share/wayland-sessions/sway.desktop"
        '';
      });
    in
    {
      services.displayManager.dms-greeter = {
        # @option widget = "switch"; label = "Enable greeter"; group = "Greeter"; groupOrder = 10; order = 10;
        enable = true;
        # @option widget = "dropdown"; label = "Compositor"; group = "Greeter"; groupOrder = 10; order = 20; choices = [ "sway" ];
        compositor.name = "sway";
        configFiles = [
          "${greeterConfig}/settings.json"
          "${greeterConfig}/session.json"
        ];
      };

      services.displayManager.defaultSession = "ojuny";

      # @option widget = "switch"; label = "Enable Sway"; group = "Session"; groupOrder = 20; order = 10;
      programs.sway.enable = true;
      programs.sway.package = swayGreeterOnly;
    };

}
