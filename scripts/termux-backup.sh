#!/data/data/com.termux/files/usr/bin/bash

BACKUP_DIR="/storage/emulated/0/Termux Backups"
DATE="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_FILE="$BACKUP_DIR/termux-full-backup-$DATE.tar.gz"

echo "📱 Termux Full Backup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "📦 Creating backup..."
echo

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_FILE" \
    -C /data/data/com.termux/files \
    home usr

RESULT=$?

echo

if [ "$RESULT" -eq 0 ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)

    echo "━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ Backup successful!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "📦 File:"
    echo "$(basename "$BACKUP_FILE")"
    echo
    echo "💾 Size: $SIZE"
    echo
    echo "📂 Location:"
    echo "$BACKUP_DIR"
else
    echo "━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❌ Backup failed!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━"

    rm -f "$BACKUP_FILE"
    exit 1
fi
