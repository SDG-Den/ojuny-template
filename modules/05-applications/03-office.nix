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

        # @option widget = "text"; label = "OpenDocument text"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true; applyCommand = "xdg-mime default %%val%% application/vnd.oasis.opendocument.text";
        xdg.mime.defaultApplications."application/vnd.oasis.opendocument.text" =
          "libreoffice-writer.desktop";

        # @option widget = "text"; label = "Word documents"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true; applyCommand = "xdg-mime default %%val%% application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        xdg.mime.defaultApplications."application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
          "libreoffice-writer.desktop";

        # @option widget = "text"; label = "Spreadsheets"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true; applyCommand = "xdg-mime default %%val%% application/vnd.oasis.opendocument.spreadsheet";
        xdg.mime.defaultApplications."application/vnd.oasis.opendocument.spreadsheet" =
          "libreoffice-calc.desktop";

        # @option widget = "text"; label = "Presentations"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true; applyCommand = "xdg-mime default %%val%% application/vnd.oasis.opendocument.presentation";
        xdg.mime.defaultApplications."application/vnd.oasis.opendocument.presentation" =
          "libreoffice-impress.desktop";

        # @option widget = "text"; label = "Drawings"; group = "Default applications"; visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true; applyCommand = "xdg-mime default %%val%% application/vnd.oasis.opendocument.graphics";
        xdg.mime.defaultApplications."application/vnd.oasis.opendocument.graphics" =
          "libreoffice-draw.desktop";

        # Craft apps (ArtCraft suite). The core enable is derived from the app
        # switches below, so it never appears as a control of its own.
        # @option widget = "switch"; label = "Link system fonts"; group = "Craft apps"; hidden = true;
        programs.craftapps.linkFonts = true;

        # @option widget = "horizontal-submodule"; label = "Craft apps"; group = "Craft apps"; groupOrder = 20;
        programs.craftapps.apps = {
          # @option widget = "switch"; label = "Photocraft"; group = "Craft apps"
          photocraft.enable = false;
          # @option widget = "switch"; label = "Vectorcraft"; group = "Craft apps"
          vectorcraft.enable = false;
          # @option widget = "switch"; label = "Lightcraft"; group = "Craft apps"
          lightcraft.enable = false;
          # @option widget = "switch"; label = "PDFcraft"; group = "Craft apps"
          pdfcraft.enable = false;
          # @option widget = "switch"; label = "Effectcraft"; group = "Craft apps"
          effectcraft.enable = false;
          # @option widget = "switch"; label = "Designcraft"; group = "Craft apps"
          designcraft.enable = false;
          # @option widget = "switch"; label = "Filmcraft"; group = "Craft apps"
          filmcraft.enable = false;
          # @option widget = "switch"; label = "Gridcraft"; group = "Craft apps"
          gridcraft.enable = false;
          # @option widget = "switch"; label = "Soundcraft"; group = "Craft apps"
          soundcraft.enable = false;
          # @option widget = "switch"; label = "Cadcraft"; group = "Craft apps"
          cadcraft.enable = false;
          # @option widget = "switch"; label = "Wordcraft"; group = "Craft apps"
          wordcraft.enable = false;
          # @option widget = "switch"; label = "Deckcraft"; group = "Craft apps"
          deckcraft.enable = false;
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
