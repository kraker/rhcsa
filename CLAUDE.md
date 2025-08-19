# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Red Hat Certified System Administrator (RHCSA) certification study repository. It contains practical lab scenarios, skills assessments, study materials, and memorization aids for RHCSA exam preparation. This is NOT a software development project - it's a learning resource for Linux system administration.

## Repository Structure

- `/lab_scenarios/` - Hands-on practice scenarios with specific time limits and difficulty levels
  - `01_user_management.md` - User/group creation, sudo configuration, password policies
  - `02_storage_management.md` - LVM, partitioning, filesystem creation, and swap setup
  - `03_selinux_security.md` - SELinux contexts, Apache httpd configuration, security troubleshooting
- `skills_assessment.md` - Comprehensive checklist of RHCSA exam objectives with self-assessment
- `anki_deck.csv` - 104 flashcards covering essential RHCSA commands organized by topic
- `README.md` - Basic project description (minimal content)
- Study materials: EPUB files and ZIP archives for reference

## Lab Environment Requirements

The lab scenarios are designed for specific RHEL 9 virtual machines:
- **rhel9a**: Used for user management and SELinux scenarios
- **rhel9b**: Used for storage management scenarios (requires multiple additional disks: /dev/sdb, /dev/sdc, /dev/sdd, /dev/sde, /dev/sdf)

## Common Study Tasks

### Working with Lab Scenarios
- Each scenario includes time limits, prerequisites, step-by-step tasks, and verification commands
- Follow the exact command sequences provided for consistent results
- Use verification commands to confirm successful completion
- Lab 3 (SELinux) contains a `TODO(human)` section that needs completion

### Skills Assessment Usage
- Use the confidence ratings: ✅ Confident, 📖 Review, 🎯 Learn
- Focus study time: 60% on Learn topics, 30% on Review topics, 10% on Confident topics
- Track progress through the comprehensive RHCSA objective checklist

### Anki Deck Commands
The CSV file contains essential commands organized by tags:
- `user_management` - useradd, usermod, chage, groupadd
- `permissions` - chmod, chown, file access controls
- `systemd` - systemctl, journalctl, service management
- `storage` - fdisk, mkfs, mount, fstab configuration
- `lvm` - pvcreate, vgcreate, lvcreate, volume management
- `selinux` - getenforce, setsebool, restorecon, context management
- `firewall` - firewall-cmd, port and service management
- `networking` - nmcli, static IP, DNS configuration
- `containers` - podman operations, systemd integration

## Key RHCSA Command Categories

### Essential System Management
```bash
# Service Management
systemctl start/stop/enable/disable service
journalctl -u servicename
systemctl set-default target

# User Management  
useradd -u UID -g GROUP username
usermod -aG supplementary-group username
chage -M maxdays -m mindays -W warndays username

# File Operations
chmod 755 filename
chown user:group filename
find / -user username -type f 2>/dev/null
```

### Storage and LVM
```bash
# LVM Workflow
pvcreate /dev/device
vgcreate vgname /dev/device
lvcreate -L size -n lvname vgname
mkfs.xfs /dev/vgname/lvname
mount /dev/vgname/lvname /mountpoint

# Filesystem Management
echo "/dev/vgname/lvname /mountpoint xfs defaults 0 2" >> /etc/fstab
xfs_growfs /mountpoint  # After lvextend
resize2fs /dev/device   # For ext4
```

### Security and SELinux
```bash
# SELinux Management
getenforce / setenforce 0|1
ls -Z filename
restorecon -R /path
setsebool -P boolean on
ausearch -m AVC -ts recent

# Firewall
firewall-cmd --add-service=http --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload
```

## Notes for Claude Code

- This repository focuses on RHCSA exam preparation, not software development
- When helping with lab scenarios, emphasize practical command execution and verification
- The study materials are for learning Linux system administration concepts
- Lab scenarios should be executed in the specified VM environments
- Pay attention to the TODO(human) section in lab_scenarios/03_selinux_security.md that may need completion
- Commands in the Anki deck represent real RHCSA exam tasks and should be executed carefully in lab environments

## Study Workflow Recommendations

1. Complete skills assessment to identify weak areas
2. Practice lab scenarios in order of increasing difficulty
3. Use Anki deck for command memorization and quick reference
4. Verify all tasks with provided verification commands
5. Focus on practical application rather than theoretical knowledge