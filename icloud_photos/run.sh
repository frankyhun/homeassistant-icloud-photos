#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json
APPLE_ID=$(jq -r '.apple_id' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password' "$CONFIG_PATH")
DOWNLOAD_PATH=$(jq -r '.download_path' "$CONFIG_PATH")

# Start ttyd with icloudpd interactive shell
ttyd -p 7681 bash -c "icloudpd --username $APPLE_ID --password $PASSWORD --directory $DOWNLOAD_PATH"
