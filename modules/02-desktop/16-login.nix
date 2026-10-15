/*
  @menu
  displayname = "Login";
  icon = "system-log-out-symbolic";
  order = 16;
  description = "Greeter and display manager";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-login = { config, pkgs, ... }: {

    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "sway";
    };

    programs.sway.enable = true;

  };

}
