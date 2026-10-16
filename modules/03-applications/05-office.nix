/*
  @menu
  displayname = "Office";
  icon = "x-office-document-symbolic";
  order = 50;
  description = "Office suite, document tools and ArtCraft apps";
  category = "Applications";
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
        # @option widget = "switch"; label = "LibreOffice"; group = "Office suite";
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

        # @option widget = "switch"; label = "PhotoCraft"; group = "Craft apps"; description = "Image editing.";
        programs.craftapps.apps.photocraft.enable = false;

        # @option widget = "switch"; label = "VectorCraft"; group = "Craft apps"; description = "Vector illustration.";
        programs.craftapps.apps.vectorcraft.enable = false;

        # @option widget = "switch"; label = "LightCraft"; group = "Craft apps"; description = "Photo library and raw processing.";
        programs.craftapps.apps.lightcraft.enable = false;

        # @option widget = "switch"; label = "PdfCraft"; group = "Craft apps"; description = "Read, organize and edit PDFs.";
        programs.craftapps.apps.pdfcraft.enable = false;

        # @option widget = "switch"; label = "EffectCraft"; group = "Craft apps"; description = "Motion graphics and visual effects.";
        programs.craftapps.apps.effectcraft.enable = false;

        # @option widget = "switch"; label = "DesignCraft"; group = "Craft apps"; description = "Page layout and publishing.";
        programs.craftapps.apps.designcraft.enable = false;

        # @option widget = "switch"; label = "FilmCraft"; group = "Craft apps"; description = "Video editing.";
        programs.craftapps.apps.filmcraft.enable = false;

        # @option widget = "switch"; label = "GridCraft"; group = "Craft apps"; description = "Spreadsheets.";
        programs.craftapps.apps.gridcraft.enable = false;

        # @option widget = "switch"; label = "SoundCraft"; group = "Craft apps"; description = "Audio recording and editing.";
        programs.craftapps.apps.soundcraft.enable = false;

        # @option widget = "switch"; label = "CadCraft"; group = "Craft apps"; description = "CAD and drafting.";
        programs.craftapps.apps.cadcraft.enable = false;

        # @option widget = "switch"; label = "WordCraft"; group = "Craft apps"; description = "Word processing.";
        programs.craftapps.apps.wordcraft.enable = false;

        # @option widget = "switch"; label = "DeckCraft"; group = "Craft apps"; description = "Presentations and slide shows.";
        programs.craftapps.apps.deckcraft.enable = false;

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
