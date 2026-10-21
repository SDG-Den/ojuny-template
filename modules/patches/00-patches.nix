{ self, ... }: {

  flake.modules.nixos.patches =
    { config, lib, ... }:
    let
      patchModules =
        kind:
        lib.attrValues (
          lib.filterAttrs (name: _: lib.hasPrefix "patch-" name) self.modules.${kind}
        );

      gate = import ./_gate.nix { inherit lib; };
    in
    {
      imports = map (gate (args: args.config.ojuny.patches)) (patchModules "nixos");

      home-manager.sharedModules = map (gate (args: args.osConfig.ojuny.patches)) (
        patchModules "homeManager"
      );
    };

}
