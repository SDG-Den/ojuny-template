{ self, ... }: {

  flake.modules.nixos.patches =
    { config, lib, ... }:
    let
      patchModules =
        kind:
        lib.attrValues (
          lib.filterAttrs (name: _: lib.hasPrefix "patch-" name) self.modules.${kind}
        );

      isWrapper =
        v:
        builtins.isAttrs v
        && !(v ? _type)
        && (v ? imports)
        && builtins.isList v.imports
        && builtins.length v.imports == 1
        && builtins.all (k: builtins.elem k [ "_class" "_file" "imports" ]) (builtins.attrNames v);

      resolve =
        module: args:
        if builtins.isFunction module then
          resolve (module args) args
        else if isWrapper module then
          resolve (builtins.head module.imports) args
        else
          module;

      gate =
        cond: module: args:
        let
          args' = if args ? pkgs then args else args // { pkgs = args.config._module.args.pkgs; };
          declared = resolve module args';
          options = declared.options or { };
          flat = builtins.removeAttrs declared [ "options" "imports" "config" "_class" "_file" ];
          gatedConfig = if declared ? config then declared.config // flat else flat;
        in
        {
          inherit options;
          imports = declared.imports or [ ];
          config = lib.mkIf (cond args) gatedConfig;
        };
    in
    {
      imports = map (gate (args: args.config.ojuny.patches)) (patchModules "nixos");

      home-manager.sharedModules = map (gate (args: args.osConfig.ojuny.patches)) (
        patchModules "homeManager"
      );
    };

}
