# 📱 Termux APK Manager

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Android](https://img.shields.io/badge/Android-Wireless%20ADB-green.svg)](#-enable-wireless-debugging)
[![Termux](https://img.shields.io/badge/Termux-supported-blue.svg)](#-termux-setup)
[![Version](https://img.shields.io/badge/version-1.0.0-informational.svg)](CHANGELOG.md)

A small, beginner-friendly Termux utility for installing Android application packages through ADB Wireless Debugging.

It is designed as a simple **fallback installation path** when normal package installation is unavailable or when a tested ART/dexopt profile mismatch occurs.

**No root. No Shizuku. No changes to Morphe.** 🔐

A lightweight APK installer for Termux using Android Debug Bridge (ADB), with support for normal and split APK packages and an automatic ART/dexopt profile fallback.

> 🔧 **Morphe-friendly:** This project is an installation fallback. It does not modify Morphe or the patched APK.

## ✨ Features

- 📦 `.apk` support
- 🧩 `.apks` support
- 📦 `.xapk` support
- 📦 `.apkm` support
- 🔀 Automatic split APK installation
- 📡 Wireless ADB support
- 🔄 Automatic ART/dexopt profile fallback
- 🧹 Automatic temporary-file cleanup
- 📁 Dedicated APK directory
- 🔤 Filenames with spaces are supported
- 🔒 No root required
- 🚫 No Shizuku required
- 🛡️ No automatic uninstall or data wipe
- ❤️ Designed as a simple fallback installation method

---

## 🧭 How it works

The normal workflow is:

**Morphe → Patch → Export APK → Put it in the APK folder → Connect ADB → Run `apk` → Select package → Install**

The installer first attempts the normal Android ADB installation.

If a specific ART/dexopt profile error is detected, it automatically retries using Android's `--ignore-dexopt-profile` installation option.

```text
📦 Package
   ↓
📲 Normal ADB installation
   ↓
   ├── ✅ Success → Finished
   │
   └── ❌ ART/profile mismatch
             ↓
      🔄 Retry with
      --ignore-dexopt-profile
             ↓
          ✅ Done
```

---

# 🔐 Privacy & sensitive information

This repository intentionally contains **no personal device information**.

Do not publish private IP addresses, ADB ports, Wireless Debugging pairing codes, personal information, passwords, tokens, credentials, private APKs, or device/account identifiers.

Example IP addresses in this README are placeholders only.

The script does not intentionally collect, upload, or transmit user data.

---

# 📋 Requirements

## 📱 Android

You need:

- Android device with Developer Options
- Wireless Debugging support
- Termux
- ADB tools installed inside Termux

Root is **not** required.

Shizuku is **not** required.

---

# 📥 Termux setup

Install a current Termux build from a trusted source such as the official Termux GitHub releases.

After opening Termux, update packages:

```bash
pkg update
```

Install Android Debug Bridge:

```bash
pkg install android-tools
```

Install unzip support:

```bash
pkg install unzip
```

Verify ADB:

```bash
adb version
```

You should see the installed Android Debug Bridge version.

---

# 📂 Create the APK folder

This project intentionally uses one dedicated folder:

```text
/storage/emulated/0/APK
```

Create it:

```bash
mkdir -p /storage/emulated/0/APK
```

Put your `.apk`, `.apks`, `.xapk`, or `.apkm` files there.

The installer searches **only this directory** when you run `apk` without an argument.

---

# 🔐 Termux storage permission

Allow Termux access to shared storage.

You can also initialize Termux shared-storage access with:

```bash
termux-setup-storage
```

Android will show a permission request. Allow it.

📌 The exact permission names can vary between Android versions and manufacturers.

---

# 📡 Enable Wireless Debugging

Wireless ADB is what allows Termux to communicate with Android's package manager.

## 1️⃣ Enable Developer Options

On most Android devices:

**Settings → About phone → Software information → Build number**

Tap **Build number** repeatedly until Developer Options are enabled.

The exact location can vary by manufacturer.

## 2️⃣ Enable Wireless Debugging

Open:

**Settings → Developer options → Wireless debugging**

Turn **Wireless debugging** ON.

---

# 🔗 Pair Termux with Wireless Debugging

If this is the first time you're connecting:

Open:

**Wireless debugging → Pair device with pairing code**

Android will display an IP address, port, and pairing code.

In Termux:

```bash
adb pair IP:PAIRING_PORT
```

For example:

```bash
adb pair 192.168.x.x:xxxxx
```

Enter the pairing code shown by Android.

✅ Pairing only needs to be performed when Android requires it.

---

# 🔌 Connect ADB

After pairing, use the connection address shown on the main Wireless Debugging screen:

```bash
adb connect IP:PORT
```

Example:

```bash
adb connect 192.168.x.x:xxxxx
```

Then verify:

```bash
adb devices
```

You should see something similar to:

```text
192.168.x.x:xxxxx    device
```

🎉 ADB is connected.

> ⚠️ Do not copy the example IP/port above. Use the current address shown by your own phone.

---

# 📥 Installing the script

After downloading or cloning this repository, copy the `apk` script into Termux:

```bash
mkdir -p ~/bin
cp apk ~/bin/apk
chmod +x ~/bin/apk
```

Verify it:

```bash
command -v apk
```

Then run:

```bash
apk
```

---

# 📲 Install packages

Once ADB is connected, simply run:

```bash
apk
```

The script will search:

```text
/storage/emulated/0/APK
```

and display the available packages.

Example:

```text
📦 Available packages:

1) OpenLoader.apks
2) ForceStopHelper.apk
3) App.apk
4) Transfer.apk

👉 Select package: 4

📦 Selected: Transfer.apk

📲 Installing APK...
Performing Streamed Install
Success

━━━━━━━━━━━━━━━━━━━━━━━━
✅ Installation successful!
━━━━━━━━━━━━━━━━━━━━━━━━
```

---

# 📦 Supported package types

## `.apk`

A normal APK is installed with:

```bash
adb install -r
```

The `-r` option allows an existing installation to be updated while retaining its application data.

## `.apks`, `.xapk`, `.apkm`

These packages can contain multiple APK components.

The script:

1. 📦 Extracts the package into a temporary directory
2. 🔍 Finds the APK components
3. 🧩 Installs the components
4. 🧹 Removes the temporary files

For multiple APK components, it uses:

```bash
adb install-multiple -r
```

Users do not need to manually extract the package.

---

# ⚠️ ART / Dexopt profile mismatch

One of the reasons this project was created was an installation problem encountered with some patched APKs.

A normal installation can sometimes produce errors such as:

```text
Error occurred during dexopt when processing external profiles

The profile does not match the APK

The checksums in the profile do not match
the checksums of the .dex files in the APK
```

At first, the APK filename may look suspicious, especially when it contains spaces.

Testing with different filenames showed that the filename itself was **not the cause**.

The issue was related to the Android Runtime (ART) dexopt profile.

---

# 🔄 Automatic fallback

Android's package installer provides:

```bash
--ignore-dexopt-profile
```

A manual installation can therefore be retried with:

```bash
adb install -r --ignore-dexopt-profile "patched-app.apk"
```

The script automates this.

### Normal path

```text
📲 adb install -r
       ↓
   ✅ Success
```

### Fallback path

```text
📲 adb install -r
       ↓
⚠️ ART/profile mismatch
       ↓
🔄 Automatic retry
       ↓
📲 --ignore-dexopt-profile
       ↓
✅ Success
```

The same fallback is used for split APK installation.

---

# 🛡️ What this project does NOT do

The installer does **not**:

- 🚫 Automatically uninstall applications
- 🚫 Wipe application data
- 🚫 Modify Morphe
- 🚫 Modify the patched APK
- 🚫 Disable ProfileInstaller
- 🚫 Require root
- 🚫 Require Shizuku
- 🚫 Delete Android profiles manually
- 🚫 Change Android system settings

It is simply an **ADB-based installation tool**.

---

# 🔧 Morphe workflow

If you use Morphe, the recommended workflow is:

### 1️⃣ Patch the app

Use Morphe normally.

### 2️⃣ Export/save the patched package

Save the resulting package to:

```text
/storage/emulated/0/APK
```

### 3️⃣ Enable Wireless Debugging

Turn it on in Android Developer Options.

### 4️⃣ Connect ADB

```bash
adb connect IP:PORT
```

Verify:

```bash
adb devices
```

### 5️⃣ Run the installer

```bash
apk
```

### 6️⃣ Select your package

Choose the number shown in the menu.

### 7️⃣ Install 🎉

The script handles normal installation and the ART profile fallback automatically.

> 💡 Morphe's own installer does not need to be modified for this project.

---

# 🧪 Tested scenarios

| Scenario | Result |
|---|---|
| Normal `.apk` | ✅ Tested |
| `.apks` split package | ✅ Tested |
| Morphe-patched APK | ✅ Tested |
| ART profile mismatch | ✅ Automatic fallback |
| APK filename with spaces | ✅ Supported |
| Temporary split extraction | ✅ Cleaned automatically |

---

# 🛠️ Troubleshooting

## ❌ `adb: command not found`

Install Android Debug Bridge:

```bash
pkg install android-tools
```

Then:

```bash
adb version
```

---

## ❌ `adb devices` shows no device

Check:

- 📡 Wireless Debugging is enabled
- 📱 Termux and the device are using a working network connection
- 🔗 The correct IP and port are being used
- 🔄 Try connecting again

```bash
adb connect IP:PORT
```

Then:

```bash
adb devices
```

---

## ❌ Device shows `unauthorized`

Check the phone for an ADB authorization prompt and accept it.

Then:

```bash
adb devices
```

---

## ❌ `apk` says ADB device not connected

Check:

```bash
adb devices
```

If the device is not listed:

```bash
adb connect IP:PORT
```

Then:

```bash
apk
```

---

## ❌ ART/profile installation error

The script should automatically detect the supported ART/profile error and retry.

For a manual test:

```bash
adb install -r --ignore-dexopt-profile "app.apk"
```

Only use the fallback when the normal installation reports the relevant profile/dexopt problem.

---

# 🔌 Disconnect ADB

When finished:

```bash
adb disconnect
```

You can also disable Wireless Debugging when you no longer need it.

📌 Disabling Developer Options/Wireless Debugging does not remove your Termux scripts or files.

---

# 🔒 Security notes

Wireless Debugging provides ADB access to the device.

For safety:

- 🔐 Use it on a trusted network
- 🚫 Do not accept unknown pairing requests
- 🔑 Never share your pairing code
- 🌐 Do not publish your private IP/ADB port unnecessarily
- 📵 Disable Wireless Debugging when you are finished if you do not need it

---

# 🧹 Temporary files

Split packages are extracted into a temporary directory under Termux.

The installer removes this directory automatically when it exits.

This keeps the temporary APK components from accumulating.

---

# 📁 Project structure

```text
Termux-APK-Manager/
├── apk
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
└── .gitignore
```

---

# ⚠️ Scope and limitations

This project intentionally keeps its job small: **find package → install through ADB → recover from the tested ART profile error → report the result.**

It does not attempt to circumvent Android account/device protections, patch applications, manage Morphe, modify APK contents, or manage app permissions automatically. Compatibility can vary between Android versions, manufacturers, package formats, and ADB implementations.

---

# ❓ FAQ

### Does this require root?

❌ No.

### Does this require Shizuku?

❌ No.

### Does this modify Morphe?

❌ No.

### Does it support normal APKs?

✅ Yes.

### Does it support split APKs?

✅ Yes.

### Does it support Morphe-patched APKs?

✅ Yes, including the tested ART profile mismatch fallback.

### Do I need Wireless Debugging enabled permanently?

❌ No. Enable it when you need ADB.

### Does turning Developer Options off break Termux?

❌ No. Termux remains installed and its files/scripts remain available.

### Does the installer search my Downloads folder?

❌ No. When run as `apk`, it searches only:

```text
/storage/emulated/0/APK
```

### Does it automatically uninstall or wipe the app?

❌ No.

---

# 🤝 Contributing

Contributions are welcome! ❤️

You can help by:

- 🐛 Reporting bugs
- 💡 Suggesting improvements
- 🔧 Submitting fixes
- 🧪 Testing on different Android versions
- 📱 Testing on different devices
- 📝 Improving documentation

Please read `CONTRIBUTING.md` before submitting changes.

---

# ❤️ Why this project exists

This started as a personal fallback because I wanted another way to install applications patched with Morphe.

Instead of changing Morphe or depending on a single installation method, this project provides a simple ADB-based installation path through Termux.

If it helps someone else too, even better. ❤️📱

---

## 📜 License

This project is licensed under the MIT License.

See [`LICENSE`](LICENSE) for details.
