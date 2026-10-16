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

    craftapps = {
      url = "github:olafkfreund/nix-craftapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chromium-webapps = {
      url = "github:chobbledotcom/nix-chromium-webapps";
    };

    firefox-addons = {
      url = "git+https://gitlab.com/rycee/nur-expressions?dir=pkgs/firefox-addons";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./modules)
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, system, ... }: {
        packages = {
          nix-settings-gui = inputs.nix-settings-gui.packages.${system}.default;
          nix-regedit = inputs.nix-regedit.packages.${system}.default;
          nix-shell-gui = inputs.nix-shell-gui.packages.${system}.default;
          simple-nix-update-gui = inputs.simple-nix-update-gui.packages.${system}.default;
        };

        apps.setup = {
          type = "app";
          program = "${pkgs.writeShellApplication {
            name = "setup";
            runtimeInputs = [
              pkgs.nixos-install-tools
              pkgs.nixos-rebuild
              pkgs.mkpasswd
              pkgs.nix
              pkgs.git
              pkgs.coreutils
              pkgs.gnused
              (pkgs.writeShellApplication {
                name = "generate-hw";
                runtimeInputs = [ pkgs.nixos-install-tools pkgs.coreutils pkgs.gnused pkgs.gnugrep pkgs.util-linux ];
                text = builtins.readFile ./scripts/generate-hw.sh;
              })
              (pkgs.writeShellApplication {
                name = "generate-user";
                runtimeInputs = [ pkgs.mkpasswd pkgs.coreutils ];
                text = builtins.readFile ./scripts/generate-user.sh;
              })
              (pkgs.writeShellApplication {
                name = "create-new-system";
                runtimeInputs = [ pkgs.gnused pkgs.coreutils ];
                text = builtins.readFile ./scripts/create-new-system.sh;
              })
            ];
            text = builtins.readFile ./scripts/setup.sh;
          }}/bin/setup";
        };
      };

      flake = {
        nixosModules.default = inputs.ojuny-desktop.nixosModules.default;
        homeManagerModules.default = inputs.ojuny-desktop.homeManagerModules.default;
      };

      # nixosConfigurations.<host> is registered by scripts/setup.sh, which also
      # writes modules/04-system/01-configuration.nix.
    };
}
