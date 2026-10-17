# Log Archive Tool

A simple Bash command line tool that compresses a log directory into a `tar.gz` file, stores it in a new directory, and records the date and time of each archive.

Project from roadmap.sh: **PASTE THE PROJECT PAGE URL HERE**

## Features

- Takes the log directory as an argument
- Compresses the logs into a `tar.gz` archive
- Stores archives in a new directory (created automatically)
- Names each archive with the date and time, for example `logs_archive_20261017_100648.tar.gz`
- Records the date and time of every archive in a log file
- Shows clear error messages for wrong input

## Requirements

- A Linux system with Bash
- Standard tools that come with Linux: `tar`, `date`, `realpath`, `du`

## How to run

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR-USERNAME/log-archive.git
   cd log-archive
   ```
2. Make the script executable:
   ```bash
   chmod +x log-archive
   ```
3. Run it with the log directory:
   ```bash
   ./log-archive <log-directory>
   ```

## Usage

```bash
./log-archive <log-directory> [archive-directory]
```

| Part | Meaning |
|------|---------|
| `<log-directory>` | The folder with the logs you want to archive (required) |
| `[archive-directory]` | Where to store the archive (optional). Default: `log-archives` in the current folder |

Examples:
```bash
# Archive the system logs (needs sudo to read some files)
sudo ./log-archive /var/log

# Archive a folder and store the archive in a custom location
./log-archive ~/my-app/logs ~/backups/logs
```

## Example output

```
$ ./log-archive test-logs
Logs archived successfully.
Archive: /home/user/log-archive/log-archives/logs_archive_20261017_100648.tar.gz
Size   : 4.0K
Record : /home/user/log-archive/log-archives/archive.log
```

The record file `archive.log` gets one line for each archive:
```
2026-10-17 10:06:48 - Archived /home/user/test-logs to /home/user/log-archive/log-archives/logs_archive_20261017_100648.tar.gz
```

## Check the result

```bash
ls log-archives                         # see the archive files
cat log-archives/archive.log            # see the record of archives
tar -tzf log-archives/<archive-name>    # list what is inside an archive
```

To extract an archive:
```bash
tar -xzf log-archives/<archive-name> -C /path/to/restore
```

## How it works

1. Checks that a log directory was given, exists, and can be read.
2. Creates the archive directory if it does not exist.
3. Builds the archive name from the current date and time: `logs_archive_YYYYMMDD_HHMMSS.tar.gz`.
4. Compresses the logs with `tar -czf`.
5. Adds a line with the date and time to `archive.log`.

## Error handling

The tool stops with a clear message when:
- No log directory is given
- The log directory does not exist or is not a directory
- The log directory cannot be read (try `sudo`)
- The archive directory is inside the log directory
- The archive could not be created

## Run it from anywhere (optional)

To run `log-archive` without `./` from any folder:
```bash
sudo cp log-archive /usr/local/bin/
log-archive <log-directory>
```

## What I learned

Write this part in your own words after you finish.
