{
  description = "Baseline flake for testing split flake inputs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        check-inputs = pkgs.writeShellApplication {
          name = "check-inputs";
          runtimeInputs = [ pkgs.coreutils ];
          text = ''
            echo "nixpkgs: ${nixpkgs.outPath}"
            echo "flake-utils: ${flake-utils.outPath}"
          '';
        };
      in
      {
        packages.default = check-inputs;

        apps.default = {
          type = "app";
          program = "${check-inputs}/bin/check-inputs";
        };
      }
    );
}
