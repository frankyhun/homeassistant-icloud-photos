#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json
APPLE_ID=$(jq -r '.apple_id' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password' "$CONFIG_PATH")
DOWNLOAD_PATH=$(jq -r '.download_path' "$CONFIG_PATH")
MODE=$(jq -r '.mode' "$CONFIG_PATH")
WATCH_INTERVAL=$(jq -r '.watch_interval' "$CONFIG_PATH")
AUTO_DELETE=$(jq -r '.auto_delete' "$CONFIG_PATH")
MFA_CODE=$(jq -r '.mfa_code' "$CONFIG_PATH")

ARGS=(
  --directory "$DOWNLOAD_PATH"
  --username "$APPLE_ID"
  --password "$PASSWORD"
)

if [ "$AUTO_DELETE" = "true" ]; then
  ARGS+=(--auto-delete)
fi

# If MFA code is set, pass it to icloudpd
if [ -n "$MFA_CODE" ] && [ "$MFA_CODE" != "null" ]; then
  echo "[INFO] Using MFA code from config..."
  ARGS+=(--auth-code "$MFA_CODE")
fi

# Select mode
if [ "$MODE" = "watch" ]; then
  echo "[INFO] Starting in watch mode (interval ${WATCH_INTERVAL}s)..."
  exec icloudpd --watch-with-interval "$WATCH_INTERVAL" "${ARGS[@]}"
else
  echo "[INFO] Starting one-time download..."
  exec icloudpd "${ARGS[@]}"
fi

# --- After successful login, clear MFA code from config ---
if [ $? -eq 0 ] && [ -n "$MFA_CODE" ] && [ "$MFA_CODE" != "null" ]; then
  echo "[INFO] Clearing MFA code from config..."
  tmpfile=$(mktemp)
  jq '.mfa_code=""' "$CONFIG_PATH" > "$tmpfile" && mv "$tmpfile" "$CONFIG_PATH"
fi