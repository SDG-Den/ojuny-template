{
  lib,
  stdenvNoCC,
  background,
  foreground,
  logo,
}:

stdenvNoCC.mkDerivation {
  pname = "ojuny-plymouth";
  version = "0.1.0";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    bg_hex="${lib.removePrefix "#" background}"
    bg_r=$((16#''${bg_hex:0:2}))
    bg_g=$((16#''${bg_hex:2:2}))
    bg_b=$((16#''${bg_hex:4:2}))

    fg_hex="${lib.removePrefix "#" foreground}"
    fg_r=$((16#''${fg_hex:0:2}))
    fg_g=$((16#''${fg_hex:2:2}))
    fg_b=$((16#''${fg_hex:4:2}))

    theme_dir=$out/share/plymouth/themes/ojuny
    mkdir -p "$theme_dir"

    sed -e "s|@themeDir@|$theme_dir|g" \
      ${./ojuny.plymouth} > "$theme_dir/ojuny.plymouth"
    sed \
      -e "s/@bgR@/$bg_r/g" \
      -e "s/@bgG@/$bg_g/g" \
      -e "s/@bgB@/$bg_b/g" \
      -e "s/@fgR@/$fg_r/g" \
      -e "s/@fgG@/$fg_g/g" \
      -e "s/@fgB@/$fg_b/g" \
      ${./ojuny.script.in} > "$theme_dir/ojuny.script"
    cp ${logo} "$theme_dir/logo.png"
  '';
}
