/* @menu
   displayname = "System";
   icon = "computer-symbolic";
   order = 10;
   description = "Hostname, locale, time and keyboard";
   category = "System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-configuration = { config, pkgs, ... }: {

    # NOTE: time.timeZone, i18n.defaultLocale, console.keyMap and the xkb
    # layout. system.stateVersion is written once by scripts/setup.sh and is
    # never prompted or shown in the GUI. Setup also writes the host wiring
    # (the imports for this machine's pages and the nixosConfigurations entry)
    # into this file.

  };

}
