{ self, inputs, ... }: {

  flake.nixosConfigurations.ojuny = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ self.modules.nixos.host-imports ];
  };

}
