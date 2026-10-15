{ self, inputs, ... }: {

  flake.nixosConfigurations.ojuny = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = builtins.attrValues self.modules.nixos;
  };

}
