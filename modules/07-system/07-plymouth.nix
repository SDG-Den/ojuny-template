/*
  @menu
  displayname = "Plymouth";
  icon = "preferences-desktop-theme-symbolic";
  order = 70;
  description = "Boot splash and branding";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-plymouth =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      theme = pkgs.callPackage ./plymouth/theme.nix {
        background = config.lib.stylix.colors.base00;
        logo = ./plymouth/ojuny-logo.png;
      };
    in
    {
      options.ojuny.plymouth.enable = lib.mkEnableOption "the Ojuny Plymouth theme";

      config = {
        # @option widget = "switch"; label = "Plymouth"; group = "Plymouth"; description = "Use the Ojuny boot splash generated from Stylix colors.";
        ojuny.plymouth.enable = true;

        boot.plymouth = lib.mkIf config.ojuny.plymouth.enable {
          enable = true;
          theme = lib.mkForce "ojuny";
          themePackages = [ theme ];
        };
      };
    };
}
