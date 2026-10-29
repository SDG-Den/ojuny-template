/*
  @menu
  displayname = "Dux tools";
  icon = "applications-utilities-symbolic";
  order = 10;
  description = "Search, files, calendar and system resource settings";
  category = "06-Utility";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dux-tools =
    { config, lib, ... }:
    {
      options.ojuny.tools.dsearch = {
        enable = lib.mkEnableOption "the dsearch indexer";
        indexPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "~" ];
          description = "Paths indexed by dsearch.";
        };
        maxDepth = lib.mkOption {
          type = lib.types.int;
          default = 6;
          description = "Maximum directory depth per index path. 0 means unlimited.";
        };
        excludeHidden = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Skip hidden files and directories.";
        };
        extractExif = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Extract EXIF metadata from images.";
        };
        workerCount = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Number of indexing workers.";
        };
        httpEnabled = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the unauthenticated HTTP API.";
        };
        maxFileBytes = lib.mkOption {
          type = lib.types.int;
          default = 2097152;
          description = "Largest file dsearch indexes, in bytes.";
        };
      };

      options.ojuny.tools.duxFiles = {
        themeMode = lib.mkOption {
          type = lib.types.enum [ "auto" "dark" "light" ];
          default = "auto";
          description = "Dux Files theme mode.";
        };
        defaultView = lib.mkOption {
          type = lib.types.enum [ "list" "grid" ];
          default = "list";
          description = "Default file view.";
        };
        showHidden = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Show hidden files.";
        };
        foldersFirst = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Sort folders before files.";
        };
        confirmTrash = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Ask before moving files to the trash.";
        };
        terminal = lib.mkOption {
          type = lib.types.str;
          default = "ghostty";
          description = "Terminal Dux Files opens.";
        };
        registerFileManager = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Register Dux Files as the session file manager.";
        };
        recentFiles = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show recent files.";
        };
        searchExcludes = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Names or paths excluded from search.";
        };
      };

      options.ojuny.tools.calendar = {
        enable = lib.mkEnableOption "Dux Calendar";
        timeFormat = lib.mkOption {
          type = lib.types.enum [ "auto" "12h" "24h" ];
          default = "auto";
          description = "Clock format.";
        };
        firstDayOfWeek = lib.mkOption {
          type = lib.types.int;
          default = -1;
          description = "First day of the week, 0 Sunday to 6 Saturday. -1 follows the locale.";
        };
        defaultView = lib.mkOption {
          type = lib.types.enum [ "month" "week" "day" "agenda" ];
          default = "month";
          description = "View opened at startup.";
        };
        remindersEnabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable event reminders.";
        };
        defaultReminderMinutes = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = "Default reminder lead time in minutes.";
        };
        snoozeMinutes = lib.mkOption {
          type = lib.types.int;
          default = 5;
          description = "Default snooze time in minutes.";
        };
        notificationSounds = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Play a sound with reminders.";
        };
        syncIntervalMinutes = lib.mkOption {
          type = lib.types.int;
          default = 30;
          description = "Background sync interval in minutes.";
        };
        showWeekNumbers = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Show week numbers.";
        };
      };

      options.ojuny.tools.gop = {
        enable = lib.mkEnableOption "the standalone dgop HTTP API";
        apiPort = lib.mkOption {
          type = lib.types.port;
          default = 63484;
          description = "Port for the dgop HTTP API.";
        };
      };

      config = {
        # @option widget = "switch"; label = "Enable dsearch"; group = "Search"; groupOrder = 10; order = 10; description = "Run the dsearch indexer as a user service.";
        ojuny.tools.dsearch.enable = true;

        # @option widget = "list"; label = "Index paths"; group = "Search"; groupOrder = 10; order = 20; itemLabel = "Path"; addLabel = "Add path"; description = "Paths indexed by dsearch.";
        ojuny.tools.dsearch.indexPaths = [ "~" ];

        # @option widget = "spin"; label = "Max depth"; group = "Search"; groupOrder = 10; order = 30; min = 0; max = 64; description = "Maximum directory depth per index path. 0 means unlimited.";
        ojuny.tools.dsearch.maxDepth = 6;

        # @option widget = "switch"; label = "Exclude hidden"; group = "Search"; groupOrder = 10; order = 40;
        ojuny.tools.dsearch.excludeHidden = true;

        # @option widget = "switch"; label = "Extract EXIF"; group = "Search"; groupOrder = 10; order = 50;
        ojuny.tools.dsearch.extractExif = true;

        # @option widget = "spin"; label = "Workers"; group = "Search"; groupOrder = 10; order = 60; min = 1; max = 32;
        ojuny.tools.dsearch.workerCount = 4;

        # @option widget = "switch"; label = "HTTP API"; group = "Search"; groupOrder = 10; order = 70; description = "The HTTP API has no authentication. Leave off unless another client needs it.";
        ojuny.tools.dsearch.httpEnabled = false;

        # @option widget = "spin"; label = "Max file size"; group = "Search"; groupOrder = 10; order = 80; min = 1024; max = 1073741824; step = 1024; unit = "B"; 
        ojuny.tools.dsearch.maxFileBytes = 2097152;

        # @option widget = "dropdown"; label = "Theme"; group = "Files"; groupOrder = 20; order = 10; choices = [ "auto" "dark" "light" ];
        ojuny.tools.duxFiles.themeMode = "auto";

        # @option widget = "dropdown"; label = "Default view"; group = "Files"; groupOrder = 20; order = 20; choices = [ "list" "grid" ];
        ojuny.tools.duxFiles.defaultView = "list";

        # @option widget = "switch"; label = "Show hidden files"; group = "Files"; groupOrder = 20; order = 30;
        ojuny.tools.duxFiles.showHidden = false;

        # @option widget = "switch"; label = "Folders first"; group = "Files"; groupOrder = 20; order = 40;
        ojuny.tools.duxFiles.foldersFirst = true;

        # @option widget = "switch"; label = "Confirm trash"; group = "Files"; groupOrder = 20; order = 50;
        ojuny.tools.duxFiles.confirmTrash = false;

        # @option widget = "text"; label = "Terminal"; group = "Files"; groupOrder = 20; order = 60;
        ojuny.tools.duxFiles.terminal = "ghostty";

        # @option widget = "switch"; label = "Register file manager"; group = "Files"; groupOrder = 20; order = 70;
        ojuny.tools.duxFiles.registerFileManager = true;

        # @option widget = "switch"; label = "Recent files"; group = "Files"; groupOrder = 20; order = 80;
        ojuny.tools.duxFiles.recentFiles = true;

        # @option widget = "list"; label = "Search excludes"; group = "Files"; groupOrder = 20; order = 90; advanced = true; itemLabel = "Name or path"; addLabel = "Add exclude";
        ojuny.tools.duxFiles.searchExcludes = [ ];

        # @option widget = "switch"; label = "Enable Dux Calendar"; group = "Calendar"; groupOrder = 30; order = 10; description = "Run the calendar daemon and install its session service.";
        ojuny.tools.calendar.enable = true;

        # @option widget = "dropdown"; label = "Time format"; group = "Calendar"; groupOrder = 30; order = 20; choices = [ "auto" "12h" "24h" ];
        ojuny.tools.calendar.timeFormat = "auto";

        # @option widget = "dropdown"; label = "First day of week"; group = "Calendar"; groupOrder = 30; order = 30; choices = [ "-1" "0" "1" "2" "3" "4" "5" "6" ]; description = "-1 follows the locale, 0 Sunday to 6 Saturday.";
        ojuny.tools.calendar.firstDayOfWeek = -1;

        # @option widget = "dropdown"; label = "Default view"; group = "Calendar"; groupOrder = 30; order = 40; choices = [ "month" "week" "day" "agenda" ];
        ojuny.tools.calendar.defaultView = "month";

        # @option widget = "switch"; label = "Reminders"; group = "Calendar"; groupOrder = 30; order = 50;
        ojuny.tools.calendar.remindersEnabled = true;

        # @option widget = "spin"; label = "Default reminder"; group = "Calendar"; groupOrder = 30; order = 60; min = 0; max = 1440; unit = "min";
        ojuny.tools.calendar.defaultReminderMinutes = 10;

        # @option widget = "spin"; label = "Snooze"; group = "Calendar"; groupOrder = 30; order = 70; min = 1; max = 1440; unit = "min";
        ojuny.tools.calendar.snoozeMinutes = 5;

        # @option widget = "switch"; label = "Notification sounds"; group = "Calendar"; groupOrder = 30; order = 80;
        ojuny.tools.calendar.notificationSounds = false;

        # @option widget = "spin"; label = "Sync interval"; group = "Calendar"; groupOrder = 30; order = 90; min = 1; max = 1440; unit = "min";
        ojuny.tools.calendar.syncIntervalMinutes = 30;

        # @option widget = "switch"; label = "Week numbers"; group = "Calendar"; groupOrder = 30; order = 100;
        ojuny.tools.calendar.showWeekNumbers = false;

        # @option widget = "switch"; label = "dgop HTTP API"; group = "System resources"; groupOrder = 40; order = 10; description = "Dux Shell uses the embedded dgop library. Enable this only for clients that call the HTTP API.";
        ojuny.tools.gop.enable = false;

        # @option widget = "spin"; label = "API port"; group = "System resources"; groupOrder = 40; order = 20; min = 1024; max = 65535; visibleWhen.path = "ojuny.tools.gop.enable"; visibleWhen.equals = true;
        ojuny.tools.gop.apiPort = 63484;

        home-manager.sharedModules = [ self.modules.homeManager.dux-tools ];
      };
    };

  flake.modules.homeManager.dux-tools =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    let
      tools = osConfig.ojuny.tools or { };
      dsearch = tools.dsearch or { };
      duxFiles = tools.duxFiles or { };
      calendar = tools.calendar or { };
      gop = tools.gop or { };
      dgop = inputs.ojuny-desktop.inputs.dux-gop.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      imports = [
        inputs.ojuny-desktop.inputs.dux-search.homeModules.default
        inputs.ojuny-desktop.inputs.dux-calendar.homeModules.default
      ];

      config = {
        programs.dsearch = lib.mkIf (dsearch.enable or false) {
          enable = true;
          config = {
            http_enabled = dsearch.httpEnabled or false;
            max_file_bytes = dsearch.maxFileBytes or 2097152;
            worker_count = dsearch.workerCount or 4;
            index_all_files = true;
            index_paths = map (path: {
              inherit path;
              max_depth = dsearch.maxDepth or 6;
              exclude_hidden = dsearch.excludeHidden or true;
              extract_exif = dsearch.extractExif or true;
            }) (dsearch.indexPaths or [ "~" ]);
          };
        };

        programs.dank-calendar = lib.mkIf (calendar.enable or false) {
          enable = true;
          settings = {
            timeFormat = calendar.timeFormat or "auto";
            firstDayOfWeek = calendar.firstDayOfWeek or -1;
            lastView = calendar.defaultView or "month";
            remindersEnabled = calendar.remindersEnabled or true;
            defaultReminderMinutes = calendar.defaultReminderMinutes or 10;
            snoozeMinutes = calendar.snoozeMinutes or 5;
            notificationSounds = calendar.notificationSounds or false;
            syncIntervalMinutes = calendar.syncIntervalMinutes or 30;
            showWeekNumbers = calendar.showWeekNumbers or false;
          };
        };

        xdg.configFile."dfiles/ui-settings.json".text = builtins.toJSON {
          themeMode = duxFiles.themeMode or "auto";
          defaultView = duxFiles.defaultView or "list";
          showHidden = duxFiles.showHidden or false;
          foldersFirst = duxFiles.foldersFirst or true;
          confirmTrash = duxFiles.confirmTrash or false;
          terminal = duxFiles.terminal or "ghostty";
          registerFileManager = duxFiles.registerFileManager or true;
          recentFiles = duxFiles.recentFiles or true;
          searchExcludes = duxFiles.searchExcludes or [ ];
        };

        systemd.user.services.dgop = lib.mkIf (gop.enable or false) {
          Unit = {
            Description = "dgop system resource API";
            After = [ "network.target" ];
          };
          Service = {
            ExecStart = "${dgop}/bin/dgop server";
            Environment = "API_PORT=:${toString (gop.apiPort or 63484)}";
            Restart = "on-failure";
            RestartSec = "2";
          };
          Install.WantedBy = [ "default.target" ];
        };
      };
    };

}
