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
          "nvidia"
          "amd"
          "modesetting"
        ];
        default = "modesetting";
        description = "Graphics vendor. Drives the kernel video drivers and the vendor-specific options.";
      };

      config = {

        # @option widget = "dropdown"; label = "GPU vendor"; group = "Graphics"; description = "intel and modesetting both use the modesetting driver."; choices = [ "intel" "nvidia" "amd" "modesetting" ];
        ojuny.gpu = "modesetting";

        # @option widget = "switch"; label = "Graphics acceleration"; group = "Graphics";
        hardware.graphics.enable = true;

        # @option widget = "switch"; label = "32-bit graphics"; group = "Graphics"; description = "Needed for 32-bit games and Wine.";
        hardware.graphics.enable32Bit = false;

        # Kernel drivers are derived from the GPU vendor selection above.
        services.xserver.videoDrivers =
          {
            intel = [ "modesetting" ];
            modesetting = [ "modesetting" ];
            nvidia = [ "nvidia" ];
            amd = [ "amdgpu" ];
          }
          .${config.ojuny.gpu};

        # @option widget = "switch"; label = "NVIDIA open kernel module"; group = "NVIDIA"; description = "Turn off for older cards that need the proprietary module."; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "nvidia";
        hardware.nvidia.open = false;

        # @option widget = "switch"; label = "NVIDIA modesetting"; group = "NVIDIA"; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "nvidia";
        hardware.nvidia.modesetting.enable = true;

        # @option widget = "switch"; label = "AMDGPU in initrd"; group = "AMD"; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "amd";
        hardware.amdgpu.initrd.enable = false;

        # @option widget = "switch"; label = "Redistributable firmware"; group = "Firmware";
        hardware.enableRedistributableFirmware = true;

        # @option widget = "text"; label = "VA-API driver"; group = "Firmware"; description = "iHD for Intel, radeonsi for AMD.";
        environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

      };

    };

}
