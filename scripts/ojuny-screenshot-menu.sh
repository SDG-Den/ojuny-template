#!/usr/bin/env bash
set -euo pipefail

TMP="/tmp/ojuny-screenshot-menu.$$"
mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT

{
  printf 'Region\0icon\x1fcrop_free\x1fmeta\x1fPrint\x1finfo\x1fregion\n'
  printf 'Fullscreen\0icon\x1fdesktop_windows\x1fmeta\x1fAlt+Print\x1finfo\x1ffull\n'
  printf 'Window\0icon\x1fwindow\x1fmeta\x1fSuper+Print\x1finfo\x1fwindow\n'
  printf 'Annotate region\0icon\x1fdraw\x1fmeta\x1fSuper+Shift+Print\x1finfo\x1fedit-region\n'
  printf 'Annotate window\0icon\x1fdraw\x1fmeta\x1fSuper+Shift+Ctrl+Print\x1finfo\x1fedit-window\n'
  printf 'Scroll capture\0icon\x1fswipe_vertical\x1fmeta\x1fSuper+Shift+X\x1finfo\x1fscroll\n'
  printf 'Copy text (OCR)\0icon\x1ftext_fields\x1fmeta\x1fSuper+Shift+O\x1finfo\x1ftext\n'
  printf 'Scan QR code\0icon\x1fqr_code_2\x1fmeta\x1fSuper+Shift+Q\x1finfo\x1fqr\n'
} > "$TMP/items"

dms dmenu --input "$TMP/items" -p "Screenshot" --icon photo_camera --no-custom \
  --disable-history --size 3 --print-info > "$TMP/pick"
rc=$?
[ "$rc" = 0 ] || exit 0

mapfile -t chosen < "$TMP/pick"
action="${chosen[1]:-}"

case "$action" in
  region) exec dms screenshot region ;;
  full) exec dms screenshot full ;;
  window) exec dms screenshot window ;;
  edit-region) exec ojuny-screenshot-edit region ;;
  edit-window) exec ojuny-screenshot-edit window ;;
  scroll) exec dms screenshot scroll ;;
  text) exec ojuny-capture-text ;;
  qr) exec ojuny-capture-qr ;;
  *) exit 0 ;;
esac
