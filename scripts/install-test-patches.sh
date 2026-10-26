#!/usr/bin/env bash
set -euo pipefail

ojuny-patches sync
ojuny-patches install patch-local-llm
ojuny-patches install patch-retroarch
ojuny-patches install patch-geforce-now
ojuny-patches install patch-moonlight-sunshine
ojuny-patches install patch-prismlauncher
ojuny-patches install patch-aux-hardware
ojuny-patches install patch-home-snapshots
