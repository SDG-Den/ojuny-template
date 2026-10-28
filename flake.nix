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
      url = "github:ojuny-project/ojuny-desktop";
      inputs.flake-parts.follows = "flake-parts";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.stylix.follows = "stylix";
    };

    dank-greeter = {
      url = "github:AvengeMedia/dank-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ojuny-cli = {
      url = "github:ojuny-project/ojuny-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./modules)
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, system, ... }:
        let
          prepare-repo = pkgs.writeShellApplication {
            name = "prepare-repo";
            runtimeInputs = [ pkgs.python3 ];
            text = ''
              exec python3 ${./scripts/prepare-repo.py} "$@"
            '';
          };

          regenerate-hardware = pkgs.writeShellApplication {
            name = "regenerate-hardware";
            runtimeInputs = [
              pkgs.python3
              pkgs.nixos-install-tools
              pkgs.nixos-facter
              pkgs.util-linux
              pkgs.coreutils
              pkgs.gnused
              pkgs.gnugrep
            ];
            text = ''
              exec python3 ${./scripts/regenerate-hardware.py} "$@"
            '';
          };
        in
        {
          packages = {
            inherit prepare-repo regenerate-hardware;

            nix-settings-gui = inputs.nix-settings-gui.packages.${system}.default;
            nix-regedit = inputs.nix-regedit.packages.${system}.default;
            nix-shell-gui = inputs.nix-shell-gui.packages.${system}.default;
            simple-nix-update-gui = inputs.simple-nix-update-gui.packages.${system}.default;
            simple-nix-update-gui-daemon = inputs.simple-nix-update-gui.packages.${system}.daemon;
            mango = inputs.ojuny-desktop.inputs.mangowm.packages.${system}.mango;
            dms = inputs.ojuny-desktop.inputs.dms.packages.${system}.default;
            dms-greeter = inputs.dank-greeter.packages.${system}.dms-greeter;
            ojuny-cli = inputs.ojuny-cli.packages.${system}.ojuny-cli;
            ojuny-patches-cli = inputs.ojuny-cli.packages.${system}.ojuny-patches-cli;
          };

          apps.prepare-repo = {
            type = "app";
            program = "${prepare-repo}/bin/prepare-repo";
          };

          apps.regenerate-hardware = {
            type = "app";
            program = "${regenerate-hardware}/bin/regenerate-hardware";
          };

          apps.setup = {
            type = "app";
            program = "${
              pkgs.writeShellApplication {
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
                    runtimeInputs = [
                      pkgs.nixos-install-tools
                      pkgs.coreutils
                      pkgs.gnused
                      pkgs.gnugrep
                      pkgs.util-linux
                    ];
                    text = builtins.readFile ./scripts/generate-hw.sh;
                  })
                  (pkgs.writeShellApplication {
                    name = "generate-user";
                    runtimeInputs = [
                      pkgs.mkpasswd
                      pkgs.coreutils
                    ];
                    text = builtins.readFile ./scripts/generate-user.sh;
                  })
                  (pkgs.writeShellApplication {
                    name = "create-new-system";
                    runtimeInputs = [
                      pkgs.gnused
                      pkgs.coreutils
                    ];
                    text = builtins.readFile ./scripts/create-new-system.sh;
                  })
                ];
                text = builtins.readFile ./scripts/setup.sh;
              }
            }/bin/setup";
          };
        };

      flake = {
        nixosModules.default = inputs.ojuny-desktop.nixosModules.default;
        homeManagerModules.default = inputs.ojuny-desktop.homeManagerModules.default;
      };

      # nixosConfigurations.<host> is registered by scripts/setup.sh, which also
      # writes modules/07-system/01-configuration.nix.
    };
}
