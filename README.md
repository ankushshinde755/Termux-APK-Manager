# 📱 Termux APK Manager

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Android](https://img.shields.io/badge/Android-ADB-3DDC84.svg)
![Termux](https://img.shields.io/badge/Termux-supported-1f1f1f.svg)
![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)

A practical **Termux + Android Debug Bridge (ADB)** package manager for Android devices.

It started as a small APK installer and evolved into a reusable command-line toolkit for installing patched APKs, handling split packages, managing user-installed/system packages, and recovering from a specific Android ART/dexopt profile mismatch that can affect patched APKs.

> **No root. No Shizuku dependency. No permanent privileged service.**
>
> ADB/Wireless Debugging is used only when you need package-management operations.

---

## ✨ Features

### 📦 Package installation

- `.apk`
- `.apks`
- `.xapk`
- `.apkm`
- Split APK installation with `adb install-multiple`
- Dedicated package directory:

```text
/storage/emulated/0/APK
```

The interactive installer searches **only this directory**.

### 🛠️ Package management

The `apk` command can also:

- 📋 List installed packages
- 🔍 Search package names
- 📄 Inspect package information
- 🚫 Disable an app for user 0
- ✅ Re-enable an app
- 🗑️ Uninstall a package for user 0
- ♻️ Restore a preinstalled package with `install-existing`

### 🧬 ART / dexopt profile recovery

Some patched APKs can trigger an Android ART profile/checksum mismatch during installation. When the normal installation fails with the known profile/dexopt indicators, the script automatically retries with:

```bash
adb install -r --ignore-dexopt-profile APP.apk
```

The script **does not** automatically:

- uninstall the app
- wipe application data
- disable ProfileInstaller
- delete ART profiles
- modify the patched APK
- require root
- require Shizuku

The normal installation is always attempted first.

### 🔒 OEM-protected packages

Some Android/OEM packages cannot be disabled or modified by the ADB shell user. For example, some Vivo/iQOO privileged packages can return a `SecurityException` stating that root permission is required.

The manager detects this common response and reports:

```text
🔒 OEM Protected Package
❌ Nothing was changed.
```

It does **not** attempt to bypass OEM security restrictions.

---

# 🚀 Quick Start

## 1. Install Termux

Use the official Termux distribution you normally use. This project is designed around the GitHub/F-Droid style Termux environment rather than a Play Store build.

For the GitHub build, see the official Termux project:

https://github.com/termux/termux-app

## 2. Update Termux

```bash
pkg update && pkg upgrade
```

## 3. Install required packages

```bash
pkg install android-tools unzip
```

The script uses Bash, ADB and `unzip`.

## 4. Give Termux storage access

```bash
termux-setup-storage
```

Allow the Android permission prompt.

## 5. Create the APK directory

```bash
mkdir -p /storage/emulated/0/APK
```

Put your APK packages in that folder.

---

# 🔌 Wireless ADB Setup

Enable **Developer Options → Wireless Debugging** on the Android device.

Pairing and connecting are separate operations.

For a normal connection, use the address and port shown by Android:

```bash
adb connect IP:PORT
```

Example format only:

```text
adb connect 192.168.x.x:xxxxx
```

Never commit your real local IP address, pairing code, or other private connection details to a public repository.

Check the connection:

```bash
adb devices
```

You should see a device ending in:

```text
device
```

Then run:

```bash
apk
```

---

# 📥 Installing the `apk` command

Copy the repository's `apk` script into your Termux executable directory:

```bash
mkdir -p ~/bin
cp apk ~/bin/apk
chmod +x ~/bin/apk
```

Make sure `~/bin` is in your PATH:

```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Verify:

```bash
command -v apk
```

Expected form:

```text
/data/data/com.termux/files/home/bin/apk
```

Check the version:

```bash
apk --version
```

---

# 📦 Interactive installer

Run:

```bash
apk
```

Choose:

```text
1) 📦 Install APK/package
2) 🛠️ Manage installed apps
3) ❌ Exit
```

The installer scans:

```text
/storage/emulated/0/APK
```

and presents supported package files for selection.

---

# ⚡ Direct installation commands

Install a package from the APK directory:

```bash
apk install example.apk
```

Or provide a full path:

```bash
apk install /path/to/example.apk
```

You can also pass a filename directly:

```bash
apk example.apk
```

Supported containers:

```text
.apk
.apks
.xapk
.apkm
```

---

# 🛠️ Package Manager

Run:

```bash
apk
```

and select:


```text
2) 🛠️ Manage installed apps
```

Available operations:

### 📋 List packages

```bash
apk list
```

### 🔍 Search packages

```bash
apk search gboard
```

### 📄 Package information

```bash
apk info com.example.app
```

### 🚫 Disable for user 0

```bash
apk disable com.example.app
```

Equivalent operation:

```bash
adb shell pm disable-user --user 0 com.example.app
```

### ✅ Enable

```bash
apk enable com.example.app
```

### 🗑️ Uninstall for user 0

```bash
apk uninstall com.example.app
```

The script intentionally uses:

```bash
adb shell pm uninstall --user 0 PACKAGE
```

For a preinstalled/system package, this normally removes it for user 0 rather than deleting the underlying system APK.

### ♻️ Restore a preinstalled package

```bash
apk restore com.example.app
```

Equivalent operation:

```bash
adb shell cmd package install-existing --user 0 com.example.app
```

This is useful for restoring a preinstalled application that was previously removed for user 0.

---

# ⌨️ Example: replacing stock Gboard

If a patched keyboard uses a different package name from stock Gboard, you can keep the patched keyboard active while removing the stock package for user 0.

First inspect installed packages:

```bash
apk search gboard
```

Then, after confirming the package names and making sure another keyboard is available:

```bash
apk uninstall com.google.android.inputmethod.latin
```

Restore the preinstalled copy later with:

```bash
apk restore com.google.android.inputmethod.latin
```

Always verify the package name before performing package operations.

---

# 🧬 ART / dexopt profile mismatch

### The problem

A patched APK can sometimes fail with output similar to:

```text
Error occurred during dexopt when processing external profiles
The profile does not match the APK
The checksums in the profile do not match the checksums of the .dex files
```

### What the manager does

The installer first performs the normal operation:

```bash
adb install -r APP.apk
```

If the output matches the known profile/dexopt failure patterns, it retries:

```bash
adb install -r --ignore-dexopt-profile APP.apk
```

For split packages it similarly retries `adb install-multiple` with the profile flag.

### Why this is automatic

The failure is environment-dependent. The same patched APK may install normally on one Android device and encounter the profile mismatch on another.

Therefore the manager uses **normal install first, targeted fallback second** rather than always bypassing profile processing.

---

# 🛡️ Safety model

This project is intentionally conservative.

### It does

- Use ADB package-management commands
- Limit destructive package removal to `--user 0`
- Ask for `YES` before interactive uninstall
- Keep system APKs intact when using user-scoped uninstall
- Detect common OEM/root-only failures
- Leave OEM security restrictions alone

### It does not

- Root the device
- Exploit Android security boundaries
- Bypass OEM root-only restrictions
- Modify `/system`
- Patch APKs
- Modify Morphe
- Wipe app data automatically
- Delete ART profiles automatically
- Install a persistent privileged daemon
- Require Shizuku

---

# 🔐 Wireless ADB and payment apps

Wireless Debugging/ADB is intended to be used only when required.

A practical workflow is:

```text
Enable Developer Options
        ↓
Enable Wireless Debugging
        ↓
Connect ADB
        ↓
Perform the required package operation
        ↓
Disconnect ADB
        ↓
Disable Wireless Debugging / Developer Options when finished
```

Whether a banking/payment application accepts a device with Developer Options or Wireless Debugging enabled is controlled by that application's own security checks. This project does not attempt to bypass those checks.

---

# 🔄 Termux backup

The APK manager itself does not need a separate backup mechanism. Back up your Termux `home` and `usr` directories with your own Termux backup workflow.

A generic backup script can be kept outside the public project if it contains personal configuration.

**Do not commit:**

- API tokens
- passwords
- pairing codes
- private IP addresses
- personal NextDNS profiles
- private backup archives
- company files
- company credentials

Personal utilities such as a `nextdns-backup` script are intentionally not included in this repository when they may contain user-specific configuration or credentials.

---

# 📁 Recommended Termux layout

```text
$HOME/
├── bin/
│   └── apk
├── .apk_tmp/             # temporary extraction directory
└── ...

/storage/emulated/0/
├── APK/
│   ├── app.apk
│   ├── app.apks
│   └── app.xapk
└── Termux Backups/
```

---

# 🧪 Testing checklist

Before releasing a new version, test at least:

- [ ] Normal `.apk` install
- [ ] APK filename containing spaces
- [ ] `.apks` split package
- [ ] `.xapk` package
- [ ] `.apkm` package
- [ ] Normal installation without profile error
- [ ] Known ART/profile mismatch fallback
- [ ] `apk list`
- [ ] `apk search QUERY`
- [ ] `apk info PACKAGE`
- [ ] Disable a normal package
- [ ] Re-enable it
- [ ] Uninstall a user-scoped package
- [ ] Restore a preinstalled package
- [ ] OEM-protected package returns a friendly error
- [ ] ADB-disconnected state returns a clear error

---

# 🧩 Why this is not Shizuku

This project deliberately uses **Termux + ADB** instead of implementing or embedding Shizuku.

Shizuku provides an IPC/Binder service that other Android applications can use to request privileged operations. This project instead keeps the workflow inside Termux and invokes ADB directly.

That means:

- Existing Shizuku-compatible applications do **not** automatically work with this project.
- This project does not claim to be a Shizuku replacement.
- It is useful when the desired operation can be performed through ADB/Package Manager commands.

Termux itself provides a `RUN_COMMAND` interface that can allow external applications to request Termux commands when explicitly configured and granted permission. If a future companion app is added, its security model should follow the official Termux permission requirements rather than exposing arbitrary shell access. See the official Termux RUN_COMMAND documentation: https://github.com/termux/termux-app/wiki/RUN_COMMAND-Intent

---

# 🤝 Contributing

Issues and pull requests are welcome.

Please keep contributions focused on:

- Android package management
- Termux compatibility
- ADB workflows
- APK/APKS/XAPK/APKM handling
- Reliability and error handling
- Documentation

Do not submit:

- private credentials
- company code
- proprietary APKs
- personal backup archives
- device-specific secrets
- bypasses for security controls

The `main` branch should remain protected. Pull requests are preferred for changes so they can be reviewed before merging. GitHub supports protected branches and PR templates for this workflow: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches

See [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

# 🔐 Security

Please do not publish security-sensitive information in issues or pull requests.

For security reports, see [`SECURITY.md`](SECURITY.md).

GitHub recommends maintaining a `SECURITY.md` policy so users know how to report vulnerabilities privately: https://docs.github.com/en/code-security/getting-started/quickstart-for-securing-your-repository

---

# 📜 License

MIT License. See [`LICENSE`](LICENSE).

---

# 📌 Project status

**Version:** `1.1.0`

This is a personal/open-source utility built around Android's ADB and package-management interfaces. Android/OEM behavior can differ between devices and software versions, especially for privileged system packages.

If an operation fails with an OEM/root-only `SecurityException`, the correct behavior is to report the restriction rather than attempt to bypass it.
