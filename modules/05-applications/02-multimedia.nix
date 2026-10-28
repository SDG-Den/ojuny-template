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
        player = lib.mkOption {
          type = lib.types.enum [
            "none"
            "mpv"
            "vlc"
            "haruna"
          ];
          default = "none";
          description = "Media player installed for local video and audio files.";
        };

        imageViewer = lib.mkEnableOption "the imv image viewer";
        obs = lib.mkEnableOption "OBS Studio";
        audacity = lib.mkEnableOption "Audacity";
        gimp = lib.mkEnableOption "GIMP";
      };

      config = {
        # @option widget = "horizontal-submodule"; label = "Applications"; group = "Apps"; groupOrder = 10;
        ojuny.apps.multimedia = {
          # @option widget = "dropdown"; label = "Media player"; choices = [ "none" "mpv" "vlc" "haruna" ]; description = "Media player installed for local video and audio files.";
          player = "none";
          # @option widget = "switch"; label = "Image viewer"; description = "Fast image viewer for common image formats.";
          imageViewer = true;
          # @option widget = "switch"; label = "OBS Studio"; description = "Video recording and live streaming.";
          obs = false;
          # @option widget = "switch"; label = "Audacity"; description = "Audio editor and recorder.";
          audacity = false;
          # @option widget = "switch"; label = "GIMP"; description = "Image editor and photo manipulation.";
          gimp = false;
        };

        xdg.mime.defaultApplications = lib.mkIf config.ojuny.apps.multimedia.imageViewer {
          "image/png" = lib.mkDefault "imv.desktop";
          "image/jpeg" = lib.mkDefault "imv.desktop";
          "image/gif" = lib.mkDefault "imv.desktop";
          "image/webp" = lib.mkDefault "imv.desktop";
          "image/avif" = lib.mkDefault "imv.desktop";
          "image/bmp" = lib.mkDefault "imv.desktop";
          "image/tiff" = lib.mkDefault "imv.desktop";
          "image/svg+xml" = lib.mkDefault "imv.desktop";
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
    let
      gpu = config.ojuny.gpu or "none";
      nvidia = builtins.elem gpu [
        "nvidia"
        "hybrid-intel-nvidia"
        "hybrid-amd-nvidia"
      ];
      obsPackage = if nvidia then pkgs.obs-studio.override { cudaSupport = true; } else pkgs.obs-studio;
    in
    {
      environment.systemPackages =
        lib.optionals (config.ojuny.apps.multimedia.player == "mpv") [ pkgs.mpv ]
        ++ lib.optionals (config.ojuny.apps.multimedia.player == "vlc") [ pkgs.vlc ]
        ++ lib.optionals (config.ojuny.apps.multimedia.player == "haruna") [ pkgs.haruna ]
        ++ lib.optionals config.ojuny.apps.multimedia.imageViewer [ pkgs.imv ]
        ++ lib.optionals config.ojuny.apps.multimedia.obs [ obsPackage ]
        ++ lib.optionals config.ojuny.apps.multimedia.audacity [ pkgs.audacity ]
        ++ lib.optionals config.ojuny.apps.multimedia.gimp [ pkgs.gimp ];
    };

}
