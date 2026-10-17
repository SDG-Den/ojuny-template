/*
  @menu
  displayname = "Web apps";
  icon = "web-browser-symbolic";
  order = 10;
  description = "Chromium based web applications";
  category = "06-Utility";
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

        # @option widget = "table-attrset"; label = "Web apps"; group = "Web apps"; columns = [ "enable" "name" "url" "icon" ];
        ojuny.webapps = {
          /* @table-item label = "YouTube"; */
          youtube = {
            enable = true;
            name = "YouTube";
            url = "https://www.youtube.com";
            icon = null;
          };
        };

        # Derived list; no @option.
        programs.chromium-webapps.webApps =
          lib.mapAttrsToList
            (_: app: { inherit (app) name url; } // lib.optionalAttrs (app.icon != null) { inherit (app) icon; })
            (lib.filterAttrs (_: app: app.enable) config.ojuny.webapps);
      };
    };

}
