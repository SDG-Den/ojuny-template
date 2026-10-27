{ self, inputs, ... }: {

  flake.nixosConfigurations.ojuny = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.host-imports
      ({ lib, ... }: {
        services.simple-nix-update-gui.flakeUri = lib.mkDefault "git+https://github.com/OWNER/REPO?dir=HOST";
      })
    ];
  };

}
