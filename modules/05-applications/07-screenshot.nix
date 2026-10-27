/*
  @menu
  displayname = "Screenshots";
  icon = "camera-photo-symbolic";
  order = 70;
  description = "Screenshot capture and annotation";
  category = "05-Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-screenshot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.ojuny.apps.screenshot;
      ocrLanguageCodes = lib.unique ([ "eng" ] ++ cfg.ocr.languages);
      ocrLanguages = lib.concatStringsSep "+" ocrLanguageCodes;
      tesseractPackage = pkgs.tesseract.override {
        enableLanguages = ocrLanguageCodes;
      };
      capturePath = lib.makeBinPath (
        [
          pkgs.grim
          pkgs.slurp
          pkgs.wl-clipboard
          pkgs.libnotify
          pkgs.zbar
        ]
        ++ lib.optionals cfg.ocr.enable [ tesseractPackage ]
      );
    in
    {
      options.ojuny.apps.screenshot = {
        enable = lib.mkEnableOption "screenshot editing with satty";

        ocr.enable = lib.mkEnableOption "OCR text capture";

        ocr.languages = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "eng" ];
          description = "Tesseract language codes used for OCR, for example eng or deu. English is always installed.";
        };
      };

      config = {
        # @option widget = "switch"; label = "Screenshot editing"; group = "Screenshots"; description = "Install satty and the capture-and-annotate wrapper.";
        ojuny.apps.screenshot.enable = true;

        # @option widget = "switch"; label = "OCR text capture"; group = "OCR"; groupOrder = 20; order = 10; description = "Install Tesseract and the capture-text command for region OCR.";
        ojuny.apps.screenshot.ocr.enable = true;

        # @option widget = "list"; label = "OCR languages"; group = "OCR"; groupOrder = 20; order = 20; visibleWhen.path = "ojuny.apps.screenshot.ocr.enable"; visibleWhen.equals = true; description = "Tesseract language codes, for example eng, deu, or nld. Only the listed packs are installed.";
        ojuny.apps.screenshot.ocr.languages = [ "eng" ];

        environment.systemPackages = lib.mkIf cfg.enable (
          with pkgs;
          [
            satty
            jq
            grim
            slurp
            wl-clipboard
            imagemagick
            zbar
            (writeShellScriptBin "ojuny-screenshot-edit" (
              builtins.readFile ../../scripts/ojuny-screenshot-edit.sh
            ))
            (writeShellScriptBin "ojuny-capture-text" ''
              export PATH="${capturePath}:$PATH"
              export OJUNY_OCR_LANGS="${ocrLanguages}"
              ${builtins.readFile ../../scripts/ojuny-capture-text}
            '')
            (writeShellScriptBin "ojuny-capture-qr" ''
              export PATH="${capturePath}:$PATH"
              ${builtins.readFile ../../scripts/ojuny-capture-qr}
            '')
            (writeShellScriptBin "ojuny-capture-scroll" (
              builtins.readFile ../../scripts/ojuny-capture-scroll
            ))
          ]
          ++ lib.optionals cfg.ocr.enable [
            tesseractPackage
          ]
        );
      };
    };
}
