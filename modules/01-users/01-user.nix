/* @menu
   displayname = "User";
   icon = "avatar-default-symbolic";
   order = 10;
   description = "The account this machine is used as";
   category = "01-Users";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.users-user = { config, lib, pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    options.users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options.ojunyShell = lib.mkOption {
          type = lib.types.enum [ "zsh" "bash" "fish" ];
          default = "zsh";
          description = "Login shell for this account.";
        };

        options.ojunyEditor = lib.mkOption {
          type = lib.types.str;
          default = "micro";
          description = "Default editor for this account.";
        };
      }));
    };

    config = {
    /* @option widget = "submodule"; label = "Account"; group = "Account"; */
    users.users.user = {
      /* @option widget = "text"; hidden = true; */
      isNormalUser = true;

      /* @option widget = "text"; label = "Description"; group = "Account";  applyCommand = "pkexec usermod -c %%val%% user"; */
      description = "Primary account";

      /* @option widget = "list"; label = "Extra groups"; group = "Account"; */
      extraGroups = [ "networkmanager" "wheel" "video" "input" ];

      /* @option widget = "text"; label = "Hashed password"; group = "Account"; advanced = true; description = "A \"!\" keeps the account locked until a password is set.";  applyCommand = "pkexec usermod -p %%val%% user"; */
      hashedPassword = "$y$j9T$E8EmnxzkCLsphRMZbqKW/1$estItGAST4R1l5OTZaSUJLWUYvlAEGVLRTGar5d0osC";

      /* @option widget = "list"; label = "SSH keys"; group = "Account"; */
      openssh.authorizedKeys.keys = [ ];

      /* @option widget = "dropdown"; label = "Shell"; group = "Account"; choices = [ "zsh" "bash" "fish" ];  applyCommand = "chsh -s \"$(command -v %%val%%)\" user"; */
      ojunyShell = "zsh";

      /* @option widget = "text"; label = "Editor"; group = "Account"; */
      ojunyEditor = "micro";

      /* @option widget = "text"; label = "Shell"; group = "Account"; hidden = true; */
      shell = pkgs.${config.users.users.user.ojunyShell};
    };

    home-manager.users.user.home.stateVersion = "25.05";

    # scripts/setup.sh fills in the home wiring for this account, e.g.
    # home-manager.users.user.imports = [ ... ];

    };

  };

}
