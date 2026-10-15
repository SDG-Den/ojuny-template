/* @menu
   displayname = "Office";
   icon = "x-office-document-symbolic";
   order = 50;
   description = "Office suite and document tools";
   category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-office = { config, pkgs, ... }: {

    # NOTE: office suite and document tools (e.g. libreoffice) and the
    # mime handlers for document types.

  };

}
