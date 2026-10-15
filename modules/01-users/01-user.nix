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

    /* @option widget = "switch"; label = "Mutable users"; group = "Account"; description = "Allow passwords and other account details to be changed at runtime."; */
    users.mutableUsers = true;

    /* @option widget = "submodule"; label = "den"; group = "Account"; */
    users.users.den = {
      /* @option widget = "switch"; label = "Normal user"; group = "Account"; */
      isNormalUser = true;

      /* @option widget = "text"; label = "Description"; group = "Account"; */
      description = "den";

      /* @option widget = "list"; label = "Extra groups"; group = "Account"; */
      extraGroups = [ "networkmanager" "wheel" ];

      /* @option widget = "text"; label = "Hashed password"; group = "Account"; advanced = true; description = "A \"!\" keeps the account locked until a password is set."; */
      hashedPassword = "!";

      /* @option widget = "list"; label = "SSH keys"; group = "Account"; */
      openssh.authorizedKeys.keys = [ ];
    };

    # scripts/setup.sh fills in the home wiring for this account, e.g.
    # home-manager.users.den.imports = [ ... ];

  };

}
