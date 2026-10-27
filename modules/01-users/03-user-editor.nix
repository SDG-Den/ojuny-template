{ self, inputs, ... }: {

  flake.modules.homeManager.users-user-editor =
    { config, lib, osConfig ? { }, ... }:
    {
      home.sessionVariables.EDITOR =
        osConfig.users.users.${config.home.username}.ojunyEditor or "micro";
    };

}
