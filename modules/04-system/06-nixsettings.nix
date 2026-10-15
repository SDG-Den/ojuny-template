/* @menu
   displayname = "Nix settings";
   icon = "package-x-generic-symbolic";
   order = 60;
   description = "Nix tooling and the settings GUIs";
   category = "System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-nixsettings = { config, pkgs, ... }: {

    imports = [
      inputs.nix-shell-gui.nixosModules.default
      inputs.nix-regedit.nixosModules.default
    ];

    # NOTE: nix tooling. Every nix call from the GUIs and from the printed
    # rebuild command carries --extra-experimental-features "nix-command
    # flakes"; nix.conf is never written. Packages here: nix-shell-gui,
    # nix-regedit. nix-settings-gui and simple-nix-update-gui still need a
    # home page.

  };

}
