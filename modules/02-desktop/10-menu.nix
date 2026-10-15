/*
  @menu
  displayname = "Menu";
  icon = "open-menu-symbolic";
  order = 100;
  description = "Nix managed application menu";
  category = "Desktop";
*/

/*
  @snippet
  name = "menu-row";
  label = "Add menu row";
  snippet = ''
    # @option widget = "submodule"; label = "%%label%%"; group = "Menu rows";
    desktop.ojuny.dankMenu.menu."%%id%%" = {
      # @option widget = "text"; label = "Icon"; group = "Menu rows";
      icon = "%%icon%%";
      # @option widget = "text"; label = "Label"; group = "Menu rows";
      label = "%%label%%";
      # @option widget = "list"; label = "Aliases"; group = "Menu rows";
      aliases = [ ];
      # @option widget = "text"; label = "Provider"; group = "Menu rows"; nullable = true;
      provider = null;
      # @option widget = "text"; label = "Target"; group = "Menu rows"; nullable = true;
      target = null;
      # @option widget = "text"; label = "Action"; group = "Menu rows"; nullable = true;
      action = null;
    };
  '';
  placeholders.id.label = "Row id";
  placeholders.id.default = "learn.keybinds";
  placeholders.label.label = "Label";
  placeholders.label.default = "Keybinds";
  placeholders.icon.label = "Icon";
  placeholders.icon.default = "keyboard";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-menu = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Manage menu with Nix"; group = "Menu"; description = "Installs the dankMenu plugin and manages its menu from this flake.";
    desktop.ojuny.dankMenu.enable = true;

    # @option widget = "raw"; label = "Extra plugin settings"; group = "Menu"; rows = 6; description = "Additional dankMenu plugin settings merged into plugin_settings.json.";
    desktop.ojuny.dankMenu.settings = { };

    # Menu rows are keyed by dotted id (e.g. "learn.keybinds") with icon, label,
    # aliases, provider, target and action. A non-empty tree replaces the
    # plugin's bundled menu, so only add rows once you want a fully custom menu.

    /*
      @insert
      name = "menu-row";
      group = "Menu rows";
      order = 1000;
    */

  };

}
