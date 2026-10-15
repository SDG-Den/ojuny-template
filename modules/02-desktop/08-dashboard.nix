/* @menu
   displayname = "Dashboard";
   icon = "view-grid-symbolic";
   order = 80;
   description = "Dashboard cards, tabs and control center";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dashboard = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    # NOTE: desktop.ojuny.dms.dashCards.<id>, dashTabs.<id> and dashOptions,
    # plus the control-center grid desktop.ojuny.dms.controlCenterWidgets.<id>.

  };

}
