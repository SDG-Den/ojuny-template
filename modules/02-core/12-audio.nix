/*
  @menu
  displayname = "Audio";
  icon = "audio-card-symbolic";
  order = 25;
  description = "PipeWire audio server, clock and JACK compatibility";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-audio =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.ojuny.audio;
    in
    {

      options.ojuny.audio = {
        enable = lib.mkEnableOption "PipeWire audio";

        sampleRate = lib.mkOption {
          type = lib.types.enum [
            44100
            48000
            88200
            96000
          ];
          default = 48000;
          description = "Default PipeWire clock rate.";
        };

        quantum = lib.mkOption {
          type = lib.types.ints.between 32 2048;
          default = 1024;
          description = "Default PipeWire quantum in frames. Lower values reduce latency at the cost of CPU and xrun risk.";
        };

        jack = lib.mkEnableOption "PipeWire JACK compatibility";
      };

          # @option widget = "switch"; label = "PipeWire audio"; group = "Audio"; groupOrder = 10; order = 10; description = "Run PipeWire as the audio server with ALSA and PulseAudio compatibility.";
          ojuny.audio.enable = true;

          # @option widget = "dropdown"; label = "Sample rate"; group = "Audio"; groupOrder = 10; order = 20; choices = [ "44100" "48000" "88200" "96000" ]; visibleWhen.path = "ojuny.audio.enable"; visibleWhen.equals = true; description = "Default PipeWire clock rate. 48000 is the normal desktop default.";
          ojuny.audio.sampleRate = 48000;

          # @option widget = "spin"; label = "Quantum"; group = "Audio"; groupOrder = 10; order = 30; min = 32; max = 2048; step = 32; visibleWhen.path = "ojuny.audio.enable"; visibleWhen.equals = true; description = "Default PipeWire buffer size in frames. 1024 is safe for desktop use; lower values reduce latency.";
          ojuny.audio.quantum = 1024;

          # @option widget = "switch"; label = "JACK compatibility"; group = "Audio"; groupOrder = 20; order = 10; visibleWhen.path = "ojuny.audio.enable"; visibleWhen.equals = true; description = "Provide the PipeWire JACK emulation layer. Do not enable a separate jackd service.";
          ojuny.audio.jack = false;

      config = lib.mkIf cfg.enable {
          services.pulseaudio.enable = false;

          services.pipewire = {
            enable = true;

            audio.enable = true;

            alsa.enable = true;
            alsa.support32Bit = true;

            pulse.enable = true;

            jack.enable = cfg.jack;

            wireplumber.enable = true;

            extraConfig.pipewire."10-ojuny-clock" = {
              "context.properties" = {
                "default.clock.rate" = cfg.sampleRate;
                "default.clock.allowed-rates" = [ cfg.sampleRate ];
                "default.clock.quantum" = cfg.quantum;
                "default.clock.min-quantum" = 32;
                "default.clock.max-quantum" = 2048;
              };
            };
          };

          security.rtkit.enable = true;

          environment.systemPackages = with pkgs; [
            alsa-utils
            pavucontrol
          ];
      };
    };

}
