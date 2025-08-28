# RHCSA Exam Quick Reference

## Essential Acronyms & Terms

### Certification & System
- **RHCSA** - Red Hat Certified System Administrator (EX200)
- **RHEL** - Red Hat Enterprise Linux (version 9)
- **OS** - Operating System
- **CLI** - Command Line Interface
- **GUI** - Graphical User Interface
- **API** - Application Programming Interface
- **FQDN** - Fully Qualified Domain Name
- **TTY** - Teletypewriter (terminal)
- **EOF** - End of File
- **STDIN/STDOUT/STDERR** - Standard input/output/error

### Hardware & Boot
- **CPU** - Central Processing Unit
- **RAM** - Random Access Memory
- **BIOS** - Basic Input/Output System
- **UEFI** - Unified Extensible Firmware Interface
- **GRUB** - Grand Unified Bootloader (version 2)
- **initramfs** - Initial RAM filesystem
- **kernel** - Core operating system
- **KVM** - Kernel-based Virtual Machine

## Pre-Exam Checklist
- [ ] Verify VM access and connectivity
- [ ] Test sudo access: `sudo -l`
- [ ] Check available storage devices: `lsblk`
- [ ] Verify SELinux status: `getenforce`
- [ ] Note network interface names: `ip link show`
- [ ] Check default target: `systemctl get-default`
- [ ] Verify firewall status: `firewall-cmd --state`

---

## File Management & Text Processing

### Key Terms & Acronyms
- **inode** - Index node (file metadata structure)
- **hard link** - Direct link to inode (same filesystem)
- **soft link** - Symbolic link (can cross filesystems)
- **glob** - Pattern matching with wildcards
- **regex** - Regular expressions
- **pipe** - Data transfer between commands (|)
- **redirection** - Output/input redirection (>, >>, <)
- **archive** - Collection of files (tar)
- **compression** - Data reduction (gzip, bzip2, xz)
- **MIME type** - File type identification
- **buffer** - Temporary data storage

### Key File Paths
```bash
/tmp/                         # Temporary files directory
/var/tmp/                     # Persistent temporary files
/proc/                        # Process and system information
/dev/null                     # Null device (discard output)
/dev/zero                     # Zero device (null bytes)
```

### Essential Commands
```bash
# File operations
ls -la                               # List files with details
ls -ltr                             # List by time, newest last
cp file1 file2                      # Copy file
cp -r dir1 dir2                     # Copy directory recursively
mv file1 file2                      # Move/rename file
rm file1                            # Remove file
rm -rf directory                    # Remove directory and contents
mkdir -p /path/to/directory         # Create directory path
rmdir directory                     # Remove empty directory
touch filename                     # Create empty file or update timestamp

# File content viewing
cat filename                        # Display file content
less filename                       # View file with paging
head -n 10 filename                 # First 10 lines
tail -n 10 filename                 # Last 10 lines
tail -f filename                    # Follow file changes
wc -l filename                      # Count lines
wc -w filename                      # Count words
file filename                       # Determine file type

# Text processing
grep pattern filename               # Search for pattern
grep -i pattern filename            # Case-insensitive search
grep -r pattern /path               # Recursive search
grep -v pattern filename           # Invert match (exclude pattern)
grep -n pattern filename           # Show line numbers
sed 's/old/new/g' filename         # Replace text
awk '{print $1}' filename          # Print first column
cut -d: -f1 /etc/passwd            # Extract first field
sort filename                       # Sort lines
sort -u filename                   # Sort and remove duplicates
uniq filename                      # Remove consecutive duplicates
tr 'a-z' 'A-Z' < file              # Translate characters

# File searching
find /path -name "*.txt"           # Find files by name
find /path -type f -size +100M     # Find large files
find /path -user username          # Find files by owner
find /path -perm 755               # Find files by permissions
find /path -mtime -7               # Modified in last 7 days
locate filename                    # Fast file search (requires updatedb)
which command                      # Find command location
whereis command                    # Find command and manual locations

# Links
ln file1 file2                     # Create hard link
ln -s /path/to/file link_name      # Create symbolic link
ls -l link_name                    # Check link target
readlink link_name                 # Show link target
```

### File Archiving & Compression
```bash
# Tar operations
tar -cf archive.tar files          # Create tar archive
tar -czf archive.tar.gz files      # Create compressed tar (gzip)
tar -cjf archive.tar.bz2 files     # Create compressed tar (bzip2)
tar -cJf archive.tar.xz files      # Create compressed tar (xz)
tar -tf archive.tar               # List archive contents
tar -xf archive.tar               # Extract archive
tar -xzf archive.tar.gz           # Extract gzip compressed tar
tar -xzf archive.tar.gz -C /path  # Extract to specific directory

# Compression utilities
gzip filename                      # Compress file
gunzip filename.gz                # Decompress file
bzip2 filename                    # Better compression
bunzip2 filename.bz2              # Decompress bzip2
xz filename                       # Best compression
unxz filename.xz                  # Decompress xz
zip archive.zip files             # Create zip archive
unzip archive.zip                 # Extract zip archive
```

### Input/Output Redirection
```bash
# Redirection operators
command > file                     # Redirect stdout to file (overwrite)
command >> file                    # Redirect stdout to file (append)
command 2> file                    # Redirect stderr to file
command 2>&1                      # Redirect stderr to stdout
command < file                     # Use file as stdin
command | command2                 # Pipe output to next command
command | tee file                 # Output to both stdout and file
command &> file                    # Redirect both stdout and stderr
```

### Common Tasks
```bash
# Create directory structure and files
mkdir -p /project/{docs,src,tests}
touch /project/docs/README.md
echo "Project files" > /project/docs/README.md

# Search and process log files
grep ERROR /var/log/messages | tail -10
grep -i "failed" /var/log/*.log | cut -d: -f1 | sort -u

# Archive and compress directories
tar -czf backup-$(date +%Y%m%d).tar.gz /home/user
find /tmp -name "*.log" -mtime +7 -exec rm {} \;

# Text processing workflow
cat file.txt | grep "pattern" | sort | uniq -c | sort -nr > results.txt

# Find and replace across multiple files
find /path -name "*.conf" -exec sed -i 's/old/new/g' {} \;
```

### Troubleshooting
```bash
# File system issues
df -h                              # Check disk space
du -sh directory                   # Check directory size
lsof filename                      # See what's using file
fuser filename                     # Alternative to lsof

# Permission issues
ls -la filename                    # Check file permissions
file filename                      # Verify file type
stat filename                      # Detailed file information

# Text processing problems
file filename                      # Check file encoding
wc -l filename                     # Verify line count
od -c filename | head              # Check for special characters
```

### Common Pitfalls
- **WRONG**: Using `rm -rf /` accidentally → **RIGHT**: Always double-check paths
- **WRONG**: Not quoting file names with spaces → **RIGHT**: Use quotes or escape spaces
- **WRONG**: Forgetting `-r` for directory operations → **RIGHT**: Use `-r` for recursive operations
- **WRONG**: Using `>` instead of `>>` → **RIGHT**: Use `>>` to append, `>` overwrites

---

## User and Group Management

### Key Terms & Acronyms
- **UID** - User Identifier (numeric user ID, root=0)
- **GID** - Group Identifier (numeric group ID)
- **sudo** - Superuser do (privilege escalation)
- **PAM** - Pluggable Authentication Modules
- **shadow** - Password hashing system
- **skel** - Skeleton directory template for new users
- **wheel** - Administrative group with sudo privileges

### Key File Paths
```bash
/etc/passwd                   # User account information
/etc/shadow                   # Password hashes
/etc/group                    # Group information
/etc/sudoers                  # Sudo access (edit with visudo only)
/etc/default/useradd          # Default user settings
/home/username                # User home directories
/etc/skel/                    # Template for new user homes
```

### Essential Commands
```bash
# User creation and management
useradd alice                          # Basic user with defaults
useradd -u 1001 -G wheel bob          # Specific UID + sudo access
useradd -r -s /sbin/nologin svcuser    # Service account
useradd -e 2024-12-31 tempuser        # Account with expiration
useradd -c "Full Name" -m username     # With comment and home dir

# Password management
passwd alice                           # Set password
chage -M 30 alice                     # Password expires in 30 days
chage -W 7 alice                      # 7-day warning before expiration
chage -l alice                        # List password aging info
chage -d 0 alice                      # Force password change on next login

# Account modifications
usermod -aG developers alice          # Add to supplementary group
usermod -L alice                      # Lock account
usermod -U alice                      # Unlock account
usermod -s /bin/bash alice            # Change shell

# Group management
groupadd -g 1500 developers           # Create group with specific GID
gpasswd -a alice developers           # Add user to group
gpasswd -d alice developers           # Remove user from group

# Information and verification
id alice                              # Show user ID and groups
groups alice                          # Show user groups
who                                   # Currently logged in users
last alice                            # Login history for user
```

### Common Tasks
```bash
# Create user with sudo access
useradd -G wheel username && passwd username

# Create service account
useradd -r -s /sbin/nologin -d /var/lib/service serviceuser

# Set up password aging policy
chage -M 90 -m 7 -W 7 username

# Verify user setup
id username && groups username
su - username  # Test login
```

### Sudo Configuration
```bash
# Always use visudo to edit
visudo

# Common sudoers entries:
alice ALL=(ALL) ALL                   # Full sudo access
%wheel ALL=(ALL) NOPASSWD: ALL         # Wheel group no password
alice ALL=(ALL) NOPASSWD: /bin/systemctl  # Specific command only
```

### Troubleshooting
```bash
# User can't login
passwd -S username                    # Check password status
chage -l username                     # Check account expiration
ls -la /home/username                 # Check home directory permissions

# Sudo issues
visudo -c                             # Check sudoers syntax
groups username                       # Verify group membership
```

### Common Pitfalls
- **WRONG**: Direct editing `/etc/sudoers` → **RIGHT**: Use `visudo`
- **WRONG**: Creating user without password → **RIGHT**: Always set password after `useradd`
- **WRONG**: Forgetting home directory → **RIGHT**: Use `-m` or check `/home`

---

## File Permissions & Access Control

### Key Terms & Acronyms
- **ACL** - Access Control List (extended permissions)
- **setuid** - Set User ID (execute as owner)
- **setgid** - Set Group ID (execute as group)
- **sticky bit** - Restrict deletion in shared directories
- **umask** - User file creation mask
- **chmod** - Change mode (permissions)
- **chown** - Change owner
- **chgrp** - Change group
- **facl** - File Access Control List utilities
- **effective permissions** - Final permissions after ACL evaluation
- **mask** - Maximum ACL permissions allowed

### Key File Paths
```bash
/etc/passwd                   # User account information
/etc/group                    # Group information
/etc/login.defs              # Default umask and settings
```

### Essential Commands
```bash
# Basic permission management
chmod 755 filename                    # Set permissions (octal)
chmod u+x filename                    # Add execute for user (symbolic)
chmod go-w filename                   # Remove write for group/others
chmod a+r filename                    # Add read for all
chown user:group filename             # Change owner and group
chown user filename                   # Change owner only
chgrp group filename                  # Change group only
chown -R user:group directory         # Recursive ownership change

# View permissions
ls -l filename                        # Long listing with permissions
stat filename                         # Detailed file information
getfacl filename                      # Show ACL permissions
ls -ld directory                      # Directory permissions

# Special permissions
chmod 4755 filename                   # Set setuid bit
chmod 2755 filename                   # Set setgid bit
chmod 1755 directory                  # Set sticky bit
chmod u+s filename                    # Set setuid (symbolic)
chmod g+s filename                    # Set setgid (symbolic)
chmod +t directory                    # Set sticky bit (symbolic)
find /path -perm -4000                # Find setuid files
find /path -perm -2000                # Find setgid files
find /path -perm -1000                # Find sticky bit files

# ACL management
setfacl -m u:alice:rw filename        # Grant user ACL permissions
setfacl -m g:developers:rwx directory # Grant group ACL permissions
setfacl -m o::r filename              # Set other permissions
setfacl -x u:alice filename           # Remove user ACL entry
setfacl -b filename                   # Remove all ACL entries
setfacl -d -m g:developers:rwx directory # Set default ACL
setfacl -R -m u:alice:rx directory    # Recursive ACL application

# umask operations
umask                                 # Show current umask
umask 022                            # Set umask (files 644, dirs 755)
umask 002                            # Set umask (files 664, dirs 775)
```

### Permission Calculation
```bash
# Octal permissions breakdown
# Read (r) = 4, Write (w) = 2, Execute (x) = 1
# 7 = 4+2+1 = rwx (read, write, execute)
# 6 = 4+2   = rw- (read, write)
# 5 = 4+1   = r-x (read, execute)
# 4 = 4     = r-- (read only)

# Common permission combinations
644 = rw-r--r--  # Files: owner read/write, group/others read
755 = rwxr-xr-x  # Executables: owner full, group/others read/execute
600 = rw-------  # Private files: owner read/write only
700 = rwx------  # Private directories: owner full access only
666 = rw-rw-rw-  # World writable files (rare)
777 = rwxrwxrwx  # World writable directories (dangerous)

# Special permission values (first digit)
4000 = setuid    # Execute as file owner
2000 = setgid    # Execute as file group
1000 = sticky    # Restrict deletion
```

### Common Tasks
```bash
# Set up shared directory with group collaboration
mkdir /shared
chgrp developers /shared
chmod 2775 /shared                    # setgid + group write
setfacl -d -m g::rwx /shared         # Default group permissions
setfacl -d -m o::r-x /shared         # Default other permissions

# Secure personal directory
chmod 700 /home/alice                 # Owner only access
chmod 600 /home/alice/.ssh/id_rsa     # Private key protection

# Make script executable for everyone
chmod +x script.sh
# Or more specifically:
chmod 755 script.sh

# Grant specific user access to file
setfacl -m u:bob:rw /data/important.txt
getfacl /data/important.txt           # Verify ACL

# Remove all permissions for group and others
chmod go= filename
# Or using octal:
chmod 600 filename

# Find files with wrong permissions
find /home -perm 777 -type f          # World-writable files (security risk)
find /usr/bin -not -user root         # Non-root owned executables
```

### Troubleshooting Permission Issues
```bash
# Permission denied troubleshooting
ls -la /path/to/file                  # Check file permissions
ls -lad /path/to/                     # Check directory permissions
getfacl /path/to/file                 # Check ACLs
groups username                       # Check user's groups
id username                           # Check user ID and groups

# Fix common permission problems
chmod +x script                       # Make script executable
chown $(whoami) file                  # Take ownership of file
chmod u+w file                        # Add write permission for user
setfacl -b file                       # Remove all ACLs if causing issues

# Restore default permissions
chmod --reference=reference_file target_file  # Copy permissions
find /path -type f -exec chmod 644 {} \;     # Files to 644
find /path -type d -exec chmod 755 {} \;     # Directories to 755
```

### ACL vs Traditional Permissions
```bash
# Traditional permissions (3 entities: user, group, other)
chmod 750 file        # rwxr-x--- (user: rwx, group: r-x, other: ---)

# ACL allows multiple users and groups
setfacl -m u:alice:rw,u:bob:r,g:admins:rwx file
getfacl file          # Shows detailed ACL permissions

# ACL inheritance (default ACLs)
setfacl -d -m u:alice:rwx /directory  # New files inherit ACL
```

### Common Pitfalls
- **WRONG**: Using `777` permissions everywhere → **RIGHT**: Use least privilege principle
- **WRONG**: Forgetting recursive flag for directories → **RIGHT**: Use `-R` for recursive operations
- **WRONG**: Not checking parent directory permissions → **RIGHT**: Verify full path permissions
- **WRONG**: Mixing ACLs and traditional permissions → **RIGHT**: Understand ACL mask interactions
- **WRONG**: Setting setuid on scripts → **RIGHT**: setuid only works on binary executables

---

## Package Management

### Key Terms & Acronyms
- **DNF** - Dandified YUM (RHEL 9 package manager)
- **YUM** - Yellowdog Updater Modified (legacy package manager)
- **RPM** - Red Hat Package Manager (low-level package format)
- **repository** - Package source location
- **GPG** - GNU Privacy Guard (package signing)
- **metadata** - Repository information cache
- **group** - Collection of related packages
- **module** - Application streams with multiple versions
- **EPEL** - Extra Packages for Enterprise Linux
- **BaseOS** - Core RHEL repository
- **AppStream** - Application and runtime repository

### Key File Paths
```bash
/etc/dnf/dnf.conf              # DNF main configuration
/etc/yum.repos.d/              # Repository configuration files
/var/cache/dnf/                # DNF cache directory
/var/log/dnf.log              # DNF transaction log
/etc/rpm/                     # RPM configuration
```

### Essential Commands
```bash
# Package information and search
dnf list                              # List all packages
dnf list installed                    # List installed packages
dnf list available                    # List available packages
dnf search httpd                      # Search package names/descriptions
dnf info httpd                        # Detailed package information
dnf provides /usr/sbin/httpd          # Find package providing file

# Package installation and removal
dnf install httpd                     # Install package
dnf install -y httpd                  # Install without confirmation
dnf remove httpd                      # Remove package
dnf reinstall httpd                   # Reinstall package
dnf downgrade httpd                   # Downgrade to previous version

# System updates
dnf check-update                      # Check for updates
dnf update                           # Update all packages
dnf update httpd                     # Update specific package
dnf upgrade                          # Same as update (preferred)

# Group operations
dnf group list                       # List package groups
dnf group info "Development Tools"   # Group information
dnf group install "Development Tools" # Install group
dnf group remove "Development Tools"  # Remove group

# Repository management
dnf repolist                         # List enabled repositories
dnf repolist all                     # List all repositories
dnf config-manager --enable epel     # Enable repository
dnf config-manager --disable epel    # Disable repository
dnf makecache                        # Rebuild metadata cache

# Local package installation
dnf localinstall package.rpm         # Install local RPM
rpm -ivh package.rpm                 # Install with RPM directly
rpm -Uvh package.rpm                 # Upgrade with RPM
rpm -e package                       # Remove with RPM

# Package queries (RPM)
rpm -qa                              # List all installed packages
rpm -qi httpd                        # Package information
rpm -ql httpd                        # List files in package
rpm -qf /usr/sbin/httpd             # Find package owning file
rpm -qc httpd                        # List config files
rpm -qd httpd                        # List documentation
```

### Module Operations (Application Streams)
```bash
# Module management
dnf module list                      # List available modules
dnf module list nodejs              # List specific module streams
dnf module info nodejs:16           # Module stream information
dnf module install nodejs:16        # Install specific stream
dnf module enable nodejs:16         # Enable stream (don't install)
dnf module disable nodejs           # Disable module
dnf module reset nodejs             # Reset module state
```

### Repository Configuration
```bash
# Add custom repository
cat > /etc/yum.repos.d/custom.repo << EOF
[custom]
name=Custom Repository
baseurl=https://example.com/repo
enabled=1
gpgcheck=1
gpgkey=https://example.com/GPG-KEY
EOF

# Enable EPEL repository
dnf install epel-release
dnf config-manager --enable epel
```

### Common Tasks
```bash
# Install web server stack
dnf install -y httpd php php-mysqlnd mariadb-server
systemctl enable --now httpd mariadb

# Install development tools
dnf group install "Development Tools"
dnf install -y git vim

# Update system security patches only
dnf update --security

# Find and install package providing specific file
dnf provides */netstat
dnf install -y net-tools

# Clean up package cache
dnf clean all                        # Clean all cache
dnf autoremove                       # Remove orphaned packages
```

### Troubleshooting
```bash
# Package issues
dnf check                           # Check for problems
dnf history                         # Show transaction history
dnf history undo 5                  # Undo transaction ID 5
dnf history info 5                  # Details of transaction 5

# Repository problems
dnf repolist -v                     # Verbose repository info
dnf makecache --refresh             # Force cache refresh
dnf config-manager --dump           # Show configuration

# Dependency issues
dnf install --allowerasing package  # Allow erasing conflicts
dnf install --best package          # Install best version available
dnf install --nobest package        # Allow suboptimal dependencies

# GPG key problems
rpm --import /path/to/GPG-KEY       # Import signing key
dnf install --nogpgcheck package    # Skip GPG verification (not recommended)
```

### Common Pitfalls
- **WRONG**: Using `yum` commands → **RIGHT**: Use `dnf` in RHEL 9
- **WRONG**: Not updating before installing → **RIGHT**: Run `dnf update` regularly
- **WRONG**: Installing from untrusted sources → **RIGHT**: Verify GPG signatures
- **WRONG**: Mixing RPM and DNF operations → **RIGHT**: Use DNF for dependency management

---

## Storage and LVM Management

### Key Terms & Acronyms
- **LVM** - Logical Volume Manager (flexible disk management)
- **PV** - Physical Volume (physical disk/partition)
- **VG** - Volume Group (pool of PVs)
- **LV** - Logical Volume (usable storage from VG)
- **UUID** - Universally Unique Identifier (persistent device ID)
- **XFS** - X File System (RHEL 9 default)
- **ext4** - Fourth Extended Filesystem
- **GPT** - GUID Partition Table (modern partitioning)
- **MBR** - Master Boot Record (legacy, 2TB limit)
- **fsck** - File System Check
- **fstab** - File System Table
- **swap** - Virtual memory on disk
- **mount point** - Directory where filesystem is attached
- **PE** - Physical Extent (LVM allocation unit)
- **VDO** - Virtual Data Optimizer (deduplication/compression)

### Key File Paths
```bash
/etc/fstab                    # Filesystem mount configuration
/dev/mapper/                  # Device mapper devices (LVM)
/dev/vg_name/lv_name          # Logical volume paths
/proc/mounts                  # Currently mounted filesystems
/proc/cmdline                 # Current kernel command line
/boot/                        # Boot files (kernels, initramfs)
```

### Essential Commands
```bash
# Disk and partition management
lsblk                                  # Check available disks
blkid                                  # Show UUIDs and file systems
fdisk /dev/sdb                        # Create partitions
# fdisk commands: n (new), p (primary), 1 (partition number), 
#                 t (change type), 8e (LVM), w (write)
partprobe                             # Re-read partition table

# LVM workflow
pvcreate /dev/sdb1 /dev/sdc1          # Create physical volumes
vgcreate vg_data /dev/sdb1 /dev/sdc1  # Create volume group
lvcreate -L 2G -n lv_database vg_data # Create logical volume
lvcreate -l 100%FREE -n lv_app vg_data # Use all remaining space

# LVM information
pvs; vgs; lvs                         # Show PV, VG, LV summary
pvdisplay; vgdisplay; lvdisplay       # Detailed information

# LVM extension
lvextend -L +1G /dev/vg_data/lv_database  # Extend LV
lvextend -l +100%FREE /dev/vg_data/lv_app # Use all free space

# Filesystem operations
mkfs.xfs /dev/vg_data/lv_database     # Create XFS filesystem
mkfs.ext4 /dev/vg_data/lv_app         # Create ext4 filesystem
mkdir /database /app                  # Create mount points
mount /dev/vg_data/lv_database /database

# Filesystem resize (after LV extension)
xfs_growfs /database                  # Grow XFS filesystem
resize2fs /dev/vg_data/lv_app         # Resize ext4 filesystem

# Verify changes
df -h /database                       # Check filesystem size
lsblk                                 # Verify block device structure
```

### Swap Management
```bash
# Create and enable swap
mkswap /dev/sdd1                      # Create swap on partition
swapon /dev/sdd1                      # Activate swap
swapon -a                             # Activate all swap in fstab
swapon --show                         # Verify active swap
```

### fstab Configuration
```bash
# Add entries to /etc/fstab for persistence
echo "/dev/vg_data/lv_database /database xfs defaults 0 2" >> /etc/fstab
echo "/dev/sdd1 swap swap defaults 0 0" >> /etc/fstab

# Test fstab entries
mount -a                              # Mount all in fstab
umount /database && mount /database   # Test specific mount
```

### Common Tasks
```bash
# Complete LVM setup from scratch
lsblk                                 # Check available disks
fdisk /dev/sdb                        # Create partition (n,p,1,enter,enter,t,8e,w)
partprobe
pvcreate /dev/sdb1
vgcreate vg_data /dev/sdb1
lvcreate -L 2G -n lv_app vg_data
mkfs.xfs /dev/vg_data/lv_app
mkdir /app
mount /dev/vg_data/lv_app /app
echo "/dev/vg_data/lv_app /app xfs defaults 0 2" >> /etc/fstab
mount -a                              # Test fstab

# Extend existing LV and filesystem
lvextend -L +1G /dev/vg_data/lv_app
xfs_growfs /app                       # For XFS
# OR resize2fs /dev/vg_data/lv_app    # For ext4
df -h /app                            # Verify new size
```

### Troubleshooting
```bash
# Storage issues diagnostic
df -h                                 # Check disk space
lsblk                                 # Check block devices
mount | grep target_mount             # Check mount status
mount -a                              # Test fstab syntax
pvs; vgs; lvs                         # Check LVM status

# Filesystem problems
fsck -n /dev/device                   # Check filesystem (ext4)
xfs_repair -n /dev/device             # Check XFS filesystem
lsof +D /mountpoint                   # See what's using mountpoint
fuser -mv /mountpoint                 # Alternative to lsof
```

### Common Pitfalls
- **WRONG**: Using `resize2fs` for XFS → **RIGHT**: Use `xfs_growfs` for XFS
- **WRONG**: Forgetting partition type → **RIGHT**: Set type `8e` for LVM in fdisk
- **WRONG**: Not testing fstab → **RIGHT**: Always `mount -a` before reboot
- **WRONG**: Forgetting `partprobe` → **RIGHT**: Run after partition changes

---

## Network Configuration

### Key Terms & Acronyms
- **NetworkManager** - Primary network service in RHEL
- **nmcli** - NetworkManager CLI
- **nmtui** - NetworkManager TUI
- **DHCP** - Dynamic Host Configuration Protocol
- **DNS** - Domain Name System
- **IP** - Internet Protocol (IPv4/IPv6)
- **TCP** - Transmission Control Protocol
- **UDP** - User Datagram Protocol
- **CIDR** - Classless Inter-Domain Routing (/24 notation)
- **MAC** - Media Access Control address
- **gateway** - Default route for external networks
- **interface** - Network device (eth0, ens33, etc.)
- **connection** - NetworkManager configuration profile

### Key File Paths
```bash
/etc/NetworkManager/          # NetworkManager configuration
/etc/resolv.conf              # DNS configuration
/etc/hosts                    # Local hostname resolution
/etc/services                 # Internet network services list
/etc/hostname                 # System hostname
/etc/sysconfig/network-scripts/  # Legacy network config (RHEL 8)
```

### Essential Commands
```bash
# Network information
ip addr show                          # Show IP addresses
ip link show                          # Show network interfaces
ip route show                         # Show routing table
nmcli device status                   # NetworkManager device status
nmcli connection show                 # Show connections

# Static IP configuration (step-by-step)
nmcli con show                        # List connections
nmcli con modify "System eth0" ipv4.method manual
nmcli con modify "System eth0" ipv4.addresses "192.168.1.100/24"
nmcli con modify "System eth0" ipv4.gateway "192.168.1.1"
nmcli con modify "System eth0" ipv4.dns "8.8.8.8,8.8.4.4"
nmcli con modify "System eth0" autoconnect yes
nmcli con up "System eth0"

# Create new connection from scratch
nmcli con add type ethernet con-name "static-eth0" ifname eth0 \
  ip4 192.168.1.100/24 gw4 192.168.1.1
nmcli con modify "static-eth0" ipv4.dns "8.8.8.8,8.8.4.4"
nmcli con up "static-eth0"

# Reset to DHCP
nmcli con modify "System eth0" ipv4.method auto
nmcli con modify "System eth0" ipv4.addresses ""
nmcli con modify "System eth0" ipv4.gateway ""
nmcli con modify "System eth0" ipv4.dns ""
nmcli con up "System eth0"
```

### Network Testing
```bash
# Connectivity testing
ping -c 3 192.168.1.1                # Test gateway
ping -c 3 8.8.8.8                    # Test external IP
ping -c 3 google.com                 # Test DNS resolution
traceroute 8.8.8.8                   # Trace network path

# DNS testing
nslookup google.com                   # Basic DNS lookup
dig google.com                        # Detailed DNS lookup
dig @8.8.8.8 google.com              # Query specific DNS server
```

### Common Tasks
```bash
# Configure static IP from scratch
nmcli con add type ethernet con-name "server" ifname ens33 \
  ip4 192.168.1.50/24 gw4 192.168.1.1
nmcli con modify "server" ipv4.dns "192.168.1.1,8.8.8.8"
nmcli con up "server"
ping -c 3 8.8.8.8                    # Verify connectivity
```

### Troubleshooting
```bash
# Network connectivity issues (layer-by-layer)
ip link show                          # Physical layer
ip addr show                          # Network layer
ip route show                         # Routing layer
ping 127.0.0.1                       # Loopback test
ping gateway_ip                       # Gateway test
ping 8.8.8.8                         # External connectivity
nslookup hostname                     # DNS resolution

# NetworkManager troubleshooting
nmcli device status                   # Check device status
nmcli connection show                 # Check connections
nmcli con up "connection_name"        # Activate connection
systemctl status NetworkManager       # Check NetworkManager service
```

### Common Pitfalls
- **WRONG**: Forgetting to activate connection → **RIGHT**: Always `nmcli con up` after changes
- **WRONG**: Not setting method to manual → **RIGHT**: Set `ipv4.method manual` for static IP
- **WRONG**: Configuring without checking interface name → **RIGHT**: Check `ip link show` first

---

## SELinux Management

### Key Terms & Acronyms
- **SELinux** - Security-Enhanced Linux (MAC system)
- **MAC** - Mandatory Access Control
- **DAC** - Discretionary Access Control
- **context** - SELinux security label (user:role:type:level)
- **type** - Most important part of context for RHCSA
- **boolean** - SELinux on/off policy switches
- **AVC** - Access Vector Cache (denial logs)
- **MLS** - Multi-Level Security
- **MCS** - Multi-Category Security
- **targeted** - Default SELinux policy
- **enforcing** - SELinux blocking violations
- **permissive** - SELinux logging only
- **disabled** - SELinux completely off
- **relabel** - Reapply correct SELinux contexts

### Key File Paths
```bash
/etc/selinux/config           # SELinux mode configuration
/var/log/audit/audit.log      # SELinux audit logs
/var/lib/selinux/             # SELinux policy files
/etc/selinux/targeted/        # Targeted policy files
```

### Essential Commands
```bash
# SELinux status and modes
getenforce                            # Current mode
sestatus                              # Detailed status
setenforce 0                          # Set permissive (temporary)
setenforce 1                          # Set enforcing (temporary)

# Persistent configuration (EXAM TIP: grubby commands are IN the config file!)
vi /etc/selinux/config                # Contains helpful grubby examples in comments
# SELINUX=enforcing|permissive|disabled
# For RHEL 9: disabled only unloads policy, doesn't fully disable SELinux
# To fully disable: grubby --update-kernel ALL --args selinux=0
# To re-enable:     grubby --update-kernel ALL --remove-args selinux

# Permanent mode changes
# Method 1: Edit configuration file
vim /etc/selinux/config               # Set SELINUX=enforcing|permissive|disabled

# Method 2: Using grubby (bootloader kernel parameters)
grubby --update-kernel=ALL --args="selinux=0"     # Disable SELinux at boot
grubby --update-kernel=ALL --remove-args="selinux=0"  # Remove disable parameter
grubby --update-kernel=ALL --args="enforcing=0"   # Boot into permissive mode
grubby --update-kernel=ALL --remove-args="enforcing=0"  # Remove permissive parameter

# Check current kernel parameters
grubby --info=DEFAULT                 # Show default kernel info
cat /proc/cmdline                     # Show current boot parameters

# File contexts
ls -Z filename                        # Show file context
ps -eZ                                # Show process contexts
restorecon -Rv /path                  # Restore default contexts
semanage fcontext -a -t httpd_exec_t "/web(/.*)?"
semanage fcontext -l                  # List file contexts
semanage fcontext -d "/web(/.*)?"     # Delete context rule

# SELinux booleans
getsebool -a                          # List all booleans
getsebool httpd_can_network_connect   # Check specific boolean
setsebool -P httpd_can_network_connect on  # Set boolean permanently
setsebool httpd_can_network_connect on     # Set boolean temporarily

# Port contexts
semanage port -l                      # List port contexts
semanage port -a -t http_port_t -p tcp 8080  # Add port context
semanage port -d -p tcp 8080          # Delete port context
semanage port -l | grep http          # Show HTTP ports
```

### Troubleshooting SELinux
```bash
# Essential ausearch commands (RED HAT OFFICIAL SYNTAX)
ausearch -m AVC -ts recent                                    # Recent AVC denials
ausearch -m AVC -ts today                                     # Today's denials  
ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts boot # All denials since boot
ausearch -c 'daemon_name' --raw | audit2allow -M my-daemon    # Generate policy for specific daemon
ausearch -m AVC -ts recent | audit2allow -R                   # Readable policy suggestions

# Analysis and policy creation
sealert -a /var/log/audit/audit.log   # Analyze denials with recommendations
sealert -l UUID                       # Detailed denial analysis
semodule -X 300 -i my-policy.pp       # Install custom policy module (new syntax)

# If auditd not running, check dmesg
dmesg | grep -i -e type=1300 -e type=1400  # SELinux messages in kernel log
grep "SELinux is preventing" /var/log/messages  # setroubleshoot messages
```

### Common Tasks
```bash
# Configure custom document root for Apache
mkdir -p /web/html
echo "<h1>Test</h1>" > /web/html/index.html
chown -R apache:apache /web/html
# Set SELinux contexts
semanage fcontext -a -t httpd_exec_t "/web(/.*)?"
restorecon -Rv /web
# Configure Apache document root in httpd.conf
systemctl restart httpd
# Test and check for denials
curl http://localhost/
ausearch -m AVC -ts recent

# Temporarily disable SELinux for troubleshooting
setenforce 0                          # Set permissive immediately
# Test your configuration
# If everything works, re-enable
setenforce 1

# Permanently disable SELinux (requires reboot)
grubby --update-kernel=ALL --args="selinux=0"
reboot
# Verify after reboot
getenforce                            # Should show "Disabled"

# Re-enable SELinux after disabling
grubby --update-kernel=ALL --remove-args="selinux=0"
vim /etc/selinux/config               # Set SELINUX=enforcing
reboot
# After reboot, may need to relabel filesystem
touch /.autorelabel                   # Force relabeling on next boot
reboot
```

### Troubleshooting Workflow
```bash
# Step-by-step SELinux troubleshooting
getenforce                            # 1. Check mode
ausearch -m AVC -ts recent            # 2. Look for recent denials
sealert -a /var/log/audit/audit.log   # 3. Analyze denials
# 4. Apply suggested fixes (contexts/booleans/ports)
systemctl restart service_name       # 5. Restart service
ausearch -m AVC -ts recent            # 6. Verify no new denials
```

### Common Pitfalls
- **WRONG**: Temporary boolean change `setsebool boolean on` → **RIGHT**: Use `-P` for permanent
- **WRONG**: Forgetting `restorecon` after context changes → **RIGHT**: Always run `restorecon -Rv`
- **WRONG**: Using wrong context type → **RIGHT**: Use `semanage fcontext -l | grep service` to find correct type
- **WRONG**: Disabling SELinux without reboot → **RIGHT**: `selinux=0` kernel parameter requires reboot
- **WRONG**: Re-enabling SELinux without relabeling → **RIGHT**: Use `touch /.autorelabel` before reboot
- **WRONG**: Editing GRUB config directly → **RIGHT**: Use `grubby` to modify kernel parameters

---

## Firewall Management

### Key Terms & Acronyms
- **firewalld** - Dynamic firewall daemon
- **zone** - Network security trust level
- **service** - Predefined firewall rule set
- **port** - Network communication endpoint
- **rich rule** - Complex firewall rules
- **masquerade** - NAT for outgoing connections
- **forward** - Pass traffic between interfaces
- **ICMP** - Internet Control Message Protocol (ping)
- **runtime** - Temporary configuration
- **permanent** - Persistent configuration

### Key File Paths
```bash
/etc/firewalld/               # Firewall configuration files
/etc/firewalld/zones/         # Zone configuration files
/etc/firewalld/services/      # Service definitions
```

### Essential Commands
```bash
# Firewall status and information
firewall-cmd --state                  # Check if firewalld is running
firewall-cmd --get-active-zones       # Show active zones
firewall-cmd --list-all               # Show all rules in default zone
firewall-cmd --list-services          # Show allowed services
firewall-cmd --list-ports             # Show allowed ports

# Service management
firewall-cmd --add-service=http --permanent      # Allow HTTP
firewall-cmd --add-service=https --permanent     # Allow HTTPS
firewall-cmd --add-service=ssh --permanent       # Allow SSH
firewall-cmd --remove-service=ssh --permanent    # Remove SSH
firewall-cmd --reload                            # Apply permanent changes

# Port management
firewall-cmd --add-port=8080/tcp --permanent     # Allow custom port
firewall-cmd --add-port=1000-1100/tcp --permanent # Port range
firewall-cmd --remove-port=8080/tcp --permanent   # Remove port
firewall-cmd --reload

# Zone management
firewall-cmd --get-default-zone       # Show default zone
firewall-cmd --set-default-zone=public  # Set default zone
firewall-cmd --zone=dmz --list-all     # Show specific zone rules
firewall-cmd --change-interface=eth1 --zone=dmz --permanent

# Rich rules (advanced)
firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" accept' --permanent
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.0.0.5" port port="22" protocol="tcp" accept' --permanent
```

### Common Tasks
```bash
# Allow web server traffic
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload
firewall-cmd --list-services          # Verify

# Allow custom application on port 8080
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload
ss -tuln | grep :8080                 # Verify port is listening

# Quick one-liners for common tasks
firewall-cmd --add-service=http --permanent && firewall-cmd --reload
firewall-cmd --add-port=443/tcp --permanent && firewall-cmd --reload
```

### Troubleshooting
```bash
# Check if firewall is blocking service
firewall-cmd --list-all               # Check current rules
ss -tuln | grep :port                 # Check if service is listening
telnet server_ip port                 # Test connection from client
firewall-cmd --add-port=port/tcp --permanent  # Add rule if needed
firewall-cmd --reload
```

### Common Pitfalls
- **WRONG**: Adding rule without `--permanent` → **RIGHT**: Always use `--permanent` and `--reload`
- **WRONG**: Forgetting to reload → **RIGHT**: Run `--reload` to apply permanent changes
- **WRONG**: Not verifying service is listening → **RIGHT**: Check with `ss -tuln | grep :port`

---

## Services and Systemd Management

### Key Terms & Acronyms
- **systemd** - System and service manager (PID 1)
- **unit** - Basic systemd object
- **service** - Daemon unit type (.service)
- **target** - Group of units (replaces runlevels)
- **socket** - IPC/network socket activation
- **timer** - Scheduled task unit (replaces cron)
- **daemon** - Background service process
- **PID** - Process Identifier
- **journal** - Systemd logging system
- **dependency** - Unit requirement/ordering
- **mask** - Prevent unit from starting
- **runlevel** - Legacy term (replaced by targets)

### Key File Paths
```bash
/etc/systemd/system/          # Custom systemd unit files
/usr/lib/systemd/system/      # System-provided unit files
/var/log/journal/             # Systemd journal logs
/etc/systemd/journald.conf    # Journal configuration
```

### Essential Commands
```bash
# Service lifecycle management
systemctl status httpd                # Check service status
systemctl start httpd                 # Start service
systemctl enable httpd                # Enable at boot
systemctl enable --now httpd          # Enable and start together
systemctl reload httpd                # Reload config without restart
systemctl restart httpd               # Full restart
systemctl disable httpd               # Disable at boot
systemctl stop httpd                  # Stop service

# Service verification
systemctl is-active httpd             # Check if running
systemctl is-enabled httpd            # Check if enabled
systemctl list-units --type=service   # List all services
systemctl --failed                    # List failed services
systemctl list-dependencies httpd     # Show dependencies

# Target management (runlevels)
systemctl get-default                 # Show current default target
systemctl set-default multi-user.target  # Set text mode default
systemctl set-default graphical.target   # Set GUI mode default
systemctl isolate rescue.target      # Switch to rescue mode
systemctl isolate multi-user.target  # Switch to multi-user mode

# Journal and logging
journalctl -u httpd                   # Service-specific logs
journalctl -u httpd -f                # Follow logs
journalctl -u httpd --since "1 hour ago"  # Recent logs
journalctl -p err                     # Error priority and above
journalctl -b                         # Current boot logs
journalctl --disk-usage               # Check journal space usage

# Make journal persistent
mkdir -p /var/log/journal
systemctl restart systemd-journald
```

### Common Tasks
```bash
# Install and configure web server
dnf install -y httpd
systemctl enable --now httpd
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
curl http://localhost                 # Test

# Set up database server
dnf install -y mariadb-server
systemctl enable --now mariadb
mysql_secure_installation
systemctl status mariadb
```

### Troubleshooting Services
```bash
# Service startup troubleshooting workflow
systemctl status service_name         # 1. Check service status
systemctl is-enabled service_name     # 2. Check if enabled
journalctl -u service_name --no-pager # 3. Check detailed logs
systemctl list-dependencies service_name  # 4. Check dependencies
systemctl list-units --failed         # 5. Check for dependency failures

# Configuration validation
httpd -t                              # Test Apache config
sshd -t                              # Test SSH config
nginx -t                             # Test Nginx config

# Check for blocking issues
ausearch -m AVC -ts recent | grep service_name  # SELinux
firewall-cmd --list-all              # Firewall
ss -tuln | grep :port                # Port availability
```

### Common Pitfalls
- **WRONG**: Starting service but not enabling → **RIGHT**: Use `systemctl enable --now`
- **WRONG**: Using restart when reload suffices → **RIGHT**: Use `reload` when possible
- **WRONG**: Not checking logs for errors → **RIGHT**: Always check `journalctl -u service`

---

## Boot Process & GRUB Configuration

### Key Terms & Acronyms
- **GRUB** - Grand Unified Bootloader (version 2)
- **UEFI** - Unified Extensible Firmware Interface
- **BIOS** - Basic Input/Output System (legacy)
- **initramfs** - Initial RAM filesystem
- **kernel** - Core operating system
- **dracut** - initramfs creation tool
- **grubby** - GRUB configuration tool
- **systemd targets** - Boot runlevels (multi-user, graphical, rescue)
- **kernel parameters** - Boot-time configuration options
- **MBR** - Master Boot Record (legacy boot)
- **GPT** - GUID Partition Table (modern)
- **ESP** - EFI System Partition

### Key File Paths
```bash
/boot/grub2/grub.cfg          # GRUB configuration (auto-generated)
/etc/default/grub             # GRUB settings file
/etc/grub.d/                  # GRUB configuration scripts
/boot/loader/entries/         # Boot loader entries (systemd-boot)
/boot/initramfs-*.img         # Initial RAM filesystem images
/boot/vmlinuz-*               # Kernel images
/proc/cmdline                 # Current kernel command line
```

### Essential Commands
```bash
# GRUB configuration management
grub2-mkconfig -o /boot/grub2/grub.cfg    # Regenerate GRUB config
grubby --default-kernel                   # Show default kernel
grubby --info=ALL                         # Show all kernel entries
grubby --set-default /boot/vmlinuz-*      # Set default kernel

# Kernel parameter management
grubby --update-kernel=ALL --args="quiet"           # Add parameter to all kernels
grubby --update-kernel=ALL --remove-args="quiet"    # Remove parameter from all kernels
grubby --update-kernel=DEFAULT --args="selinux=0"   # Add to default kernel only
grubby --info=DEFAULT                               # Show default kernel info

# Boot target management
systemctl get-default                     # Show current default target
systemctl set-default multi-user.target  # Set text mode as default
systemctl set-default graphical.target   # Set GUI mode as default
systemctl list-units --type=target       # List available targets
systemctl isolate rescue.target          # Switch to rescue mode immediately

# Emergency boot options (GRUB menu)
# Add these to kernel line in GRUB:
# rd.break                    # Break before root filesystem mount
# systemd.unit=rescue.target  # Boot to rescue mode
# systemd.unit=emergency.target # Boot to emergency mode
# selinux=0                   # Disable SELinux
# enforcing=0                 # Boot SELinux in permissive mode

# initramfs management
dracut --force                           # Rebuild initramfs for current kernel
dracut --force /boot/initramfs-$(uname -r).img $(uname -r)  # Specific kernel
lsinitrd                                # List contents of initramfs
lsinitrd /boot/initramfs-$(uname -r).img # List specific initramfs
```

### GRUB Configuration
```bash
# Edit GRUB defaults (/etc/default/grub)
GRUB_TIMEOUT=5                          # Boot menu timeout
GRUB_DEFAULT=saved                      # Remember last selection
GRUB_DISABLE_QUIET=true                # Show boot messages
GRUB_CMDLINE_LINUX_DEFAULT="quiet"     # Default kernel parameters
GRUB_CMDLINE_LINUX="crashkernel=auto"  # Always applied parameters

# After editing /etc/default/grub:
grub2-mkconfig -o /boot/grub2/grub.cfg  # Apply changes

# Custom GRUB entries (create in /etc/grub.d/40_custom)
menuentry "My Custom Boot" {
    linux /boot/vmlinuz-custom root=/dev/sda1 quiet
    initrd /boot/initramfs-custom.img
}
```

### Boot Targets (Systemd)
```bash
# Common systemd targets
graphical.target     # Multi-user + GUI (runlevel 5)
multi-user.target    # Multi-user text mode (runlevel 3)
rescue.target        # Single user mode (runlevel 1)
emergency.target     # Minimal system
reboot.target        # Reboot system
poweroff.target      # Shutdown system

# Target management
systemctl isolate multi-user.target    # Switch target temporarily
systemctl set-default graphical.target # Set permanent default
systemctl get-default                  # Check current default
```

### Password Recovery Procedure
```bash
# RHEL 9 Password Reset Steps:
# 1. Boot system and interrupt GRUB menu (press 'e')
# 2. Find linux line, add: rd.break
# 3. Press Ctrl+X to boot
# 4. At emergency prompt:
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
touch /.autorelabel    # If SELinux enabled
exit
exit
# System will reboot and relabel filesystem
```

### Common Tasks
```bash
# Change default boot target to text mode
systemctl set-default multi-user.target
systemctl get-default                   # Verify change

# Add kernel parameter permanently
grubby --update-kernel=ALL --args="intel_iommu=on"
grubby --info=DEFAULT | grep args       # Verify parameter added

# Create custom GRUB menu entry
cat >> /etc/grub.d/40_custom << 'EOF'
menuentry "RHEL 9 Debug Mode" {
    linux /boot/vmlinuz-$(uname -r) root=/dev/sda1 debug
    initrd /boot/initramfs-$(uname -r).img
}
EOF
grub2-mkconfig -o /boot/grub2/grub.cfg

# Rebuild initramfs after hardware changes
dracut --force --add-drivers "driver_name"
# Or for all modules:
dracut --force --regenerate-all
```

### Boot Troubleshooting
```bash
# Boot process diagnosis
journalctl -b                          # Current boot logs
journalctl -b -1                       # Previous boot logs
journalctl -u systemd-logind          # Specific service at boot
dmesg                                  # Kernel ring buffer messages

# GRUB issues
grub2-install /dev/sda                # Reinstall GRUB bootloader
grub2-mkconfig -o /boot/grub2/grub.cfg # Regenerate configuration
efibootmgr -v                         # Show UEFI boot entries (UEFI systems)

# Kernel/initramfs problems
rpm -qa kernel                        # List installed kernels
ls -la /boot/                         # Check boot files exist
dracut --force                        # Rebuild current initramfs
grubby --remove-kernel=/boot/vmlinuz-old # Remove problematic kernel

# Emergency access methods
# Method 1: rd.break (password reset)
# Method 2: systemd.unit=rescue.target (rescue shell)
# Method 3: systemd.unit=emergency.target (minimal system)
# Method 4: Live CD/USB rescue mode
```

### Common Pitfalls
- **WRONG**: Editing `/boot/grub2/grub.cfg` directly → **RIGHT**: Use `grub2-mkconfig` or `grubby`
- **WRONG**: Forgetting `/.autorelabel` after password reset → **RIGHT**: Always touch when SELinux enabled
- **WRONG**: Not regenerating GRUB config after changes → **RIGHT**: Run `grub2-mkconfig` after editing defaults
- **WRONG**: Using legacy GRUB commands → **RIGHT**: Use `grub2-*` commands in RHEL 9

---

## Logging & System Monitoring

### Key Terms & Acronyms
- **journald** - Systemd journal daemon
- **rsyslog** - System logging service
- **syslog** - System logging protocol
- **logrotate** - Log rotation utility
- **dmesg** - Kernel ring buffer messages
- **audit** - Linux audit framework
- **facility** - Syslog message category
- **priority** - Syslog message severity
- **persistent** - Journal storage on disk
- **volatile** - Journal storage in memory only
- **systemd-journald** - Journal service daemon
- **rsyslogd** - Remote system logging daemon

### Key File Paths
```bash
/var/log/messages             # General system messages (rsyslog)
/var/log/secure              # Authentication and security messages
/var/log/audit/audit.log     # Audit framework logs
/var/log/journal/            # Persistent systemd journal
/run/log/journal/            # Volatile systemd journal
/etc/systemd/journald.conf   # Journal daemon configuration
/etc/rsyslog.conf           # Rsyslog main configuration
/etc/rsyslog.d/             # Rsyslog additional configurations
/etc/logrotate.conf         # Log rotation configuration
/etc/logrotate.d/           # Service-specific logrotate configs
```

### Essential Commands
```bash
# Systemd Journal (journalctl)
journalctl                              # View all journal entries
journalctl -f                           # Follow journal (like tail -f)
journalctl -u httpd                     # Service-specific logs
journalctl -u httpd -f                  # Follow service logs
journalctl -p err                       # Priority level (emerg, alert, crit, err, warning, notice, info, debug)
journalctl --since "1 hour ago"        # Time-based filtering
journalctl --since "2023-01-01" --until "2023-01-02"
journalctl -b                           # Current boot logs
journalctl -b -1                        # Previous boot logs
journalctl --disk-usage                 # Check journal disk usage
journalctl --vacuum-time=1month         # Clean logs older than 1 month
journalctl --vacuum-size=100M           # Limit journal size to 100MB

# Journal output formatting
journalctl -o json                      # JSON format
journalctl -o verbose                   # Verbose output
journalctl -o cat                       # Message text only
journalctl --no-pager                   # Don't use pager

# System information and monitoring
dmesg                                   # Kernel ring buffer
dmesg -w                               # Follow kernel messages
uptime                                 # System uptime and load
who                                    # Currently logged in users
w                                      # Detailed user activity
last                                   # Login history
lastlog                                # Last login times

# Process monitoring
top                                    # Real-time process monitor
htop                                   # Enhanced process monitor (if installed)
ps aux                                # Process snapshot
ps -ef                                # Full format process list
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem  # Custom format, sorted by memory
pstree                                # Process tree view
pgrep httpd                           # Find processes by name
pkill httpd                           # Kill processes by name

# System resource monitoring
free -h                               # Memory usage (human readable)
df -h                                 # Disk space usage
du -sh /var/log                       # Directory size
lsof                                  # List open files
lsof -u username                      # Files opened by user
lsof +D /path                         # Files in directory
ss -tuln                              # Network socket statistics
netstat -tuln                         # Network connections (legacy)
```

### Performance Monitoring
```bash
# System performance tools
sar                                   # System activity reporter
sar -u 1 5                          # CPU usage, 1 second intervals, 5 times
sar -r 1 5                          # Memory usage
sar -d 1 5                          # Disk I/O
sar -n DEV 1 5                      # Network statistics
iostat                              # I/O statistics
iostat -x 1                         # Extended stats every second
vmstat                              # Virtual memory statistics  
vmstat 1 5                          # 1 second intervals, 5 times
```

### Log Configuration
```bash
# Make journal persistent
mkdir -p /var/log/journal
systemctl restart systemd-journald
# Or edit /etc/systemd/journald.conf:
# Storage=persistent

# Configure journal retention
echo "MaxRetentionSec=1month" >> /etc/systemd/journald.conf
echo "SystemMaxUse=100M" >> /etc/systemd/journald.conf
systemctl restart systemd-journald

# Rsyslog configuration examples
# In /etc/rsyslog.conf or /etc/rsyslog.d/custom.conf:
auth.*                    /var/log/auth.log     # Authentication messages
mail.*                    /var/log/mail.log     # Mail system messages
*.emerg                   :omusrmsg:*           # Emergency to all users
*.info;mail.none;authpriv.none  /var/log/messages  # General messages

# Custom log file for application
echo "local0.*    /var/log/myapp.log" > /etc/rsyslog.d/myapp.conf
systemctl restart rsyslog
# In application: logger -p local0.info "Application message"
```

### Log Rotation
```bash
# Logrotate configuration
# Edit /etc/logrotate.d/myapp:
/var/log/myapp.log {
    daily           # Rotate daily
    missingok       # Don't error if log missing
    rotate 7        # Keep 7 old logs
    compress        # Compress old logs
    delaycompress   # Compress on next rotation
    notifempty      # Don't rotate empty logs
    copytruncate    # Copy and truncate original
    postrotate      # Commands after rotation
        systemctl reload myapp
    endscript
}

# Test logrotate configuration
logrotate -d /etc/logrotate.d/myapp     # Debug mode (dry run)
logrotate -f /etc/logrotate.d/myapp     # Force rotation
```

### Common Tasks
```bash
# Monitor system startup issues
journalctl -b -p err                   # Boot errors
journalctl -u systemd-networkd -b      # Network service boot logs
systemctl --failed                     # Failed services

# Track user activity
journalctl _UID=1000                   # Logs for specific user ID
last -n 10                             # Last 10 logins
who -a                                 # All login information

# Monitor file access
lsof /var/log/messages                 # What's accessing log file
fuser -v /var/log/messages             # Alternative to lsof

# System performance baseline
sar -A > /tmp/system-baseline.txt      # Complete system activity report
vmstat 1 60 > /tmp/vmstat-1min.txt     # 1 minute of VM statistics

# Clean up logs
journalctl --vacuum-time=2weeks        # Keep 2 weeks of journal logs
find /var/log -name "*.gz" -mtime +30 -delete  # Remove compressed logs > 30 days
```

### Troubleshooting with Logs
```bash
# Service won't start
systemctl status servicename           # Service status
journalctl -u servicename --no-pager   # Service logs
journalctl -u servicename --since "10 minutes ago"

# System performance issues
top                                    # Current resource usage
sar -u 1 10                           # CPU usage pattern
sar -r 1 10                           # Memory usage pattern
iostat -x 1 10                        # I/O patterns

# Authentication problems
grep "Failed password" /var/log/secure
grep "authentication failure" /var/log/secure
journalctl _SYSTEMD_UNIT=sshd.service -p warning

# Network connectivity issues
ss -tuln | grep :80                   # Check if web server listening
journalctl -u NetworkManager --since "1 hour ago"
dmesg | grep -i network               # Network-related kernel messages

# Boot problems
journalctl -b -p err                  # Current boot errors
journalctl -b -1 -p warning           # Previous boot warnings
dmesg | grep -i error                 # Kernel errors
```

### Log Analysis Techniques
```bash
# Pattern matching and analysis
grep "ERROR" /var/log/messages | tail -20
grep -c "Failed password" /var/log/secure    # Count occurrences
awk '/Failed password/ {print $1, $2, $3, $11}' /var/log/secure  # Extract fields

# Time-based log analysis
journalctl --since "2023-12-01 09:00:00" --until "2023-12-01 17:00:00" -p err
grep "Dec 01 09:" /var/log/messages | grep ERROR

# Real-time monitoring
tail -f /var/log/messages | grep ERROR
journalctl -f | grep -i fail
multitail /var/log/messages /var/log/secure  # Multiple files simultaneously
```

### Common Pitfalls
- **WRONG**: Using `tail -f` on journal files → **RIGHT**: Use `journalctl -f`
- **WRONG**: Not making journal persistent → **RIGHT**: Create `/var/log/journal` directory
- **WRONG**: Ignoring log rotation → **RIGHT**: Configure logrotate for custom logs
- **WRONG**: Not filtering logs by time/service → **RIGHT**: Use journalctl filters for efficiency

---

## NFS and AutoFS

### Key Terms & Acronyms
- **NFS** - Network File System (remote file sharing protocol)
- **AutoFS** - Automatic File System (on-demand mounting service)
- **export** - Making shares available on NFS server
- **mount** - Accessing shares on NFS client
- **showmount** - Command to list NFS exports
- **exportfs** - Command to export NFS shares
- **automount** - AutoFS daemon process
- **direct map** - AutoFS mount on specific paths
- **indirect map** - AutoFS mount under common parent directory
- **master map** - Main AutoFS configuration file
- **wildcard** - Pattern matching in AutoFS maps (* and &)
- **\_netdev** - Mount option indicating network dependency

### Key File Paths
```bash
/etc/exports                  # NFS server export configuration
/etc/fstab                    # Persistent mount configuration
/etc/auto.master              # AutoFS master map
/etc/auto.master.d/           # AutoFS user-defined maps directory
/etc/autofs.conf              # AutoFS service configuration
/etc/auto.misc                # Default indirect map for removable media
```

### NFS Server Setup
```bash
# Install NFS server software
dnf install -y nfs-utils

# Create and configure share directory
mkdir -p /nfs-share
chmod 755 /nfs-share
chown nobody:nobody /nfs-share

# Configure exports (/etc/exports)
echo "/nfs-share *(rw,sync,no_root_squash)" >> /etc/exports
# Common export options:
# rw/ro                - read-write/read-only
# sync/async           - synchronous/asynchronous writes  
# no_root_squash       - don't map root to nobody
# root_squash          - map root to nobody (default)
# all_squash          - map all users to nobody

# Export the shares
exportfs -avr                 # Export all shares with verbose output
exportfs -v                   # Show current exports

# Start and enable NFS services
systemctl enable --now nfs-server
systemctl enable --now rpcbind

# Configure firewall
firewall-cmd --add-service=nfs --permanent
firewall-cmd --add-service=rpc-bind --permanent  
firewall-cmd --add-service=mountd --permanent
firewall-cmd --reload
```

### NFS Client Operations
```bash
# Install NFS client software
dnf install -y nfs-utils

# List available exports from server
showmount -e server.example.com
showmount -e 192.168.1.100

# Create mount point and mount manually
mkdir /mnt/nfs-data
mount -t nfs server.example.com:/nfs-share /mnt/nfs-data
mount -t nfs -o nfsvers=4.2 server:/nfs-share /mnt/nfs-data

# Test NFS mount
df -h /mnt/nfs-data
ls -la /mnt/nfs-data
echo "test file" > /mnt/nfs-data/testfile

# Unmount NFS share
umount /mnt/nfs-data
```

### Persistent NFS Mounting via fstab
```bash
# Add entry to /etc/fstab for persistent mounting
echo "server.example.com:/nfs-share /mnt/nfs-data nfs defaults,_netdev 0 0" >> /etc/fstab

# Common NFS mount options:
# _netdev              - wait for network before mounting
# rw/ro               - read-write/read-only
# hard/soft           - retry behavior on server failure
# intr                - allow interruption of NFS calls
# rsize/wsize         - read/write buffer sizes
# timeo=n             - timeout value in deciseconds
# retrans=n           - number of retries

# Test fstab entry
umount /mnt/nfs-data
mount -a                      # Mount all fstab entries
mount /mnt/nfs-data          # Mount specific entry
```

### AutoFS Configuration
```bash
# Install AutoFS
dnf install -y autofs

# Configure master map (/etc/auto.master)
# Format: mount-point map-file [options]
echo "/mnt/auto /etc/auto.nfs --timeout=60" >> /etc/auto.master

# For direct maps (specific mount points)
echo "/- /etc/auto.direct" >> /etc/auto.master

# Create indirect map file (/etc/auto.nfs)
# Format: key [options] location
echo "shared -rw server.example.com:/nfs-share" > /etc/auto.nfs
echo "data -ro,intr server.example.com:/data" >> /etc/auto.nfs

# Create direct map file (/etc/auto.direct) 
# Format: mount-point [options] location
echo "/mnt/direct-share -rw server.example.com:/nfs-share" > /etc/auto.direct

# Start and enable AutoFS service
systemctl enable --now autofs

# Verify AutoFS operation
systemctl status autofs
ls /mnt/auto                  # Triggers automount for indirect maps
cd /mnt/auto/shared          # Access triggers mount
mount | grep autofs          # Show active automounts
```

### AutoFS Wildcards for User Home Directories
```bash
# Wildcard mapping in indirect map
# * matches subdirectory name, & substitutes server/path
echo "* -rw server.example.com:/home/&" > /etc/auto.home

# Master map entry for home directories
echo "/home /etc/auto.home" >> /etc/auto.master

# This automatically mounts server.example.com:/home/username 
# when user accesses /home/username
```

### Common NFS and AutoFS Tasks
```bash
# Set up NFS client with AutoFS indirect map
showmount -e nfs-server              # List available shares
mkdir -p /mnt/auto                   # Create mount point
echo "/mnt/auto /etc/auto.nfs" >> /etc/auto.master
echo "share1 -rw nfs-server:/export/share1" > /etc/auto.nfs
systemctl enable --now autofs
ls /mnt/auto/share1                  # Triggers mount

# Set up AutoFS direct map
echo "/- /etc/auto.direct" >> /etc/auto.master  
echo "/shared-data -rw nfs-server:/data" > /etc/auto.direct
systemctl reload autofs
ls /shared-data                      # Triggers mount

# Monitor AutoFS activity
tail -f /var/log/messages | grep automount
systemctl status autofs
mount | grep autofs
```

### Troubleshooting NFS and AutoFS
```bash
# NFS server troubleshooting
exportfs -v                          # Show active exports
rpcinfo -p                          # Show RPC services
systemctl status nfs-server rpcbind
showmount -e localhost               # Test local exports
firewall-cmd --list-services         # Verify firewall rules

# NFS client troubleshooting  
showmount -e server                  # Test server connectivity
rpcinfo -p server                   # Check server RPC services
mount -v -t nfs server:/share /mnt   # Verbose mount
ping server                         # Basic connectivity
telnet server 2049                  # Test NFS port

# AutoFS troubleshooting
systemctl status autofs             # Check service status
automount -f -v                     # Run in foreground with verbose
tail -f /var/log/messages           # Watch AutoFS log messages
ls -la /etc/auto.*                  # Verify map file permissions
mount | grep autofs                 # Show active automounts

# Restart AutoFS after configuration changes
systemctl reload autofs             # Reload maps without restart
systemctl restart autofs            # Full restart if needed
```

### Common Pitfalls
- **WRONG**: Forgetting `_netdev` in fstab → **RIGHT**: Always use `_netdev` for network filesystems
- **WRONG**: Using AutoFS and fstab together → **RIGHT**: Choose either AutoFS or fstab, not both
- **WRONG**: Not starting rpcbind service → **RIGHT**: Ensure rpcbind runs before nfs-server
- **WRONG**: Incorrect firewall rules → **RIGHT**: Allow nfs, rpc-bind, and mountd services
- **WRONG**: Forgetting to export after editing /etc/exports → **RIGHT**: Run `exportfs -ra` after changes
- **WRONG**: AutoFS maps with wrong permissions → **RIGHT**: Ensure map files are readable by autofs

---

## Container Management (Podman)

### Key Terms & Acronyms
- **podman** - Pod Manager (daemonless container engine)
- **container** - Isolated application instance
- **image** - Read-only container template
- **registry** - Container image repository
- **Containerfile** - Build instructions (aka Dockerfile)
- **OCI** - Open Container Initiative
- **runtime** - Container execution environment
- **rootless** - Containers without root privileges
- **namespace** - Linux isolation mechanism
- **cgroup** - Control group (resource limits)
- **layer** - Image filesystem layer
- **tag** - Image version identifier
- **buildah** - Container image builder
- **skopeo** - Container image inspector

### Key File Paths
```bash
~/.config/systemd/user/       # User systemd service files
/etc/systemd/system/          # System-wide container services
~/.config/containers/         # User container configuration
/etc/containers/              # System container configuration
```

### Essential Commands
```bash
# Container lifecycle
podman pull registry.redhat.io/ubi8/ubi:latest  # Pull image
podman run -d --name webserver -p 8080:80 httpd # Run detached with port mapping
podman ps                             # List running containers
podman ps -a                          # List all containers
podman logs webserver                 # View container logs
podman logs -f webserver              # Follow logs

# Container management
podman stop webserver                 # Stop container
podman start webserver                # Start container
podman restart webserver              # Restart container
podman exec -it webserver /bin/bash   # Execute command in container
podman rm webserver                   # Remove container
podman rmi httpd                      # Remove image

# Volume and data management
podman run -d --name db -v /host/data:/container/data postgres
podman run -d --name web -v webdata:/var/www/html httpd

# Image management
podman images                         # List local images
podman search httpd                   # Search for images
podman inspect httpd                  # Inspect image details

# Building images from Containerfile
podman build -t myimage:latest .      # Build image from current directory
podman build -t myimage:v1.0 /path/to/containerfile/  # Build from specific directory
podman build -f CustomContainerfile -t myimage .      # Use custom filename
```

### Containerfile Instructions

| Instruction | Description |
|-------------|-------------|
| `FROM` | Identifies the base container image to use |
| `RUN` | Executes specified commands during build |
| `CMD` | Runs a command when container starts (default command) |
| `COPY` | Copies files from host to container |
| `ADD` | Similar to COPY but can handle URLs and archives |
| `ENV` | Defines environment variables for build and runtime |
| `EXPOSE` | Documents which ports the container will listen on |
| `USER` | Defines a non-root user to run commands as |
| `WORKDIR` | Sets the working directory (created if doesn't exist) |
| `VOLUME` | Creates a mount point for external volumes |
| `LABEL` | Adds metadata to the image |
| `ENTRYPOINT` | Configures the main command (cannot be overridden) |

### Sample Containerfile
```dockerfile
# Example Containerfile for web server
FROM registry.redhat.io/ubi8/ubi:latest
RUN dnf install -y httpd
COPY index.html /var/www/html/
EXPOSE 80
USER apache
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
```

### Systemd Integration
```bash
# Rootless containers (as regular user)
loginctl enable-linger username       # Enable user services
podman generate systemd --new --files --name webserver
mkdir -p ~/.config/systemd/user
mv container-webserver.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable container-webserver.service
systemctl --user start container-webserver.service

# System-wide containers (as root)
sudo podman generate systemd --new --files --name webserver
sudo cp container-webserver.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable container-webserver.service
sudo systemctl start container-webserver.service
```

### Common Tasks
```bash
# Deploy containerized web server with persistent service
podman pull httpd
podman run -d --name mywebserver -p 8080:80 httpd
podman generate systemd --new --files --name mywebserver
sudo cp container-mywebserver.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now container-mywebserver.service
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload
curl http://localhost:8080            # Test

# Deploy with persistent storage
podman run -d --name webapp -p 8080:80 -v /opt/webapp:/usr/local/apache2/htdocs httpd

# Build custom image from Containerfile
mkdir /tmp/myapp
cd /tmp/myapp
# Create Containerfile (see sample above)
echo "<h1>My Custom App</h1>" > index.html
podman build -t myapp:v1.0 .
podman run -d --name customapp -p 8080:80 myapp:v1.0
```

### Troubleshooting
```bash
# Container issues
podman ps -a                          # Check container status
podman logs container_name            # Check container logs
podman inspect container_name         # Check container configuration
ss -tuln | grep :8080                # Check port binding
systemctl --user status container-name.service  # Check systemd service
```

### Common Pitfalls
- **WRONG**: Forgetting `loginctl enable-linger` for user services → **RIGHT**: Enable lingering for persistent user services
- **WRONG**: Not opening firewall ports → **RIGHT**: Always configure firewall for exposed ports
- **WRONG**: Using wrong systemd directory → **RIGHT**: Use `~/.config/systemd/user/` for user services

---

## Scheduled Tasks & Automation

### Key Terms & Acronyms
- **cron** - Time-based job scheduler
- **crontab** - Cron table (user's scheduled jobs)
- **crond** - Cron daemon
- **anacron** - Cron for systems not always on
- **systemd timers** - Modern alternative to cron
- **at** - One-time scheduled task
- **batch** - Queue jobs when system load permits
- **systemd.timer** - Timer unit file
- **systemd.service** - Service unit file
- **OnCalendar** - Timer schedule specification
- **Persistent** - Timer survives system shutdown

### Key File Paths
```bash
/etc/crontab                  # System-wide cron table
/etc/cron.d/                  # System cron job directory
/etc/cron.daily/              # Daily cron jobs
/etc/cron.weekly/             # Weekly cron jobs  
/etc/cron.monthly/            # Monthly cron jobs
/etc/cron.hourly/             # Hourly cron jobs
/var/spool/cron/              # User crontabs
/etc/cron.allow               # Users allowed to use cron
/etc/cron.deny                # Users denied cron access
/etc/at.allow                 # Users allowed to use at
/etc/at.deny                  # Users denied at access
/var/spool/at/                # At job queue
/etc/anacrontab               # Anacron configuration
```

### Essential Commands
```bash
# Crontab management
crontab -e                            # Edit user's crontab
crontab -l                            # List user's crontab
crontab -r                            # Remove user's crontab
crontab -l -u username                # List another user's crontab (root only)
crontab -e -u username                # Edit another user's crontab (root only)

# At command (one-time scheduling)
at 15:30                              # Schedule job for 3:30 PM today
at 15:30 tomorrow                     # Schedule for tomorrow
at 15:30 12/25/2023                   # Specific date
at now + 5 minutes                    # Relative time
atq                                   # List pending at jobs
atrm job_number                       # Remove at job
at -f script.sh now + 1 hour          # Run script file

# Batch command (load-dependent scheduling)
batch                                 # Schedule when load average < 1.5
batch -f script.sh                    # Schedule script file

# Systemd timers
systemctl list-timers                 # List active timers
systemctl list-timers --all           # List all timers
systemctl status timer_name           # Timer status
systemctl enable --now timer_name     # Enable and start timer
systemctl disable timer_name          # Disable timer
```

### Cron Syntax
```bash
# Crontab format: minute hour day month weekday command
# * * * * * command
# ┬ ┬ ┬ ┬ ┬
# │ │ │ │ │
# │ │ │ │ └── Weekday (0-7, 0=Sunday)
# │ │ │ └──── Month (1-12)
# │ │ └────── Day (1-31)
# │ └──────── Hour (0-23)
# └────────── Minute (0-59)

# Special values:
# *           Any value
# ,           List separator (1,3,5)
# -           Range (1-5)
# /           Step values (*/5 = every 5)

# Examples:
0 2 * * *           # Daily at 2:00 AM
30 14 * * 1-5       # Weekdays at 2:30 PM
0 */4 * * *         # Every 4 hours
15 3 1 * *          # First day of month at 3:15 AM
0 6 * * 0           # Sundays at 6:00 AM
*/10 * * * *        # Every 10 minutes

# Special keywords (system cron only):
@reboot             # At startup
@yearly or @annually # Once a year (0 0 1 1 *)
@monthly            # Once a month (0 0 1 * *)
@weekly             # Once a week (0 0 * * 0)
@daily or @midnight # Once a day (0 0 * * *)
@hourly             # Once an hour (0 * * * *)
```

### Systemd Timers
```bash
# Create timer unit file (/etc/systemd/system/backup.timer)
[Unit]
Description=Daily backup timer
Requires=backup.service

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target

# Create corresponding service file (/etc/systemd/system/backup.service)
[Unit]
Description=Daily backup service
Wants=backup.timer

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh

[Install]
WantedBy=multi-user.target

# OnCalendar examples:
OnCalendar=*-*-* 02:00:00      # Daily at 2:00 AM
OnCalendar=Mon *-*-* 09:00:00  # Mondays at 9:00 AM
OnCalendar=*-*-01 00:00:00     # First of month at midnight
OnCalendar=*-01,07 00:00:00    # January and July 1st
OnCalendar=hourly              # Every hour
OnCalendar=*:0/15              # Every 15 minutes
```

### Common Tasks
```bash
# Daily log rotation at 3:00 AM
echo "0 3 * * * /usr/sbin/logrotate /etc/logrotate.conf" | crontab -

# Weekly system update on Sundays at 2:00 AM
echo "0 2 * * 0 /usr/bin/dnf update -y" > /etc/cron.d/system-update

# Backup script every 6 hours
echo "0 */6 * * * /home/user/backup.sh" | crontab -

# Send system report monthly
echo "0 9 1 * * /usr/local/bin/system-report.sh | mail admin@example.com" >> /etc/crontab

# One-time maintenance in 2 hours
echo "/usr/local/bin/maintenance.sh" | at now + 2 hours

# Create systemd timer for daily backup
cat > /etc/systemd/system/daily-backup.timer << 'EOF'
[Unit]
Description=Daily backup timer

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat > /etc/systemd/system/daily-backup.service << 'EOF'  
[Unit]
Description=Daily backup service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
User=backup
EOF

systemctl enable --now daily-backup.timer
```

### Environment and Output Handling
```bash
# Cron environment variables (in crontab)
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=admin@example.com

# Redirect output
0 2 * * * /script.sh > /var/log/script.log 2>&1    # Log output
0 2 * * * /script.sh >/dev/null 2>&1               # Suppress output
0 2 * * * /script.sh 2>&1 | logger -t "script"    # Send to syslog

# Environment in scripts
#!/bin/bash
# Set PATH and other variables explicitly in scripts
export PATH=/usr/local/bin:/usr/bin:/bin
cd /home/user
./script.sh
```

### Access Control
```bash
# Allow specific users to use cron
echo "alice" >> /etc/cron.allow
echo "bob" >> /etc/cron.allow

# Deny specific users (if no cron.allow exists)
echo "baduser" >> /etc/cron.deny

# At command access control
echo "alice" >> /etc/at.allow
echo "bob" >> /etc/at.allow
```

### Troubleshooting
```bash
# Check cron service status
systemctl status crond
journalctl -u crond                   # Cron daemon logs

# Verify cron jobs are running
grep CRON /var/log/cron              # Cron execution logs (if rsyslog configured)
journalctl -u crond --since "1 hour ago"

# Check at jobs
atq                                   # List pending jobs
ls -la /var/spool/at/                # At job files
systemctl status atd                 # At daemon status

# Timer troubleshooting
systemctl list-timers --failed       # Failed timers
systemctl status timer_name          # Specific timer status
journalctl -u timer_name             # Timer logs

# Common issues
# 1. Script not executable
chmod +x /path/to/script.sh

# 2. Wrong PATH in cron environment
# Add full paths or set PATH in crontab

# 3. Missing MAILTO causes local mail accumulation
# Set MAILTO="" to suppress or configure proper email

# 4. Scripts expecting interactive shell
# Use absolute paths and set environment variables
```

### Monitoring Scheduled Tasks
```bash
# List all active cron jobs
for user in $(cut -f1 -d: /etc/passwd); do
    echo "User: $user"
    crontab -l -u $user 2>/dev/null
done

# Monitor cron execution
tail -f /var/log/cron                 # If rsyslog configured for cron
journalctl -u crond -f               # Follow cron daemon logs

# Check systemd timer last run
systemctl list-timers                # Shows next run and last run times
systemctl status timer_name          # Detailed timer status
```

### Common Pitfalls
- **WRONG**: Using relative paths in cron jobs → **RIGHT**: Use absolute paths always
- **WRONG**: Not setting proper environment → **RIGHT**: Set PATH and other variables in crontab
- **WRONG**: Forgetting output redirection → **RIGHT**: Redirect stdout/stderr appropriately
- **WRONG**: Not making scripts executable → **RIGHT**: Use `chmod +x` on script files
- **WRONG**: Using interactive commands → **RIGHT**: Use non-interactive flags and options

---

## Emergency Recovery Procedures

### Key Terms & Acronyms
- **rd.break** - Kernel parameter for root password reset
- **rescue** - Systemd target for system recovery
- **emergency** - Minimal systemd target
- **chroot** - Change root directory
- **autorelabel** - Force SELinux relabeling
- **single** - Single user mode (legacy)
- **fsck** - File system check
- **grubby** - GRUB configuration tool

### Boot Issues and Recovery
```bash
# GRUB rescue (password reset)
# At GRUB menu: e -> linux line -> add rd.break
# mount -o remount,rw /sysroot
# chroot /sysroot
# passwd root
# touch /.autorelabel  # If SELinux enabled
# exit; exit

# Systemd rescue mode
# At GRUB: add systemd.unit=rescue.target

# Emergency mode (minimal system)
# At GRUB: add systemd.unit=emergency.target

# Boot with SELinux disabled
# At GRUB: add selinux=0
```

### Critical File Recovery
```bash
# Corrupted fstab
# Boot to rescue mode
# mount -o remount,rw /
# cp /etc/fstab.backup /etc/fstab  # If backup exists
# Or manually fix entries

# Corrupted sudoers
# Boot to rescue mode as root
# visudo  # Fix syntax
# Or: pkexec visudo  # If available
```

---

## SSH & Remote Access

### Key Terms & Acronyms
- **SSH** - Secure Shell (encrypted remote access protocol)
- **sshd** - SSH daemon (server process)
- **RSA** - Rivest-Shamir-Adleman (key algorithm)
- **DSA** - Digital Signature Algorithm (legacy key type)
- **ECDSA** - Elliptic Curve Digital Signature Algorithm
- **Ed25519** - Modern elliptic curve signature scheme
- **public key** - Cryptographic key for encryption/verification
- **private key** - Secret key for decryption/signing
- **known_hosts** - File storing server public keys
- **authorized_keys** - File storing allowed client public keys
- **port forwarding** - Tunnel network connections through SSH
- **X11 forwarding** - Remote GUI application display

### Key File Paths
```bash
/etc/ssh/sshd_config          # SSH daemon configuration
/etc/ssh/ssh_config           # System-wide client configuration
~/.ssh/config                 # User SSH client configuration  
~/.ssh/authorized_keys        # Allowed public keys for this user
~/.ssh/known_hosts            # Verified server public keys
~/.ssh/id_rsa                 # User's private key (RSA)
~/.ssh/id_rsa.pub             # User's public key (RSA)
~/.ssh/id_ed25519             # User's private key (Ed25519)
~/.ssh/id_ed25519.pub         # User's public key (Ed25519)
/var/log/secure               # SSH authentication logs
```

### Essential Commands
```bash
# SSH connection basics
ssh user@hostname                     # Connect to remote host
ssh -p 2222 user@hostname            # Connect to custom port
ssh -l username hostname              # Alternative user specification
ssh user@hostname command             # Execute single command
ssh -t user@hostname 'sudo command'   # Force pseudo-terminal allocation

# Key generation
ssh-keygen -t rsa -b 4096             # Generate RSA 4096-bit key
ssh-keygen -t ed25519                 # Generate Ed25519 key (recommended)
ssh-keygen -t rsa -b 4096 -C "comment" -f ~/.ssh/custom_key  # Custom key
ssh-keygen -y -f ~/.ssh/id_rsa        # Display public key from private key
ssh-keygen -l -f ~/.ssh/id_rsa.pub    # Show key fingerprint

# Key distribution
ssh-copy-id user@hostname             # Copy public key to remote host
ssh-copy-id -i ~/.ssh/custom_key.pub user@hostname  # Copy specific key
scp ~/.ssh/id_rsa.pub user@hostname:~/.ssh/authorized_keys  # Manual copy

# File transfer
scp file.txt user@hostname:/path/     # Copy file to remote host
scp user@hostname:/path/file.txt .    # Copy file from remote host
scp -r directory user@hostname:/path  # Copy directory recursively
scp -P 2222 file.txt user@hostname:/path  # Custom port

# Advanced SSH features
ssh -L 8080:localhost:80 user@hostname     # Local port forwarding
ssh -R 8080:localhost:80 user@hostname     # Remote port forwarding
ssh -D 1080 user@hostname                  # SOCKS proxy
ssh -X user@hostname                       # X11 forwarding (GUI apps)
ssh -N -f -L 8080:localhost:80 user@hostname  # Background tunnel
```

### SSH Configuration
```bash
# Server configuration (/etc/ssh/sshd_config)
Port 22                          # Default SSH port
PermitRootLogin no               # Disable root login
PasswordAuthentication no        # Disable password auth (keys only)  
PubkeyAuthentication yes         # Enable public key auth
AuthorizedKeysFile .ssh/authorized_keys  # Location of authorized keys
MaxAuthTries 3                   # Maximum authentication attempts
ClientAliveInterval 300          # Keep connection alive (seconds)
ClientAliveCountMax 2            # Maximum client alive messages
AllowUsers alice bob             # Restrict users
DenyUsers baduser                # Deny specific users
AllowGroups sshusers             # Allow specific groups

# After editing sshd_config:
sshd -t                         # Test configuration syntax
systemctl reload sshd          # Apply changes

# Client configuration (~/.ssh/config)
Host webserver
    HostName 192.168.1.100
    User admin
    Port 2222
    IdentityFile ~/.ssh/webserver_key
    
Host *.example.com
    User myusername
    IdentityFile ~/.ssh/company_key
    
Host bastion
    HostName bastion.example.com
    User admin
    ProxyJump jumphost.example.com
```

### Key-Based Authentication Setup
```bash
# Complete key-based authentication setup
# 1. Generate key pair on client
ssh-keygen -t ed25519 -C "user@client"

# 2. Copy public key to server (method 1 - preferred)
ssh-copy-id user@server

# 3. Or manually copy public key (method 2)
cat ~/.ssh/id_ed25519.pub | ssh user@server "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# 4. Set proper permissions on server
ssh user@server "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"

# 5. Test key-based login
ssh user@server

# 6. Disable password authentication (optional)
# Edit /etc/ssh/sshd_config: PasswordAuthentication no
sudo systemctl reload sshd
```

### SSH Security Hardening
```bash
# Change default port
sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config

# Disable root login
sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Disable password authentication (use keys only)
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Enable fail2ban for SSH protection
dnf install -y fail2ban
systemctl enable --now fail2ban
# Configure in /etc/fail2ban/jail.local

# Configure firewall
firewall-cmd --remove-service=ssh --permanent    # Remove default SSH
firewall-cmd --add-port=2222/tcp --permanent     # Add custom port
firewall-cmd --reload

# Apply SSH configuration
sshd -t && systemctl reload sshd
```

### Common Tasks
```bash
# Set up passwordless SSH between servers
ssh-keygen -t ed25519 -N "" -f ~/.ssh/server_key
ssh-copy-id -i ~/.ssh/server_key.pub user@target-server
ssh -i ~/.ssh/server_key user@target-server

# Create SSH tunnel for database access
ssh -N -f -L 5432:localhost:5432 user@database-server
# Now connect to localhost:5432 to reach remote database

# Execute commands on multiple servers
for host in server1 server2 server3; do
    ssh user@$host "uptime"
done

# Copy files between remote servers (via local machine)
scp user@server1:/path/file.txt user@server2:/path/

# Monitor SSH connections
ss -tuln | grep :22              # Check SSH listening
last | grep ssh                  # Recent SSH logins
journalctl -u sshd -f           # Follow SSH logs in real-time
```

### Troubleshooting SSH
```bash
# Connection troubleshooting
ssh -v user@hostname             # Verbose output (debug)
ssh -vv user@hostname            # More verbose
ssh -vvv user@hostname           # Maximum verbosity

# Test SSH configuration
sshd -t                         # Test sshd config syntax
sshd -T                         # Dump effective configuration

# Check SSH service status
systemctl status sshd           # Service status
journalctl -u sshd --no-pager   # SSH daemon logs
grep "ssh" /var/log/secure      # SSH authentication attempts

# Key problems
ssh-keygen -R hostname          # Remove host from known_hosts
chmod 600 ~/.ssh/id_rsa         # Fix private key permissions
chmod 644 ~/.ssh/id_rsa.pub     # Fix public key permissions
chmod 700 ~/.ssh               # Fix .ssh directory permissions
chmod 600 ~/.ssh/authorized_keys # Fix authorized_keys permissions

# Connection issues
telnet hostname 22              # Test basic connectivity
nmap -p 22 hostname             # Check if port is open
firewall-cmd --list-all         # Check firewall rules
semanage port -l | grep ssh     # Check SELinux port contexts
```

### SSH Agent and Key Management
```bash
# Start SSH agent
eval $(ssh-agent)               # Start agent and set environment
ssh-agent bash                  # Start new shell with agent

# Add keys to agent
ssh-add ~/.ssh/id_rsa          # Add specific key
ssh-add                        # Add default keys
ssh-add -l                     # List loaded keys
ssh-add -D                     # Remove all keys from agent

# Key forwarding
ssh -A user@hostname           # Enable agent forwarding
# Add to ~/.ssh/config:
# ForwardAgent yes

# Multiple key management
ssh-add ~/.ssh/personal_key
ssh-add ~/.ssh/work_key
ssh -i ~/.ssh/specific_key user@hostname  # Use specific key
```

### Common Pitfalls
- **WRONG**: Using weak RSA 1024-bit keys → **RIGHT**: Use RSA 4096-bit or Ed25519 keys
- **WRONG**: Leaving default SSH port 22 → **RIGHT**: Change to non-standard port for security
- **WRONG**: Wrong file permissions on SSH keys → **RIGHT**: Use 600 for private keys, 644 for public keys
- **WRONG**: Not testing SSH config before applying → **RIGHT**: Always use `sshd -t` to test configuration
- **WRONG**: Disabling password auth without testing key auth → **RIGHT**: Test key authentication before disabling passwords

---

## Shell Environment & Scripting Basics

### Key Terms & Acronyms
- **bash** - Bourne Again Shell (default RHEL shell)
- **env** - Environment (shell variables and settings)
- **PATH** - Executable search path
- **PS1** - Primary prompt string
- **stdin** - Standard input (file descriptor 0)
- **stdout** - Standard output (file descriptor 1)
- **stderr** - Standard error (file descriptor 2)
- **shebang** - #! interpreter directive
- **exit status** - Return code of command (0=success)
- **alias** - Command shortcut
- **function** - Shell function definition
- **source/dot** - Execute script in current shell

### Key File Paths
```bash
/etc/profile                  # System-wide shell initialization
/etc/profile.d/              # System-wide shell scripts
/etc/bashrc                  # System-wide bash configuration
~/.bash_profile              # User bash login script
~/.bashrc                    # User bash non-login script
~/.bash_logout               # User logout script
~/.bash_history              # Command history file
/etc/environment             # System environment variables
```

### Essential Commands
```bash
# Environment variables
export VAR=value                      # Set and export variable
env                                   # Show all environment variables
printenv VAR                          # Show specific variable
unset VAR                            # Remove variable
echo $VAR                            # Display variable value
env VAR=value command                # Set variable for single command

# Command history
history                              # Show command history
history -c                           # Clear history
!!                                   # Repeat last command
!n                                   # Repeat command number n
!string                              # Repeat last command starting with string
^old^new                             # Replace and re-run last command

# Aliases and functions
alias ll='ls -la'                    # Create alias
alias                                # List all aliases
unalias ll                           # Remove alias
function myfunc() { echo $1; }       # Define function
type command                         # Show command type (alias/function/builtin)
which command                        # Show executable location

# Process substitution and pipes
command1 | command2                  # Pipe output to input
command > file                       # Redirect stdout to file
command >> file                      # Append stdout to file
command 2> file                      # Redirect stderr to file
command &> file                      # Redirect both stdout and stderr
command < file                       # Use file as stdin
command1 && command2                 # Run command2 if command1 succeeds
command1 || command2                 # Run command2 if command1 fails
command1; command2                   # Run commands sequentially
```

### Basic Scripting Constructs
```bash
#!/bin/bash
# Shebang - interpreter specification

# Variables (no spaces around =)
name="John"
count=10
readonly PI=3.14159                  # Read-only variable

# Command substitution
current_date=$(date)                 # Modern syntax
current_date=`date`                  # Legacy syntax (avoid)

# Conditional statements
if [ condition ]; then
    commands
elif [ condition ]; then
    commands
else
    commands
fi

# Test conditions
[ -f file ]                         # File exists and is regular file
[ -d directory ]                    # Directory exists
[ -r file ]                         # File is readable
[ -w file ]                         # File is writable
[ -x file ]                         # File is executable
[ -z string ]                       # String is empty
[ -n string ]                       # String is not empty
[ string1 = string2 ]               # Strings are equal
[ $num1 -eq $num2 ]                # Numbers are equal
[ $num1 -gt $num2 ]                # num1 greater than num2

# Loops
for file in *.txt; do
    echo "Processing $file"
done

for i in {1..10}; do
    echo "Number: $i"
done

while [ condition ]; do
    commands
done

# Case statement
case $variable in
    pattern1)
        commands;;
    pattern2)
        commands;;
    *)
        default commands;;
esac
```

### Common Scripting Patterns
```bash
# Check if script has arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 <argument>"
    exit 1
fi

# Process script arguments
while [ $# -gt 0 ]; do
    case $1 in
        -h|--help)
            echo "Help message"
            exit 0;;
        -v|--verbose)
            verbose=true;;
        *)
            echo "Unknown option: $1"
            exit 1;;
    esac
    shift
done

# Function with return value
calculate_sum() {
    local num1=$1
    local num2=$2
    echo $((num1 + num2))
}
result=$(calculate_sum 5 3)

# Error handling
command || {
    echo "Command failed" >&2
    exit 1
}

# Log function
log() {
    echo "$(date): $*" >> /var/log/script.log
}
```

### Environment Configuration
```bash
# System-wide environment (/etc/profile)
export PATH="/usr/local/bin:$PATH"
export EDITOR=vim
export HISTSIZE=1000

# User environment (~/.bashrc)
# Add to end of file:
export PATH="$HOME/bin:$PATH"
alias ll='ls -la'
alias grep='grep --color=auto'

# Load custom configurations
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Custom prompt
export PS1='\u@\h:\w\$ '            # user@host:directory$
export PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '  # Colored

# Apply changes
source ~/.bashrc                     # Reload configuration
```

### Common Tasks
```bash
# Create a backup script
#!/bin/bash
BACKUP_DIR="/backup"
SOURCE_DIR="/home/user"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" "$SOURCE_DIR"
echo "Backup completed: backup_$TIMESTAMP.tar.gz"

# System monitoring script
#!/bin/bash
echo "=== System Status ==="
echo "Date: $(date)"
echo "Uptime: $(uptime)"
echo "Disk Usage:"
df -h
echo "Memory Usage:"
free -h
echo "Load Average:"
cat /proc/loadavg

# User management script
#!/bin/bash
create_user() {
    local username=$1
    if id "$username" &>/dev/null; then
        echo "User $username already exists"
        return 1
    fi
    useradd -m "$username"
    echo "User $username created"
}

# Process multiple users
for user in alice bob charlie; do
    create_user "$user"
done
```

### Advanced Shell Features
```bash
# Parameter expansion
${var}                              # Variable value
${var:-default}                     # Use default if var is empty
${var:=default}                     # Set var to default if empty
${#var}                            # Length of variable
${var%pattern}                     # Remove shortest match from end
${var%%pattern}                    # Remove longest match from end
${var#pattern}                     # Remove shortest match from beginning
${var##pattern}                    # Remove longest match from beginning

# Arrays (basic)
arr=("item1" "item2" "item3")
echo ${arr[0]}                     # First element
echo ${arr[@]}                     # All elements
echo ${#arr[@]}                    # Array length

# Here documents
cat << 'EOF' > config.txt
Setting1=value1
Setting2=value2
EOF

# Job control
command &                          # Run in background
jobs                               # List background jobs
fg %1                             # Bring job 1 to foreground
bg %1                             # Send job 1 to background
nohup command &                   # Run command immune to hangups
```

### Debugging and Troubleshooting
```bash
# Script debugging
bash -x script.sh                 # Execute with debug output
bash -n script.sh                 # Check syntax without execution
set -x                            # Enable debug mode in script
set +x                            # Disable debug mode

# Error handling
set -e                            # Exit on any error
set -u                            # Exit on undefined variable
set -o pipefail                   # Exit on pipeline failure

# Debug information in script
echo "Debug: Variable value is $var" >&2
printf "Debug: Processing file %s\n" "$filename" >&2

# Validate script arguments
if [ ! -f "$1" ]; then
    echo "Error: File $1 does not exist" >&2
    exit 1
fi
```

### Common Pitfalls
- **WRONG**: `VAR = value` → **RIGHT**: `VAR=value` (no spaces around =)
- **WRONG**: Not quoting variables → **RIGHT**: Use `"$var"` to prevent word splitting
- **WRONG**: Using `[ $var = value ]` with empty var → **RIGHT**: Use `[ "$var" = "value" ]`
- **WRONG**: Forgetting executable permissions → **RIGHT**: Use `chmod +x script.sh`
- **WRONG**: Not handling script arguments → **RIGHT**: Check `$#` and validate `$1`, `$2`, etc.

---

## Quick Verification Commands

```bash
# System overview
lsblk && df -h                        # Storage status
systemctl --failed && getenforce     # Services and SELinux
firewall-cmd --list-all               # Firewall rules
ss -tuln | grep LISTEN               # Listening services
mount | grep -v tmpfs                 # Active mounts

# Service verification
systemctl is-active httpd && systemctl is-enabled httpd
ping -c 1 8.8.8.8 && echo "Network OK"
ausearch -m AVC -ts recent | wc -l    # Count SELinux denials
```

---

## Last-Minute Exam Reminders

### Must-Verify Checklist
- [ ] Services enabled AND started: `systemctl is-enabled service && systemctl is-active service`
- [ ] Firewall rules applied: `firewall-cmd --list-all`
- [ ] SELinux not blocking: `ausearch -m AVC -ts recent`
- [ ] Mounts persistent: Check `/etc/fstab` and `mount -a`
- [ ] Users can login: Test with `su - username`
- [ ] Network connectivity: `ping 8.8.8.8`

### Emergency Commands
```bash
# If something breaks during exam:
systemctl status service_name        # Check service status
journalctl -u service_name --no-pager # Check logs
getenforce && ausearch -m AVC -ts recent  # SELinux issues
firewall-cmd --list-all             # Firewall blocking?
lsof -i :port                       # What's using the port?
ss -tuln | grep :port               # Is service listening?
```

### Final Strategy
**Accuracy over speed. Verify everything. Use man pages when uncertain.**

Time allocation: 40% basic tasks (users, basic services), 40% intermediate (storage, network), 20% advanced (containers, troubleshooting).