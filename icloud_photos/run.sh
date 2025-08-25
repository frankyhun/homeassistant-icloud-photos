#!/usr/bin/env bash
set -e

APPLE_ID=$(jq -r '.apple_id' /data/options.json)
PASSWORD=$(jq -r '.password' /data/options.json)
DOWNLOAD_PATH=$(jq -r '.download_path' /data/options.json)
AUTO_DELETE=$(jq -r '.auto_delete' /data/options.json)
AUTH_REFRESH_INTERVAL=$(jq -r '.auth_refresh_interval' /data/options.json)

COOKIE_DIR="/config/icloud_cookies"
COOKIE_FILE="$COOKIE_DIR/$APPLE_ID/cookie"
mkdir -p "$DOWNLOAD_PATH"
mkdir -p "$COOKIE_DIR"

check_cookie_expiry() {
    if [ -f "$COOKIE_FILE" ]; then
        # Extract expiry timestamp from cookie file
        expiry=$(grep 'mfa' "$COOKIE_FILE" | awk '{print $5}' | sort | tail -1)

        if [ -n "$expiry" ]; then
            expiry_date=$(date -d @"$expiry" +%Y-%m-%d)
            now=$(date +%s)
            days_left=$(( (expiry - now) / 86400 ))

            if [ "$days_left" -le 10 ]; then
                echo "[WARN] iCloud cookie for $APPLE_ID expires in $days_left days (on $expiry_date)."
                echo "[WARN] Add your password back into the add-on config soon to refresh authentication."
            else
                echo "[INFO] Cookie valid until $expiry_date ($days_left days left)."
            fi
        else
            echo "[WARN] Could not determine cookie expiry."
        fi
    else
        echo "[INFO] No cookie file found yet."
    fi
}

while true; do
    echo "[INFO] Syncing iCloud photos for $APPLE_ID..."

    if [ -f "$COOKIE_FILE" ]; then
        echo "[INFO] Using existing session cookie, password not required."
        icloudpd \
            --directory "$DOWNLOAD_PATH" \
            --username "$APPLE_ID" \
            --cookie-directory "$COOKIE_DIR" \
            --no-progress-bar \
            $( [ "$AUTO_DELETE" = "true" ] && echo "--auto-delete" )
    else
        if [ -z "$PASSWORD" ] || [ "$PASSWORD" = "null" ]; then
            echo "[ERROR] No cookie found and no password provided. Please configure a password for first login."
            exit 1
        fi

        echo "[INFO] First-time login, using password for authentication..."
        icloudpd \
            --directory "$DOWNLOAD_PATH" \
            --username "$APPLE_ID" \
            --password "$PASSWORD" \
            --cookie-directory "$COOKIE_DIR" \
            --no-progress-bar \
            $( [ "$AUTO_DELETE" = "true" ] && echo "--auto-delete" )
    fi

    check_cookie_expiry

    echo "[INFO] Sync complete. Sleeping for $AUTH_REFRESH_INTERVAL"
    sleep $(echo $AUTH_REFRESH_INTERVAL | sed 's/h/*3600/' | bc)
done
