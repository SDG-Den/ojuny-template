/*
  @menu
  displayname = "KDE Connect";
  icon = "phone-symbolic";
  order = 60;
  description = "KDE Connect integration";
  category = "05-Applications";
  hidden = true;
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-kdeconnect = { pkgs, lib, ... }: {
    # @option widget = "switch"; label = "KDE Connect"; group = "KDE Connect"; groupOrder = 10; order = 1; description = "Phone notifications, file transfer and remote input.";
    programs.kdeconnect.enable = true;

    # themed fork of KDE Connect used by stylix; parity with dendrite desktop-svc.nix.
    programs.kdeconnect.package = lib.mkDefault pkgs.valent;

  };

}
