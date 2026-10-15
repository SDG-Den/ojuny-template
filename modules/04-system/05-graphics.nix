/* @menu
   displayname = "Graphics";
   icon = "hardware-driver-symbolic";
   order = 50;
   description = "Graphics drivers and hardware acceleration";
   category = "System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-graphics = { config, pkgs, ... }: {

    # NOTE: hardware.graphics.enable and the GPU driver selection (nvidia,
    # amd, intel) for this machine.

  };

}
