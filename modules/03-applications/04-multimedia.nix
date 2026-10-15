/*
  @menu
  displayname = "Multimedia";
  icon = "applications-multimedia-symbolic";
  order = 40;
  description = "Video, audio and image applications";
  category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-multimedia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.ojuny.apps.multimedia = {
        mpv = lib.mkEnableOption "the mpv media player";
        obs = lib.mkEnableOption "OBS Studio";
        audacity = lib.mkEnableOption "Audacity";
        gimp = lib.mkEnableOption "GIMP";
      };

      config = {
        # @option widget = "switch"; label = "mpv"; group = "Multimedia";
        ojuny.apps.multimedia.mpv = false;

        # @option widget = "switch"; label = "OBS Studio"; group = "Multimedia";
        ojuny.apps.multimedia.obs = false;

        # @option widget = "switch"; label = "Audacity"; group = "Multimedia";
        ojuny.apps.multimedia.audacity = false;

        # @option widget = "switch"; label = "GIMP"; group = "Multimedia";
        ojuny.apps.multimedia.gimp = false;

        # @option widget = "packages"; label = "Multimedia tools"; group = "Tools";
        environment.systemPackages = with pkgs; [
          ffmpeg
          imagemagick
          yt-dlp
        ];
      };
    };

  # Optional apps are installed conditionally. No @option, so the tools list
  # above stays a plain literal the GUI can render.
  flake.modules.nixos.applications-multimedia-apps =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages =
        lib.optionals config.ojuny.apps.multimedia.mpv [ pkgs.mpv ]
        ++ lib.optionals config.ojuny.apps.multimedia.obs [ pkgs.obs-studio ]
        ++ lib.optionals config.ojuny.apps.multimedia.audacity [ pkgs.audacity ]
        ++ lib.optionals config.ojuny.apps.multimedia.gimp [ pkgs.gimp ];
    };

}
