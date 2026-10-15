/* @menu
   displayname = "User";
   icon = "avatar-default-symbolic";
   order = 10;
   description = "The account this machine is used as";
   category = "Users";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.users-user = { config, pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    /* @option widget = "submodule"; label = "user"; group = "Account"; */
    users.users.user = {
      /* @option widget = "switch"; label = "Normal user"; group = "Account"; */
      isNormalUser = true;

      /* @option widget = "text"; label = "Description"; group = "Account"; */
      description = "user";

      /* @option widget = "list"; label = "Extra groups"; group = "Account"; */
      extraGroups = [ "networkmanager" "wheel" ];

      /* @option widget = "text"; label = "Hashed password"; group = "Account"; advanced = true; description = "A \"!\" keeps the account locked until a password is set."; */
      hashedPassword = "$y$j9T$E8EmnxzkCLsphRMZbqKW/1$estItGAST4R1l5OTZaSUJLWUYvlAEGVLRTGar5d0osC";

      /* @option widget = "list"; label = "SSH keys"; group = "Account"; */
      openssh.authorizedKeys.keys = [ ];
    };

    # scripts/setup.sh fills in the home wiring for this account, e.g.
    # home-manager.users.user.imports = [ ... ];

  };

}
