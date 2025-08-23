# 01 - System Installation & Initial Configuration

**Navigation**: [← Exam Overview](00_exam_overview.md) | [Index](index.md) | [Next → File Management](02_file_management.md)

---

## 1. Executive Summary

**Topic Scope**: RHEL 9 installation process, initial system configuration, and post-installation setup

**RHCSA Relevance**: Foundation knowledge - while not directly tested, understanding installation helps with system administration tasks

**Exam Weight**: Medium - Installation concepts appear in troubleshooting and system configuration scenarios

**Prerequisites**: Basic understanding of Linux concepts and virtualization

**Related Topics**: [Boot Process & GRUB](11_boot_grub.md), [Storage & LVM](07_storage_lvm.md), [Network Configuration](08_networking.md)

---

## 2. Conceptual Foundation

### Core Theory
RHEL installation involves deploying the Red Hat Enterprise Linux operating system using the **Anaconda** installer. The process includes:

- **System preparation**: Hardware verification and boot media creation
- **Installation configuration**: Language, storage, network, and user setup
- **Package selection**: Choosing software packages based on intended use
- **Post-installation**: Initial login and system verification

### Real-World Applications
- **Data center deployments**: Automated installation using Kickstart files
- **Development environments**: Virtual machine installations for testing
- **Production servers**: Careful configuration for specific workloads
- **Lab environments**: Practice installations for certification preparation

### Common Misconceptions
- **Installation = configuration**: Installation only provides the base system
- **Default settings are optimal**: Production systems require careful customization
- **GUI required**: RHEL can be fully managed from command line
- **Single partition layout**: Multiple partitions provide better organization and security

### Key Terminology
- **Anaconda**: The RHEL installer program
- **ISO image**: Bootable installation media file
- **Kickstart**: Automated installation configuration file
- **Base environment**: Predefined software package collections
- **Root filesystem**: Primary filesystem containing the operating system
- **Boot partition**: Separate partition containing boot loader and kernel files

---

## 3. Command Mastery

### Pre-Installation Commands
```bash
# Verify system requirements
lscpu                    # Check CPU information
free -h                  # Check memory availability
lsblk                    # List available storage devices
ip addr show             # Check network interfaces

# ISO verification (if needed)
sha256sum rhel-9.1-x86_64-dvd.iso
```

### Post-Installation Verification
```bash
# System information
hostnamectl              # Display system hostname and info
uname -a                 # Kernel and system information
cat /etc/os-release      # Operating system version details

# Storage verification
lsblk                    # List all block devices
df -h                    # Check filesystem usage
mount | column -t        # Display mounted filesystems

# Network verification
ip addr show             # Display IP configuration
ping -c 3 8.8.8.8       # Test network connectivity
```

### Initial System Configuration
```bash
# Set system hostname
hostnamectl set-hostname server1.example.com

# Configure timezone
timedatectl set-timezone America/New_York
timedatectl status

# Update system (post-installation)
dnf update -y

# Check enabled services
systemctl list-unit-files --type=service --state=enabled
```

---

## 4. Installation Workflows

### Standard Installation Procedure
1. **Boot from Installation Media**
   - Select "Install Red Hat Enterprise Linux 9.x"
   - Wait for Anaconda to load (may take several minutes)

2. **Language and Localization**
   - Select installation language
   - Configure keyboard layout
   - Set date and time/timezone

3. **Installation Source**
   - Verify installation media is detected
   - Configure additional repositories if needed

4. **Software Selection**
   ```
   Available Base Environments:
   ├── Server (recommended for RHCSA)
   ├── Minimal Install (command line only)
   ├── Workstation (desktop environment)
   ├── Custom Operating System (advanced users)
   └── Virtualization Host (for hypervisors)
   ```

5. **Storage Configuration**
   - **Automatic partitioning**: Simple, good for learning
   - **Custom partitioning**: More control, better for production

6. **Network Configuration**
   - Configure hostname
   - Set up network interfaces
   - Configure static IP if needed

7. **User Configuration**
   - Set root password (required)
   - Create regular user account (recommended)
   - Configure sudo access

8. **Begin Installation**
   - Review settings summary
   - Start installation process
   - Configure users while installation proceeds

### Recommended Partitioning Scheme
```bash
# For RHCSA practice (20GB disk):
/boot     1GB   (ext4)    # Boot files and kernels
/         18GB  (xfs)     # Root filesystem
swap      1GB   (swap)    # Virtual memory

# For production environments:
/boot     1GB   (ext4)    # Boot files
/         10GB  (xfs)     # Root filesystem  
/home     5GB   (xfs)     # User data
/var      3GB   (xfs)     # Variable data (logs, etc.)
swap      1GB   (swap)    # Virtual memory
```

### Base Environment Comparison
| Environment | Size | GUI | Services | Use Case |
|-------------|------|-----|----------|----------|
| **Server** | ~3GB | No | Standard server services | RHCSA practice, production servers |
| **Minimal** | ~1GB | No | Essential only | Containers, embedded systems |
| **Workstation** | ~5GB | Yes | Desktop services | Development, desktop use |

---

## 5. Configuration Deep Dive

### Anaconda Installation Configuration
During installation, Anaconda creates several key configuration files:

#### Network Configuration
```bash
# /etc/hostname
server1.example.com
```

#### User Configuration
```bash
# /etc/passwd (user entries created)
root:x:0:0:root:/root:/bin/bash
user1:x:1000:1000:User One:/home/user1:/bin/bash
```

#### Filesystem Configuration
```bash
# /etc/fstab (automatically generated)
/dev/mapper/rhel-root   /       xfs     defaults        0 0
UUID=abc123-def456      /boot   ext4    defaults        1 2
/dev/mapper/rhel-swap   swap    swap    defaults        0 0
```

### Post-Installation Configuration Files
#### System Information
```bash
# /etc/os-release
NAME="Red Hat Enterprise Linux"
VERSION="9.1 (Plow)"
ID="rhel"
VERSION_ID="9.1"
PLATFORM_ID="platform:el9"
```

#### Installed Package Information
```bash
# View installation log
cat /var/log/anaconda/anaconda.log

# List packages installed during installation
dnf history info 1
```

---

## 6. Hands-On Labs

### Lab 6.1: Basic RHEL Installation (Asghar Ghori Method)
**Objective**: Install RHEL 9 with standard configuration for RHCSA practice

**Prerequisites**:
- RHEL 9 ISO image
- Virtual machine with 20GB disk, 2GB RAM
- Network connectivity

**Steps**:
1. **Create Virtual Machine**
   ```bash
   # In VirtualBox/VMware:
   # - Name: rhel9-server1
   # - RAM: 2048MB
   # - Disk: 20GB dynamically allocated
   # - Network: NAT or Bridged
   ```

2. **Boot Installation Media**
   - Attach RHEL 9 ISO to VM
   - Boot from ISO
   - Select "Install Red Hat Enterprise Linux 9.x"

3. **Configure Installation**
   - Language: English (US)
   - Software Selection: Server
   - Installation Destination: Use entire disk, automatic partitioning

4. **Network Configuration**
   - Set hostname: `server1.example.com`
   - Configure network interface with DHCP or static IP

5. **User Configuration**
   - Root password: Set secure password
   - Create user: Regular user with sudo privileges

6. **Complete Installation**
   - Review summary and begin installation
   - Wait for completion (20-30 minutes)
   - Reboot system

**Verification**:
```bash
# After reboot, verify installation
hostnamectl                    # Check hostname
cat /etc/os-release           # Verify RHEL version
lsblk                         # Check disk partitioning
ip addr show                  # Verify network configuration
systemctl status              # Check system status
```

### Lab 6.2: Custom Partitioning Installation (Sander van Vugt Method)
**Objective**: Install RHEL 9 with custom partitioning scheme

**Steps**:
1. **Follow initial steps from Lab 6.1** through software selection

2. **Custom Storage Configuration**
   - Installation Destination → Custom → Done
   - Create new mount points:
     ```
     /boot    1GB    ext4
     /        10GB   xfs
     /home    5GB    xfs
     /var     3GB    xfs
     swap     1GB    swap
     ```

3. **Configure each partition**:
   ```bash
   # For each mount point:
   # - Click "+" to add mount point
   # - Specify mount point and size
   # - Select filesystem type
   # - Click "Add mount point"
   ```

4. **Complete installation** following remaining steps from Lab 6.1

**Verification**:
```bash
# Verify custom partitioning
lsblk                         # Check partition layout
df -h                         # Check filesystem usage
cat /etc/fstab               # Verify fstab entries
mount | grep "^/" | sort     # List mounted filesystems
```

### Lab 6.3: Post-Installation Configuration
**Objective**: Configure newly installed system for RHCSA practice

**Steps**:
1. **System Updates**
   ```bash
   # Register system (if using RHEL subscription)
   subscription-manager register --username your_username

   # Update all packages
   dnf update -y
   ```

2. **Additional Software Installation**
   ```bash
   # Install useful tools for RHCSA practice
   dnf groupinstall "Development Tools" -y
   dnf install vim wget curl man-pages -y
   ```

3. **Security Configuration**
   ```bash
   # Configure firewall
   firewall-cmd --state
   firewall-cmd --list-all
   
   # Enable SELinux (verify)
   getenforce
   ```

4. **User Environment**
   ```bash
   # Configure bash aliases for root
   echo 'alias ll="ls -la"' >> /root/.bashrc
   echo 'alias grep="grep --color=auto"' >> /root/.bashrc
   ```

**Verification**:
```bash
# Verify post-installation configuration
dnf list installed | wc -l   # Count installed packages
systemctl list-unit-files --state=enabled | wc -l  # Count enabled services
firewall-cmd --list-all       # Check firewall status
getenforce                    # Verify SELinux status
```

---

## 7. Troubleshooting Playbook

### Common Installation Issues

#### Issue 1: Installation Media Not Detected
**Symptoms**:
- Boot process hangs or shows errors
- "No installation source found" message

**Diagnosis**:
```bash
# Check ISO integrity before installation
sha256sum /path/to/rhel-9.x-x86_64-dvd.iso
# Compare with official checksum from Red Hat
```

**Resolution**:
- Re-download ISO image if corrupted
- Verify virtual machine CD/DVD settings
- Try different boot order in BIOS/UEFI

**Prevention**: Always verify ISO checksums before installation

#### Issue 2: Insufficient Disk Space
**Symptoms**:
- "Not enough space" error during partitioning
- Installation fails during package installation

**Diagnosis**:
```bash
# In installer, check available disk space
# Minimum requirements:
# - Server: 3GB
# - Workstation: 5GB
# - Recommended: 20GB+ for practice
```

**Resolution**:
- Increase virtual machine disk size
- Choose Minimal Install if space limited
- Use custom partitioning to optimize space usage

#### Issue 3: Network Configuration Problems
**Symptoms**:
- Cannot set hostname
- Network interface not detected
- No network connectivity post-installation

**Diagnosis**:
```bash
# During installation, check network tab
# Post-installation:
ip link show                  # Check if interfaces exist
ip addr show                  # Check IP configuration
```

**Resolution**:
```bash
# Post-installation network fix:
nmcli connection show
nmcli connection up "interface-name"
systemctl restart NetworkManager
```

### Boot Issues After Installation

#### Issue 4: System Won't Boot
**Symptoms**:
- GRUB rescue prompt
- Kernel panic messages
- Black screen after boot

**Diagnosis**:
```bash
# From rescue media:
mkdir /mnt/sysimage
mount /dev/mapper/rhel-root /mnt/sysimage
chroot /mnt/sysimage
```

**Resolution**:
```bash
# Reinstall GRUB bootloader
grub2-install /dev/sda
grub2-mkconfig -o /boot/grub2/grub.cfg
```

---

## 8. Quick Reference Card

### Essential Installation Commands
```bash
# Pre-installation verification
lscpu                    # Check CPU
free -h                  # Check memory
lsblk                    # Check storage

# Post-installation verification  
hostnamectl              # System info
uname -a                 # Kernel info
df -h                    # Storage usage
ip addr show             # Network config
```

### Key File Locations
- **Installation logs**: `/var/log/anaconda/`
- **System configuration**: `/etc/os-release`
- **Filesystem mounts**: `/etc/fstab`
- **Network configuration**: `/etc/NetworkManager/`

### Installation Options
- **Graphical**: Default installation interface
- **Text mode**: Add `inst.text` to boot parameters
- **VNC**: Add `inst.vnc` for remote installation
- **Kickstart**: Add `inst.ks=URL` for automated installation

### Verification Commands
```bash
# Quick system health check
systemctl status         # System status
journalctl -b           # Boot messages
dmesg | tail           # Kernel messages
```

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What is the name of the RHEL installer program?
   **Answer**: Anaconda - this is the graphical and text-based installer used for all RHEL installations.

2. **Question**: What are the minimum partition requirements for RHEL installation?
   **Answer**: Root filesystem (/) and swap partition. While /boot is recommended as separate partition, it can reside within the root filesystem in simple installations.

3. **Question**: What is the difference between Server and Minimal Install base environments?
   **Answer**: Server includes standard server services and networking tools (~3GB), while Minimal Install contains only essential packages for basic system operation (~1GB).

### Practical Scenarios
1. **Scenario**: You need to install RHEL on a system with only 10GB available disk space.
   **Solution**: Use Minimal Install base environment, create 8GB root partition and 2GB swap, or use custom partitioning to optimize space allocation.

2. **Scenario**: Installation completed but system won't boot, showing GRUB rescue prompt.
   **Solution**: Boot from installation media in rescue mode, chroot to installed system, reinstall GRUB bootloader using grub2-install and grub2-mkconfig commands.

### Command Challenges
1. **Challenge**: Write commands to verify a successful RHEL installation.
   **Answer**: 
   ```bash
   hostnamectl              # Check system info
   cat /etc/os-release     # Verify RHEL version
   lsblk && df -h          # Check storage
   ip addr show            # Verify network
   systemctl status        # Check system health
   ```

---

## 10. Exam Strategy

### Topic-Specific Tips
- Installation knowledge helps with boot troubleshooting tasks
- Understand default partitioning schemes for storage questions
- Know post-installation configuration locations
- Practice both graphical and text-mode installations

### Common Exam Scenarios
1. **Scenario**: Fix boot issues on system that won't start
   **Approach**: Use rescue mode, check /boot contents, verify GRUB configuration

2. **Scenario**: Configure hostname during system setup
   **Approach**: Use `hostnamectl set-hostname` command, verify with `hostnamectl status`

### Time Management
- **Installation tasks**: Usually 5-10 minutes for configuration
- **Boot troubleshooting**: Allocate 15-20 minutes maximum
- **Quick verification**: Use fast commands like `hostnamectl`, `lsblk`

### Pitfalls to Avoid
- Don't spend excessive time on installation details during exam
- Remember to make configuration changes persistent
- Always verify system boots correctly after changes
- Check both current state and persistent configuration

---

## Summary

### Key Takeaways
- **Anaconda** is the RHEL installer program with graphical and text interfaces
- **Server base environment** is ideal for RHCSA practice and exam preparation
- **Standard partitioning** includes root (/) and swap at minimum, /boot recommended
- **Post-installation verification** ensures system is properly configured

### Critical Commands to Remember
```bash
hostnamectl                 # System information and hostname management
lsblk                      # Display block devices and partitions
systemctl status           # Check system and service status
```

### Next Steps
- Continue to [Module 02: File Management](02_file_management.md)
- Practice installation in virtual environment using Vagrant
- Review related topics: [Boot Process](11_boot_grub.md), [Storage](07_storage_lvm.md)

---

**Navigation**: [← Exam Overview](00_exam_overview.md) | [Index](index.md) | [Next → File Management](02_file_management.md)