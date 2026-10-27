/*
  @menu
  displayname = "Input methods";
  icon = "input-keyboard-symbolic";
  order = 25;
  description = "Fcitx5 engines and CJK input";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-input-method =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = config.ojuny.inputMethod;

      cjkEngines = {
        none = null;
        japanese = {
          name = "mozc";
          package = pkgs.fcitx5-mozc;
        };
        korean = {
          name = "hangul";
          package = pkgs.fcitx5-hangul;
        };
        simplified-chinese = {
          name = "pinyin";
          package = pkgs.fcitx5-chinese-addons;
        };
        traditional-chinese = {
          name = "chewing";
          package = pkgs.fcitx5-chewing;
        };
      };

      cjkEngine = cjkEngines.${cfg.cjkForms};

      knownEngineNames = {
        fcitx5-mozc = "mozc";
        fcitx5-hangul = "hangul";
        fcitx5-chinese-addons = "pinyin";
        fcitx5-chewing = "chewing";
      };

      extraEngineNames = lib.filter (name: name != null) (
        map (package: knownEngineNames.${lib.getName package} or null) cfg.engines
      );

      profileEngines = lib.unique (
        [ "keyboard-us" ]
        ++ lib.optional (cjkEngine != null) cjkEngine.name
        ++ extraEngineNames
      );

      profileItems = lib.listToAttrs (
        lib.imap0 (
          index: name: {
            name = "Groups/0/Items/${toString index}";
            value = {
              Name = name;
              Layout = "";
            };
          }
        ) profileEngines
      );

      profile = profileItems // {
        "Groups/0" = {
          Name = cfg.defaultGroup;
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        GroupOrder = {
          "0" = cfg.defaultGroup;
        };
      };
    in
    {

      options.ojuny.inputMethod = {
        enable = lib.mkEnableOption "Fcitx5 input method support";

        engines = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra Fcitx5 engine packages to install.";
        };

        defaultGroup = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "Default";
          description = "Fcitx5 input method group name in the generated profile.";
        };

        cjkForms = lib.mkOption {
          type = lib.types.enum [
            "none"
            "japanese"
            "korean"
            "simplified-chinese"
            "traditional-chinese"
          ];
          default = "none";
          description = "Curated CJK engine and Noto CJK font set.";
        };
      };

      config = lib.mkMerge [
        {
          # @option widget = "switch"; label = "Enable Fcitx5"; group = "Input method"; groupOrder = 10; order = 10; description = "Install and start Fcitx5. Off by default.";
          ojuny.inputMethod.enable = false;

          # @option widget = "packages"; label = "Extra engines"; group = "Input method"; groupOrder = 10; order = 20; visibleWhen.path = "ojuny.inputMethod.enable"; visibleWhen.equals = true; description = "Additional Fcitx5 engine packages. The keyboard engine is always available.";
          ojuny.inputMethod.engines = [ ];

          # @option widget = "text"; label = "Default group"; group = "Input method"; groupOrder = 10; order = 30; visibleWhen.path = "ojuny.inputMethod.enable"; visibleWhen.equals = true; description = "Fcitx5 input method group name. A user profile takes precedence.";
          ojuny.inputMethod.defaultGroup = "Default";

          # @option widget = "dropdown"; label = "CJK form"; group = "Input method"; groupOrder = 10; order = 40; choices = [ "none" "japanese" "korean" "simplified-chinese" "traditional-chinese" ]; visibleWhen.path = "ojuny.inputMethod.enable"; visibleWhen.equals = true; description = "Adds the matching engine and Noto CJK fonts.";
          ojuny.inputMethod.cjkForms = "none";
        }

        (lib.mkIf cfg.enable {
          i18n.inputMethod.enable = true;
          i18n.inputMethod.type = "fcitx5";

          i18n.inputMethod.fcitx5.addons =
            lib.optional (cjkEngine != null) cjkEngine.package ++ cfg.engines;

          i18n.inputMethod.fcitx5.settings.inputMethod = profile;

          environment.variables = {
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";
            SDL_IM_MODULE = "fcitx";
          };

          fonts.packages = lib.optionals (cfg.cjkForms != "none") [
            pkgs.noto-fonts-cjk-sans
            pkgs.noto-fonts-cjk-serif
          ];
        })
      ];
    };

}
