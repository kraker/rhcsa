# RHCSA Skills Assessment

Use this checklist to identify areas for focused study. Rate each objective based on your confidence:
- ✅ **Confident** - Can perform without reference under exam time pressure
- 📖 **Review** - Know the concept, need to practice RHEL 9-specific syntax/details  
- 🎯 **Learn** - Need to study this topic
- ⚡ **Time Risk** - Know it but might struggle under 3-hour exam pressure

**For Experienced Admins:** Be honest about exam conditions. Mark ⚡ for tasks you can do but might fumble syntax without Google.

## ⭐ High-Risk Areas for Experienced Admins

These are commonly missed by experienced admins due to RHEL 9 changes or exam-specific requirements:

### RHEL 9 Specific Changes
- [ ] Container management with podman (not Docker)
- [ ] NetworkManager CLI (nmcli) - no GUI editing
- [ ] firewall-cmd instead of iptables direct manipulation
- [ ] systemd-resolved DNS vs /etc/resolv.conf
- [ ] New SELinux boolean names and contexts

### Exam Pressure Points
- [ ] Boot process interruption and rescue mode
- [ ] LVM commands under time pressure (extend, reduce safely)
- [ ] Cron syntax without looking it up
- [ ] SSH key-based auth setup from scratch
- [ ] NFS/autofs configuration syntax

## Understand and Use Essential Tools (Weight: ~15%)

### File Operations and Text Processing
- [ ] Access shell prompt and issue commands with correct syntax
- [ ] Use input/output redirection (`>`, `>>`, `<`, `|`)
- [ ] Use grep and regular expressions to analyze text
- [ ] Access remote systems using SSH
- [ ] Log in and switch users in multiuser targets
- [ ] Archive, compress, unpack, uncompress files (`tar`, `gzip`, `bzip2`)
- [ ] Create and edit text files
- [ ] Create, delete, copy, move files and directories
- [ ] Create hard and soft links
- [ ] List, set, change file permissions and ownership

**Quick Test Commands:**
```bash
man grep    # Check regex syntax
man tar     # Archive options
man chmod   # Permission syntax
```

## Create Simple Shell Scripts (Weight: ~10%)

### Scripting Basics
- [ ] Conditionally execute code (`if`, `case`)
- [ ] Use looping constructs (`for`, `while`) 
- [ ] Process script inputs (`$1`, `$2`, etc.)
- [ ] Process output of shell commands in scripts

**Practice Scripts to Write:**
- User creation script with input validation
- File backup script with date stamps
- System monitoring script with thresholds

## Operate Running Systems (Weight: ~20%)

### Boot Process and Services
- [ ] Boot, reboot, shut down system normally
- [ ] Boot systems into emergency and rescue targets
- [ ] Start and stop services, configure auto-start
- [ ] Interrupt boot process to gain root access
- [ ] Identify CPU/memory intensive processes
- [ ] Adjust process scheduling priority
- [ ] Manage tuning profiles
- [ ] Locate and interpret system log files and journals
- [ ] Preserve system journals across reboots
- [ ] Start, stop, check status of network services
- [ ] Transfer files securely via network

**Key Commands to Master:**
```bash
systemctl list-units --type=service
journalctl -xe
systemctl set-default multi-user.target
```

## Configure Local Storage (Weight: ~15%)

### Disk Management
- [ ] List, create, delete partitions on MBR and GPT disks
- [ ] Create and remove physical volumes
- [ ] Assign physical volumes to volume groups
- [ ] Create and delete logical volumes
- [ ] Configure systems to mount file systems on boot
- [ ] Add new partitions and logical volumes non-destructively

**Lab Practice Areas:**
- Use your rhel9b VM with multiple disks
- Practice fdisk, parted, pvcreate, vgcreate, lvcreate
- Test /etc/fstab entries and mount options

## Create and Configure File Systems (Weight: ~10%)

### File System Operations
- [ ] Create, mount, unmount, use xfs and ext4 filesystems
- [ ] Mount and unmount network file systems using NFS
- [ ] Configure autofs for NFS
- [ ] Extend existing logical volumes
- [ ] Create and configure swap partitions
- [ ] Configure disk compression
- [ ] Manage layered storage
- [ ] Diagnose and correct file permission problems

**File Systems to Practice:**
- XFS (default RHEL 9)
- ext4 (legacy compatibility)
- NFS mounts and autofs

## Deploy, Configure, Maintain Systems (Weight: ~15%)

### System Configuration
- [ ] Schedule tasks using at and cron
- [ ] Start and stop services and configure auto-start
- [ ] Configure services to start automatically
- [ ] Configure time service clients
- [ ] Install and update software packages
- [ ] Modify system bootloader
- [ ] Configure network services to start automatically

**Configuration Files to Know:**
- /etc/crontab, /var/spool/cron/
- /etc/chrony.conf
- /boot/grub2/grub.cfg (don't edit directly!)
- grub2-mkconfig command

## Manage Basic Networking (Weight: ~10%)

### Network Configuration
- [ ] Configure IPv4 and IPv6 addresses
- [ ] Configure hostname resolution
- [ ] Configure network services to start automatically
- [ ] Restrict network access using firewall-cmd/firewalld

**Network Tools:**
```bash
nmcli con show
nmcli con modify
firewall-cmd --list-all
```

## Manage Users and Groups (Weight: ~10%)

### User Management
- [ ] Create, delete, modify local user accounts
- [ ] Change passwords and adjust password aging
- [ ] Create, delete, modify local groups
- [ ] Configure superuser access

**Essential Commands:**
- useradd, usermod, userdel
- passwd, chage
- groupadd, groupmod, groupdel
- visudo, /etc/sudoers

## Manage Security (Weight: ~15%)

### SELinux and Security
- [ ] Configure firewall settings using firewall-cmd/firewalld
- [ ] Manage default file permissions
- [ ] Configure key-based authentication for SSH
- [ ] Set enforcing and permissive modes for SELinux
- [ ] List and identify SELinux file and process contexts
- [ ] Restore default file contexts
- [ ] Manage SELinux port labels
- [ ] Use boolean settings to modify system SELinux settings
- [ ] Diagnose and address routine SELinux policy violations

**SELinux Commands to Master:**
```bash
getenforce / setenforce
ls -Z / ps -Z
restorecon
semanage port -l
getsebool -a
setsebool
ausearch -m AVC
```

## Manage Containers (New in RHEL 9)

### Container Operations
- [ ] Find and retrieve container images from registry
- [ ] Inspect container images
- [ ] Perform container management using podman
- [ ] Build a container from a Containerfile
- [ ] Perform basic container management
- [ ] Run containers as systemd services
- [ ] Attach persistent storage to containers

---

## Assessment Summary

After completing this assessment, focus your study time on:

1. **🎯 Learn Topics** (Highest priority - allocate 60% of study time)
2. **📖 Review Topics** (Medium priority - allocate 30% of study time)  
3. **✅ Confident Topics** (Low priority - allocate 10% for maintenance)

## Next Steps

1. Complete this assessment honestly
2. Use the `study_timeline.md` for scheduling
3. Practice with lab scenarios in `lab_scenarios/`
4. Review with Anki flashcards daily
5. Take mock exams in week 4

Remember: The exam is practical. You should be able to complete tasks efficiently using man pages when needed, not memorize every flag.