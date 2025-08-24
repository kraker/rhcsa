# 07 - Storage & LVM Management

**Navigation**: [← Package Management](06_package_management.md) | [Index](index.md) | [Next → Network Configuration](08_networking.md)

---

## 1. Executive Summary

**Topic Scope**: Disk partitioning, LVM (Logical Volume Management), filesystem creation, mounting, and swap management in RHEL 9

**RHCSA Relevance**: Critical exam topic - storage management is a major component of RHCSA certification

**Exam Weight**: High - Storage tasks are complex and carry significant point values

**Prerequisites**: Understanding of Linux file system hierarchy and basic command line operations

**Related Topics**: [System Installation](01_system_installation.md), [File Management](02_file_management.md), [Boot Process](11_boot_grub.md)

---

## 2. Conceptual Foundation

### Core Theory
Storage management in RHEL 9 involves multiple layers:

- **Physical storage**: Hard drives, SSDs, network storage
- **Partitions**: Logical divisions of physical storage
- **Volume management**: LVM provides flexibility between partitions and filesystems
- **Filesystems**: Data organization structures (XFS, ext4, etc.)
- **Mount points**: Directory locations where filesystems are accessible

### Real-World Applications
- **Database servers**: Managing storage for database files with growth requirements
- **Web servers**: Organizing storage for logs, content, and temporary files
- **Development systems**: Creating isolated storage areas for different projects
- **Backup systems**: Managing storage for backup data with retention policies
- **Virtual environments**: Providing flexible storage to virtual machines

### Common Misconceptions
- **LVM complexity**: LVM adds flexibility, not just complexity
- **XFS vs ext4**: XFS is better for large files, ext4 for small files
- **Partition vs LVM**: LVM provides better flexibility for production systems
- **Swap size**: Modern systems need less swap than traditional recommendations
- **Online resizing**: XFS can only grow, ext4 can shrink and grow

### Key Terminology
- **Physical Volume (PV)**: Physical storage device or partition used by LVM
- **Volume Group (VG)**: Collection of physical volumes acting as single storage pool
- **Logical Volume (LV)**: Virtual partition created from volume group space
- **Physical Extent (PE)**: Smallest unit of space allocation in LVM
- **Logical Extent (LE)**: Mapping unit from logical volume to physical extents
- **Mount point**: Directory where filesystem is attached to directory tree
- **fstab**: Configuration file for automatic filesystem mounting
- **UUID**: Universally Unique Identifier for devices and filesystems

---

## 3. Command Mastery

### Disk and Partition Management
```bash
# View disk information
lsblk                        # List block devices in tree format
lsblk -f                     # Include filesystem information
fdisk -l                     # List all partitions on all disks
fdisk -l /dev/sda            # List partitions on specific disk
blkid                        # Show device UUIDs and filesystem types
df -h                        # Show mounted filesystem usage
du -sh /path                 # Show directory space usage

# Partition management with fdisk
fdisk /dev/sdb               # Interactive partition editor
# Common fdisk commands:
# n - create new partition
# d - delete partition
# t - change partition type
# w - write changes and exit
# q - quit without saving

# Partition management with parted
parted /dev/sdb              # Interactive partition editor
parted /dev/sdb print        # Show partition table
parted /dev/sdb mklabel gpt  # Create GPT partition table
parted /dev/sdb mkpart primary 1MB 100%  # Create partition

# Update kernel partition table
partprobe /dev/sdb           # Update without reboot
```

### LVM Management Commands
```bash
# Physical Volume (PV) management
pvcreate /dev/sdb1           # Create physical volume
pvdisplay                    # Show PV details
pvs                          # Show PV summary
pvremove /dev/sdb1           # Remove PV (must be unused)

# Volume Group (VG) management
vgcreate vgname /dev/sdb1    # Create volume group
vgcreate vgname /dev/sdb1 /dev/sdc1  # VG with multiple PVs
vgdisplay                    # Show VG details
vgs                          # Show VG summary
vgextend vgname /dev/sdd1    # Add PV to VG
vgreduce vgname /dev/sdd1    # Remove PV from VG
vgremove vgname              # Remove VG (must be empty)

# Logical Volume (LV) management
lvcreate -L 2G -n lvname vgname        # Create LV with specific size
lvcreate -l 50%VG -n lvname vgname     # Create LV with percentage
lvcreate -l 100%FREE -n lvname vgname  # Use all free space
lvdisplay                              # Show LV details
lvs                                    # Show LV summary
lvextend -L +1G /dev/vgname/lvname     # Extend LV by 1GB
lvextend -L 5G /dev/vgname/lvname      # Extend LV to 5GB total
lvreduce -L -1G /dev/vgname/lvname     # Reduce LV by 1GB
lvremove /dev/vgname/lvname            # Remove LV
```

### Filesystem Management
```bash
# Create filesystems
mkfs.xfs /dev/vgname/lvname            # Create XFS filesystem
mkfs.ext4 /dev/vgname/lvname           # Create ext4 filesystem
mkfs -t xfs /dev/sdb1                  # Alternative syntax

# Filesystem information
blkid /dev/vgname/lvname               # Show filesystem UUID and type
xfs_info /dev/vgname/lvname            # XFS filesystem information
tune2fs -l /dev/vgname/lvname          # ext4 filesystem information

# Filesystem resizing
xfs_growfs /mountpoint                 # Grow XFS (can only grow)
resize2fs /dev/vgname/lvname           # Resize ext4 (grow or shrink)
resize2fs /dev/vgname/lvname 3G        # Resize ext4 to specific size

# Filesystem checking and repair
xfs_repair /dev/vgname/lvname          # Repair XFS (unmounted)
fsck.ext4 /dev/vgname/lvname           # Check/repair ext4 (unmounted)
```

### Mount Management
```bash
# Mounting filesystems
mount /dev/vgname/lvname /mnt/data     # Mount filesystem
mount -t xfs /dev/sdb1 /mnt/backup     # Mount with specific type
mount -o ro /dev/sdb1 /mnt/readonly    # Mount read-only
umount /mnt/data                       # Unmount filesystem
umount -f /mnt/data                    # Force unmount

# Persistent mounting
vim /etc/fstab                         # Edit fstab for permanent mounts
mount -a                               # Mount all fstab entries
findmnt --verify                       # Verify fstab syntax

# View mounted filesystems
mount                                  # Show all mounted filesystems
mount | column -t                      # Formatted output
findmnt                               # Tree view of mounts
df -h                                 # Mounted filesystem usage
```

### Swap Management
```bash
# Create and manage swap
mkswap /dev/vgname/swaplv              # Create swap filesystem
swapon /dev/vgname/swaplv              # Enable swap
swapoff /dev/vgname/swaplv             # Disable swap
swapon --show                          # Show active swap
swapon -a                              # Enable all swap in fstab

# Swap file creation
dd if=/dev/zero of=/swapfile bs=1M count=1024  # Create 1GB file
chmod 600 /swapfile                    # Secure permissions
mkswap /swapfile                       # Format as swap
swapon /swapfile                       # Enable swap file
```

### Command Reference Table
| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `lsblk` | List block devices | `-f` | `lsblk -f` |
| `fdisk` | Partition editor | `-l` | `fdisk /dev/sdb` |
| `pvcreate` | Create physical volume | | `pvcreate /dev/sdb1` |
| `vgcreate` | Create volume group | | `vgcreate datavg /dev/sdb1` |
| `lvcreate` | Create logical volume | `-L`, `-n` | `lvcreate -L 2G -n datalv datavg` |
| `mkfs.xfs` | Create XFS filesystem | | `mkfs.xfs /dev/datavg/datalv` |

---

## 4. Procedural Workflows

### Standard Procedure: Complete LVM Setup
1. **Prepare physical storage**
   ```bash
   # Create partition (if not using whole disk)
   fdisk /dev/sdb
   # Create partition, set type to Linux LVM (8e)
   partprobe /dev/sdb
   ```

2. **Create LVM structure**
   ```bash
   # Create physical volume
   pvcreate /dev/sdb1
   
   # Create volume group
   vgcreate datavg /dev/sdb1
   
   # Create logical volume
   lvcreate -L 2G -n datalv datavg
   ```

3. **Create and mount filesystem**
   ```bash
   # Create filesystem
   mkfs.xfs /dev/datavg/datalv
   
   # Create mount point
   mkdir -p /data
   
   # Mount filesystem
   mount /dev/datavg/datalv /data
   ```

4. **Make mount permanent**
   ```bash
   # Add to fstab
   echo "/dev/datavg/datalv /data xfs defaults 0 2" >> /etc/fstab
   
   # Verify fstab
   mount -a
   df -h /data
   ```

### Standard Procedure: Extending LVM Storage
1. **Add new physical volume**
   ```bash
   # Prepare new disk/partition
   pvcreate /dev/sdc1
   
   # Add to existing volume group
   vgextend datavg /dev/sdc1
   
   # Verify VG size increased
   vgs datavg
   ```

2. **Extend logical volume**
   ```bash
   # Extend logical volume
   lvextend -L +5G /dev/datavg/datalv
   
   # Or extend to use all available space
   lvextend -l +100%FREE /dev/datavg/datalv
   ```

3. **Extend filesystem**
   ```bash
   # For XFS filesystems
   xfs_growfs /data
   
   # For ext4 filesystems
   resize2fs /dev/datavg/datalv
   
   # Verify new size
   df -h /data
   ```

### Decision Tree: Storage Strategy Selection
```
Storage Requirements
├── Simple single-disk setup?
│   ├── Basic partitioning → fdisk + mkfs + mount
│   └── Future growth expected → Use LVM even for single disk
├── Multiple disks?
│   ├── Need flexibility? → LVM with multiple PVs
│   ├── Performance priority? → RAID + LVM
│   └── Simple aggregation? → LVM spanning
└── Specific use case?
    ├── Database storage → XFS on LVM for large files
    ├── Boot partition → ext4 on regular partition
    └── Swap space → LVM logical volume or swap file
```

### Standard Procedure: Filesystem Migration
1. **Prepare new storage**
   ```bash
   # Create new LVM structure
   pvcreate /dev/sdd1
   vgcreate newvg /dev/sdd1
   lvcreate -L 10G -n newlv newvg
   mkfs.xfs /dev/newvg/newlv
   ```

2. **Copy data safely**
   ```bash
   # Mount new filesystem temporarily
   mkdir /mnt/newdata
   mount /dev/newvg/newlv /mnt/newdata
   
   # Copy data with rsync
   rsync -avxHAX /olddata/ /mnt/newdata/
   
   # Verify data integrity
   diff -r /olddata /mnt/newdata
   ```

3. **Switch to new storage**
   ```bash
   # Update fstab
   sed -i 's|/dev/oldvg/oldlv|/dev/newvg/newlv|g' /etc/fstab
   
   # Unmount old, remount new
   umount /olddata
   umount /mnt/newdata
   mount /dev/newvg/newlv /olddata
   ```

---

## 5. Configuration Deep Dive

### /etc/fstab Configuration
#### fstab Entry Format
```bash
# Device/UUID  Mount Point  Filesystem  Options  Dump  Pass
/dev/datavg/datalv  /data  xfs  defaults  0  2
UUID=abc123-def456  /home  ext4  defaults,noatime  1  2
/dev/datavg/swaplv  swap   swap defaults  0  0
```

#### Common fstab Options
```bash
# Performance options
defaults,noatime        # Don't update access times (performance)
defaults,relatime       # Update access time relatively (compromise)

# Security options  
defaults,noexec         # Prevent execution of binaries
defaults,nosuid         # Ignore suid bits
defaults,nodev          # Don't interpret device files

# Reliability options
defaults,_netdev        # Network device (wait for network)
defaults,nofail         # Continue boot if device unavailable
```

### LVM Configuration Files
#### LVM Configuration
```bash
# /etc/lvm/lvm.conf
devices {
    scan = [ "/dev" ]           # Directories to scan for devices
    filter = [ "a/sda/", "r/.*/" ]  # Device filter (accept/reject)
}

activation {
    volume_list = [ "vg1", "@*" ]   # Limit activated VGs
}

backup {
    backup = 1                  # Enable metadata backups
    archive = 1                 # Enable metadata archives
}
```

#### Volume Group Backup and Recovery
```bash
# Backup VG metadata
vgcfgbackup vgname
vgcfgbackup -f /backup/vgname.conf vgname

# Restore VG metadata
vgcfgrestore -f /backup/vgname.conf vgname

# List backups
vgcfgrestore -l vgname
```

### Filesystem-Specific Configuration
#### XFS Configuration
```bash
# XFS filesystem options in fstab
/dev/datavg/datalv /data xfs defaults,noatime,logbsize=256k 0 2

# XFS maintenance commands
xfs_fsr /data                   # Defragment XFS filesystem
xfs_db -r /dev/datavg/datalv    # XFS debugger (read-only)
```

#### ext4 Configuration
```bash
# ext4 tuning
tune2fs -o acl,user_xattr /dev/datavg/datalv    # Enable ACLs
tune2fs -c 50 /dev/datavg/datalv                # Check every 50 mounts
tune2fs -i 180d /dev/datavg/datalv              # Check every 180 days
```

---

## 6. Hands-On Labs

### Lab 6.1: Basic LVM Setup (Asghar Ghori Style)
**Objective**: Create complete LVM storage solution from scratch

**Prerequisites**: Additional disk (/dev/sdb) available for testing

**Steps**:
1. **Explore current storage**
   ```bash
   # View current storage configuration
   lsblk
   df -h
   pvs
   vgs
   lvs
   ```

2. **Create partition for LVM**
   ```bash
   # Create partition on /dev/sdb
   fdisk /dev/sdb
   # Commands in fdisk:
   # n (new partition)
   # p (primary)
   # 1 (partition number)
   # Enter (default start)
   # Enter (default end, use whole disk)
   # t (change type)
   # 8e (Linux LVM)
   # w (write and exit)
   
   # Update kernel partition table
   partprobe /dev/sdb
   
   # Verify partition
   lsblk /dev/sdb
   ```

3. **Create LVM components**
   ```bash
   # Create physical volume
   pvcreate /dev/sdb1
   pvdisplay /dev/sdb1
   
   # Create volume group
   vgcreate labtesting /dev/sdb1
   vgdisplay labtesting
   
   # Create logical volumes
   lvcreate -L 1G -n data labtesting
   lvcreate -L 500M -n logs labtesting  
   lvcreate -L 256M -n swap labtesting
   
   # Verify LVM structure
   lvdisplay
   ```

4. **Create filesystems and swap**
   ```bash
   # Create filesystems
   mkfs.xfs /dev/labtesting/data
   mkfs.ext4 /dev/labtesting/logs
   mkswap /dev/labtesting/swap
   
   # Verify filesystem creation
   blkid | grep labtesting
   ```

5. **Mount and configure**
   ```bash
   # Create mount points
   mkdir -p /lab/{data,logs}
   
   # Mount filesystems
   mount /dev/labtesting/data /lab/data
   mount /dev/labtesting/logs /lab/logs
   swapon /dev/labtesting/swap
   
   # Verify mounts
   df -h /lab/data /lab/logs
   swapon --show
   ```

**Verification**:
```bash
# Complete verification
lsblk
pvs && vgs && lvs
df -h | grep lab
swapon --show | grep labtesting
```

### Lab 6.2: LVM Extension and Management (Sander van Vugt Style)
**Objective**: Practice extending and managing existing LVM infrastructure

**Prerequisites**: Lab 6.1 completed, additional disk (/dev/sdc) available

**Steps**:
1. **Add storage to existing VG**
   ```bash
   # Prepare new disk
   fdisk /dev/sdc
   # Create partition, set type to Linux LVM (8e)
   partprobe /dev/sdc
   
   # Add to LVM
   pvcreate /dev/sdc1
   vgextend labtesting /dev/sdc1
   
   # Verify VG growth
   vgs labtesting
   vgdisplay labtesting
   ```

2. **Extend logical volumes**
   ```bash
   # Extend data LV by 2GB
   lvextend -L +2G /dev/labtesting/data
   
   # Extend logs LV to use remaining space
   lvextend -l +100%FREE /dev/labtesting/logs
   
   # Verify LV sizes
   lvs labtesting
   ```

3. **Resize filesystems**
   ```bash
   # Resize XFS filesystem (data)
   xfs_growfs /lab/data
   
   # Resize ext4 filesystem (logs)
   resize2fs /dev/labtesting/logs
   
   # Verify filesystem sizes
   df -h /lab/data /lab/logs
   ```

4. **Practice LV management operations**
   ```bash
   # Create snapshot of data LV
   lvcreate -L 500M -s -n data-snapshot /dev/labtesting/data
   
   # Create some test data
   echo "Test file content" > /lab/data/testfile.txt
   ls -la /lab/data/
   
   # Mount and examine snapshot
   mkdir /mnt/snapshot
   mount /dev/labtesting/data-snapshot /mnt/snapshot
   ls -la /mnt/snapshot/
   
   # Clean up snapshot
   umount /mnt/snapshot
   lvremove -f /dev/labtesting/data-snapshot
   ```

**Verification**:
```bash
# Verify final state
pvs && vgs && lvs
df -h | grep lab
lsblk | grep labtesting
```

### Lab 6.3: Complete Storage Migration (Synthesis Challenge)
**Objective**: Migrate existing storage to new LVM configuration with minimal downtime

**Scenario**: Migrate a production-like data directory to new storage with better organization

**Requirements**:
- Create new VG with better naming convention
- Migrate data safely without corruption
- Update system configuration appropriately
- Document the migration process

**Solution Steps**:
1. **Prepare new storage infrastructure**
   ```bash
   # Use remaining space or additional disk
   if lsblk | grep -q sdd; then
       NEWDISK=/dev/sdd
   else
       # Use remaining space in existing VG
       NEWDISK="extend_existing"
   fi
   
   if [ "$NEWDISK" != "extend_existing" ]; then
       pvcreate ${NEWDISK}1
       vgcreate production ${NEWDISK}1
   else
       # Extend existing VG and create new LVs
       vgextend labtesting /dev/sdc1 2>/dev/null || true
   fi
   
   # Create production-style LVM layout
   if vgs production >/dev/null 2>&1; then
       lvcreate -L 3G -n app-data production
       lvcreate -L 1G -n app-logs production
       lvcreate -L 500M -n app-backup production
   else
       lvcreate -L 1G -n app-data labtesting
       lvcreate -L 500M -n app-logs labtesting
       lvcreate -L 256M -n app-backup labtesting
   fi
   ```

2. **Prepare new filesystems**
   ```bash
   # Determine which VG to use
   if vgs production >/dev/null 2>&1; then
       VG=production
   else
       VG=labtesting
   fi
   
   # Create filesystems with appropriate options
   mkfs.xfs -L app-data /dev/${VG}/app-data
   mkfs.ext4 -L app-logs /dev/${VG}/app-logs  
   mkfs.ext4 -L app-backup /dev/${VG}/app-backup
   
   # Create mount points
   mkdir -p /app/{data,logs,backup}
   ```

3. **Migrate existing data**
   ```bash
   # Create some test data in old location
   echo "Important application data" > /lab/data/app.conf
   echo "$(date): Application started" > /lab/logs/app.log
   mkdir -p /lab/data/important
   echo "Critical data" > /lab/data/important/critical.txt
   
   # Mount new filesystems temporarily
   mkdir -p /mnt/migration/{data,logs,backup}
   mount /dev/${VG}/app-data /mnt/migration/data
   mount /dev/${VG}/app-logs /mnt/migration/logs
   mount /dev/${VG}/app-backup /mnt/migration/backup
   
   # Migrate data safely with rsync
   rsync -avxHAX /lab/data/ /mnt/migration/data/
   rsync -avxHAX /lab/logs/ /mnt/migration/logs/
   
   # Create backup of migration
   tar -czf /mnt/migration/backup/migration-backup-$(date +%Y%m%d).tar.gz \
       -C /mnt/migration data logs
   
   # Verify data integrity
   diff -r /lab/data /mnt/migration/data
   echo "Data integrity check: $?"
   ```

4. **Update system configuration**
   ```bash
   # Prepare new fstab entries
   cat >> /tmp/new-fstab-entries << EOF
   /dev/${VG}/app-data  /app/data    xfs   defaults,noatime     0 2
   /dev/${VG}/app-logs  /app/logs    ext4  defaults,noatime     0 2
   /dev/${VG}/app-backup /app/backup ext4  defaults,noexec      0 2
   EOF
   
   # Show what will be added
   echo "New fstab entries:"
   cat /tmp/new-fstab-entries
   
   # Add to fstab (in real migration, this would be done during maintenance window)
   cat /tmp/new-fstab-entries >> /etc/fstab
   
   # Switch to new storage
   umount /mnt/migration/data /mnt/migration/logs /mnt/migration/backup
   mount /dev/${VG}/app-data /app/data
   mount /dev/${VG}/app-logs /app/logs  
   mount /dev/${VG}/app-backup /app/backup
   ```

5. **Verify and document migration**
   ```bash
   # Create migration report
   cat > /app/backup/migration-report-$(date +%Y%m%d).txt << EOF
   Storage Migration Report
   Date: $(date)
   
   Old Storage:
   - /lab/data ($(du -sh /lab/data | cut -f1))
   - /lab/logs ($(du -sh /lab/logs | cut -f1))
   
   New Storage:
   Volume Group: ${VG}
   - /app/data: /dev/${VG}/app-data (XFS, $(df -h /app/data | tail -1 | awk '{print $2}'))
   - /app/logs: /dev/${VG}/app-logs (ext4, $(df -h /app/logs | tail -1 | awk '{print $2}'))
   - /app/backup: /dev/${VG}/app-backup (ext4, $(df -h /app/backup | tail -1 | awk '{print $2}'))
   
   Migration Status: COMPLETED
   Data Verification: PASSED
   Backup Created: migration-backup-$(date +%Y%m%d).tar.gz
   EOF
   
   # Display final configuration
   echo "=== Migration Complete ==="
   lsblk | grep -E "(${VG}|labtesting)"
   df -h | grep app
   cat /app/backup/migration-report-$(date +%Y%m%d).txt
   ```

**Verification**:
```bash
# Complete post-migration verification
mount | grep "/app"
ls -la /app/data/
ls -la /app/logs/
ls -la /app/backup/
cat /app/data/app.conf
cat /app/logs/app.log
```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: LV Won't Mount After Reboot
**Symptoms**:
- Filesystem not available after system restart
- "Device not found" errors during boot
- Services fail to start due to missing storage

**Diagnosis**:
```bash
# Check if LVM volumes are active
lvs
vgs
pvs

# Check fstab entries
cat /etc/fstab | grep -v "^#"

# Check what's actually mounted
mount | grep mapper
```

**Resolution**:
```bash
# Activate volume groups
vgchange -ay

# Scan for LVM volumes
pvscan
vgscan
lvscan

# Fix fstab if needed (use UUID instead of device names)
blkid /dev/vgname/lvname
# Replace device path with UUID in fstab

# Test mount
mount -a
```

**Prevention**: Use UUIDs in fstab, ensure LVM service is enabled

#### Issue 2: Cannot Extend Filesystem
**Symptoms**:
- LV extends successfully but filesystem size unchanged
- "No space left on device" despite LV extension
- Applications still report old filesystem size

**Diagnosis**:
```bash
# Check LV vs filesystem size
lvs
df -h /mountpoint

# Check filesystem type
mount | grep /mountpoint
blkid /dev/vgname/lvname
```

**Resolution**:
```bash
# For XFS filesystems
xfs_growfs /mountpoint

# For ext4 filesystems  
resize2fs /dev/vgname/lvname

# Verify filesystem size
df -h /mountpoint
```

#### Issue 3: VG Shows as Inactive
**Symptoms**:
- Volume group not visible or inactive
- Cannot access logical volumes
- LVM commands show no VGs

**Diagnosis**:
```bash
# Check PV status
pvdisplay -C
pvscan

# Check for VG metadata issues
vgscan
vgdisplay -A
```

**Resolution**:
```bash
# Activate volume group
vgchange -ay vgname

# If metadata corrupted, restore from backup
vgcfgrestore -l vgname
vgcfgrestore -f /etc/lvm/archive/vgname_XXXX.vg vgname

# Rescan LVM components
pvscan
vgscan  
lvscan
```

### Diagnostic Command Sequence
```bash
# Storage troubleshooting workflow
lsblk                        # Overview of block devices
df -h                        # Mounted filesystem status
mount | column -t            # Mount point details
pvs && vgs && lvs           # LVM component status
blkid                       # Device UUIDs and filesystems
cat /etc/fstab              # Persistent mount configuration
```

### Log File Analysis
- **`/var/log/messages`**: General storage and LVM errors
- **`/var/log/boot.log`**: Boot-time storage issues
- **`dmesg`**: Kernel messages about storage devices
- **`journalctl -u lvm2*`**: LVM service messages

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance
```bash
# LVM creation workflow
pvcreate /dev/sdb1           # Create physical volume
vgcreate vgname /dev/sdb1    # Create volume group
lvcreate -L 2G -n lvname vgname  # Create logical volume
mkfs.xfs /dev/vgname/lvname  # Create filesystem
mount /dev/vgname/lvname /mnt # Mount filesystem

# Extension workflow
vgextend vgname /dev/sdc1    # Add space to VG
lvextend -L +1G /dev/vgname/lvname  # Extend LV
xfs_growfs /mnt              # Grow XFS filesystem
```

### fstab Entry Examples
```bash
# Using device path (not recommended)
/dev/datavg/datalv  /data  xfs  defaults  0  2

# Using UUID (recommended)
UUID=abc123-def456  /data  xfs  defaults,noatime  0  2

# Swap entry
/dev/datavg/swaplv  swap  swap  defaults  0  0
```

### LVM Size Specifications
- **Absolute sizes**: `1G`, `500M`, `2T`
- **Percentage of VG**: `50%VG`, `100%VG`
- **Percentage of free space**: `50%FREE`, `100%FREE`
- **Relative changes**: `+1G`, `-500M`, `+50%FREE`

### Filesystem Types
- **XFS**: Best for large files, can only grow
- **ext4**: General purpose, can grow and shrink
- **swap**: Virtual memory extension

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What's the advantage of LVM over traditional partitioning?
   **Answer**: LVM provides flexibility to resize storage without repartitioning disks. You can extend logical volumes across multiple physical devices, create snapshots, and resize filesystems online. It separates physical storage from logical organization, making storage management much more flexible.

2. **Question**: Why can't you shrink an XFS filesystem?
   **Answer**: XFS is designed for performance and large-scale storage. Its metadata structure and allocation algorithms are optimized for forward growth. Shrinking would require complex metadata reorganization that could compromise performance and reliability, so XFS developers chose to support only growth operations.

3. **Question**: When would you use a swap file instead of swap partition?
   **Answer**: Swap files are easier to manage dynamically - you can create, resize, or remove them without repartitioning. They're useful when you need to add swap temporarily, when using cloud instances with limited partitioning options, or when you want to adjust swap size based on changing workload requirements.

### Practical Scenarios
1. **Scenario**: Database server running out of space for transaction logs.
   **Solution**: Extend the LV containing the logs (`lvextend -L +10G /dev/vgname/logslv`), then grow the filesystem (`xfs_growfs /var/lib/mysql/logs`), assuming XFS filesystem.

2. **Scenario**: Need to migrate data from failing disk to new storage.
   **Solution**: Create new LVM structure on new disk, use `rsync -avxHAX` to copy data while old disk still works, then update fstab and remount on new storage.

### Command Challenges
1. **Challenge**: Create a 5GB logical volume using exactly 50% of volume group space.
   **Answer**: `lvcreate -l 50%VG -n mylv vgname`
   **Explanation**: `-l` uses extents/percentages, `50%VG` means half of total VG space

2. **Challenge**: Find all LVM logical volumes and their mount points.
   **Answer**: `findmnt | grep mapper` or `mount | grep mapper`
   **Explanation**: LVM device paths contain `/dev/mapper/` prefix when mounted

---

## 10. Exam Strategy

### Topic-Specific Tips
- Always verify disk space before creating partitions or LVs
- Use `lsblk` to visualize storage hierarchy before making changes
- Remember that XFS can only grow, not shrink
- Practice the complete workflow: PV → VG → LV → filesystem → mount → fstab

### Common Exam Scenarios
1. **Scenario**: Add storage to existing system
   **Approach**: Create PV, extend VG, extend LV, resize filesystem

2. **Scenario**: Create swap space
   **Approach**: Create LV, format as swap, enable swap, add to fstab

3. **Scenario**: Set up persistent mounts
   **Approach**: Add appropriate entries to /etc/fstab, test with `mount -a`

### Time Management
- **Basic LVM setup**: 8-10 minutes for complete PV→VG→LV→filesystem→mount
- **Storage extension**: 5-7 minutes for extend LV and resize filesystem
- **Partition creation**: 3-4 minutes using fdisk
- **Always verify**: Check with `df -h` and `mount` after each step

### Pitfalls to Avoid
- Don't forget `partprobe` after creating partitions with fdisk
- Remember to resize filesystem after extending LV
- Use UUIDs in fstab for reliability
- Always verify fstab with `mount -a` before rebooting
- Don't try to shrink XFS - it's not supported
- Ensure adequate space before creating LVs (don't use 100% VG space)

---

## Summary

### Key Takeaways
- **LVM provides storage flexibility** - essential for production systems
- **Understand the hierarchy**: Physical Volume → Volume Group → Logical Volume → Filesystem
- **XFS vs ext4 have different capabilities** - choose based on requirements
- **fstab configuration is critical** - systems won't boot properly without correct entries

### Critical Commands to Remember
```bash
pvcreate /dev/sdb1                       # Create physical volume
vgcreate vgname /dev/sdb1               # Create volume group
lvcreate -L 2G -n lvname vgname         # Create logical volume
mkfs.xfs /dev/vgname/lvname             # Create XFS filesystem
lvextend -L +1G /dev/vgname/lvname      # Extend logical volume
xfs_growfs /mountpoint                  # Grow XFS filesystem
```

### Next Steps
- Continue to [Module 08: Network Configuration](08_networking.md)
- Practice storage management in the Vagrant environment with multiple disks
- Review related topics: [System Installation](01_system_installation.md), [Boot Process](11_boot_grub.md)

---

**Navigation**: [← Package Management](06_package_management.md) | [Index](index.md) | [Next → Network Configuration](08_networking.md)