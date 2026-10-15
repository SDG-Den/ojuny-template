/* @menu
   displayname = "Style";
   icon = "applications-graphics-symbolic";
   order = 40;
   description = "Theme, colors, fonts and wallpaper";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-style = { config, pkgs, ... }: {

    imports = [
      inputs.ojuny-desktop.nixosModules.default
      inputs.stylix.nixosModules.stylix
    ];

    /* @option widget = "switch"; label = "Theme mango from stylix"; group = "Theme"; */
    desktop.ojuny.stylix.enable = true;

    /* @option widget = "switch"; label = "Stylix"; group = "Theme"; */
    stylix.enable = true;

    /* @option widget = "dropdown"; label = "Polarity"; group = "Theme"; choices = [ "dark" "light" ]; */
    stylix.polarity = "dark";

    # base16Scheme is a theme file from pkgs.base16-schemes; pick one from
    # https://tinted-theming.github.io/tinted-gallery/ and change the name.
    # Left without an @option so a GUI edit cannot lose the store path.
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    /* @option widget = "path"; label = "Wallpaper"; group = "Theme"; nullable = true; */
    stylix.image = null;

    /* @option widget = "text"; label = "Monospace font"; group = "Fonts"; */
    stylix.fonts.monospace.name = "CaskaydiaMono Nerd Font Mono";

    /* @option widget = "package"; label = "Monospace package"; group = "Fonts"; */
    stylix.fonts.monospace.package = pkgs.nerd-fonts.caskaydia-mono;

    /* @option widget = "text"; label = "Sans-serif font"; group = "Fonts"; */
    stylix.fonts.sansSerif.name = "CaskaydiaCove Nerd Font";

    /* @option widget = "package"; label = "Sans-serif package"; group = "Fonts"; */
    stylix.fonts.sansSerif.package = pkgs.nerd-fonts.caskaydia-cove;

    /* @option widget = "text"; label = "Serif font"; group = "Fonts"; */
    stylix.fonts.serif.name = "CaskaydiaCove Nerd Font";

    /* @option widget = "package"; label = "Serif package"; group = "Fonts"; */
    stylix.fonts.serif.package = pkgs.nerd-fonts.caskaydia-cove;

    /* @option widget = "switch"; label = "Icon theme"; group = "Icons and cursor"; */
    stylix.icons.enable = true;

    /* @option widget = "text"; label = "Cursor theme"; group = "Icons and cursor"; */
    stylix.cursor.name = "Bibata-Modern-Classic";

    /* @option widget = "package"; label = "Cursor package"; group = "Icons and cursor"; */
    stylix.cursor.package = pkgs.bibata-cursors;

    /* @option widget = "spin"; label = "Cursor size"; group = "Icons and cursor"; min = 16; max = 64; */
    stylix.cursor.size = 24;

  };

}
