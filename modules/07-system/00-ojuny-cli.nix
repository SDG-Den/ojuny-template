{ inputs, ... }: {

  flake.modules.nixos.system-ojuny-cli = { pkgs, ... }: {

    environment.systemPackages = [
      inputs.ojuny-cli.packages.${pkgs.stdenv.hostPlatform.system}.ojuny-cli
      inputs.ojuny-cli.packages.${pkgs.stdenv.hostPlatform.system}.ojuny-patches-cli
    ];

  };

}
