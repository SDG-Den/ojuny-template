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
    let
      viewerDesktop =
        {
          imv = "imv.desktop";
          qimgv = "qimgv.desktop";
          gwenview = "org.kde.gwenview.desktop";
        }
        .${config.ojuny.apps.multimedia.imageViewer} or null;
    in
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

        imageViewer = lib.mkOption {
          type = lib.types.enum [
            "none"
            "imv"
            "qimgv"
            "gwenview"
          ];
          default = "imv";
          description = "Image viewer installed for common image formats.";
        };

        obs = lib.mkEnableOption "OBS Studio";
        audacity = lib.mkEnableOption "Audacity";
        gimp = lib.mkEnableOption "GIMP";
      };

      config = {
        # @option widget = "horizontal-submodule"; label = "Viewers"; group = "Viewers"; groupOrder = 10;
        ojuny.apps.multimedia = {
          # @option widget = "dropdown"; label = "Media player"; choices = [ "none" "mpv" "vlc" "haruna" ]; description = "Media player installed for local video and audio files.";
          player = "none";
          # @option widget = "dropdown"; label = "Image viewer"; choices = [ "none" "imv" "qimgv" "gwenview" ]; description = "Image viewer for common image formats.";
          imageViewer = "imv";
        };

        # @option widget = "horizontal-submodule"; label = "Tools"; group = "Tools"; groupOrder = 20;
        ojuny.apps.multimedia = {
          # @option widget = "switch"; label = "OBS Studio"; group = "Tools"; groupOrder = 20;
          obs = false;
          # @option widget = "switch"; label = "Audacity"; group = "Tools"; groupOrder = 20;
          audacity = false;
          # @option widget = "switch"; label = "GIMP"; group = "Tools"; groupOrder = 20;
          gimp = false;
        };

        xdg.mime.defaultApplications = lib.mkIf (viewerDesktop != null) {
          "image/png" = lib.mkDefault viewerDesktop;
          "image/jpeg" = lib.mkDefault viewerDesktop;
          "image/gif" = lib.mkDefault viewerDesktop;
          "image/webp" = lib.mkDefault viewerDesktop;
          "image/avif" = lib.mkDefault viewerDesktop;
          "image/bmp" = lib.mkDefault viewerDesktop;
          "image/tiff" = lib.mkDefault viewerDesktop;
          "image/svg+xml" = lib.mkDefault viewerDesktop;
        };

        # @option widget = "packages"; label = "Multimedia tools"; group = "Tools"; groupOrder = 20;
        environment.systemPackages = with pkgs; [
          ffmpeg
          imagemagick
          yt-dlp
          satty
        ];
      };
    };

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
      viewerPackage =
        {
          imv = pkgs.imv;
          qimgv = pkgs.qimgv;
          gwenview = pkgs.kdePackages.gwenview;
        }
        .${config.ojuny.apps.multimedia.imageViewer} or null;
    in
    {
      environment.systemPackages =
        lib.optionals (config.ojuny.apps.multimedia.player == "mpv") [ pkgs.mpv ]
        ++ lib.optionals (config.ojuny.apps.multimedia.player == "vlc") [ pkgs.vlc ]
        ++ lib.optionals (config.ojuny.apps.multimedia.player == "haruna") [ pkgs.haruna ]
        ++ lib.optional (viewerPackage != null) viewerPackage
        ++ lib.optionals config.ojuny.apps.multimedia.obs [ obsPackage ]
        ++ lib.optionals config.ojuny.apps.multimedia.audacity [ pkgs.audacity ]
        ++ lib.optionals config.ojuny.apps.multimedia.gimp [ pkgs.gimp ];
    };

}
