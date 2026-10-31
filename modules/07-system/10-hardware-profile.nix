{ self, inputs, ... }:
let
  lib = inputs.nixpkgs.lib;

  # Mirrored in scripts/regenerate-hardware.py.
  # tests/check-hardware-profile.py fails when the two tables differ.
  # Slugs checked against nixos-hardware 1b418b8f203e49a92f250f8babdd19af1b6f7a7f.
  # Order matters: the first row whose vendor and product pattern match wins.
  hardwareProfiles = [
    { vendor = "apple"; pattern = ".*macbookpro.*"; profile = "apple-macbook-pro"; state = "untested"; }
    { vendor = "apple"; pattern = ".*macbookair7,.*"; profile = "apple-macbook-air-3"; state = "untested"; }
    { vendor = "apple"; pattern = ".*macbookair8,.*"; profile = "apple-macbook-air-4"; state = "untested"; }
    { vendor = "apple"; pattern = ".*macbookair9,.*"; profile = "apple-macbook-air-5"; state = "untested"; }
    { vendor = "apple"; pattern = ".*macmini.*"; profile = "apple-macmini-4-1"; state = "untested"; }
    { vendor = "asus"; pattern = ".*g513.*"; profile = "asus-rog-strix-g513im"; state = "untested"; }
    { vendor = "asus"; pattern = ".*g533.*"; profile = "asus-rog-strix-g533zw"; state = "untested"; }
    { vendor = "asus"; pattern = ".*g713.*"; profile = "asus-rog-strix-g713ie"; state = "untested"; }
    { vendor = "asus"; pattern = ".*g733.*"; profile = "asus-rog-strix-g733qs"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ga401.*"; profile = "asus-zephyrus-ga401iv"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ga402.*"; profile = "asus-zephyrus-ga402"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ga503.*"; profile = "asus-zephyrus-ga503"; state = "untested"; }
    { vendor = "asus"; pattern = ".*gu603.*"; profile = "asus-zephyrus-gu603h"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ux371.*"; profile = "asus-zenbook-ux371"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ux535.*"; profile = "asus-zenbook-ux535"; state = "untested"; }
    { vendor = "asus"; pattern = ".*px13.*"; profile = "asus-proart-px13"; state = "untested"; }
    { vendor = "asus"; pattern = ".*fx506.*"; profile = "asus-fx506hm"; state = "untested"; }
    { vendor = "asus"; pattern = ".*fa506.*"; profile = "asus-fa506nc"; state = "untested"; }
    { vendor = "asus"; pattern = ".*fa507.*"; profile = "asus-fa507nv"; state = "untested"; }
    { vendor = "asus"; pattern = ".*x570.*"; profile = "asus-rog-strix-x570e"; state = "untested"; }
    { vendor = "chuwi"; pattern = ".*minibook x.*"; profile = "chuwi-minibook-x"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9370.*"; profile = "dell-xps-13-9370"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9380.*"; profile = "dell-xps-13-9380"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9300.*"; profile = "dell-xps-13-9300"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9310.*"; profile = "dell-xps-13-9310"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9315.*"; profile = "dell-xps-13-9315"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9343.*"; profile = "dell-xps-13-9343"; state = "unsupported"; }
    { vendor = "dell"; pattern = ".*xps 15 9500.*"; profile = "dell-xps-15-9500"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9510.*"; profile = "dell-xps-15-9510"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9520.*"; profile = "dell-xps-15-9520"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9530.*"; profile = "dell-xps-15-9530"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9550.*"; profile = "dell-xps-15-9550"; state = "unsupported"; }
    { vendor = "dell"; pattern = ".*latitude 7420.*"; profile = "dell-latitude-7420"; state = "untested"; }
    { vendor = "dell"; pattern = ".*latitude 7430.*"; profile = "dell-latitude-7430"; state = "untested"; }
    { vendor = "dell"; pattern = ".*latitude 7490.*"; profile = "dell-latitude-7490"; state = "untested"; }
    { vendor = "dell"; pattern = ".*precision 5560.*"; profile = "dell-precision-5560"; state = "untested"; }
    { vendor = "dell"; pattern = ".*precision 5570.*"; profile = "dell-precision-5570"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*7040.*"; profile = "framework-13-7040-amd"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*12th.*"; profile = "framework-12th-gen-intel"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*11th.*"; profile = "framework-11th-gen-intel"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*13th.*"; profile = "framework-13th-gen-intel"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*core ultra.*1.*"; profile = "framework-intel-core-ultra-series1"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*ai 300.*"; profile = "framework-amd-ai-300-series"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 16.*7040.*"; profile = "framework-16-7040-amd"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 16.*ai 300.*"; profile = "framework-16-amd-ai-300-series"; state = "untested"; }
    { vendor = "framework"; pattern = ".*"; profile = "framework"; state = "untested"; }
    { vendor = "gigabyte"; pattern = ".*b550.*"; profile = "gigabyte-b550"; state = "untested"; }
    { vendor = "gigabyte"; pattern = ".*b650.*"; profile = "gigabyte-b650"; state = "untested"; }
    { vendor = "google"; pattern = ".*pixelbook.*"; profile = "google-pixelbook"; state = "untested"; }
    { vendor = "google"; pattern = ".*brya.*"; profile = "google-brya"; state = "untested"; }
    { vendor = "google"; pattern = ".*rex.*"; profile = "google-rex"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*pocket 3.*"; profile = "gpd-pocket-3"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*pocket 4.*"; profile = "gpd-pocket-4"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*win 2.*"; profile = "gpd-win-2"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*win max 2.*"; profile = "gpd-win-max-2-2023"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*win mini.*"; profile = "gpd-win-mini-2024"; state = "untested"; }
    { vendor = "hp"; pattern = ".*elitebook 830 g6.*"; profile = "hp-elitebook-830g6"; state = "untested"; }
    { vendor = "hp"; pattern = ".*elitebook 845 g7.*"; profile = "hp-elitebook-845g7"; state = "untested"; }
    { vendor = "hp"; pattern = ".*elitebook 845 g8.*"; profile = "hp-elitebook-845g8"; state = "untested"; }
    { vendor = "hp"; pattern = ".*elitebook 845 g9.*"; profile = "hp-elitebook-845g9"; state = "untested"; }
    { vendor = "hp"; pattern = ".*probook 440 g5.*"; profile = "hp-probook-440G5"; state = "untested"; }
    { vendor = "hp"; pattern = ".*probook 460 g11.*"; profile = "hp-probook-460G11"; state = "untested"; }
    { vendor = "hp"; pattern = ".*laptop 14s.*"; profile = "hp-laptop-14s-dq2024nf"; state = "untested"; }
    { vendor = "hp"; pattern = ".*laptop 15s.*"; profile = "hp-laptop-15s-fq1xxx"; state = "untested"; }
    { vendor = "hp"; pattern = ".*omen 14.*"; profile = "omen-14-fb0798ng"; state = "untested"; }
    { vendor = "hp"; pattern = ".*omen 16.*"; profile = "omen-16-n0005ne"; state = "untested"; }
    { vendor = "huawei"; pattern = ".*machc.*"; profile = "huawei-machc-wa"; state = "untested"; }
    { vendor = "intel"; pattern = ".*nuc.*"; profile = "intel-nuc-12wshi7"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*x1 carbon.*7th.*"; profile = "lenovo-thinkpad-x1-7th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*x1 carbon.*9th.*"; profile = "lenovo-thinkpad-x1-9th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*x1 carbon.*10th.*"; profile = "lenovo-thinkpad-x1-10th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*x1 carbon.*11th.*"; profile = "lenovo-thinkpad-x1-11th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*20qd.*"; profile = "lenovo-thinkpad-x1-7th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*20xw.*"; profile = "lenovo-thinkpad-x1-9th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*21cb.*"; profile = "lenovo-thinkpad-x1-10th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*21hm.*"; profile = "lenovo-thinkpad-x1-11th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*thinkpad x1 carbon.*"; profile = "lenovo-thinkpad-x1"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*thinkpad t14.*gen 1.*"; profile = "lenovo-thinkpad-t14-intel-gen1"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*thinkpad t14s.*"; profile = "lenovo-thinkpad-t14s"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*thinkpad x13.*"; profile = "lenovo-thinkpad-x13-intel"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*yoga 7 14arh7.*"; profile = "lenovo-yoga-7-14ARH7"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*yoga 6 13alc6.*"; profile = "lenovo-yoga-6-13ALC6"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*ideapad 15ach6.*"; profile = "lenovo-ideapad-15ach6"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*legion 5.*"; profile = "lenovo-legion-15ach6h"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface go.*"; profile = "microsoft-surface-go"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface pro 3.*"; profile = "microsoft-surface-pro-3"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface pro 9.*"; profile = "microsoft-surface-pro-9"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface pro.*"; profile = "microsoft-surface-pro-intel"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface laptop.*amd.*"; profile = "microsoft-surface-laptop-amd"; state = "untested"; }
    { vendor = "msi"; pattern = ".*gf63.*"; profile = "msi-gf63"; state = "untested"; }
    { vendor = "msi"; pattern = ".*gs60.*"; profile = "msi-gs60"; state = "untested"; }
    { vendor = "msi"; pattern = ".*gl62.*"; profile = "msi-gl62"; state = "untested"; }
    { vendor = "msi"; pattern = ".*gl65.*"; profile = "msi-gl65-10SDR-492"; state = "untested"; }
    { vendor = "msi"; pattern = ".*prestige 15.*"; profile = "msi-prestige-15-a10sc"; state = "untested"; }
    { vendor = "msi"; pattern = ".*b550.*"; profile = "msi-b550-tomahawk"; state = "untested"; }
    { vendor = "panasonic"; pattern = ".*cf-lx3.*"; profile = "letsnote-cf-lx3"; state = "untested"; }
    { vendor = "panasonic"; pattern = ".*cf-lx4.*"; profile = "letsnote-cf-lx4"; state = "untested"; }
    { vendor = "purism"; pattern = ".*librem 13.*"; profile = "purism-librem-13v3"; state = "untested"; }
    { vendor = "purism"; pattern = ".*librem 15.*"; profile = "purism-librem-15v3"; state = "untested"; }
    { vendor = "razer"; pattern = ".*blade 14.*"; profile = "razer-blade-14-RZ09-0530"; state = "untested"; }
    { vendor = "samsung"; pattern = ".*np900x3c.*"; profile = "samsung-np900x3c"; state = "unsupported"; }
    { vendor = "slimbook"; pattern = ".*hero.*"; profile = "slimbook-hero-rpl-rtx"; state = "untested"; }
    { vendor = "starlabs"; pattern = ".*starlite.*"; profile = "starlabs-starlite-i5"; state = "untested"; }
    { vendor = "system76"; pattern = ".*gaze.*"; profile = "system76-gaze18"; state = "untested"; }
    { vendor = "system76"; pattern = ".*galago.*"; profile = "system76-galp5-1650"; state = "untested"; }
    { vendor = "system76"; pattern = ".*darter.*"; profile = "system76-darp6"; state = "untested"; }
    { vendor = "system76"; pattern = ".*thelio.*"; profile = "system76-thelio-mega"; state = "untested"; }
    { vendor = "system76"; pattern = ".*"; profile = "system76"; state = "untested"; }
    { vendor = "toshiba"; pattern = ".*satellite.*"; profile = "toshiba-swanky"; state = "unsupported"; }
    { vendor = "tuxedo"; pattern = ".*aura 15.*"; profile = "tuxedo-aura-15-gen1"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*infinitybook.*14.*gen 9.*intel.*"; profile = "tuxedo-infinitybook-pro14-gen9-intel"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*infinitybook.*14.*gen 9.*amd.*"; profile = "tuxedo-infinitybook-pro14-gen9-amd"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*infinitybook.*14.*gen 10.*amd.*"; profile = "tuxedo-infinitybook-pro14-gen10-amd"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*infinitybook.*15.*gen 10.*amd.*"; profile = "tuxedo-infinitybook-pro15-gen10-amd"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*pulse 14.*"; profile = "tuxedo-pulse-14-gen3"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*pulse 15.*"; profile = "tuxedo-pulse-15-gen2"; state = "untested"; }
    { vendor = "xiaomi"; pattern = ".*redmibook 15.*"; profile = "xiaomi-redmibook-15-pro-2021"; state = "untested"; }
    { vendor = "xiaomi"; pattern = ".*redmibook 16.*"; profile = "xiaomi-redmibook-16-pro-2024"; state = "untested"; }
  ];

  vendorAliases = [
    { vendor = "apple"; pattern = ".*apple.*"; }
    { vendor = "asus"; pattern = ".*asus.*"; }
    { vendor = "asus"; pattern = ".*asustek.*"; }
    { vendor = "chuwi"; pattern = ".*chuwi.*"; }
    { vendor = "dell"; pattern = ".*dell.*"; }
    { vendor = "framework"; pattern = ".*framework.*"; }
    { vendor = "gigabyte"; pattern = ".*gigabyte.*"; }
    { vendor = "google"; pattern = ".*google.*"; }
    { vendor = "gpd"; pattern = ".*gpd.*"; }
    { vendor = "hp"; pattern = ".*hewlett.*packard.*"; }
    { vendor = "hp"; pattern = ".*hp.*"; }
    { vendor = "hp"; pattern = ".*omen.*"; }
    { vendor = "huawei"; pattern = ".*huawei.*"; }
    { vendor = "intel"; pattern = ".*intel.*"; }
    { vendor = "lenovo"; pattern = ".*lenovo.*"; }
    { vendor = "microsoft"; pattern = ".*microsoft.*"; }
    { vendor = "msi"; pattern = ".*micro.star.*"; }
    { vendor = "msi"; pattern = ".*msi.*"; }
    { vendor = "panasonic"; pattern = ".*panasonic.*"; }
    { vendor = "purism"; pattern = ".*purism.*"; }
    { vendor = "razer"; pattern = ".*razer.*"; }
    { vendor = "samsung"; pattern = ".*samsung.*"; }
    { vendor = "slimbook"; pattern = ".*slimbook.*"; }
    { vendor = "starlabs"; pattern = ".*star.?labs.*"; }
    { vendor = "system76"; pattern = ".*system76.*"; }
    { vendor = "toshiba"; pattern = ".*toshiba.*"; }
    { vendor = "toshiba"; pattern = ".*dynabook.*"; }
    { vendor = "tuxedo"; pattern = ".*tuxedo.*"; }
    { vendor = "xiaomi"; pattern = ".*xiaomi.*"; }
  ];

  detectVendor =
    manufacturer:
    let
      alias = lib.findFirst
        (entry: builtins.match entry.pattern (lib.toLower manufacturer) != null)
        null
        vendorAliases;
    in
    if alias == null then "unknown" else alias.vendor;

  detect =
    report:
    let
      smbios = report.smbios.system or { };
      manufacturer = smbios.manufacturer or "";
      product = smbios.product or "";
      model =
        let
          name = lib.concatStringsSep " " (lib.filter (part: part != "") [ manufacturer product ]);
        in
        if name == "" then "unknown" else name;
      vendor = detectVendor manufacturer;
      match = lib.findFirst
        (row: row.vendor == vendor && builtins.match row.pattern (lib.toLower product) != null)
        null
        hardwareProfiles;
    in
    if match == null then
      {
        inherit model vendor;
        profile = "unmatched";
        state = "unmatched";
      }
    else
      {
        inherit model vendor;
        inherit (match) profile state;
      };

  facterPath = ./facter.json;
  detection =
    if builtins.pathExists facterPath then
      detect (builtins.fromJSON (builtins.readFile facterPath))
    else
      {
        model = "unknown";
        vendor = "unknown";
        profile = "unmatched";
        state = "unmatched";
      };
in
{
  flake.lib.hardware-profile = detect;
  flake.lib.hardware-detection = detection;

  flake.modules.nixos.system-hardware-profile =
    { lib, ... }:
    {
      options.ojuny.hardware.detectedModel = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = "SMBIOS manufacturer and product from the generated nixos-facter report.";
      };

      options.ojuny.hardware.detectedProfile = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = "nixos-hardware profile selected for the detected machine, or unmatched.";
      };

      options.ojuny.hardware.detectedState = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = "Coverage state for the detected machine: tested, untested, unsupported or unmatched.";
      };
    };
}
