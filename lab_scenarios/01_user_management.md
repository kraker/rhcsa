# Lab Scenario 1: User and Group Management

**VM:** rhel9a  
**Time Limit:** 30 minutes  
**Difficulty:** Beginner

## Scenario
You are a new system administrator at Acme Corp. Your first task is to set up user accounts for the development team and configure proper access controls.

## Tasks

### 1. Create Users and Groups (10 minutes)
```bash
# Create groups
sudo groupadd -g 2000 developers
sudo groupadd -g 2001 testers
sudo groupadd -g 2002 managers

# Create users
sudo useradd -u 3001 -g developers -s /bin/bash alice
sudo useradd -u 3002 -g developers -s /bin/bash bob
sudo useradd -u 3003 -g testers -s /bin/bash charlie
sudo useradd -u 3004 -g managers -s /bin/bash diana

# Add alice to managers group as secondary
sudo usermod -aG managers alice
```

### 2. Password Policies (5 minutes)
```bash
# Set passwords (interactive)
sudo passwd alice
sudo passwd bob
sudo passwd charlie
sudo passwd diana

# Configure password aging for alice
sudo chage -M 90 -m 7 -W 7 alice

# Force bob to change password on next login
sudo chage -d 0 bob
```

### 3. Sudo Configuration (10 minutes)
```bash
# Allow developers group to run specific commands
sudo visudo
# Add line: %developers ALL=(ALL) /usr/bin/systemctl, /usr/bin/dnf

# Allow diana (manager) full sudo access
# Add line: diana ALL=(ALL) ALL
```

### 4. Home Directory Setup (5 minutes)
```bash
# Create shared directory for developers
sudo mkdir -p /opt/projects
sudo chown root:developers /opt/projects
sudo chmod 2775 /opt/projects

# Set default umask for developers
echo "umask 002" | sudo tee -a /etc/profile.d/developers.sh
```

## Verification Commands
```bash
# Verify users and groups
id alice
id bob
groups alice
getent passwd alice
getent group developers

# Check password aging
sudo chage -l alice

# Test sudo access
sudo -u alice systemctl status httpd
sudo -u diana whoami

# Check directory permissions
ls -ld /opt/projects
```

## Expected Results
- Alice should be in developers and managers groups
- Bob should be forced to change password on login
- Alice can run systemctl and dnf with sudo
- Diana has full sudo access
- /opt/projects should have group sticky bit set

## Troubleshooting Tips
- If user creation fails: Check if UID/GID already exists
- If sudo fails: Verify /etc/sudoers syntax with `visudo`
- If password aging doesn't work: Check `/etc/shadow` file