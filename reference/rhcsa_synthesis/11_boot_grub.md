# Module 11: Boot Process & GRUB Configuration

## 1. Learning Objectives
- Understand the RHEL 9 boot process from UEFI/BIOS to systemd
- Configure and customize GRUB2 bootloader settings
- Manage kernel parameters and boot options
- Recover from boot failures using rescue modes
- Work with systemd targets and boot troubleshooting
- Implement emergency access and password recovery procedures

## 2. Key Concepts

### Boot Process Overview
The RHEL 9 boot sequence follows these stages:
1. **UEFI/BIOS**: Hardware initialization and bootloader location
2. **GRUB2**: Boot menu, kernel selection, and parameter passing
3. **Kernel**: Hardware detection, driver loading, initramfs mounting
4. **systemd**: Service initialization and target reaching

### GRUB2 Configuration Structure
- **Main config**: `/boot/grub2/grub.cfg` (auto-generated)
- **Default settings**: `/etc/default/grub`
- **Custom entries**: `/etc/grub.d/` directory
- **EFI systems**: `/boot/efi/EFI/redhat/grub.cfg`

### Systemd Targets
- **graphical.target**: Full multi-user with GUI
- **multi-user.target**: Multi-user without GUI
- **rescue.target**: Single-user maintenance mode
- **emergency.target**: Minimal environment with read-only root

## 3. Essential Commands

### GRUB Management
```bash
# Regenerate GRUB configuration
grub2-mkconfig -o /boot/grub2/grub.cfg                # BIOS systems
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg       # UEFI systems

# Install GRUB to disk
grub2-install /dev/sda                                # BIOS systems
grub2-install --target=x86_64-efi --efi-directory=/boot/efi  # UEFI

# Set default boot entry
grub2-set-default 0                                   # Set first entry as default
grub2-editenv list                                    # Show current default
```

### Kernel Parameter Management
```bash
# Temporary kernel parameters (current boot only)
# Edit in GRUB menu: press 'e', modify linux line, press Ctrl+x

# Permanent kernel parameters
grubby --update-kernel=ALL --args="parameter=value"   # Add parameter
grubby --update-kernel=ALL --remove-args="parameter"  # Remove parameter
grubby --info=ALL                                     # List all kernels and parameters

# View current kernel command line
cat /proc/cmdline
```

### Boot Target Management
```bash
# Get current target
systemctl get-default

# Set default target
systemctl set-default multi-user.target
systemctl set-default graphical.target

# Switch to target (temporary)
systemctl isolate rescue.target
systemctl isolate emergency.target

# Boot to specific target (from GRUB)
# Add: systemd.unit=rescue.target
```

### Recovery Procedures
```bash
# Reset root password (from rescue mode)
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
touch /.autorelabel                                   # For SELinux systems
exit
reboot

# Boot with init=/bin/bash
# Add to kernel line: init=/bin/bash
mount -o remount,rw /
passwd root
mount -o remount,ro /
reboot
```

## 4. Asghar Ghori's Approach

### Boot Process Analysis
Ghori emphasizes understanding each boot stage through observation:
```bash
# Analyze boot messages
dmesg | less
journalctl -b                                         # Current boot messages
journalctl --list-boots                               # Available boot logs
journalctl -b -1                                      # Previous boot messages
```

### GRUB Customization Method
```bash
# Modify /etc/default/grub
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap rhgb quiet"

# Apply changes
grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Rescue Mode Procedure
Ghori's systematic approach to rescue scenarios:
1. Boot from installation media
2. Select "Troubleshooting" → "Rescue a Red Hat Enterprise Linux system"
3. Choose shell option for full system access
4. Mount filesystems and chroot into system
5. Perform repairs and regenerate GRUB if needed

## 5. Sander van Vugt's Approach

### Bootloader Troubleshooting Methodology
Van Vugt focuses on systematic GRUB repair procedures:
```bash
# Complete GRUB reinstallation procedure
# Boot from live/rescue media
mkdir /mnt/sysimage
mount /dev/sda2 /mnt/sysimage                         # Mount root partition
mount /dev/sda1 /mnt/sysimage/boot                    # Mount boot partition
mount --bind /dev /mnt/sysimage/dev
mount --bind /proc /mnt/sysimage/proc
mount --bind /sys /mnt/sysimage/sys
chroot /mnt/sysimage
grub2-install /dev/sda
grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Advanced Kernel Parameter Management
```bash
# Comprehensive grubby usage
grubby --default-kernel                               # Show default kernel
grubby --set-default-index=1                          # Set specific kernel index
grubby --add-kernel=/boot/vmlinuz-new --title="New Kernel" --initrd=/boot/initramfs-new.img
grubby --remove-kernel=/boot/vmlinuz-old
```

### Systemd Boot Analysis
Van Vugt's approach to boot performance analysis:
```bash
# Boot time analysis
systemd-analyze                                       # Overall boot time
systemd-analyze blame                                 # Service startup times
systemd-analyze critical-chain                       # Critical path analysis
systemd-analyze plot > bootchart.svg                 # Visual boot chart
```

## 6. Command Examples and Scenarios

### Scenario 1: Kernel Parameter Configuration
```bash
# Add kernel parameter for debugging
grubby --update-kernel=ALL --args="debug"
grubby --info=ALL | grep -A5 -B5 debug

# Remove quiet and rhgb for verbose boot
grubby --update-kernel=ALL --remove-args="quiet rhgb"

# Add custom memory settings
grubby --update-kernel=ALL --args="mem=2G"
```

### Scenario 2: GRUB Menu Customization
```bash
# Extend GRUB timeout
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=15/' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Disable GRUB submenu
echo 'GRUB_DISABLE_SUBMENU=true' >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Add custom menu entry
cat > /etc/grub.d/40_custom << 'EOF'
#!/bin/sh
exec tail -n +3 $0
menuentry 'Memory Test' {
    linux16 /memtest86+
}
EOF
chmod +x /etc/grub.d/40_custom
grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Scenario 3: Boot Target Management
```bash
# Switch to text mode permanently
systemctl set-default multi-user.target
systemctl get-default                                 # Verify change

# Temporary switch to rescue mode
systemctl isolate rescue.target

# Emergency boot troubleshooting
# At GRUB menu, press 'e' and add:
systemd.unit=emergency.target

# Boot with specific runlevel (legacy)
systemd.unit=runlevel3.target                        # Equivalent to multi-user
```

## 7. Lab Exercises

### Lab 11A: GRUB Configuration and Kernel Parameters (Ghori-focused)
**Time Limit**: 20 minutes
**Objective**: Configure GRUB bootloader and manage kernel parameters

**Prerequisites**:
- RHEL 9 system with multiple kernel versions
- Root access for bootloader modifications

**Tasks**:
1. Modify GRUB timeout to 15 seconds and disable submenu
2. Add kernel parameter `console=ttyS0,115200` to all kernels
3. Create custom GRUB menu entry for memory test
4. Remove `quiet` parameter from current kernel
5. Set the second kernel as default boot option

**Verification Commands**:
```bash
grep GRUB_TIMEOUT /etc/default/grub                   # Check timeout setting
grubby --info=ALL | grep console                      # Verify console parameter
grub2-editenv list                                    # Check default kernel
cat /proc/cmdline                                     # Verify current parameters
```

### Lab 11B: Boot Troubleshooting and Recovery (van Vugt-focused)
**Time Limit**: 25 minutes
**Objective**: Practice boot failure recovery procedures

**Prerequisites**:
- RHEL 9 system with intentionally broken boot configuration
- Installation media or rescue disk available

**Tasks**:
1. Simulate GRUB corruption by removing `/boot/grub2/grub.cfg`
2. Boot into rescue mode and reinstall GRUB
3. Change root password using emergency boot mode
4. Configure system to boot to multi-user target by default
5. Analyze boot performance and identify slowest service

**Verification Commands**:
```bash
ls -la /boot/grub2/grub.cfg                          # Verify GRUB config exists
systemctl get-default                                 # Check default target
systemd-analyze blame | head -5                      # Show slowest services
journalctl -b | grep -i error                        # Check for boot errors
```

### Lab 11C: Synthesis Challenge - Complete Boot Environment Setup
**Time Limit**: 30 minutes
**Objective**: Integrate both methodologies for comprehensive boot management

**Prerequisites**:
- Fresh RHEL 9 installation
- Multiple kernel versions installed
- Access to rescue media

**Tasks**:
1. Configure GRUB with custom splash image and 20-second timeout
2. Add persistent kernel parameters for debugging and console redirection
3. Create custom rescue menu entry that boots directly to single-user mode
4. Set up automatic boot to graphical target with fallback to multi-user
5. Implement password protection for GRUB menu editing
6. Document complete recovery procedure for boot failure scenarios

**Advanced Requirements**:
- Use both grubby and manual GRUB configuration methods
- Combine Ghori's systematic approach with van Vugt's advanced troubleshooting
- Create comprehensive boot analysis report using systemd tools

**Verification Commands**:
```bash
grub2-editenv list                                    # Verify default settings
grubby --info=ALL                                     # Check all kernel parameters
systemd-analyze critical-chain                       # Analyze boot dependencies
journalctl -b --no-pager | grep -E "(Started|Failed)" # Boot service status
```

## 8. Troubleshooting Common Issues

### GRUB Not Loading
```bash
# Symptoms: System boots directly to BIOS/UEFI
# Solution: Reinstall GRUB to MBR/ESP

# For BIOS systems:
grub2-install /dev/sda
grub2-mkconfig -o /boot/grub2/grub.cfg

# For UEFI systems:
grub2-install --target=x86_64-efi --efi-directory=/boot/efi
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```

### Kernel Panic on Boot
```bash
# Symptoms: Kernel panic, unable to mount root filesystem
# Solution: Boot with different kernel or rescue mode

# From GRUB menu:
# 1. Select older kernel version
# 2. Add kernel parameter: init=/bin/bash
# 3. Boot to rescue mode from installation media
```

### Wrong systemd Target
```bash
# Symptoms: System boots to wrong runlevel/target
# Solution: Check and correct default target

systemctl get-default
systemctl set-default graphical.target
systemctl list-units --type=target --state=active    # Show active targets
```

### GRUB Configuration Corruption
```bash
# Symptoms: Syntax errors, missing menu entries
# Solution: Regenerate configuration

# Backup existing configuration
cp /boot/grub2/grub.cfg /boot/grub2/grub.cfg.backup

# Check /etc/default/grub for syntax errors
cat /etc/default/grub

# Regenerate clean configuration
grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Forgotten Root Password Recovery
```bash
# Method 1: rd.break method
# Add to kernel line: rd.break
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
touch /.autorelabel
exit
reboot

# Method 2: init=/bin/bash method
# Add to kernel line: init=/bin/bash
mount -o remount,rw /
passwd root
exec /sbin/init
```

## 9. Best Practices

### GRUB Configuration Management
- Always backup `/boot/grub2/grub.cfg` before changes
- Use `/etc/default/grub` for global settings
- Place custom entries in `/etc/grub.d/40_custom`
- Test boot changes immediately after implementation
- Keep rescue media available for emergency recovery

### Kernel Parameter Management
- Use `grubby` for persistent kernel parameter changes
- Document all custom parameters and their purposes
- Test parameter changes before making them permanent
- Monitor system behavior after parameter modifications
- Maintain list of working parameter combinations

### Boot Security
- Implement GRUB password protection for menu editing
- Secure physical access to prevent boot parameter tampering
- Use encrypted boot partitions for sensitive environments
- Regularly update bootloader for security patches
- Monitor boot logs for unauthorized access attempts

### Recovery Preparedness
- Create and test rescue media regularly
- Document complete recovery procedures
- Practice password recovery methods
- Maintain emergency contact information
- Keep system documentation current and accessible

## 10. Integration with Other RHCSA Topics

### Storage Integration
- Boot partition requirements for LVM root filesystems
- GRUB configuration for encrypted root partitions
- Rescue procedures for storage failures
- Boot from different storage devices

### Security Integration
- SELinux autorelabel during password recovery
- Boot security with GRUB passwords
- Secure boot configuration in UEFI environments
- Audit trail for boot-time security events

### Network Integration
- Network boot with PXE and GRUB
- Console redirection for remote management
- Boot parameter configuration for network interfaces
- Remote boot troubleshooting procedures

### Service Integration
- systemd target dependencies and boot order
- Service startup optimization for faster boot
- Boot-time service failure troubleshooting
- Integration with monitoring systems for boot alerts

---

**Module 11 Summary**: Boot process management and GRUB configuration are critical skills for system recovery and optimization. This module combines systematic troubleshooting approaches with practical recovery procedures, ensuring administrators can handle boot failures and customize the boot environment effectively. Understanding both the theory of the boot process and hands-on recovery techniques is essential for RHCSA certification and real-world system administration.