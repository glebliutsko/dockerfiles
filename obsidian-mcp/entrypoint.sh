#!/bin/sh
set -eu

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

die() {
    printf '%s\n' "$1" >&2
    exit "${2:-1}"
}

is_empty() {
    [ -z "$(find "$1" -mindepth 1 -maxdepth 1 -print -quit)" ] || return 1
}

re='^[0-9]+$'
(echo "$PUID" | grep -Eq "$re") || die 'Invalid PUID'
(echo "$PGID" | grep -Eq "$re") || die 'Invalid PGID'

is_empty "$OBSIDIAN_MCP_DATA" && chown "$PUID:$PGID" "$OBSIDIAN_MCP_DATA"
is_empty "$OBSIDIAN_VAULT_PATH" && chown "$PUID:$PGID" "$OBSIDIAN_VAULT_PATH"

exec gosu "$PUID:$PGID" "$@"
