# 🚀 Automated Backup & Rotation System using AWS EC2, Bash, rclone & Google Drive

## 📌 Project Overview

This project demonstrates an **automated backup system** running on AWS EC2.

The system automatically:

* Compresses project files
* Uploads backups to Google Drive
* Deletes old backups
* Logs activities
* Runs automatically using cron jobs

---

# 🏗 DevOps Architecture

```
            ┌────────────────────┐
            │      Developer      │
            │   (Push project)    │
            └─────────┬──────────┘
                      │
                      ▼
              ┌───────────────┐
              │   AWS EC2     │
              │ Amazon Linux  │
              └───────┬───────┘
                      │
                      ▼
            ┌─────────────────┐
            │ Backup Script   │
            │  backup_script  │
            └────────┬────────┘
                     │
                     ▼
              ┌─────────────┐
              │   Cron Job  │
              │ Daily 2 AM  │
              └───────┬─────┘
                      │
                      ▼
              ┌──────────────┐
              │ Backup File  │
              │  tar.gz      │
              └───────┬──────┘
                      │
                      ▼
             ┌─────────────────┐
             │     rclone      │
             │ Upload to Cloud │
             └───────┬─────────┘
                     │
                     ▼
              ┌──────────────┐
              │ Google Drive │
              │ Backup Store │
              └──────────────┘
```

---

# ⚙️ Step 1 — Launch AWS EC2 Instance

Launch an EC2 instance:

```
Amazon Linux 2023
t2.micro
```

### 📸 EC2 Instance Running

![EC2 Instance](./)

---

# ⚙️ Step 2 — Install rclone

```
curl https://rclone.org/install.sh | sudo bash
```

Verify installation:

```
rclone version
```

---

# ⚙️ Step 3 — Configure Google Drive

```
rclone config
```

Select:

```
n → new remote
name → gdrive
storage → drive
scope → 1
```

### 📸 Google Account Authorization

![Google Login](screenshots/google-account.png)

### 📸 Google Authentication Success

![Auth Success](screenshots/google-auth-success.png)

---

# ⚙️ Step 4 — Create Backup Script

Create file:

```
nano backup_script.sh
```

Paste script:

```bash
#!/bin/bash

PROJECT_NAME="devops-project"
SOURCE_DIR="/home/ec2-user/backup-automation-project"
BACKUP_DIR="/home/ec2-user/backup-automation-project/backups"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$PROJECT_NAME-$DATE.tar.gz"

echo "Backup started at $(date)" >> backup.log

tar -czf $BACKUP_DIR/$BACKUP_FILE $SOURCE_DIR

echo "Backup created: $BACKUP_FILE" >> backup.log

rclone copy $BACKUP_DIR/$BACKUP_FILE gdrive:backup-folder

echo "Uploaded to Google Drive" >> backup.log

find $BACKUP_DIR -type f -mtime +7 -delete

echo "Old backups cleaned" >> backup.log
```

---

# ⚙️ Step 5 — Run Backup Script

```
chmod +x backup_script.sh
./backup_script.sh
```

### 📸 Backup Script Running

![Backup Script](screenshots/backup-script.png)

---

# ⚙️ Step 6 — Verify Google Drive Backup

```
rclone ls gdrive:backup-folder
```

### 📸 Backup Uploaded to Google Drive

![Google Drive Backup](screenshots/google-drive-backup.png)

---

# ⚙️ Step 7 — Install Cron

```
sudo dnf install cronie -y
```

Start cron:

```
sudo systemctl start crond
```

Enable cron:

```
sudo systemctl enable crond
```

---

# ⚙️ Step 8 — Schedule Backup

```
crontab -e
```

Add:

```
0 2 * * * /home/ec2-user/backup-automation-project/backup_script.sh
```

### 📸 Cron Job Running

![Cron Job](screenshots/cron-job.png)

---

# 📂 Project Structure

```
backup-automation-project
│
├── backup_script.sh
├── backup.log
├── README.md
└── screenshots
```

---

# 📈 Real DevOps Use Case

This project demonstrates:

* Infrastructure automation
* Backup strategy implementation
* Cloud storage integration
* Linux automation
* Scheduled job management

---

# 👨‍💻 Author

**Rohit Bhusare**

Aspiring DevOps Engineer
AWS • Linux • Automation • CI/CD
