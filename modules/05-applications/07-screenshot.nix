/*
  @menu
  displayname = "Screenshots";
  icon = "camera-photo-symbolic";
  order = 70;
  description = "Screenshot capture and annotation";
  category = "05-Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-screenshot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.ojuny.apps.screenshot.enable = lib.mkEnableOption "screenshot editing with satty";

      config = {
        # @option widget = "switch"; label = "Screenshot editing"; group = "Screenshots"; description = "Install satty and the capture-and-annotate wrapper.";
        ojuny.apps.screenshot.enable = true;

        environment.systemPackages = lib.mkIf config.ojuny.apps.screenshot.enable (
          with pkgs;
          [
            satty
            jq
            (writeShellScriptBin "ojuny-screenshot-edit" (
              builtins.readFile ../../scripts/ojuny-screenshot-edit.sh
            ))
          ]
        );
      };
    };
}
