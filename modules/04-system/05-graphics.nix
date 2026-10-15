/*
  @menu
  displayname = "Graphics";
  icon = "hardware-driver-symbolic";
  order = 50;
  description = "Graphics drivers and hardware acceleration";
  category = "System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-graphics =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      options.ojuny.gpu = lib.mkOption {
        type = lib.types.enum [
          "intel"
          "amd"
          "nvidia"
        ];
        default = "intel";
        description = "Graphics vendor. Drives the kernel video drivers, the vendor extras and the VA-API backend.";
      };

      config = {

        # @option widget = "dropdown"; label = "GPU vendor"; group = "Graphics"; description = "Intel covers Intel GPUs and generic modesetting."; choices = [ "intel" "amd" "nvidia" ];
        ojuny.gpu = "intel";

        # @option widget = "switch"; label = "Graphics acceleration"; group = "Graphics";
        hardware.graphics.enable = true;

        # @option widget = "switch"; label = "32-bit graphics"; group = "Graphics"; description = "Needed for 32-bit games and Wine.";
        hardware.graphics.enable32Bit = false;

        # @option widget = "switch"; label = "Redistributable firmware"; group = "Graphics"; description = "Firmware blobs for Wi-Fi, GPUs and other devices.";
        hardware.enableRedistributableFirmware = true;

        # Intel
        # @option widget = "packages"; label = "Intel media packages"; group = "Intel"; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "intel"; description = "intel-media-driver (VA-API/iHD), vpl-gpu-rt (oneVPL) and intel-compute-runtime (OpenCL) for Xe and Arc GPUs.";
        hardware.graphics.extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
          intel-compute-runtime
        ];

        # @option widget = "list"; label = "Kernel parameters"; group = "Intel"; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "intel"; description = "Helps VA-API and QSV initialise on Arc and Xe GPUs.";
        boot.kernelParams = [ "i915.enable_guc=3" ];

        # AMD
        # @option widget = "switch"; label = "AMDGPU in initrd"; group = "AMD"; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "amd";
        hardware.amdgpu.initrd.enable = true;

        # NVIDIA
        # @option widget = "switch"; label = "NVIDIA open kernel module"; group = "NVIDIA"; description = "Turn off for older cards that need the proprietary module."; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "nvidia";
        hardware.nvidia.open = false;

        # @option widget = "switch"; label = "NVIDIA modesetting"; group = "NVIDIA"; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "nvidia";
        hardware.nvidia.modesetting.enable = true;

        # Kernel drivers and the VA-API backend follow the vendor selection.
        services.xserver.videoDrivers =
          {
            intel = [ "modesetting" ];
            amd = [ "amdgpu" ];
            nvidia = [ "nvidia" ];
          }
          .${config.ojuny.gpu};

        environment.sessionVariables = lib.mkIf (config.ojuny.gpu != "nvidia") {
          LIBVA_DRIVER_NAME =
            {
              intel = "iHD";
              amd = "radeonsi";
            }
            .${config.ojuny.gpu};
        };

      };

    };

}
