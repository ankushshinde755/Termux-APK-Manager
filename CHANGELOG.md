# Changelog

All notable changes to this project are documented here.

## [1.1.0] - 2026-10-05

### Added
- Interactive package-management menu.
- Package listing.
- Package-name search.
- Package information inspection.
- Disable package for user 0.
- Enable package.
- User-0 uninstall.
- Restore preinstalled packages with `install-existing`.
- Direct CLI subcommands for package management.
- `apk --version` / `apk -v`.
- OEM/root-only protection detection with a friendly error message.
- Explicit uninstall confirmation in interactive mode.

### Retained
- `.apk` installation.
- `.apks`, `.xapk`, and `.apkm` extraction.
- Split APK installation.
- Automatic ART/dexopt profile mismatch recovery.
- Dedicated `/storage/emulated/0/APK` directory.
- Filename-with-spaces support.

### Security
- Package removal remains scoped to `--user 0`.
- No root or Shizuku dependency added.
- No attempt to bypass OEM package protections.

## [1.0.0]

Initial public project structure and APK installation workflow.
