# RHCSA Command Reference by Topic Area

Organized command reference extracted from both study guides, designed for quick lookup during exam preparation.

## System Information and Management

### Hardware and System Information
```bash
# System information
uname -a                    # System kernel and architecture
uname -r                    # Kernel version
hostnamectl                 # Hostname and system info
hostnamectl set-hostname NAME  # Set system hostname
uptime                      # System uptime and load
who                         # Currently logged in users
w                           # Detailed user activity
id                          # Current user ID and groups
whoami                      # Current username

# Hardware information
lscpu                       # CPU information
lsmem                       # Memory information  
lsblk                       # Block device information
lspci                       # PCI device information
lsusb                       # USB device information
lshw                        # Detailed hardware information
dmidecode                   # Hardware DMI information

# Memory and disk usage
free -h                     # Memory usage (human readable)
df -h                       # Disk space usage (human readable)
du -sh /path                # Directory size
du -h --max-depth=1 /path   # Subdirectory sizes
```

### Date and Time Management
```bash
# Time and timezone
date                        # Current date and time
timedatectl                 # System time settings
timedatectl set-time TIME   # Set system time
timedatectl set-timezone ZONE  # Set timezone
timedatectl list-timezones  # List available timezones
hwclock                     # Hardware clock
chrony                      # Time synchronization service
systemctl status chronyd   # Check time sync status
```

## File System and Storage Management

### Basic File Operations
```bash
# Directory navigation
pwd                         # Print working directory
cd /path                    # Change directory
cd ~                        # Go to home directory
cd -                        # Go to previous directory

# File listing
ls                          # List files
ls -l                       # Long format listing
ls -la                      # Include hidden files
ls -lh                      # Human readable sizes
ls -ltr                     # Sort by time, newest last
ls -Z                       # Show SELinux contexts

# File operations
cp source dest              # Copy file
cp -r source dest           # Copy directory recursively
cp -p source dest           # Preserve permissions and timestamps
mv source dest              # Move/rename file
rm file                     # Remove file
rm -r directory             # Remove directory recursively
rm -rf directory            # Force remove directory
mkdir directory             # Create directory
mkdir -p path/to/dir        # Create parent directories
rmdir directory             # Remove empty directory
touch file                  # Create empty file or update timestamp
```

### File Searching and Finding
```bash
# Find files and directories
find /path -name "pattern"  # Find by name
find /path -type f          # Find files only
find /path -type d          # Find directories only
find /path -user username   # Find by owner
find /path -group groupname # Find by group
find /path -perm 755        # Find by permissions
find /path -size +100M      # Find large files (>100MB)
find /path -mtime -7        # Modified in last 7 days
find /path -atime +30       # Accessed more than 30 days ago
find /path -exec command {} \;  # Execute command on results

# Alternative find commands
locate filename             # Fast file location (updatedb)
which command               # Find command location
whereis command             # Find command, source, manual
type command                # Show command type and location
```

### File Linking
```bash
# Hard and soft links
ln source hard_link         # Create hard link
ln -s target soft_link      # Create symbolic link
readlink link               # Show link target
stat file                   # Show file statistics and links
```

### File Compression and Archives
```bash
# tar archives
tar -czf archive.tar.gz files/     # Create gzipped tar
tar -xzf archive.tar.gz            # Extract gzipped tar
tar -cjf archive.tar.bz2 files/    # Create bzip2 tar
tar -xjf archive.tar.bz2           # Extract bzip2 tar
tar -tf archive.tar.gz             # List archive contents
tar -czf archive.tar.gz --exclude=pattern files/  # Exclude pattern

# Individual compression
gzip file                   # Compress with gzip
gunzip file.gz              # Decompress gzip
bzip2 file                  # Compress with bzip2
bunzip2 file.bz2            # Decompress bzip2
zip archive.zip files       # Create zip archive
unzip archive.zip           # Extract zip archive
```

## Text Processing and File Content

### Viewing File Contents
```bash
# Display file contents
cat file                    # Display entire file
cat -n file                 # Display with line numbers
tac file                    # Display in reverse order
head file                   # First 10 lines
head -n 20 file             # First 20 lines
tail file                   # Last 10 lines
tail -n 20 file             # Last 20 lines
tail -f file                # Follow file changes
less file                   # Page through file
more file                   # Page through file (simpler)
```

### Text Processing Tools
```bash
# Search and filter
grep pattern file           # Search for pattern
grep -i pattern file        # Case insensitive search
grep -v pattern file        # Invert match (exclude pattern)
grep -r pattern directory   # Recursive search
grep -n pattern file        # Show line numbers
grep -E "regex" file        # Extended regex
grep -A 3 pattern file      # Show 3 lines after match
grep -B 3 pattern file      # Show 3 lines before match
grep -C 3 pattern file      # Show 3 lines before and after

# Text manipulation
sort file                   # Sort lines
sort -n file                # Numeric sort
sort -r file                # Reverse sort
sort -k 2 file              # Sort by second field
uniq file                   # Remove duplicate lines
uniq -c file                # Count occurrences
cut -d: -f1 file            # Extract first field (: delimiter)
cut -c1-10 file             # Extract characters 1-10
awk '{print $1}' file       # Print first field
awk -F: '{print $1}' file   # Custom field separator
sed 's/old/new/g' file      # Replace all occurrences
sed '1,10d' file            # Delete lines 1-10
tr 'a-z' 'A-Z' < file       # Convert lowercase to uppercase

# Line and word counts
wc file                     # Lines, words, characters
wc -l file                  # Line count only
wc -w file                  # Word count only
wc -c file                  # Character count only
```

### Text Editors
```bash
# vim editor
vim file                    # Open file in vim
# vim modes: i (insert), ESC (normal), :wq (save and quit)
# :q! (quit without saving), :w (save), /pattern (search)

# nano editor
nano file                   # Open file in nano
# Ctrl+X to exit, Ctrl+O to save, Ctrl+K to cut line
```

## Permissions and Security

### File Permissions
```bash
# View permissions
ls -l file                  # Show permissions
stat file                   # Detailed file information
getfacl file                # Show ACL permissions

# Change permissions (symbolic)
chmod u+x file              # Add execute for user
chmod g-w file              # Remove write for group  
chmod o=r file              # Set other to read only
chmod a+r file              # Add read for all
chmod +x file               # Add execute for all

# Change permissions (octal)
chmod 755 file              # rwxr-xr-x
chmod 644 file              # rw-r--r--
chmod 600 file              # rw-------
chmod 777 file              # rwxrwxrwx

# Change ownership
chown user file             # Change owner
chown user:group file       # Change owner and group
chgrp group file            # Change group only
chown -R user:group directory  # Recursive ownership change

# Default permissions
umask                       # Show current umask
umask 022                   # Set umask (755 for dirs, 644 for files)
umask 077                   # Set umask (700 for dirs, 600 for files)
```

### Special Permissions
```bash
# Special permission bits
chmod +s file               # Set setuid/setgid
chmod +t directory          # Set sticky bit
chmod 4755 file             # setuid (4000 + 755)
chmod 2755 directory        # setgid (2000 + 755)
chmod 1755 directory        # sticky bit (1000 + 755)

# Find special permissions
find / -perm -4000 2>/dev/null  # Find setuid files
find / -perm -2000 2>/dev/null  # Find setgid files
find / -perm -1000 2>/dev/null  # Find sticky bit files
```

### Access Control Lists (ACLs)
```bash
# Manage ACLs
setfacl -m u:username:rwx file      # Set user ACL
setfacl -m g:groupname:rx file      # Set group ACL
setfacl -m d:u:username:rwx dir     # Set default ACL
setfacl -x u:username file          # Remove user ACL
setfacl -b file                     # Remove all ACLs
getfacl file                        # Display ACLs
```

## User and Group Management

### User Account Management
```bash
# Create users
useradd username            # Create user with defaults
useradd -u 1001 username    # Specify UID
useradd -g group username   # Specify primary group
useradd -G groups username  # Specify supplementary groups
useradd -s /bin/bash username  # Specify shell
useradd -d /home/user username  # Specify home directory
useradd -c "Full Name" username  # Add comment
useradd -m username         # Create home directory
useradd -r username         # Create system account

# Modify users
usermod -aG group username  # Add to supplementary group
usermod -g group username   # Change primary group
usermod -s /bin/bash username  # Change shell
usermod -d /new/home username  # Change home directory
usermod -c "New Name" username  # Change comment
usermod -L username         # Lock account
usermod -U username         # Unlock account
usermod -e 2024-12-31 username  # Set expiration date

# Delete users
userdel username            # Delete user (keep home)
userdel -r username         # Delete user and home directory

# User information
id username                 # Show user ID and groups
groups username             # Show user groups
finger username             # User information (if available)
```

### Password Management
```bash
# Password operations
passwd username             # Set user password
passwd -l username          # Lock password
passwd -u username          # Unlock password
passwd -d username          # Delete password
passwd -e username          # Expire password (force change)

# Password aging
chage username              # Interactive password aging
chage -l username           # List password aging info
chage -M 90 username        # Max password age (90 days)
chage -m 7 username         # Min password age (7 days)
chage -W 7 username         # Warning period (7 days)
chage -d 0 username         # Force password change on next login
chage -E 2024-12-31 username  # Account expiration date
```

### Group Management
```bash
# Create groups
groupadd groupname          # Create group
groupadd -g 1001 groupname  # Specify GID
groupadd -r groupname       # Create system group

# Modify groups
groupmod -n newname oldname # Rename group
groupmod -g 1002 groupname  # Change GID
gpasswd -a user group       # Add user to group
gpasswd -d user group       # Remove user from group
gpasswd -A admin group      # Set group administrator

# Delete groups
groupdel groupname          # Delete group

# Group information
groups                      # Show current user groups
getent group groupname      # Show group information
```

### User Information and Login History
```bash
# Current activity
who                         # Currently logged in users
w                           # Detailed user activity
users                       # Simple list of logged in users
last                        # Login history
lastb                       # Failed login attempts
lastlog                     # Last login for all users
```

## Process and Job Management

### Process Monitoring
```bash
# View processes
ps                          # Current session processes
ps aux                      # All processes (BSD style)
ps -ef                      # All processes (Unix style)
ps -u username              # Processes by user
ps -C processname           # Processes by name
pstree                      # Process tree
top                         # Real-time process monitor
htop                        # Enhanced process monitor
```

### Process Control
```bash
# Find processes
pgrep processname           # Find process IDs by name
pgrep -u username           # Find processes by user
pidof processname           # Find PID of running process

# Kill processes  
kill PID                    # Terminate process by PID
kill -9 PID                 # Force kill process
kill -15 PID                # Graceful termination (default)
killall processname         # Kill all processes by name
pkill processname           # Kill processes by name
pkill -u username           # Kill processes by user

# Process priority
nice -n 10 command          # Start with priority 10
renice 5 PID                # Change priority of running process
renice -5 -u username       # Change priority for user processes
```

### Job Control
```bash
# Background jobs
command &                   # Run in background
jobs                        # List active jobs
bg %1                       # Put job 1 in background
fg %1                       # Bring job 1 to foreground
disown %1                   # Remove job from shell
nohup command &             # Run immune to hangups

# Job control signals
Ctrl+Z                      # Suspend current job
Ctrl+C                      # Interrupt current job
```

## System Services and Systemd

### Service Management
```bash
# Service operations
systemctl start service     # Start service
systemctl stop service      # Stop service
systemctl restart service   # Restart service
systemctl reload service    # Reload configuration
systemctl enable service    # Enable at boot
systemctl disable service   # Disable at boot
systemctl enable --now service  # Enable and start
systemctl mask service      # Mask service (prevent start)
systemctl unmask service    # Unmask service

# Service status
systemctl status service    # Service status
systemctl is-active service # Check if running
systemctl is-enabled service # Check if enabled
systemctl is-failed service # Check if failed
systemctl list-units --type=service  # List all services
systemctl list-units --state=failed  # List failed services
systemctl --failed          # Show failed services
```

### Systemd Targets
```bash
# Target management
systemctl get-default       # Show default target
systemctl set-default multi-user.target  # Set default target
systemctl isolate rescue.target  # Switch to target
systemctl list-units --type=target  # List targets
systemctl list-dependencies target  # Show target dependencies
```

### Unit Files and Configuration
```bash
# Unit file management
systemctl daemon-reload     # Reload unit files
systemctl cat service       # Show unit file content
systemctl edit service      # Edit unit file (override)
systemctl revert service    # Revert unit file changes
systemctl show service      # Show unit properties
```

## Logging and Monitoring

### Journal (systemd logs)
```bash
# View logs
journalctl                  # All journal entries
journalctl -u service       # Service-specific logs
journalctl -f               # Follow (tail) logs
journalctl -n 50            # Last 50 entries
journalctl -p err           # Error priority and above
journalctl --since "1 hour ago"  # Recent entries
journalctl --since "2024-01-01"  # Since date
journalctl --until "2024-01-31"  # Until date
journalctl -b               # Current boot logs
journalctl --list-boots     # List boot sessions
journalctl -k               # Kernel messages
journalctl --disk-usage     # Journal disk usage
```

### Traditional Logs
```bash
# Log files
tail -f /var/log/messages   # Follow system messages
tail -f /var/log/secure     # Follow security logs
tail -f /var/log/maillog    # Follow mail logs
less /var/log/cron          # Cron job logs
logger "test message"       # Send message to syslog
```

### Log Rotation
```bash
# Logrotate
logrotate -d /etc/logrotate.conf  # Debug/test rotation
logrotate -f /etc/logrotate.conf  # Force rotation
```

## Network Configuration and Management

### Network Information
```bash
# Network interfaces
ip addr show                # Show IP addresses
ip link show                # Show network interfaces
ip route show               # Show routing table
ip route get 8.8.8.8        # Show route to destination

# Legacy commands (still available)
ifconfig                    # Show interfaces (deprecated)
route -n                    # Show routing table (deprecated)
```

### NetworkManager with nmcli
```bash
# Connection management
nmcli device status         # Device status
nmcli connection show       # Show connections
nmcli con show "connection" # Show connection details
nmcli device wifi list     # List WiFi networks

# Create connections
nmcli con add type ethernet con-name "conn1" ifname eth0
nmcli con add type wifi con-name "wifi1" ifname wlan0 ssid "SSID"

# Modify connections
nmcli con modify "conn1" ipv4.addresses "192.168.1.100/24"
nmcli con modify "conn1" ipv4.gateway "192.168.1.1"
nmcli con modify "conn1" ipv4.dns "8.8.8.8,8.8.4.4"
nmcli con modify "conn1" ipv4.method manual
nmcli con modify "conn1" autoconnect yes

# Control connections
nmcli con up "conn1"        # Activate connection
nmcli con down "conn1"      # Deactivate connection
nmcli con reload            # Reload configurations
nmcli con delete "conn1"    # Delete connection
```

### Network Testing and Troubleshooting
```bash
# Connectivity testing
ping host                   # Test connectivity
ping -c 4 host              # Send 4 packets
traceroute host             # Trace network path
mtr host                    # Real-time traceroute

# DNS resolution
nslookup hostname           # DNS lookup
dig hostname                # Detailed DNS lookup
dig @server hostname        # Query specific DNS server
host hostname               # Simple DNS lookup

# Network connections
ss -tuln                    # Show listening ports
ss -tupln                   # Show all connections with PIDs
netstat -tuln               # Legacy network connections
lsof -i :80                 # Show what's using port 80
lsof -i tcp:22              # Show SSH connections
```

## Network File System (NFS) and AutoFS

### NFS Client Operations
```bash
# NFS package installation
dnf install -y nfs-utils       # Install NFS client utilities

# Discovering NFS shares
showmount -e server.example.com  # List exports from NFS server
showmount -e 192.168.1.100      # List exports using IP address
showmount -a server             # Show all client connections
showmount -d server             # Show directories being accessed

# Manual NFS mounting
mkdir /mnt/nfs-share            # Create mount point
mount -t nfs server:/export/share /mnt/nfs-share  # Mount NFS share
mount -t nfs -o nfsvers=4.2 server:/share /mnt    # Specify NFS version
mount -o rw,intr server:/data /mnt/data            # Mount with options

# NFS mount options
# rw/ro                - read-write/read-only
# hard/soft           - retry behavior on failure
# intr                - allow interrupts
# rsize=8192          - read buffer size
# wsize=8192          - write buffer size
# timeo=14            - timeout (1/10 second)
# retrans=3           - retry attempts
# _netdev             - wait for network

# NFS unmounting
umount /mnt/nfs-share          # Unmount NFS share
umount -l /mnt/nfs-share       # Lazy unmount (when busy)
umount -f /mnt/nfs-share       # Force unmount

# Testing NFS connectivity
ping nfs-server                # Basic connectivity
telnet nfs-server 2049         # Test NFS port
rpcinfo -p nfs-server          # Show RPC services
```

### NFS Server Management
```bash
# NFS server package installation
dnf install -y nfs-utils       # Install NFS server utilities

# Export configuration (/etc/exports)
/export/share *(rw,sync)       # Export to all hosts
/data 192.168.1.0/24(rw,sync) # Export to specific network
/home server1(rw) server2(ro)  # Different permissions per host

# Export management commands
exportfs -avr                  # Export all shares with verbose output
exportfs -v                    # Show current exports
exportfs -u /export/share      # Unexport specific share
exportfs -ra                   # Re-export all shares

# NFS service management
systemctl enable --now nfs-server  # Start and enable NFS server
systemctl enable --now rpcbind     # Start and enable RPC service
systemctl status nfs-server        # Check NFS server status

# Firewall configuration for NFS
firewall-cmd --add-service=nfs --permanent      # Allow NFS traffic
firewall-cmd --add-service=rpc-bind --permanent # Allow RPC bind
firewall-cmd --add-service=mountd --permanent   # Allow mountd
firewall-cmd --reload                          # Apply firewall changes
```

### AutoFS Configuration and Management
```bash
# AutoFS installation
dnf install -y autofs          # Install AutoFS package

# Master map configuration (/etc/auto.master)
/mnt/auto /etc/auto.nfs --timeout=60    # Indirect map with timeout
/- /etc/auto.direct                     # Direct map entry

# Indirect map configuration
# Format: key [options] server:/path
shared -rw server.example.com:/export/shared
data -ro,intr server:/export/data

# Direct map configuration  
# Format: mount-point [options] server:/path
/mnt/shared-data -rw server:/export/data
/opt/software -ro server:/export/software

# Wildcard mapping for user directories
# Format: * [options] server:/path/&
* -rw server.example.com:/home/&        # Maps to server:/home/username

# AutoFS service management
systemctl enable --now autofs          # Start and enable AutoFS
systemctl status autofs                # Check AutoFS status
systemctl reload autofs                # Reload configuration
systemctl restart autofs               # Restart AutoFS service

# AutoFS monitoring and troubleshooting
automount -f -v                        # Run in foreground with verbose
tail -f /var/log/messages | grep automount  # Watch AutoFS logs
ls -la /etc/auto.*                     # Check map file permissions
mount | grep autofs                    # Show active automounts
```

### fstab Integration for NFS
```bash
# fstab entry format for NFS
# device mount-point type options dump fsck
server:/export/share /mnt/nfs nfs defaults,_netdev 0 0

# Common fstab NFS options
defaults,_netdev                # Standard options with network dependency
rw,_netdev,soft,intr           # Read-write, soft mount, interruptible
ro,_netdev,hard,retrans=3      # Read-only, hard mount, 3 retries

# Testing fstab entries
mount -a                       # Mount all fstab entries
umount /mnt/nfs && mount /mnt/nfs  # Test specific entry
findmnt /mnt/nfs              # Show mount details
```

### NFS and AutoFS Troubleshooting
```bash
# NFS client troubleshooting
showmount -e server           # Test server connectivity
rpcinfo -p server            # Check RPC services on server
mount -v -t nfs server:/share /mnt  # Verbose mount output
ping server && telnet server 2049  # Test basic and NFS connectivity

# NFS server troubleshooting  
exportfs -v                   # Show current exports
rpcinfo -p localhost          # Check local RPC services
systemctl status nfs-server rpcbind  # Check service status
showmount -e localhost        # Test local NFS exports
netstat -tuln | grep :2049   # Check NFS port listening

# AutoFS troubleshooting
systemctl status autofs       # Check AutoFS service
automount -f -v              # Run AutoFS in foreground
ls -la /etc/auto.*           # Check map file permissions
cat /etc/auto.master         # Verify master map syntax
tail -f /var/log/messages | grep automount  # Watch logs

# General network filesystem troubleshooting
mount | grep nfs             # Show NFS mounts
df -t nfs                    # Show NFS filesystem usage
fuser -mv /mnt/nfs-share     # Show processes using mount point
lsof +D /mnt/nfs-share       # Show open files in NFS mount
```

## Package Management

### DNF Package Manager
```bash
# Package operations
dnf install package         # Install package
dnf update package          # Update package
dnf remove package          # Remove package
dnf upgrade                 # Update all packages
dnf downgrade package       # Downgrade package
dnf reinstall package       # Reinstall package

# Package information
dnf search keyword          # Search packages
dnf info package            # Package information
dnf list installed          # List installed packages
dnf list available          # List available packages
dnf list "pattern*"         # List packages matching pattern
dnf provides /path/file     # Find package providing file
dnf repoquery --requires package  # Show dependencies

# Package groups
dnf group list              # List package groups
dnf group info "group"      # Group information
dnf group install "group"   # Install package group
dnf group remove "group"    # Remove package group

# Repository management
dnf repolist                # List repositories
dnf repolist all            # List all repositories
dnf config-manager --add-repo URL  # Add repository
dnf config-manager --enable repo   # Enable repository
dnf config-manager --disable repo  # Disable repository

# History and cleanup
dnf history                 # Transaction history
dnf history info ID         # History transaction details
dnf history undo ID         # Undo transaction
dnf clean all               # Clean package cache
dnf autoremove              # Remove unneeded packages
```

### RPM Package Manager
```bash
# RPM queries
rpm -qa                     # List all installed packages
rpm -qi package             # Package information
rpm -ql package             # List package files
rpm -qf /path/file          # Find package owning file
rpm -qd package             # List package documentation
rpm -qc package             # List package configuration files
rpm -q --requires package   # Show package dependencies
rpm -q --provides package   # Show what package provides

# RPM installation/removal
rpm -ivh package.rpm        # Install package
rpm -Uvh package.rpm        # Upgrade package
rpm -e package              # Remove package
rpm --import GPG-KEY        # Import GPG key

# RPM verification
rpm -V package              # Verify package integrity
rpm -Va                     # Verify all packages
```

## Storage Management and File Systems

### Disk and Partition Management
```bash
# Disk information
lsblk                       # List block devices
lsblk -f                    # Show file systems
blkid                       # Show UUIDs and file systems
fdisk -l                    # List disk partitions
df -h                       # Show mounted file systems
du -sh directory            # Directory size

# Partition management
fdisk /dev/device           # Create/modify partitions
parted /dev/device          # Alternative partitioning tool
partprobe                   # Re-read partition table
mkfs.ext4 /dev/partition    # Create ext4 file system
mkfs.xfs /dev/partition     # Create XFS file system
tune2fs -L label /dev/partition  # Set file system label
```

### LVM (Logical Volume Management)
```bash
# Physical volumes
pvcreate /dev/device        # Create physical volume
pvdisplay                   # Show PV details
pvs                         # Show PV summary
pvremove /dev/device        # Remove physical volume

# Volume groups
vgcreate vg_name /dev/device  # Create volume group
vgdisplay                   # Show VG details
vgs                         # Show VG summary
vgextend vg_name /dev/device  # Extend volume group
vgreduce vg_name /dev/device  # Reduce volume group
vgremove vg_name            # Remove volume group

# Logical volumes
lvcreate -L 1G -n lv_name vg_name      # Create LV (size)
lvcreate -l 100%FREE -n lv_name vg_name  # Use all free space
lvcreate -l 50%VG -n lv_name vg_name   # Use 50% of VG
lvdisplay                   # Show LV details
lvs                         # Show LV summary
lvextend -L +1G /dev/vg/lv  # Extend logical volume
lvextend -l +100%FREE /dev/vg/lv  # Extend to use all space
lvreduce -L -1G /dev/vg/lv  # Reduce logical volume
lvremove /dev/vg/lv         # Remove logical volume
```

### File System Operations
```bash
# Mounting
mount /dev/device /mountpoint     # Mount file system
mount -t xfs /dev/device /mnt     # Mount with type
mount -o ro /dev/device /mnt      # Mount read-only
umount /mountpoint                # Unmount file system
umount -l /mountpoint             # Lazy unmount
mount -a                          # Mount all in /etc/fstab

# File system resize
xfs_growfs /mountpoint      # Grow XFS file system
resize2fs /dev/device       # Resize ext4 file system
e2fsck -f /dev/device       # Check ext4 file system
xfs_repair /dev/device      # Repair XFS file system

# Swap management
mkswap /dev/device          # Create swap space
swapon /dev/device          # Enable swap
swapoff /dev/device         # Disable swap
swapon --show               # Show active swap
swapon -a                   # Enable all swap in fstab
```

### fstab Configuration
```bash
# /etc/fstab format:
# device mountpoint fstype options dump pass
/dev/sda1 / ext4 defaults 0 1
UUID=xxx /home xfs defaults 0 2
/dev/vg/lv /data ext4 defaults 0 2
/dev/sdb1 swap swap defaults 0 0

# fstab options
defaults        # rw,suid,dev,exec,auto,nouser,async
ro              # Read-only
rw              # Read-write
noauto          # Don't mount automatically
user            # Allow users to mount
noexec          # Don't allow execution
nosuid          # Ignore setuid bits
```

## Firewall Management

### firewalld Configuration
```bash
# Firewall status
firewall-cmd --state        # Check if running
firewall-cmd --get-active-zones  # Show active zones
firewall-cmd --list-all     # Show all rules
firewall-cmd --list-services  # Show allowed services
firewall-cmd --list-ports   # Show allowed ports

# Zone management
firewall-cmd --get-default-zone  # Show default zone
firewall-cmd --set-default-zone=public  # Set default zone
firewall-cmd --get-zones    # List all zones
firewall-cmd --zone=work --list-all  # Show zone rules

# Service management
firewall-cmd --add-service=http  # Allow HTTP (temporary)
firewall-cmd --add-service=ssh --permanent  # Allow SSH (permanent)
firewall-cmd --remove-service=http  # Remove HTTP
firewall-cmd --list-services  # Show allowed services

# Port management
firewall-cmd --add-port=8080/tcp  # Allow port (temporary)
firewall-cmd --add-port=443/tcp --permanent  # Allow port (permanent)
firewall-cmd --remove-port=8080/tcp  # Remove port
firewall-cmd --list-ports   # Show allowed ports

# Rich rules
firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" accept'
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.0.0.5" port port="22" protocol="tcp" accept'

# Apply changes
firewall-cmd --reload       # Reload configuration
firewall-cmd --runtime-to-permanent  # Make runtime rules permanent
```

## SELinux Management

### SELinux Status and Modes
```bash
# SELinux status
getenforce                  # Current mode (Enforcing/Permissive/Disabled)
sestatus                    # Detailed status
setenforce 0                # Set permissive mode (temporary)
setenforce 1                # Set enforcing mode (temporary)

# Permanent mode change (edit /etc/selinux/config)
SELINUX=enforcing          # or permissive, disabled
```

### File Contexts
```bash
# View contexts
ls -Z file                  # Show file context
ps -eZ                      # Show process contexts
id -Z                       # Show user context

# Manage contexts
restorecon file             # Restore default context
restorecon -R directory     # Restore recursively
restorecon -v file          # Verbose output

# Set custom contexts
semanage fcontext -a -t httpd_exec_t "/web(/.*)?"
restorecon -R /web          # Apply new context
semanage fcontext -l        # List file contexts
semanage fcontext -d "/web(/.*)?"  # Delete context rule
```

### SELinux Booleans
```bash
# View booleans
getsebool -a                # List all booleans
getsebool httpd_can_network_connect  # Check specific boolean
setsebool httpd_can_network_connect on  # Set boolean (temporary)
setsebool -P httpd_can_network_connect on  # Set boolean (permanent)
```

### Port Contexts
```bash
# Manage port contexts
semanage port -l            # List port contexts
semanage port -a -t http_port_t -p tcp 8080  # Add port context
semanage port -d -p tcp 8080  # Delete port context
semanage port -l | grep http  # Show HTTP ports
```

### SELinux Troubleshooting
```bash
# Check for denials
ausearch -m AVC -ts recent  # Recent AVC denials
ausearch -m AVC -ts today   # Today's denials
sealert -a /var/log/audit/audit.log  # Analyze denials
sealert -l UUID             # Detailed denial analysis

# Generate policies
audit2allow -a              # Generate policy from all denials
audit2allow -a -M mypolicy  # Generate policy module
semodule -i mypolicy.pp     # Install policy module
```

## Boot Process and GRUB

### GRUB Configuration
```bash
# GRUB management
grub2-editenv list          # List GRUB environment
grub2-mkconfig -o /boot/grub2/grub.cfg  # Generate GRUB config
grub2-set-default "menu entry"  # Set default boot entry
grub2-reboot "menu entry"   # Boot specific entry once

# Kernel parameters (persistent)
grub2-editenv - set "kernelopts=root=/dev/sda1 quiet"
grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Boot Targets and Runlevels
```bash
# Systemd targets
systemctl get-default       # Show default target
systemctl set-default multi-user.target  # Set default target
systemctl isolate rescue.target  # Switch to rescue mode
systemctl isolate emergency.target  # Switch to emergency mode

# Target management
systemctl list-units --type=target  # List all targets
systemctl list-dependencies graphical.target  # Show dependencies
```

## Scheduled Tasks

### Cron Jobs
```bash
# User crontab
crontab -e                  # Edit user crontab
crontab -l                  # List user crontab
crontab -r                  # Remove user crontab
crontab -u username -e      # Edit another user's crontab

# System crontab
vim /etc/crontab            # System-wide crontab
ls /etc/cron.d/             # Additional cron files
ls /etc/cron.{hourly,daily,weekly,monthly}/  # Cron directories

# Cron format: minute hour day month weekday command
# Examples:
0 2 * * * /path/script      # Daily at 2 AM
*/15 * * * * /path/script   # Every 15 minutes
0 0 * * 0 /path/script      # Weekly on Sunday
0 3 1 * * /path/script      # Monthly on 1st at 3 AM
```

### At Jobs
```bash
# Schedule one-time jobs
at now + 5 minutes          # Schedule for 5 minutes from now
at 15:30                    # Schedule for 3:30 PM today
at 15:30 tomorrow           # Schedule for 3:30 PM tomorrow
at -f script.sh now + 1 hour  # Run script in 1 hour

# Manage at jobs
atq                         # List scheduled jobs
atrm job_number             # Remove scheduled job
at -c job_number            # Show job details
```

### Systemd Timers
```bash
# Timer management
systemctl list-timers       # List all timers
systemctl list-timers --all # List all timers (including inactive)
systemctl enable timer.timer  # Enable timer
systemctl start timer.timer   # Start timer
systemctl status timer.timer  # Check timer status
```

## Container Management with Podman

### Container Operations
```bash
# Image management
podman pull image:tag       # Pull image from registry
podman images               # List local images
podman rmi image            # Remove image
podman search keyword       # Search for images
podman inspect image        # Inspect image details

# Container lifecycle
podman run -d --name container image  # Run container in background
podman run -it image /bin/bash  # Run interactive container
podman run -p 8080:80 image   # Port mapping
podman run -v /host:/container image  # Volume mount
podman ps                   # List running containers
podman ps -a                # List all containers
podman stop container       # Stop container
podman start container      # Start container
podman restart container    # Restart container
podman rm container         # Remove container

# Container management
podman exec -it container /bin/bash  # Execute command in container
podman logs container       # View container logs
podman logs -f container    # Follow container logs
podman cp file container:/path  # Copy file to container
podman stats                # Show container statistics
```

### Systemd Integration
```bash
# Generate systemd units
podman generate systemd --new --files --name container
sudo cp container-name.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable container-name.service

# User services (rootless)
loginctl enable-linger username  # Enable user services
systemctl --user enable container.service
```

## SSH and Remote Access

### SSH Client
```bash
# SSH connections
ssh user@hostname           # Connect to remote host
ssh -p 2222 user@hostname   # Connect to custom port
ssh -i keyfile user@hostname  # Use specific key
ssh -L 8080:localhost:80 user@host  # Local port forwarding
ssh -R 8080:localhost:80 user@host  # Remote port forwarding
ssh -X user@hostname        # X11 forwarding

# Key management
ssh-keygen -t rsa           # Generate RSA key pair
ssh-keygen -t ed25519       # Generate Ed25519 key pair
ssh-copy-id user@hostname   # Copy public key to remote
ssh-add keyfile             # Add key to SSH agent
ssh-agent bash              # Start SSH agent
```

### SSH Server Configuration
```bash
# SSH daemon configuration (/etc/ssh/sshd_config)
Port 22                     # Change SSH port
PermitRootLogin no          # Disable root login
PasswordAuthentication no   # Disable password auth
PubkeyAuthentication yes    # Enable key-based auth
AllowUsers user1 user2      # Restrict users

# Apply SSH configuration
systemctl reload sshd       # Reload SSH daemon
sshd -t                     # Test configuration
```

### File Transfer
```bash
# SCP (Secure Copy)
scp file user@host:/path    # Copy file to remote
scp user@host:/path/file .  # Copy file from remote
scp -r directory user@host:/path  # Copy directory

# RSYNC
rsync -av source/ destination/  # Sync directories
rsync -av --delete source/ dest/  # Sync and delete extras
rsync -av user@host:/path/ local/  # Sync from remote
```

This comprehensive command reference covers all major RHCSA topics with practical command examples organized by functional area for efficient study and quick reference during exam preparation.