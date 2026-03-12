#!/bin/bash

# Project name
PROJECT_NAME="devops-project"

# Source directory
SOURCE_DIR="/home/ec2-user/backup-automation-project"

# Backup directory
BACKUP_DIR="/home/ec2-user/backup-automation-project/backups"

# Date format
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Backup file name
BACKUP_FILE="$PROJECT_NAME-$DATE.tar.gz"

echo "--------------------------------" >> backup.log
echo "Backup started at $(date)" >> backup.log

# Create compressed backup
tar -czf $BACKUP_DIR/$BACKUP_FILE $SOURCE_DIR

echo "Backup created: $BACKUP_FILE" >> backup.log

# Upload backup to Google Drive
rclone copy $BACKUP_DIR/$BACKUP_FILE gdrive:backup-folder

echo "Uploaded to Google Drive" >> backup.log

# Delete backups older than 7 days
find $BACKUP_DIR -type f -mtime +7 -delete

echo "Old backups cleaned" >> backup.log

echo "Backup finished at $(date)" >> backup.log