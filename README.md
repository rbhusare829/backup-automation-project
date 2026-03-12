# 🚀 Automated Backup & Rotation System using AWS EC2, Bash, rclone & Google Drive

## 📌 Project Overview

This project demonstrates an **automated backup system** running on **AWS EC2**.

The system automatically:

* Compresses project files
* Uploads backups to Google Drive
* Deletes old backups
* Logs backup activity
* Runs automatically using cron jobs

This simulates a **real-world DevOps backup strategy** used in production systems.

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

![EC2 Instance Running](./screenshots/Screenshot%202026-03-12%20155519.png)

---

# ⚙️ Step 2 — Install rclone

Install rclone on EC2:

```
curl https://rclone.org/install.sh | sudo bash
```

Verify installation:

```
rclone version
```

---

# ⚙️ Step 3 — Configure Google Drive

Run configuration:

```
rclone config
```

Select options:

```
n → new remote
name → gdrive
storage → drive
scope → 1
```

### 📸 Google Account Authorization

![Google Account Authorization](./screenshots/Screenshot%202026-03-12%20152815.png)

### 📸 rclone Authorization Success

![rclone Authorization Success](./screenshots/Screenshot%202026-03-12%20152759.png)

---

# ⚙️ Step 4 — Create Backup Script

Create the script:

```
nano backup_script.sh
```

Script:

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

### 📸 Backup Script Execution

![Backup Script Execution](./screenshots/Screenshot%202026-03-12%20154648.png)

---

# ⚙️ Step 6 — Verify Google Drive Backup

```
rclone ls gdrive:backup-folder
```

### 📸 Backup Uploaded to Google Drive

![Backup Uploaded to Google Drive](./screenshots/Screenshot%202026-03-12%20154619.png)

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

![Cron Job Running](./screenshots/Screenshot%202026-03-12%20154709.png)

---

# ⚙️ Step 9 — rclone Authorization

### 📸 rclone Authorization Terminal

![rclone Authorization Terminal](./screenshots/Screenshot%202026-03-12%20154531.png)

---

# 📂 Project Structure

```
backup-automation-project
│
├── backup_script.sh
├── backup.log
├── README.md
└── screenshots/
    ├── Screenshot 2026-03-12 152759.png
    ├── Screenshot 2026-03-12 152815.png
    ├── Screenshot 2026-03-12 154531.png
    ├── Screenshot 2026-03-12 154619.png
    ├── Screenshot 2026-03-12 154648.png
    ├── Screenshot 2026-03-12 154709.png
    └── Screenshot 2026-03-12 155519.png
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
