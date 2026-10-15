/*
  @menu
  displayname = "Nix settings";
  icon = "package-x-generic-symbolic";
  order = 60;
  description = "Nix tooling and the settings GUIs";
  category = "System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-nixsettings = { config, pkgs, ... }: {

    imports = [
      inputs.nix-shell-gui.nixosModules.default
      inputs.nix-regedit.nixosModules.default
    ];

    # @option widget = "switch"; label = "Allow unfree packages"; group = "Packages"; description = "Needed by Steam, NVIDIA drivers and other proprietary software.";
    nixpkgs.config.allowUnfree = true;

    # @option widget = "list"; label = "Trusted users"; group = "Access"; description = "Users allowed to use the Nix daemon and add substituters.";
    nix.settings.trusted-users = [ "@wheel" ];

    # @option widget = "list"; label = "Experimental features"; group = "Features"; description = "nix-command and flakes are required by this flake.";
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # @option widget = "switch"; label = "Auto-optimise store"; group = "Store"; description = "Hard-link identical store paths to save disk space.";
    nix.settings.auto-optimise-store = true;

    # @option widget = "switch"; label = "Optimise store periodically"; group = "Store";
    nix.optimise.automatic = true;

    # @option widget = "switch"; label = "Automatic garbage collection"; group = "Garbage collection";
    nix.gc.automatic = true;

    # @option widget = "list"; label = "Garbage collection schedule"; group = "Garbage collection"; visibleWhen.path = "nix.gc.automatic"; visibleWhen.equals = true; description = "systemd calendar expressions, e.g. weekly.";
    nix.gc.dates = [ "weekly" ];

    # @option widget = "text"; label = "Garbage collection options"; group = "Garbage collection"; visibleWhen.path = "nix.gc.automatic"; visibleWhen.equals = true; description = "e.g. --delete-older-than 30d";
    nix.gc.options = "--delete-older-than 30d";

    # @option widget = "switch"; label = "nix-shell-gui"; group = "Tools";
    services.nix-shell-gui.enable = true;

    # @option widget = "switch"; label = "nix-regedit"; group = "Tools";
    services.nix-regedit.enable = true;

    # @option widget = "submodule"; label = "Bar widget"; group = "Nix monitor";
    desktop.ojuny.dms.barConfigs.default.rightWidgets.nixMonitor = {
      # @option widget = "switch"; label = "Enabled"; group = "Nix monitor";
      enabled = true;

      # @option widget = "spin"; label = "Order"; group = "Nix monitor"; min = 1; max = 100;
      _order = 40;
    };

    # Every nix call from the GUIs and from the printed rebuild command carries
    # --extra-experimental-features "nix-command flakes"; nix.conf is never
    # written. nix-settings-gui and simple-nix-update-gui live on the Updates
    # page.

  };

}
