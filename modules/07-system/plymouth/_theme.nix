{
  lib,
  stdenvNoCC,
  background,
  logo,
}:

stdenvNoCC.mkDerivation {
  pname = "ojuny-plymouth";
  version = "0.1.0";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    hex="${lib.removePrefix "#" background}"
    r=$((16#''${hex:0:2}))
    g=$((16#''${hex:2:2}))
    b=$((16#''${hex:4:2}))

    mkdir -p $out/share/plymouth/themes/ojuny
    cp ${./ojuny.plymouth} $out/share/plymouth/themes/ojuny/ojuny.plymouth
    sed \
      -e "s/@bgR@/$r/g" \
      -e "s/@bgG@/$g/g" \
      -e "s/@bgB@/$b/g" \
      ${./ojuny.script.in} > $out/share/plymouth/themes/ojuny/ojuny.script
    cp ${logo} $out/share/plymouth/themes/ojuny/logo.png
  '';
}
