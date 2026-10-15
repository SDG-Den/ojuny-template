/*
  @menu
  displayname = "Plugins";
  icon = "application-x-addon-symbolic";
  order = 110;
  description = "DMS plugins that ship with this desktop";
  category = "Desktop";
*/

/*
  @snippet
  name = "plugin";
  label = "Add plugin";
  snippet = ''
    # @option widget = "submodule"; label = "%%name%%"; group = "Third-party plugins";
    desktop.ojuny.dms.plugins.%%name%% = {
      # @option widget = "switch"; label = "Enabled"; group = "Third-party plugins";
      enable = true;
      # @option widget = "path"; label = "Source"; group = "Third-party plugins"; nullable = true;
      src = "%%src%%";
      # @option widget = "raw"; label = "Settings (JSON)"; group = "Third-party plugins"; rows = 6;
      settings = {};
    };
  '';
  placeholders.name.label = "Plugin name";
  placeholders.name.default = "dms-example";
  placeholders.src.label = "Source path";
  placeholders.src.default = "./plugins/dms-example";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-plugins = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Manage plugin settings"; group = "Plugins"; description = "Write DMS plugin settings from this flake.";
    desktop.ojuny.dms.managePluginSettings = true;

    # Plugins installed from the DMS plugin registry. The bar, control center
    # and menu ship widgets that need these, so they default to enabled.

    # Menu
    # @option widget = "switch"; label = "Enabled"; group = "Menu (dankMenu)"; readonly = true; description = "Controlled by the Menu page.";
    desktop.ojuny.dms.plugins.dankMenu.enable = true;

    # Phone connect
    # @option widget = "switch"; label = "Enabled"; group = "Phone connect (dankKDEConnect)";
    desktop.ojuny.dms.plugins.dankKDEConnect.enable = true;

    # @option widget = "switch"; label = "Scan subdirectories"; group = "Phone connect (dankKDEConnect)"; visibleWhen.path = "desktop.ojuny.dms.plugins.dankKDEConnect.enable"; visibleWhen.equals = true; description = "Included in the file browser when sending files.";
    desktop.ojuny.dms.plugins.dankKDEConnect.settings.scanSubdirectories = true;

    # Nix monitor
    # @option widget = "switch"; label = "Enabled"; group = "Nix monitor (nixMonitor)";
    desktop.ojuny.dms.plugins.nixMonitor.enable = true;

    # @option widget = "switch"; label = "Show generations"; group = "Nix monitor (nixMonitor)"; visibleWhen.path = "desktop.ojuny.dms.plugins.nixMonitor.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.nixMonitor.settings.showGenerations = true;

    # @option widget = "switch"; label = "Show store size"; group = "Nix monitor (nixMonitor)"; visibleWhen.path = "desktop.ojuny.dms.plugins.nixMonitor.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.nixMonitor.settings.showStoreSize = true;

    # @option widget = "spin"; label = "Update interval"; group = "Nix monitor (nixMonitor)"; min = 60; max = 86400; unit = "s"; visibleWhen.path = "desktop.ojuny.dms.plugins.nixMonitor.enable"; visibleWhen.equals = true; description = "How often the widget polls the local store.";
    desktop.ojuny.dms.plugins.nixMonitor.settings.updateInterval = 3600;

    # @option widget = "spin"; label = "Update check interval"; group = "Nix monitor (nixMonitor)"; min = 60; max = 86400; unit = "s"; visibleWhen.path = "desktop.ojuny.dms.plugins.nixMonitor.enable"; visibleWhen.equals = true; description = "How often it checks for updates.";
    desktop.ojuny.dms.plugins.nixMonitor.settings.updateCheckInterval = 3600;

    # @option widget = "spin"; label = "Garbage collection alert threshold"; group = "Nix monitor (nixMonitor)"; min = 1; max = 10000; unit = "GB"; visibleWhen.path = "desktop.ojuny.dms.plugins.nixMonitor.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.nixMonitor.settings.gcThresholdGB = 100;

    # Local services
    # @option widget = "switch"; label = "Enabled"; group = "Local services (localServices)";
    desktop.ojuny.dms.plugins.localServices.enable = true;

    # @option widget = "text"; label = "Ignored ports"; group = "Local services (localServices)"; visibleWhen.path = "desktop.ojuny.dms.plugins.localServices.enable"; visibleWhen.equals = true; description = "Comma separated ports to hide, e.g. 22,53.";
    desktop.ojuny.dms.plugins.localServices.settings.ignoredPorts = "";

    # @option widget = "text"; label = "Exact watches"; group = "Local services (localServices)"; visibleWhen.path = "desktop.ojuny.dms.plugins.localServices.enable"; visibleWhen.equals = true; description = "Comma separated ports or ranges to always show, e.g. 8081,3000-3010.";
    desktop.ojuny.dms.plugins.localServices.settings.exactWatches = "";

    # @option widget = "multiline"; label = "Port labels"; group = "Local services (localServices)"; rows = 3; visibleWhen.path = "desktop.ojuny.dms.plugins.localServices.enable"; visibleWhen.equals = true; description = "JSON object mapping ports to labels, e.g. {\"8081\": \"webserver\"}.";
    desktop.ojuny.dms.plugins.localServices.settings.labels = "{}";

    # Scratchpad helper
    # @option widget = "switch"; label = "Enabled"; group = "Scratchpad helper (scratchpadHelper)";
    desktop.ojuny.dms.plugins.scratchpadHelper.enable = true;

    # @option widget = "switch"; label = "Hide bar when empty"; group = "Scratchpad helper (scratchpadHelper)"; visibleWhen.path = "desktop.ojuny.dms.plugins.scratchpadHelper.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.scratchpadHelper.settings.hideBarWhenEmpty = true;

    # @option widget = "switch"; label = "Named scratchpads"; group = "Scratchpad helper (scratchpadHelper)"; visibleWhen.path = "desktop.ojuny.dms.plugins.scratchpadHelper.enable"; visibleWhen.equals = true; description = "Managed named scratchpads instead of one shared scratchpad.";
    desktop.ojuny.dms.plugins.scratchpadHelper.settings.namedManagerEnabled = false;

    # Developer utilities
    # @option widget = "switch"; label = "Enabled"; group = "Developer utilities (developerUtilities)";
    desktop.ojuny.dms.plugins.developerUtilities.enable = true;

    # Screen capture toolbar
    # @option widget = "switch"; label = "Enabled"; group = "Screen capture toolbar (screenCaptureToolbar)";
    desktop.ojuny.dms.plugins.screenCaptureToolbar.enable = true;

    # @option widget = "switch"; label = "Record audio"; group = "Screen capture toolbar (screenCaptureToolbar)"; visibleWhen.path = "desktop.ojuny.dms.plugins.screenCaptureToolbar.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.screenCaptureToolbar.settings.enableAudioRecorder = true;

    # @option widget = "switch"; label = "Multi-monitor screenshots"; group = "Screen capture toolbar (screenCaptureToolbar)"; visibleWhen.path = "desktop.ojuny.dms.plugins.screenCaptureToolbar.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.screenCaptureToolbar.settings.multiMonitorScreenshot = true;

    # @option widget = "switch"; label = "Show toolbar notifications"; group = "Screen capture toolbar (screenCaptureToolbar)"; visibleWhen.path = "desktop.ojuny.dms.plugins.screenCaptureToolbar.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.screenCaptureToolbar.settings.showNotify = false;

    # @option widget = "switch"; label = "Show recording pill"; group = "Screen capture toolbar (screenCaptureToolbar)"; visibleWhen.path = "desktop.ojuny.dms.plugins.screenCaptureToolbar.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.screenCaptureToolbar.settings.showRecPill = false;

    # @option widget = "slider"; label = "Toolbar opacity"; group = "Screen capture toolbar (screenCaptureToolbar)"; min = 0.0; max = 1.0; step = 0.05; visibleWhen.path = "desktop.ojuny.dms.plugins.screenCaptureToolbar.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.screenCaptureToolbar.settings.toolbarOpacity = 1.0;

    # @option widget = "slider"; label = "Recording pill opacity"; group = "Screen capture toolbar (screenCaptureToolbar)"; min = 0.0; max = 1.0; step = 0.05; visibleWhen.path = "desktop.ojuny.dms.plugins.screenCaptureToolbar.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.screenCaptureToolbar.settings.pillOpacity = 1.0;

    # Command runner
    # @option widget = "switch"; label = "Enabled"; group = "Command runner (commandRunner)";
    desktop.ojuny.dms.plugins.commandRunner.enable = true;

    # @option widget = "text"; label = "Terminal"; group = "Command runner (commandRunner)"; visibleWhen.path = "desktop.ojuny.dms.plugins.commandRunner.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.commandRunner.settings.terminal = "ghostty";

    # @option widget = "text"; label = "Trigger"; group = "Command runner (commandRunner)"; visibleWhen.path = "desktop.ojuny.dms.plugins.commandRunner.enable"; visibleWhen.equals = true; description = "Prefix typed in the launcher to run a command.";
    desktop.ojuny.dms.plugins.commandRunner.settings.trigger = ">";

    # @option widget = "text"; label = "Terminal exec flag"; group = "Command runner (commandRunner)"; visibleWhen.path = "desktop.ojuny.dms.plugins.commandRunner.enable"; visibleWhen.equals = true;
    desktop.ojuny.dms.plugins.commandRunner.settings.execFlag = "-e";

    # Web search
    # @option widget = "switch"; label = "Enabled"; group = "Web search (webSearch)";
    desktop.ojuny.dms.plugins.webSearch.enable = true;

    # Third-party plugins: desktop.ojuny.dms.plugins.<name> takes enable, src
    # (path) and settings. The registry default only fills in src for the
    # plugins listed above, so point src at your own package for new ones.

    /*
      @insert
      name = "plugin";
      group = "Third-party plugins";
      order = 1000;
    */

  };

}
