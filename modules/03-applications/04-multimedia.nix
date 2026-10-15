/* @menu
   displayname = "Multimedia";
   icon = "applications-multimedia-symbolic";
   order = 40;
   description = "Video, audio and image applications";
   category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-multimedia = { config, pkgs, ... }: {

    # NOTE: video/audio/image applications (e.g. mpv, obs, audacity, gimp)
    # and any codec/font packages they need.

  };

}
