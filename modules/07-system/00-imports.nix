{ self, ... }: {

  flake.modules.nixos.host-imports = {

    imports = [
      self.modules.nixos.system-configuration
      self.modules.nixos.system-hardware
      self.modules.nixos.system-bootloader
      self.modules.nixos.system-networking
      self.modules.nixos.system-bluetooth
      self.modules.nixos.system-graphics
      self.modules.nixos.system-nixsettings
      self.modules.nixos.system-updates
      self.modules.nixos.system-ssh-test

      self.modules.nixos.users-commonsettings
      self.modules.nixos.users-user

      self.modules.nixos.desktop-mango
      self.modules.nixos.desktop-mangosettings
      self.modules.nixos.desktop-mangomaster
      self.modules.nixos.desktop-mangodwindle
      self.modules.nixos.desktop-mangoworkspaces
      self.modules.nixos.desktop-scroller
      self.modules.nixos.desktop-display
      self.modules.nixos.desktop-style
      self.modules.nixos.desktop-bar
      self.modules.nixos.desktop-dock
      self.modules.nixos.desktop-dashboard
      self.modules.nixos.desktop-notifications
      self.modules.nixos.desktop-clipboard
      self.modules.nixos.desktop-menu
      self.modules.nixos.desktop-plugins

      self.modules.nixos.desktop-binds
      self.modules.nixos.desktop-autostart
      self.modules.nixos.desktop-input
      self.modules.nixos.desktop-login
      self.modules.nixos.desktop-controlcenter
      self.modules.nixos.desktop-gestures
      self.modules.nixos.desktop-launcher

      self.modules.nixos.applications-applist
      self.modules.nixos.applications-browser
      self.modules.nixos.applications-git
      self.modules.nixos.applications-kdeconnect
      self.modules.nixos.applications-multimedia
      self.modules.nixos.applications-office
      self.modules.nixos.applications-steam
      self.modules.nixos.applications-terminal
      self.modules.nixos.applications-vesktop
    ];

    home-manager.sharedModules = [
      self.modules.homeManager.stylix-colors
      self.modules.homeManager.applications-browser
      self.modules.homeManager.applications-vesktop
      self.modules.homeManager.applications-terminal-ghostty
      self.modules.homeManager.applications-terminal-btop
      self.modules.homeManager.applications-terminal-fastfetch
      self.modules.homeManager.applications-webapps
    ];

  };

}
