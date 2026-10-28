{ lib, ... }: {

  flake.modules.homeManager.users-user-editor = {
    home.sessionVariables.EDITOR = lib.mkDefault "micro";
  };

}
