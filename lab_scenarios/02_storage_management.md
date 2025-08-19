# Lab Scenario 2: Storage and LVM Management

**VM:** rhel9b (use the additional disks)  
**Time Limit:** 45 minutes  
**Difficulty:** Intermediate

## Scenario
Your company needs additional storage for a database server. You have multiple disks available and need to configure them using LVM for flexibility. You also need to set up automatic mounting.

## Prerequisites
- Verify available disks: `lsblk`
- You should see /dev/sdb, /dev/sdc, /dev/sdd, /dev/sde, /dev/sdf

## Tasks

### 1. Partition Setup (10 minutes)
```bash
# Create partitions on multiple disks
sudo fdisk /dev/sdb
# Create one primary partition using full disk

sudo fdisk /dev/sdc
# Create one primary partition using full disk

# Make partitions LVM type (8e)
sudo fdisk /dev/sdb
# t, 8e, w

sudo fdisk /dev/sdc
# t, 8e, w
```

### 2. LVM Physical Volumes (5 minutes)
```bash
# Create physical volumes
sudo pvcreate /dev/sdb1 /dev/sdc1

# Verify PV creation
sudo pvdisplay
sudo pvscan
```

### 3. Volume Group Creation (5 minutes)
```bash
# Create volume group
sudo vgcreate vg_database /dev/sdb1 /dev/sdc1

# Verify VG creation
sudo vgdisplay vg_database
sudo vgs
```

### 4. Logical Volume Creation (10 minutes)
```bash
# Create logical volumes
sudo lvcreate -L 100M -n lv_data vg_database
sudo lvcreate -L 50M -n lv_logs vg_database

# Create filesystems
sudo mkfs.xfs /dev/vg_database/lv_data
sudo mkfs.ext4 /dev/vg_database/lv_logs

# Verify LV creation
sudo lvdisplay
sudo lvs
```

### 5. Mount Configuration (10 minutes)
```bash
# Create mount points
sudo mkdir -p /database/data
sudo mkdir -p /database/logs

# Mount filesystems
sudo mount /dev/vg_database/lv_data /database/data
sudo mount /dev/vg_database/lv_logs /database/logs

# Configure automatic mounting
echo "/dev/vg_database/lv_data /database/data xfs defaults 0 2" | sudo tee -a /etc/fstab
echo "/dev/vg_database/lv_logs /database/logs ext4 defaults 0 2" | sudo tee -a /etc/fstab

# Test fstab configuration
sudo umount /database/data /database/logs
sudo mount -a
```

### 6. LVM Extension Practice (5 minutes)
```bash
# Extend logical volume
sudo lvextend -L +20M /dev/vg_database/lv_data

# Extend filesystem (XFS)
sudo xfs_growfs /database/data

# Verify extension
df -h /database/data
```

## Advanced Challenge: Swap Setup
```bash
# Use /dev/sdd for swap
sudo fdisk /dev/sdd
# Create partition, set type to 82 (swap)

sudo mkswap /dev/sdd1
sudo swapon /dev/sdd1

# Add to fstab
echo "/dev/sdd1 swap swap defaults 0 0" | sudo tee -a /etc/fstab

# Verify swap
swapon --show
free -h
```

## Verification Commands
```bash
# Check disk usage
lsblk
df -h

# Verify LVM components
sudo pvs
sudo vgs
sudo lvs

# Check mount points
mount | grep database
cat /etc/fstab

# Test filesystem types
findmnt -D
```

## Expected Results
- Two logical volumes mounted under /database/
- XFS filesystem on lv_data, ext4 on lv_logs
- Automatic mounting configured in /etc/fstab
- Swap partition active
- lv_data successfully extended

## Troubleshooting Tips
- If partition creation fails: Check disk availability with `lsblk`
- If LV extension fails: Ensure VG has free space with `vgs`
- If XFS resize fails: Filesystem must be mounted
- If fstab fails: Check syntax and device paths
- Always test fstab with `mount -a` before rebooting