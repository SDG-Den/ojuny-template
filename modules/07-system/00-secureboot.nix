/*
  @menu
  displayname = "Secure Boot";
  icon = "security-high-symbolic";
  order = 80;
  description = "Optional UEFI Secure Boot setup with Lanzaboote";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-secureboot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      # @option widget = "secureboot"; label = "Secure Boot";
      boot.lanzaboote.enable = false;

      boot.lanzaboote.pkiBundle = "/var/lib/sbctl";

      environment.systemPackages = [ pkgs.sbctl ];

      boot.loader.systemd-boot.enable =
        lib.mkIf (config.boot.lanzaboote.enable && !config.boot.loader.grub.enable)
          (lib.mkForce false);

      assertions = [
        {
          assertion = !(config.boot.lanzaboote.enable && config.boot.loader.grub.enable);
          message = ''
            Secure Boot requires UEFI firmware and systemd-boot, but this install
            uses GRUB. Reinstall in UEFI mode with systemd-boot, or leave
            boot.lanzaboote.enable disabled.
          '';
        }
      ];
    };

}
