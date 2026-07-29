#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
godot_root="$project_root/.tools"
godot_binary="$godot_root/godot-4.7.1-linux/Godot_v4.7.1-stable_linux.x86_64"
godot_user_root="$godot_root/godot-user"

if [[ ! -x "$godot_binary" ]]; then
	echo "Native Godot 4.7.1 is not installed at: $godot_binary" >&2
	exit 1
fi

mkdir -p \
	"$godot_user_root/data" \
	"$godot_user_root/config" \
	"$godot_user_root/cache"

export XDG_DATA_HOME="$godot_user_root/data"
export XDG_CONFIG_HOME="$godot_user_root/config"
export XDG_CACHE_HOME="$godot_user_root/cache"
export GODOT_SILENCE_ROOT_WARNING=1

exec "$godot_binary" --headless --path "$project_root" "$@"
