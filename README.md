# iCloud Photos Downloader (Home Assistant Add-on)

This add-on downloads your iCloud Photos into Home Assistant’s media folder, making them available in the Media Browser.

## Features
- Sync iCloud Photos into `/media/icloud` (or custom path)
- Two-factor authentication support
- Configurable sync interval
- Optional auto-delete for removed photos
- Runs as a Home Assistant add-on (no manual Docker setup)

## Installation
1. In Home Assistant → Settings → Add-ons → Add-on Store → Repositories, add:
https://github.com/frankyhun/homeassistant-icloud-photos
2. Install **iCloud Photos Downloader**.
3. Configure your Apple ID:

apple_id: "yourname@icloud.com"
download_path: "/media/icloud"
auto_delete: false
auth_refresh_interval: "12h"
Start the add-on.

On first run, check the logs to enter your 2FA code.

## Notes
Use an app-specific password instead of your iCloud main password.

Photos will appear under Media → iCloud in Home Assistant.

First sync may take a long time depending on your library size.