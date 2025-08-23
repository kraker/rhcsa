# RHCSA Study Guide Summary: Topics and Commands from Both EPUBs

Based on analysis of both "RHCSA Red Hat Enterprise Linux - Asghar Ghori" and "Red Hat RHCSA 9 Cert Guide - Sander van Vugt" study guides.

## Book Structure Overview

### Asghar Ghori RHCSA Book Structure
**22 Chapters with comprehensive exercises and labs**

**Chapters 1-4: Foundation Skills**
- Chapter 1: Local Installation 
- Chapter 2: Initial Interaction with the System
- Chapter 3: Working with Files and File Permissions  
- Chapter 4: Basic File Permissions

**Chapters 5-8: User and System Management**
- Chapter 5: Basic User Management
- Chapter 6: Advanced User Management
- Chapter 7: The Bash Shell
- Chapter 8: Managing Services and Processes

**Chapters 9-12: System Operations**
- Chapter 9: Package Management
- Chapter 10: System Processes and Job Control
- Chapter 11: Boot Process, GRUB2, and the Linux Kernel
- Chapter 12: System Logging and Monitoring

**Chapters 13-16: Storage and Networking**
- Chapter 13: Storage Management (LVM, VDO)
- Chapter 14: File Systems and Swap
- Chapter 15: Networking, Network Devices, and Network Connections
- Chapter 16: Network File System

**Chapters 17-22: Advanced Topics**
- Chapter 17: AutoFS and Automounting
- Chapter 18: Storage Management
- Chapter 19: Firewall and System Security
- Chapter 20: SELinux
- Chapter 21: SSH and Time Services  
- Chapter 22: Containers with Podman

### Sander van Vugt RHCSA Book Structure
**26 Chapters organized in 5 parts**

**Part I: Basic System Management Tasks (Chapters 1-8)**
- Chapter 1: Installing Red Hat Enterprise Linux Server
- Chapter 2: Using Essential Tools
- Chapter 3: Essential File Management Tools
- Chapter 4: Working with Text Files
- Chapter 5: Connecting to Red Hat Enterprise Linux Server
- Chapter 6: User and Group Management
- Chapter 7: Permissions Management
- Chapter 8: Configuring Networking

**Part II: Operating Running Systems (Chapters 9-13)**
- Chapter 9: Software Management
- Chapter 10: Managing Processes
- Chapter 11: Working with Systemd Services
- Chapter 12: Scheduling Tasks
- Chapter 13: Configuring Logging

**Part III: Advanced System Administration Tasks (Chapters 14-20)**
- Chapter 14: Managing Storage
- Chapter 15: Advanced Storage Management
- Chapter 16: Basic Kernel Management
- Chapter 17: Managing and Understanding the Boot Procedure
- Chapter 18: Essential Troubleshooting Skills
- Chapter 19: An Introduction to Bash Shell Scripting
- Chapter 20: Managing Software

**Part IV: Managing Network Services (Chapters 21-25)**
- Chapter 21: Configuring SSH
- Chapter 22: Managing SELinux
- Chapter 23: Configuring a Firewall
- Chapter 24: Accessing Network Storage
- Chapter 25: Configuring Time Services

**Part V: RHCSA Practice Exams (Chapter 26)**
- Chapter 26: Managing Containers

## Topic-by-Topic Breakdown with Lab Exercises

### 1. System Installation and Initial Setup

#### **Asghar Ghori Labs:**
- Exercise 1-1: Download and Install VirtualBox Software
- Exercise 1-2: Download and Install RHEL
- Exercise 1-3: Logging In from Windows  
- Lab 1-1: Build RHEL9-VM2 (server2)

#### **Sander van Vugt Labs:**
- Focus on automated installation methods
- Kickstart configuration
- Initial system configuration

#### **Key Commands:**
```bash
# System information
hostnamectl
uname -a
cat /etc/redhat-release
lscpu
free -h
df -h

# Initial configuration
nmtui
timedatectl set-timezone
localectl set-locale
```

### 2. File Management and Text Processing

#### **Asghar Ghori Labs:**
- Exercise 3-1: Create Compressed Archives
- Exercise 3-2: Create and Manage Hard Links
- Exercise 3-3: Create and Manage Soft Links
- Lab 3-1: Archive, List, and Restore Files
- Lab 3-2: Practice the vim Editor
- Lab 3-3: File and Directory Operations

#### **Sander van Vugt Labs:**
- Working with tar archives
- Text file manipulation with sed, awk, grep
- File linking and copying strategies

#### **Key Commands:**
```bash
# File operations
ls -la
cp -r source destination
mv source destination
rm -rf directory
find / -name "filename" -type f
locate filename

# Archives and compression
tar -czf archive.tar.gz directory/
tar -xzf archive.tar.gz
gzip file
gunzip file.gz

# Links
ln source hard_link
ln -s target symbolic_link

# Text processing
grep pattern file
sed 's/old/new/g' file
awk '{print $1}' file
sort file
uniq file
wc -l file

# Text editors
vim filename
nano filename
```

### 3. File Permissions and Security

#### **Asghar Ghori Labs:**
- Exercise 4-1: Modify Permission Bits Using Symbolic Form
- Exercise 4-2: Modify Permission Bits Using Octal Form
- Exercise 4-3: Test the Effect of setuid Bit on Executable Files
- Exercise 4-4: Test the Effect of setgid Bit on Executable Files
- Exercise 4-5: Set up Shared Directory for Group Collaboration
- Exercise 4-6: Test the Effect of Sticky Bit
- Lab 4-1: Manipulate File Permissions
- Lab 4-2: Configure Group Collaboration and Prevent File Deletion
- Lab 4-3: Find Files
- Lab 4-4: Find Files Using Different Criteria

#### **Sander van Vugt Labs:**
- Advanced permission scenarios
- ACL implementation
- Special permissions in practice

#### **Key Commands:**
```bash
# Basic permissions
chmod 755 file
chmod u+x,g+r,o-w file
chown user:group file
chgrp group file

# Special permissions
chmod +s file              # setuid/setgid
chmod +t directory         # sticky bit
chmod 4755 file           # setuid
chmod 2755 directory      # setgid
chmod 1755 directory      # sticky bit

# ACLs
setfacl -m u:username:rwx file
getfacl file
setfacl -x u:username file

# Finding files
find / -perm -4000         # setuid files
find / -perm -2000         # setgid files
find / -user username
find / -group groupname
```

### 4. User and Group Management

#### **Asghar Ghori Labs:**
- Exercise 5-1: Create a User Account with Default Attributes
- Exercise 5-2: Create a User Account with Custom Values
- Exercise 5-3: Modify and Delete a User Account
- Exercise 5-4: Create a User Account with No-Login Access
- Lab 5-1: Check User Login Attempts
- Lab 5-2: Verify User and Group Identity
- Exercise 6-3: Lock and Unlock a User Account with usermod and passwd

#### **Sander van Vugt Labs:**
- User account policies
- Group membership management
- Password aging configuration

#### **Key Commands:**
```bash
# User management
useradd -u UID -g GROUP -G GROUPS -s SHELL -d HOME username
usermod -aG group username
usermod -L username        # lock account
usermod -U username        # unlock account
userdel -r username

# Password management
passwd username
chage -M 90 -m 7 -W 7 username
chage -l username

# Group management
groupadd -g GID groupname
groupmod -n newname oldname
groupdel groupname
gpasswd -a username groupname

# User information
id username
groups username
who
w
last
lastb
```

### 5. Process and Service Management

#### **Asghar Ghori Labs:**
- Systemctl command exercises
- Service configuration labs
- Process monitoring and control

#### **Sander van Vugt Labs:**
- Systemd service creation
- Timer configuration
- Process priority management

#### **Key Commands:**
```bash
# Process management
ps aux
ps -ef
top
htop
pgrep process_name
pkill process_name
kill PID
killall process_name
jobs
bg
fg
nohup command &

# Process priority
nice -n 10 command
renice 5 PID

# System services
systemctl start service
systemctl stop service
systemctl restart service
systemctl reload service
systemctl enable service
systemctl disable service
systemctl status service
systemctl list-units --type=service
systemctl daemon-reload

# Systemd targets
systemctl set-default multi-user.target
systemctl get-default
systemctl isolate rescue.target
```

### 6. Package Management

#### **Asghar Ghori Labs:**
- DNF package management exercises
- Repository configuration
- RPM command usage

#### **Sander van Vugt Labs:**
- Advanced package queries
- Group package management
- Creating custom repositories

#### **Key Commands:**
```bash
# DNF package management
dnf install package
dnf update package
dnf remove package
dnf search keyword
dnf info package
dnf list installed
dnf list available
dnf group list
dnf group install "group name"
dnf history
dnf clean all

# Repository management
dnf config-manager --add-repo URL
dnf repolist
dnf config-manager --enable repo
dnf config-manager --disable repo

# RPM commands
rpm -qa                    # list all packages
rpm -qi package           # package info
rpm -ql package           # list files in package
rpm -qf /path/file        # which package owns file
rpm -ivh package.rpm      # install package
rpm -Uvh package.rpm      # upgrade package
```

### 7. Storage Management and LVM

#### **Asghar Ghori Labs:**
- LVM creation and management exercises
- File system creation and mounting
- Swap configuration labs

#### **Sander van Vugt Labs:**
- Advanced LVM scenarios
- Storage troubleshooting
- VDO configuration

#### **Key Commands:**
```bash
# Disk and partition management
lsblk
fdisk -l
fdisk /dev/device
parted /dev/device
partprobe

# LVM management
pvcreate /dev/device
pvdisplay
pvs
vgcreate vg_name /dev/device
vgdisplay
vgs
vgextend vg_name /dev/device
lvcreate -L size -n lv_name vg_name
lvdisplay
lvs
lvextend -L +size /dev/vg/lv
lvreduce -L -size /dev/vg/lv

# File systems
mkfs.xfs /dev/device
mkfs.ext4 /dev/device
mount /dev/device /mountpoint
umount /mountpoint
mount -a
df -h
du -sh directory

# File system resizing
xfs_growfs /mountpoint      # for XFS
resize2fs /dev/device       # for ext4

# Swap management
mkswap /dev/device
swapon /dev/device
swapoff /dev/device
swapon --show
```

### 8. Network Configuration

#### **Asghar Ghori Labs:**
- NetworkManager configuration with nmcli
- Static IP configuration
- Network troubleshooting exercises

#### **Sander van Vugt Labs:**
- Advanced networking scenarios
- Network bonding and teaming
- IPv6 configuration

#### **Key Commands:**
```bash
# Network information
ip addr show
ip route show
ip link show
nmcli device status
nmcli connection show

# Network configuration
nmcli con add type ethernet con-name NAME ifname DEVICE
nmcli con modify NAME ipv4.addresses IP/MASK
nmcli con modify NAME ipv4.gateway GATEWAY
nmcli con modify NAME ipv4.dns DNS1,DNS2
nmcli con modify NAME ipv4.method manual
nmcli con up NAME
nmcli con down NAME

# Network testing
ping host
traceroute host
nslookup hostname
dig hostname
ss -tuln
netstat -tuln
```

### 9. Firewall Configuration

#### **Asghar Ghori Labs:**
- firewall-cmd basic configuration
- Service and port management
- Rich rules implementation

#### **Sander van Vugt Labs:**
- Advanced firewall scenarios
- Custom service definitions
- Firewall troubleshooting

#### **Key Commands:**
```bash
# Firewall management
firewall-cmd --state
firewall-cmd --get-active-zones
firewall-cmd --list-all
firewall-cmd --add-service=SERVICE --permanent
firewall-cmd --remove-service=SERVICE --permanent
firewall-cmd --add-port=PORT/PROTOCOL --permanent
firewall-cmd --remove-port=PORT/PROTOCOL --permanent
firewall-cmd --reload

# Rich rules
firewall-cmd --add-rich-rule='rule family="ipv4" source address="IP" accept' --permanent

# Zone management
firewall-cmd --set-default-zone=ZONE
firewall-cmd --change-interface=INTERFACE --zone=ZONE --permanent
```

### 10. SELinux Management

#### **Asghar Ghori Labs:**
- SELinux mode configuration
- Context management exercises
- Boolean configuration
- Port labeling labs

#### **Sander van Vugt Labs:**
- Advanced SELinux troubleshooting
- Custom policy modules
- File context analysis

#### **Key Commands:**
```bash
# SELinux status and modes
getenforce
setenforce 0|1
sestatus

# File contexts
ls -Z file
restorecon -Rv /path
semanage fcontext -a -t TYPE "/path(/.*)?"
semanage fcontext -l | grep path

# Process contexts
ps -eZ
ps auxZ

# SELinux booleans
getsebool -a
getsebool boolean_name
setsebool -P boolean_name on|off

# Port contexts
semanage port -l
semanage port -a -t TYPE -p PROTOCOL PORT

# Troubleshooting
ausearch -m AVC -ts recent
sealert -a /var/log/audit/audit.log
```

### 11. Boot Process and GRUB

#### **Asghar Ghori Labs:**
- GRUB configuration modification
- Kernel parameter management
- Boot troubleshooting scenarios

#### **Sander van Vugt Labs:**
- Advanced boot procedures
- Systemd target management
- Recovery scenarios

#### **Key Commands:**
```bash
# GRUB management
grub2-editenv list
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default "menu entry"

# Boot targets
systemctl get-default
systemctl set-default multi-user.target
systemctl list-units --type=target

# Kernel management
uname -r
rpm -qa kernel
dnf list installed kernel
```

### 12. Logging and Monitoring

#### **Asghar Ghori Labs:**
- Journald configuration
- Rsyslog setup
- Log rotation configuration

#### **Sander van Vugt Labs:**
- Advanced logging scenarios
- Remote logging setup
- Log analysis techniques

#### **Key Commands:**
```bash
# Journal management
journalctl
journalctl -u service
journalctl -f
journalctl --since "1 hour ago"
journalctl -p err
journalctl --list-boots

# Traditional logging
tail -f /var/log/messages
tail -f /var/log/secure
logger "test message"

# Log rotation
logrotate -d /etc/logrotate.conf
```

### 13. Scheduled Tasks

#### **Asghar Ghori Labs:**
- Crontab configuration
- At job scheduling
- Systemd timer creation

#### **Sander van Vugt Labs:**
- Advanced scheduling scenarios
- Timer unit configuration
- Anacron usage

#### **Key Commands:**
```bash
# Cron management
crontab -e
crontab -l
crontab -r
crontab -u username -e

# At scheduling
at now + 5 minutes
at 15:30
atq
atrm job_number

# Systemd timers
systemctl list-timers
systemctl enable timer.timer
systemctl start timer.timer
```

### 14. Container Management

#### **Asghar Ghori Labs:**
- Podman basic operations
- Container networking
- Container storage management

#### **Sander van Vugt Labs:**
- Advanced container scenarios
- Systemd integration
- Container image management

#### **Key Commands:**
```bash
# Container management
podman pull image
podman run -d --name NAME -p HOST:CONTAINER image
podman ps
podman ps -a
podman stop container
podman start container
podman rm container
podman rmi image

# Container systemd integration
podman generate systemd --new --files --name container
loginctl enable-linger username

# Container images
podman images
podman search term
podman inspect image
podman logs container
```

### 15. Network Services

#### **Asghar Ghori Labs:**
- NFS server and client configuration
- AutoFS implementation
- SSH configuration

#### **Sander van Vugt Labs:**
- Advanced NFS scenarios
- Time synchronization
- SSH key management

#### **Key Commands:**
```bash
# NFS management
systemctl enable --now nfs-server
exportfs -arv
exportfs -s
showmount -e server

# AutoFS
systemctl enable --now autofs
mount | grep autofs

# SSH configuration
ssh-keygen -t rsa
ssh-copy-id user@server
scp file user@server:/path
```

## Command Summary by Category

### User Management Commands
```bash
useradd, usermod, userdel, passwd, chage, chsh, chfn
groupadd, groupmod, groupdel, gpasswd
id, groups, who, w, last, lastb
```

### File Management Commands
```bash
ls, cp, mv, rm, mkdir, rmdir, touch, find, locate
chmod, chown, chgrp, umask
setfacl, getfacl
tar, gzip, gunzip, zip, unzip
```

### Process Management Commands
```bash
ps, top, htop, pgrep, pkill, kill, killall
jobs, bg, fg, nohup
nice, renice
```

### System Service Commands
```bash
systemctl, journalctl
service, chkconfig (legacy)
```

### Network Commands
```bash
nmcli, nmtui
ip, ifconfig (legacy)
ping, traceroute, nslookup, dig
ss, netstat (legacy)
```

### Storage Commands
```bash
lsblk, fdisk, parted, partprobe
pvcreate, vgcreate, lvcreate, pvs, vgs, lvs
mkfs.xfs, mkfs.ext4, mount, umount
xfs_growfs, resize2fs
```

### Package Management Commands
```bash
dnf, rpm, yum (legacy)
```

### Security Commands
```bash
firewall-cmd
getenforce, setenforce, setsebool, restorecon, semanage
ausearch, sealert
```

### Container Commands
```bash
podman, buildah, skopeo
```

This comprehensive summary covers all major topics and commands from both study guides, organized for efficient exam preparation.