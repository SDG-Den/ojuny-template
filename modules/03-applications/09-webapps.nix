/*
  @menu
  displayname = "Web apps";
  icon = "web-browser-symbolic";
  order = 90;
  description = "Chromium based web applications";
  category = "Applications";
*/

/*
  @snippet
  name = "webapp";
  label = "Add web app";
  snippet = ''
    # @option widget = "submodule"; label = "%%name%%"; group = "Web apps";
    ojuny.webapps.%%id%% = {
      # @option widget = "switch"; label = "Enabled"; group = "Web apps";
      enable = true;
      # @option widget = "text"; label = "Name"; group = "Web apps";
      name = "%%name%%";
      # @option widget = "text"; label = "URL"; group = "Web apps";
      url = "%%url%%";
      # @option widget = "path"; label = "Icon"; group = "Web apps"; nullable = true;
      icon = null;
    };
  '';
  placeholders.id.label = "App id";
  placeholders.id.default = "github";
  placeholders.name.label = "App name";
  placeholders.name.default = "GitHub";
  placeholders.url.label = "URL";
  placeholders.url.default = "https://github.com";
*/

{ self, inputs, ... }: {

  # Home Manager page: chromium-webapps builds desktop entries per user. The
  # keyed `ojuny.webapps` attrset is the GUI-friendly indirection; it is turned
  # into the plain list the module wants.
  flake.modules.homeManager.applications-webapps =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.chromium-webapps.homeManagerModules.default ];

      options.ojuny.webapps = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Install this web app.";
              };
              name = lib.mkOption {
                type = lib.types.str;
                description = "Application name.";
              };
              url = lib.mkOption {
                type = lib.types.str;
                description = "URL to open.";
              };
              icon = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description = "Optional icon file.";
              };
            };
          }
        );
        default = { };
        description = "Web apps keyed by id, converted to the chromium-webapps list.";
      };

      config = {
        # @option widget = "switch"; label = "Web apps"; group = "Web apps"; description = "Install Chromium web applications as desktop entries.";
        programs.chromium-webapps.enable = true;

        # Shipped default, editable like any snippet entry.
        # @option widget = "submodule"; label = "YouTube"; group = "Web apps";
        ojuny.webapps.youtube = {
          # @option widget = "switch"; label = "Enabled"; group = "Web apps";
          enable = true;
          # @option widget = "text"; label = "Name"; group = "Web apps";
          name = "YouTube";
          # @option widget = "text"; label = "URL"; group = "Web apps";
          url = "https://www.youtube.com";
          # @option widget = "path"; label = "Icon"; group = "Web apps"; nullable = true;
          icon = null;
        };

        # Derived list; no @option. Each webapp added by the snippet appends here.
        programs.chromium-webapps.webApps =
          lib.mapAttrsToList
            (_: app: { inherit (app) name url; } // lib.optionalAttrs (app.icon != null) { inherit (app) icon; })
            (lib.filterAttrs (_: app: app.enable) config.ojuny.webapps);

        /*
          @insert
          name = "webapp";
          group = "Web apps";
          order = 1000;
        */
      };
    };

}
