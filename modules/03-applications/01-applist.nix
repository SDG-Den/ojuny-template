/*
  @menu
  displayname = "Installed applications";
  icon = "system-software-install-symbolic";
  order = 10;
  description = "Applications installed system-wide";
  category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-applist =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      # @option widget = "packages"; label = "Base packages"; group = "Installed applications"; description = "Small command line and utility tools available to every user.";
      environment.systemPackages = with pkgs; [
        wget
        curl
        micro
        fzf
        bat
        eza
        jq
        netcat-openbsd
        dnsmasq
        libnotify
        sops
        age
        vim
      ];

      # Larger optional applications are installed from their own pages: the
      # Office, Multimedia and Vesktop switches live on those pages and add
      # their packages there.

    };

}
