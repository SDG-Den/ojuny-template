/*
  @menu
  displayname = "Git";
  icon = "folder-remote-symbolic";
  order = 30;
  description = "Git and version control defaults";
  category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-git =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      # @option widget = "switch"; label = "Git"; group = "Git";
      programs.git.enable = true;

      # @option widget = "switch"; label = "Git LFS"; group = "Large files"; description = "Track large binaries with Git LFS.";
      programs.git.lfs.enable = false;

      # @option widget = "packages"; label = "Git packages"; group = "Git";
      environment.systemPackages = with pkgs; [
        git
        gh
        lazygit
        delta
      ];

      # Identity
      # @option widget = "text"; label = "Default branch"; group = "Identity";
      programs.git.config.init.defaultBranch = "main";

      # Behaviour
      # @option widget = "dropdown"; label = "Line endings"; group = "Behaviour"; choices = [ "input" "true" "false" ];
      programs.git.config.core.autocrlf = "input";

      # @option widget = "switch"; label = "Rebase on pull"; group = "Behaviour";
      programs.git.config.pull.rebase = false;

      # @option widget = "switch"; label = "Auto set upstream on push"; group = "Behaviour";
      programs.git.config.push.autoSetupRemote = true;

      # @option widget = "switch"; label = "Reuse conflict resolutions"; group = "Behaviour";
      programs.git.config.rerere.enabled = true;

      # @option widget = "dropdown"; label = "Conflict style"; group = "Behaviour"; choices = [ "merge" "diff3" "zdiff3" ];
      programs.git.config.merge.conflictstyle = "zdiff3";

      # Paging with delta
      # @option widget = "text"; label = "Pager"; group = "Paging";
      programs.git.config.core.pager = "delta";

      # @option widget = "switch"; label = "Delta line numbers"; group = "Paging";
      programs.git.config.delta.lineNumbers = true;

      # @option widget = "text"; label = "Delta decorations"; group = "Paging"; description = "Style for the +/- file decorations.";
      programs.git.config.delta.decorationStyle = "filebox";

      # Credentials, askpass and stores
      # @option widget = "text"; label = "Askpass helper"; group = "Credentials"; description = "Command that prompts for a password, e.g. ssh-askpass or systemd-askpass.";
      programs.git.config.core.askpass = "ssh-askpass";

      # @option widget = "dropdown"; label = "Credential helper"; group = "Credentials"; description = "Where stored credentials live."; choices = [ "cache" "cache --timeout=3600" "store" "libsecret" "!gh auth git-credential" ];
      programs.git.config.credential.helper = "cache";

      # @option widget = "switch"; label = "Store HTTP path"; group = "Credentials"; description = "Keep credentials per host and path, not just per host.";
      programs.git.config.credential.useHttpPath = false;

      # @option widget = "switch"; label = "GitHub credential helper"; group = "Credentials"; description = "Use gh to authenticate github.com over HTTPS.";
      programs.git.config.credential."https://github.com".helper = "!gh auth git-credential";

      # Your name and email are per-user, so they live in the templated per-user
      # file (modules/01-users/user.nix), not here.

    };

}
