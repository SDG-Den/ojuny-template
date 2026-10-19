/*
  @menu
  displayname = "Office";
  icon = "x-office-document-symbolic";
  order = 30;
  description = "Office suite, document tools and ArtCraft apps";
  category = "05-Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-office =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.craftapps.nixosModules.default
        self.modules.nixos.applications-office-apps
      ];

      options.ojuny.apps.office.enable = lib.mkEnableOption "the LibreOffice office suite";

      config = {
        # @option widget = "switch"; label = "LibreOffice"; group = "Office suite"; groupOrder = 10; order = 1;
        ojuny.apps.office.enable = false;

        # @option widget = "text"; label = "OpenDocument text"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true;
        xdg.mime.defaultApplications."application/vnd.oasis.opendocument.text" =
          "libreoffice-writer.desktop";

        # @option widget = "text"; label = "Word documents"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true;
        xdg.mime.defaultApplications."application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
          "libreoffice-writer.desktop";

        # @option widget = "text"; label = "Spreadsheets"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true;
        xdg.mime.defaultApplications."application/vnd.oasis.opendocument.spreadsheet" =
          "libreoffice-calc.desktop";

        # @option widget = "text"; label = "Presentations"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true;
        xdg.mime.defaultApplications."application/vnd.oasis.opendocument.presentation" =
          "libreoffice-impress.desktop";

        # @option widget = "text"; label = "Drawings"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true;
        xdg.mime.defaultApplications."application/vnd.oasis.opendocument.graphics" =
          "libreoffice-draw.desktop";

        # Craft apps (ArtCraft suite). The core enable is derived from the app
        # switches below, so it never appears as a control of its own.
        # @option widget = "switch"; label = "Link system fonts"; group = "Craft apps"; hidden = true;
        programs.craftapps.linkFonts = true;

        # @option widget = "table-attrset"; label = "Craft apps"; group = "Craft apps"; groupOrder = 20; columns = [ "enable" ]; columnTypes = [ "bool" ];
        programs.craftapps.apps = {
          /* @table-item label = "PhotoCraft"; */
          photocraft = { enable = false; };
          /* @table-item label = "VectorCraft"; */
          vectorcraft = { enable = false; };
          /* @table-item label = "LightCraft"; */
          lightcraft = { enable = false; };
          /* @table-item label = "PdfCraft"; */
          pdfcraft = { enable = false; };
          /* @table-item label = "EffectCraft"; */
          effectcraft = { enable = false; };
          /* @table-item label = "DesignCraft"; */
          designcraft = { enable = false; };
          /* @table-item label = "FilmCraft"; */
          filmcraft = { enable = false; };
          /* @table-item label = "GridCraft"; */
          gridcraft = { enable = false; };
          /* @table-item label = "SoundCraft"; */
          soundcraft = { enable = false; };
          /* @table-item label = "CadCraft"; */
          cadcraft = { enable = false; };
          /* @table-item label = "WordCraft"; */
          wordcraft = { enable = false; };
          /* @table-item label = "DeckCraft"; */
          deckcraft = { enable = false; };
        };

        # Derived, no @option: the upstream module only installs while the core
        # is on, and the core turns itself on when any app is selected.
        programs.craftapps.enable =
          config.programs.craftapps.apps.photocraft.enable
          || config.programs.craftapps.apps.vectorcraft.enable
          || config.programs.craftapps.apps.lightcraft.enable
          || config.programs.craftapps.apps.pdfcraft.enable
          || config.programs.craftapps.apps.effectcraft.enable
          || config.programs.craftapps.apps.designcraft.enable
          || config.programs.craftapps.apps.filmcraft.enable
          || config.programs.craftapps.apps.gridcraft.enable
          || config.programs.craftapps.apps.soundcraft.enable
          || config.programs.craftapps.apps.cadcraft.enable
          || config.programs.craftapps.apps.wordcraft.enable
          || config.programs.craftapps.apps.deckcraft.enable;
      };
    };

  # LibreOffice is installed conditionally; no @option, so it stays out of a
  # packages widget the GUI would try to render.
  flake.modules.nixos.applications-office-apps =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages =
        lib.optionals config.ojuny.apps.office.enable [ pkgs.libreoffice-fresh ]
        ++ lib.optionals config.ojuny.apps.office.enable (with pkgs.hunspellDicts; [
          en_US
          de_DE
        ]);
    };

}
