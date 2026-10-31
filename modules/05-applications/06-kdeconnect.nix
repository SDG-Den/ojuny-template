/*
  @menu
  displayname = "KDE Connect";
  icon = "phone-symbolic";
  order = 60;
  description = "KDE Connect integration";
  category = "05-Applications";
  hidden = true;
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-kdeconnect = { pkgs, lib, ... }: {
    # @option widget = "switch"; label = "KDE Connect"; group = "KDE Connect"; groupOrder = 10; order = 1; description = "Phone notifications, file transfer and remote input.";
    programs.kdeconnect.enable = true;

    # themed fork of KDE Connect used by stylix; parity with dendrite desktop-svc.nix.
    programs.kdeconnect.package = lib.mkDefault pkgs.valent;

    # valent's sftp plugin mounts the device under /run/user/<uid>/gvfs and runs
    # `ssh-add` to register the device key, so gvfs and a reachable agent are required.
    services.gvfs.enable = true;
    programs.ssh.startAgent = true;
    environment.etc."environment.d/50-ssh-agent.conf".text = ''
      SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
    '';

  };

}
