{
  description = "Ojuny template - a NixOS config edited through nix-settings-gui";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ojuny-desktop = {
      url = "github:SDG-Den/ojuny-desktop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-settings-gui = {
      url = "github:SDG-Den/nix-settings-gui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-regedit = {
      url = "github:SDG-Den/nix-regedit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-shell-gui = {
      url = "github:SDG-Den/nix-shell-gui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nix-update-gui = {
      url = "github:SDG-Den/simple-nix-update-gui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = inputs.import-tree ./modules ++ [
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = [ "x86_64-linux" ];

      flake = {
        nixosModules.default = inputs.ojuny-desktop.nixosModules.default;
        homeManagerModules.default = inputs.ojuny-desktop.homeManagerModules.default;
      };

      # nixosConfigurations.<host> is registered by scripts/setup.sh, which also
      # writes modules/04-system/01-configuration.nix.
    };
}
