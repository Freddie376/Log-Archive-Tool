#!/bin/bash
# log-archive
# Compresses a log directory into a tar.gz file and records when it was archived.
#
# Usage: log-archive <log-directory> [archive-directory]

# --- 1. Check the input ---
if [ -z "$1" ]; then
    echo "Error: please give the log directory."
    echo "Usage: log-archive <log-directory> [archive-directory]"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a directory or does not exist."
    exit 1
fi

if [ ! -r "$1" ]; then
    echo "Error: no permission to read '$1'. Try running with sudo."
    exit 1
fi

# --- 2. Set up the paths ---
LOG_DIR=$(realpath "$1")
ARCHIVE_DIR=$(realpath -m "${2:-log-archives}")   # default: ./log-archives

# Do not store the archive inside the folder being archived
case "$ARCHIVE_DIR/" in
    "$LOG_DIR"/*)
        echo "Error: the archive directory cannot be inside the log directory."
        exit 1
        ;;
esac

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE_FILE="$ARCHIVE_DIR/logs_archive_$TIMESTAMP.tar.gz"
RECORD_FILE="$ARCHIVE_DIR/archive.log"

# --- 3. Create the archive directory ---
mkdir -p "$ARCHIVE_DIR" || {
    echo "Error: could not create '$ARCHIVE_DIR'."
    exit 1
}

# --- 4. Compress the logs ---
# -C moves into the parent folder first, so the archive does not keep the full path
if ! tar -czf "$ARCHIVE_FILE" -C "$(dirname "$LOG_DIR")" "$(basename "$LOG_DIR")"; then
    echo "Error: could not create the archive."
    rm -f "$ARCHIVE_FILE"
    exit 1
fi

# --- 5. Record the date and time of the archive ---
echo "$(date '+%Y-%m-%d %H:%M:%S') - Archived $LOG_DIR to $ARCHIVE_FILE" >> "$RECORD_FILE"

# --- 6. Show the result ---
echo "Logs archived successfully."
echo "Archive: $ARCHIVE_FILE"
echo "Size   : $(du -h "$ARCHIVE_FILE" | cut -f1)"
echo "Record : $RECORD_FILE"
