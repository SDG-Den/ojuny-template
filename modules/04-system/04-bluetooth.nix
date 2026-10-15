/* @menu
   displayname = "Bluetooth";
   icon = "bluetooth-active-symbolic";
   order = 40;
   description = "Bluetooth pairing and services";
   category = "System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-bluetooth = { config, pkgs, ... }: {

    # NOTE: hardware.bluetooth and services.blueman for the pairing UI.

  };

}
