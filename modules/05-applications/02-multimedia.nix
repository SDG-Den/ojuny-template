/*
  @menu
  displayname = "Multimedia";
  icon = "applications-multimedia-symbolic";
  order = 20;
  description = "Video, audio and image applications";
  category = "05-Applications";
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
      imports = [ self.modules.nixos.applications-multimedia-apps ];

      options.ojuny.apps.multimedia = {
        mpv = lib.mkEnableOption "the mpv media player";
        obs = lib.mkEnableOption "OBS Studio";
        audacity = lib.mkEnableOption "Audacity";
        gimp = lib.mkEnableOption "GIMP";
      };

      config = {
        # @option widget = "horizontal-submodule"; label = "Applications"; group = "Apps"; groupOrder = 10;
        ojuny.apps.multimedia = {
          /* @option widget = "switch"; label = "mpv"; description = "Minimalist media player for video and audio."; */
          mpv = false;
          /* @option widget = "switch"; label = "OBS Studio"; description = "Video recording and live streaming."; */
          obs = false;
          /* @option widget = "switch"; label = "Audacity"; description = "Audio editor and recorder."; */
          audacity = false;
          /* @option widget = "switch"; label = "GIMP"; description = "Image editor and photo manipulation."; */
          gimp = false;
        };

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
