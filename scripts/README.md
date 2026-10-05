# Optional scripts

This directory contains generic local utilities that can be useful alongside the APK manager.

## `termux-backup.sh`

Backs up the Termux `home` and `usr` directories into `/storage/emulated/0/Termux Backups/`.

It does not back up shared-storage APK files or personal files outside Termux's `home` and `usr` directories.

Usage:

```bash
bash scripts/termux-backup.sh
```

### Intentionally excluded

Personal scripts such as `nextdns-backup` are not distributed here because they may contain or handle user-specific configuration, API credentials, profiles, or other private data.
