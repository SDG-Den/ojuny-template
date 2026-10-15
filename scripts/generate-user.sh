#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${OJUNY_ROOT:-$PWD}"
OUT="$REPO_ROOT/modules/01-users/01-user.nix"
STATE_VERSION="25.05"

force=0
for arg in "$@"; do
  case "$arg" in
  --force) force=1 ;;
  *)
    echo "generate-user: unknown argument: $arg" >&2
    exit 2
    ;;
  esac
done

if [ -e "$OUT" ] && [ "$force" -ne 1 ]; then
  echo "generate-user: refusing to overwrite $OUT (pass --force)" >&2
  exit 1
fi

read -rp "Username [user]: " username
username="${username:-user}"
read -rp "Description (full name) [$username]: " description
description="${description:-$username}"
read -rp "Extra groups [networkmanager wheel]: " groups
groups="${groups:-networkmanager wheel}"
read -rp "Login shell [zsh]: " shell
shell="${shell:-zsh}"

read -rsp "Password (empty to leave locked): " password
echo

hashed="!"
if [ -n "$password" ]; then
  if command -v mkpasswd >/dev/null 2>&1; then
    hashed="$(mkpasswd -m yescrypt "$password" 2>/dev/null || mkpasswd -m sha-512 "$password")"
  else
    echo "generate-user: mkpasswd not found" >&2
    exit 1
  fi
fi

read -ra group_names <<<"$groups"
group_list=""
for g in "${group_names[@]}"; do
  group_list+="\"$g\" "
done
group_list="${group_list% }"

key_list=""
while true; do
  read -rp "SSH public key (empty to finish): " key
  [ -z "$key" ] && break
  key_list+="      \"$key\""$'\n'
done
if [ -z "$key_list" ]; then
  keys_block="[ ]"
else
  keys_block="$(printf '[\n%s    ]' "$key_list")"
fi

{
  cat <<EOF
/* @menu
   displayname = "$username Account";
   icon = "avatar-default-symbolic";
   order = 10;
   description = "The account this machine is used as";
   category = "Users";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.users-$username = { config, pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    /* @option widget = "submodule"; label = "$username"; group = "Account"; */
    users.users.$username = {
      /* @option widget = "switch"; label = "Normal user"; group = "Account"; */
      isNormalUser = true;

      /* @option widget = "text"; label = "Description"; group = "Account"; */
      description = "$description";

      /* @option widget = "list"; label = "Extra groups"; group = "Account"; */
      extraGroups = [ $group_list ];

      /* @option widget = "text"; label = "Hashed password"; group = "Account"; advanced = true; description = "A \"!\" keeps the account locked until a password is set."; */
      hashedPassword = "$hashed";

      /* @option widget = "list"; label = "SSH keys"; group = "Account"; */
      openssh.authorizedKeys.keys = $keys_block;

      shell = pkgs.$shell;
    };

    home-manager.users.$username.home.stateVersion = "$STATE_VERSION";

  };

}
EOF
} >"$OUT"

echo "generate-user: wrote $OUT"
