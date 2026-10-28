/* @menu
   displayname = "User";
   icon = "avatar-default-symbolic";
   order = 10;
   description = "The account this machine is used as";
   category = "01-Users";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.users-user = { pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    config = {
      /* @option widget = "users"; label = "Accounts"; */
      users.users = {
        user = {
          isNormalUser = true;
          uid = 1000;
          description = "Primary account";
          extraGroups = [ "networkmanager" "wheel" "video" "input" ];
          hashedPassword = "$y$j9T$E8EmnxzkCLsphRMZbqKW/1$estItGAST4R1l5OTZaSUJLWUYvlAEGVLRTGar5d0osC";
          openssh.authorizedKeys.keys = [ ];
          shell = pkgs.zsh;
        };
      };

      home-manager.users.user.home.stateVersion = "25.05";

      # scripts/setup.sh fills in the home wiring for this account, e.g.
      # home-manager.users.user.imports = [ ... ];
    };

  };

}
