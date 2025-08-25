# Changelog

## [1.0.6] - 2025-08-25
- chore: verbose logging to address startup issues #3

## [1.0.5] - 2025-08-25
- chore: verbose logging to address startup issues #2

## [1.0.4] - 2025-08-25
- chore: verbose logging to address startup issues

## [1.0.3] - 2025-08-25
- fix: password and MFA handling

## [1.0.2] - 2025-08-25
- fix: startup error due missing jq dependency

## [1.0.1] - 2025-08-25
- fix: startup error due wrong EOL

## [1.0.0] - 2025-08-25
- Initial release of iCloud Photos Downloader for Home Assistant
- Downloads photos from iCloud using `icloudpd`
- Supports configurable download path (`/media/icloud` by default)
- Optional auto-delete of removed iCloud photos
- Adjustable sync interval (default: 12h)
- Two-factor authentication supported via cookie session
