#!/usr/bin/env bash
set -e

APPLE_ID=$(jq -r '.apple_id' /data/options.json)
DOWNLOAD_PATH=$(jq -r '.download_path' /data/options.json)
AUTO_DELETE=$(jq -r '.auto_delete' /data/options.json)
AUTH_REFRESH_INTERVAL=$(jq -r '.auth_refresh_interval' /data/options.json)

mkdir -p "$DOWNLOAD_PATH"

while true; do
    echo "[INFO] Syncing iCloud photos for $APPLE_ID..."
    icloudpd \
        --directory "$DOWNLOAD_PATH" \
        --username "$APPLE_ID" \
        --no-progress-bar \
        $( [ "$AUTO_DELETE" = "true" ] && echo "--auto-delete" )

    echo "[INFO] Sync complete. Sleeping for $AUTH_REFRESH_INTERVAL"
    sleep $(echo $AUTH_REFRESH_INTERVAL | sed 's/h/*3600/' | bc)
done
