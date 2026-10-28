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
        .mkConfig { dux = config.desktop.ojuny.dux; };

      greeterConfig = pkgs.runCommand "ojuny-dux-greeter-config" { } ''
        mkdir -p "$out"
        cp ${pkgs.writeText "settings.json" rendered.duxJson} "$out/settings.json"
        cp ${pkgs.writeText "session.json" rendered.duxSessionJson} "$out/session.json"
      '';
    in
    {
      imports = [ inputs.dux-greeter.nixosModules.default ];

      programs.dms-greeter = {
        # @option widget = "switch"; label = "Enable greeter"; group = "Greeter"; groupOrder = 10; order = 10;
        enable = true;
        # @option widget = "dropdown"; label = "Compositor"; group = "Greeter"; groupOrder = 10; order = 20; choices = [ "sway" ];
        compositor = {
          name = "sway";
          package = pkgs.sway;
        };
        configFiles = [
          "${greeterConfig}/settings.json"
          "${greeterConfig}/session.json"
        ];
      };

      services.displayManager.defaultSession = "ojuny";
    };

}
