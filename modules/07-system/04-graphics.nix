/*
  @menu
  displayname = "Graphics";
  icon = "hardware-driver-symbolic";
  order = 40;
  description = "Graphics drivers and hardware acceleration";
  category = "07-System";
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
          "hybrid-intel-nvidia"
          "hybrid-amd-nvidia"
          "none"
        ];
        default = "intel";
        description = "Graphics vendor. Drives the kernel video drivers, the vendor extras and the VA-API backend.";
      };

      options.ojuny.gpuBusIds = {
        intel = lib.mkOption {
          type = lib.types.str;
          default = "PCI:0:2:0";
        };
        amd = lib.mkOption {
          type = lib.types.str;
          default = "PCI:5:0:0";
        };
        nvidia = lib.mkOption {
          type = lib.types.str;
          default = "PCI:1:0:0";
        };
      };

      config = {

        # @option widget = "dropdown"; label = "GPU vendor"; group = "Graphics"; groupOrder = 10; order = 10; description = "Intel covers Intel GPUs and generic modesetting. Use none for a VM or a machine without a usable GPU: it enables software rendering, allows the wlroots software renderer and switches Qt to the basic render loop."; choices = [ "intel" "amd" "nvidia" "hybrid-intel-nvidia" "hybrid-amd-nvidia" "none" ];
        ojuny.gpu = "intel";

        # @option widget = "text"; label = "Intel bus ID"; group = "Hybrid"; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "hybrid-intel-nvidia" ];
        ojuny.gpuBusIds.intel = "PCI:0:2:0";

        # @option widget = "text"; label = "AMD bus ID"; group = "Hybrid"; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "hybrid-amd-nvidia" ];
        ojuny.gpuBusIds.amd = "PCI:5:0:0";

        # @option widget = "text"; label = "NVIDIA bus ID"; group = "Hybrid"; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "hybrid-intel-nvidia" "hybrid-amd-nvidia" ];
        ojuny.gpuBusIds.nvidia = "PCI:1:0:0";

        # @option widget = "switch"; label = "Graphics acceleration"; group = "Graphics"; groupOrder = 10; order = 20;
        hardware.graphics.enable = true;

        # @option widget = "switch"; label = "32-bit graphics"; group = "Graphics"; groupOrder = 10; order = 30; description = "Install 32-bit graphics libraries for 32-bit games and Wine. Steam forces this on while Steam is enabled, so this switch only affects 32-bit software used outside Steam.";
        hardware.graphics.enable32Bit = lib.mkDefault false;

        # @option widget = "switch"; label = "Redistributable firmware"; group = "Graphics"; groupOrder = 10; order = 40; description = "Firmware blobs for Wi-Fi, GPUs and other devices.";
        hardware.enableRedistributableFirmware = true;

        # Intel
        # @option widget = "packages"; label = "Intel media packages"; group = "Intel"; groupOrder = 20; order = 10; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "intel" "hybrid-intel-nvidia" ]; description = "intel-media-driver (VA-API/iHD), vpl-gpu-rt (oneVPL) and intel-compute-runtime (OpenCL) for Xe and Arc GPUs.";
        hardware.graphics.extraPackages =
          lib.mkIf
            (builtins.elem config.ojuny.gpu [
              "intel"
              "hybrid-intel-nvidia"
            ])
            (
              with pkgs;
              [
                intel-media-driver
                vpl-gpu-rt
                intel-compute-runtime
              ]
            );

        # @option widget = "list"; label = "Kernel parameters"; group = "Intel"; groupOrder = 20; order = 20; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "intel" "hybrid-intel-nvidia" ]; description = "Helps VA-API and QSV initialise on Arc and Xe GPUs.";
        boot.kernelParams = lib.mkIf (builtins.elem config.ojuny.gpu [
          "intel"
          "hybrid-intel-nvidia"
        ]) [ "i915.enable_guc=3" ];

        # AMD
        # @option widget = "switch"; label = "AMDGPU in initrd"; group = "AMD"; groupOrder = 30; order = 10; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "amd" "hybrid-amd-nvidia" ];
        hardware.amdgpu.initrd.enable = lib.mkIf (builtins.elem config.ojuny.gpu [
          "amd"
          "hybrid-amd-nvidia"
        ]) true;

        # NVIDIA
        # @option widget = "switch"; label = "NVIDIA open kernel module"; group = "NVIDIA"; groupOrder = 40; order = 10; description = "Turn off for older cards that need the proprietary module."; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "nvidia" "hybrid-intel-nvidia" "hybrid-amd-nvidia" ];
        hardware.nvidia.open = lib.mkIf (builtins.elem config.ojuny.gpu [
          "nvidia"
          "hybrid-intel-nvidia"
          "hybrid-amd-nvidia"
        ]) false;

        # @option widget = "switch"; label = "NVIDIA modesetting"; group = "NVIDIA"; groupOrder = 40; order = 20; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "nvidia" "hybrid-intel-nvidia" "hybrid-amd-nvidia" ];
        hardware.nvidia.modesetting.enable = lib.mkIf (builtins.elem config.ojuny.gpu [
          "nvidia"
          "hybrid-intel-nvidia"
          "hybrid-amd-nvidia"
        ]) true;

        hardware.nvidia.prime.offload.enable = lib.mkIf (lib.hasPrefix "hybrid-" config.ojuny.gpu) true;
        hardware.nvidia.prime.offload.enableOffloadCmd =
          lib.mkIf (lib.hasPrefix "hybrid-" config.ojuny.gpu) true;
        hardware.nvidia.prime.nvidiaBusId = lib.mkIf (lib.hasPrefix "hybrid-" config.ojuny.gpu) config.ojuny.gpuBusIds.nvidia;
        hardware.nvidia.prime.intelBusId = lib.mkIf (
          config.ojuny.gpu == "hybrid-intel-nvidia"
        ) config.ojuny.gpuBusIds.intel;
        hardware.nvidia.prime.amdgpuBusId = lib.mkIf (
          config.ojuny.gpu == "hybrid-amd-nvidia"
        ) config.ojuny.gpuBusIds.amd;

        # Kernel drivers and the VA-API backend follow the vendor selection.
        services.xserver.videoDrivers =
          {
            intel = [ "modesetting" ];
            amd = [ "amdgpu" ];
            nvidia = [ "nvidia" ];
            hybrid-intel-nvidia = [
              "modesetting"
              "nvidia"
            ];
            hybrid-amd-nvidia = [
              "amdgpu"
              "nvidia"
            ];
            none = [ "modesetting" ];
          }
          .${config.ojuny.gpu};

        environment.sessionVariables = lib.mkMerge [
          (lib.mkIf (config.ojuny.gpu == "none") {
            WLR_RENDERER_ALLOW_SOFTWARE = "1";
            QSG_RENDER_LOOP = "basic";
          })
          (lib.mkIf (config.ojuny.gpu != "none") {
            QSG_RENDER_LOOP = "threaded";
          })
          (lib.mkIf
            (builtins.elem config.ojuny.gpu [
              "intel"
              "hybrid-intel-nvidia"
            ])
            {
              LIBVA_DRIVER_NAME = "iHD";
            }
          )
          (lib.mkIf
            (builtins.elem config.ojuny.gpu [
              "amd"
              "hybrid-amd-nvidia"
            ])
            {
              LIBVA_DRIVER_NAME = "radeonsi";
            }
          )
        ];

      };

    };

}
