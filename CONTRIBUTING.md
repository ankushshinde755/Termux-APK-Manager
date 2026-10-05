# Contributing

Thanks for helping improve Termux APK Manager! 🛠️

## Before opening an issue

- Confirm the problem is reproducible.
- Include Android version and Termux version when relevant.
- Include ADB version when relevant.
- Remove private IP addresses, pairing codes, tokens, usernames, and other secrets.
- Do not upload proprietary APKs or company files.

## Pull requests

1. Fork the repository.
2. Create a focused branch.
3. Make the smallest practical change.
4. Test the script with `bash -n apk`.
5. Test affected functionality on a real Android/Termux environment when possible.
6. Update documentation/changelog when behavior changes.
7. Open a pull request against `main`.

## Shell-script requirements

- Keep the `#!/data/data/com.termux/files/usr/bin/bash` shebang.
- Quote paths and variables where practical.
- Preserve filenames containing spaces.
- Avoid destructive operations without clear confirmation or user scoping.
- Do not add root exploits or security-bypass logic.
- Do not add telemetry or network calls without explicit project requirements.

## Package-management changes

Prefer Android's documented/normal package-manager interfaces. User-scoped removal should remain `--user 0` unless a future change explicitly documents why another scope is required.

OEM-protected packages should be reported cleanly rather than bypassed.
