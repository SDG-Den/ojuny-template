/*
  @menu
  displayname = "Nix settings";
  icon = "package-x-generic-symbolic";
  order = 110;
  description = "Nix tooling and the settings GUIs";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-nixsettings = { config, pkgs, ... }: {

    imports = [
      inputs.nix-shell-gui.nixosModules.default
      inputs.nix-regedit.nixosModules.default
    ];

    # @option widget = "switch"; label = "Allow unfree packages"; group = "Packages"; groupOrder = 10; order = 100; description = "Needed by Steam, NVIDIA drivers and other proprietary software.";
    nixpkgs.config.allowUnfree = true;

    # @option widget = "list"; label = "Trusted users"; group = "Access"; groupOrder = 20; order = 100; description = "Users allowed to use the Nix daemon and add substituters.";
    nix.settings.trusted-users = [ "@wheel" ];

    # @option widget = "list"; label = "Experimental features"; group = "Features"; groupOrder = 30; order = 100; description = "nix-command and flakes are required by this flake.";
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # @option widget = "list"; label = "Substituters"; group = "Substituters"; groupOrder = 40; description = "Binary caches to pull prebuilt paths from."; order = 100;
    nix.settings.substituters = [ "https://cache.nixos.org/" ];

    # @option widget = "list"; label = "Trusted public keys"; group = "Substituters"; groupOrder = 40; description = "Signing keys for the substituters above."; order = 200;
    nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];

    # @option widget = "text"; label = "Max build jobs"; group = "Build"; groupOrder = 50; description = "Number of parallel build processes, or auto to use every CPU core."; order = 100;
    nix.settings.max-jobs = "auto";

    # @option widget = "spin"; label = "Cores per job"; group = "Build"; groupOrder = 50; description = "Cores each build uses; 0 means all of them."; min = 0; max = 128; order = 200;
    nix.settings.cores = 0;

    # @option widget = "switch"; label = "Sandbox builds"; group = "Build"; groupOrder = 50; description = "Run builds in isolated namespaces."; order = 300;
    nix.settings.sandbox = true;

    # @option widget = "switch"; label = "Allow import from derivation"; group = "Build"; groupOrder = 50; description = "Lets derivations evaluate other derivations; needed by some flakes."; order = 400;
    nix.settings.allow-import-from-derivation = true;

    # @option widget = "spin"; label = "Connection timeout"; group = "Daemon"; groupOrder = 60; description = "Seconds before a download is abandoned."; min = 1; max = 600; unit = "s"; order = 100;
    nix.settings.connect-timeout = 30;

    # @option widget = "spin"; label = "Stalled download timeout"; group = "Daemon"; groupOrder = 60; description = "Seconds a download may stall before it is retried."; min = 1; max = 3600; unit = "s"; order = 200;
    nix.settings.stalled-download-timeout = 1200;

    # @option widget = "spin"; label = "Download attempts"; group = "Daemon"; groupOrder = 60; description = "How many times a failed download is retried."; min = 1; max = 100; order = 300;
    nix.settings.download-attempts = 30;

    # @option widget = "switch"; label = "Auto-optimise store"; group = "Store"; groupOrder = 70; order = 100; description = "Hard-link identical store paths to save disk space.";
    nix.settings.auto-optimise-store = true;

    # @option widget = "switch"; label = "Optimise store periodically"; group = "Store"; groupOrder = 70; order = 200;
    nix.optimise.automatic = true;

    # @option widget = "switch"; label = "Automatic garbage collection"; group = "Garbage collection"; groupOrder = 80; order = 100;
    nix.gc.automatic = true;

    # @option widget = "list"; label = "Garbage collection schedule"; group = "Garbage collection"; groupOrder = 80; order = 200; visibleWhen.path = "nix.gc.automatic"; visibleWhen.equals = true; description = "systemd calendar expressions, e.g. weekly.";
    nix.gc.dates = [ "weekly" ];

    # @option widget = "text"; label = "Garbage collection options"; group = "Garbage collection"; groupOrder = 80; order = 300; visibleWhen.path = "nix.gc.automatic"; visibleWhen.equals = true; description = "e.g. --delete-older-than 30d";
    nix.gc.options = "--delete-older-than 30d";

    # @option widget = "switch"; label = "nix-shell-gui"; group = "Tools"; groupOrder = 90; order = 100;
    services.nix-shell-gui.enable = true;

    # @option widget = "switch"; label = "nix-regedit"; group = "Tools"; groupOrder = 90; order = 200;
    services.nix-regedit.enable = true;


    # Every nix call from the GUIs and from the printed rebuild command carries
    # --extra-experimental-features "nix-command flakes"; nix.conf is never
    # written. nix-settings-gui and simple-nix-update-gui live on the Updates
    # page.

  };

}
