
# Log Archive Script

Project page: [https://roadmap.sh/projects/log-archive-tool](https://roadmap.sh/projects/log-archive-tool)

This script (`log-archive.sh`) is a simple CLI tool to archive and compress logs from a specified directory.

## Prerequisites
- Bash shell (Linux, macOS, or Windows with WSL/Git Bash)
- `tar` utility (standard on most Unix-like systems)
- AWS CLI installed and configured ([installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
- An AWS S3 bucket (see below)

## AWS Setup

1. **Configure AWS CLI:**
   ```sh
   aws configure
   ```
   Enter your AWS Access Key, Secret Key, region, and output format.

2. **Create an S3 bucket:**
   ```sh
   aws s3 mb s3://your-s3-bucket-name
   ```
   Replace `your-s3-bucket-name` with your desired bucket name.

3. **Set the S3 bucket in the script:**
   Edit `log-archive.sh` and set the `S3_BUCKET` variable to your bucket name.

## Usage

1. **Make the script executable:**
   ```sh
   chmod +x log-archive.sh
   ```

2. **Run the script with the log directory as an argument:**
   ```sh
   ./log-archive.sh /path/to/log-directory
   ```
   - Replace `/path/to/log-directory` with the path to the directory containing your logs.

## What It Does
- Archives and compresses all files in the specified log directory into a timestamped `.tar.gz` file under `~/log-archives/`.
- Uploads the archive to your configured AWS S3 bucket.
- Logs each archive operation in `~/log-archives/archive.log`.

## Example
```sh
./log-archive.sh /var/log/nginx
```

## Output
- Archive: `~/log-archives/logs_archive_<timestamp>.tar.gz`
- S3: `s3://your-s3-bucket-name/logs_archive_<timestamp>.tar.gz`
- Log: `~/log-archives/archive.log`

## Automate with Cron
To run the script every day at 12:00 AM, add this line to your crontab (edit with `crontab -e`):

```
0 0 * * * /bin/bash /path/to/log-archive.sh /path/to/log-directory
```
Replace `/path/to/log-archive.sh` and `/path/to/log-directory` with the actual paths.

