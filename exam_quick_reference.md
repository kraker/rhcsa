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
# Check for denials
ausearch -m AVC -ts recent            # Recent AVC denials
ausearch -m AVC -ts today             # Today's denials
sealert -a /var/log/audit/audit.log   # Analyze denials
sealert -l UUID                       # Detailed denial analysis

# Generate and install policies
audit2allow -a                        # Generate policy from all denials
audit2allow -a -M mypolicy            # Generate policy module
semodule -i mypolicy.pp               # Install policy module
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