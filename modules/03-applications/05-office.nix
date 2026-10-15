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
      imports = [ inputs.craftapps.nixosModules.default ];

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

        # Craft apps (ArtCraft suite)
        # @option widget = "switch"; label = "Craft apps"; group = "Craft apps"; description = "Install the ArtCraft creative applications.";
        programs.craftapps.enable = false;

        # @option widget = "switch"; label = "All craft apps"; group = "Craft apps"; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true; description = "Default every craft app on.";
        programs.craftapps.enableAll = false;

        # @option widget = "switch"; label = "Link system fonts"; group = "Craft apps"; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true; hidden = true;
        programs.craftapps.linkFonts = true;

        # @option widget = "switch"; label = "PhotoCraft"; group = "Craft apps"; description = "Image editing."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.photocraft.enable = false;

        # @option widget = "switch"; label = "VectorCraft"; group = "Craft apps"; description = "Vector illustration."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.vectorcraft.enable = false;

        # @option widget = "switch"; label = "LightCraft"; group = "Craft apps"; description = "Photo library and raw processing."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.lightcraft.enable = false;

        # @option widget = "switch"; label = "PdfCraft"; group = "Craft apps"; description = "Read, organize and edit PDFs."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.pdfcraft.enable = false;

        # @option widget = "switch"; label = "EffectCraft"; group = "Craft apps"; description = "Motion graphics and visual effects."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.effectcraft.enable = false;

        # @option widget = "switch"; label = "DesignCraft"; group = "Craft apps"; description = "Page layout and publishing."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.designcraft.enable = false;

        # @option widget = "switch"; label = "FilmCraft"; group = "Craft apps"; description = "Video editing."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.filmcraft.enable = false;

        # @option widget = "switch"; label = "GridCraft"; group = "Craft apps"; description = "Spreadsheets."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.gridcraft.enable = false;

        # @option widget = "switch"; label = "SoundCraft"; group = "Craft apps"; description = "Audio recording and editing."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.soundcraft.enable = false;

        # @option widget = "switch"; label = "CadCraft"; group = "Craft apps"; description = "CAD and drafting."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.cadcraft.enable = false;

        # @option widget = "switch"; label = "WordCraft"; group = "Craft apps"; description = "Word processing."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.wordcraft.enable = false;

        # @option widget = "switch"; label = "DeckCraft"; group = "Craft apps"; description = "Presentations and slide shows."; visibleWhen.path = "programs.craftapps.enable"; visibleWhen.equals = true;
        programs.craftapps.apps.deckcraft.enable = false;
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
      environment.systemPackages = lib.optionals config.ojuny.apps.office.enable [ pkgs.libreoffice-fresh ];
    };

}
