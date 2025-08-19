# RHCSA Exam Quick Reference

## Pre-Exam Checklist
- [ ] Verify VM access and connectivity
- [ ] Test sudo access
- [ ] Check available storage devices: `lsblk`
- [ ] Verify SELinux status: `getenforce`
- [ ] Note network interface names: `ip link show`

## Critical Command Syntax

### User Management
```bash
# User creation with options
useradd -u UID -g GROUP -G GROUPS -s SHELL -d HOMEDIR username

# Password aging
chage -M maxdays -m mindays -W warndays -d lastchange username

# Lock/unlock accounts
usermod -L username  # lock
usermod -U username  # unlock

# Sudo configuration
visudo  # always use this, never edit /etc/sudoers directly
```

### Storage and LVM
```bash
# Complete LVM workflow
pvcreate /dev/device
vgcreate vgname /dev/device
lvcreate -L size -n lvname vgname
mkfs.xfs /dev/vgname/lvname
mkdir /mountpoint
mount /dev/vgname/lvname /mountpoint

# Extend LV and filesystem
lvextend -L +size /dev/vgname/lvname
xfs_growfs /mountpoint  # for XFS
resize2fs /dev/vgname/lvname  # for ext4

# Partition types
fdisk: t -> 82 (swap), 8e (LVM), 83 (Linux)
```

### Network Configuration (nmcli)
```bash
# Static IP configuration
nmcli con modify CONNECTION ipv4.addresses IP/MASK
nmcli con modify CONNECTION ipv4.gateway GATEWAY
nmcli con modify CONNECTION ipv4.dns DNS1,DNS2
nmcli con modify CONNECTION ipv4.method manual
nmcli con up CONNECTION

# Show connections
nmcli con show
nmcli device status
```

### SELinux Management
```bash
# Status and mode
getenforce
setenforce 0|1
# Permanent: edit /etc/selinux/config

# File contexts
ls -Z filename
restorecon -Rv /path
semanage fcontext -a -t TYPE "/path(/.*)?"
restorecon -Rv /path

# Booleans
getsebool -a | grep boolean_name
setsebool -P boolean_name on

# Troubleshooting
ausearch -m AVC -ts recent
sealert -a /var/log/audit/audit.log
```

### Systemd Services
```bash
# Service management
systemctl start|stop|restart|reload SERVICE
systemctl enable|disable SERVICE
systemctl enable --now SERVICE  # enable and start
systemctl status SERVICE
systemctl list-units --type=service

# Targets
systemctl set-default TARGET
systemctl get-default
systemctl isolate TARGET

# Journal
journalctl -u SERVICE
journalctl -f  # follow
journalctl --since "1 hour ago"
journalctl -p err  # priority error and above
```

### Firewall (firewalld)
```bash
# Service management
firewall-cmd --add-service=SERVICE --permanent
firewall-cmd --add-port=PORT/PROTOCOL --permanent
firewall-cmd --reload
firewall-cmd --list-all

# Zones
firewall-cmd --get-active-zones
firewall-cmd --set-default-zone=ZONE
```

### Container Management (Podman)
```bash
# Basic operations
podman pull IMAGE
podman run -d --name NAME -p HOST:CONTAINER IMAGE
podman ps
podman logs CONTAINER

# Systemd integration
podman generate systemd --new --files --name CONTAINER
cp container-NAME.service /etc/systemd/system/
systemctl enable container-NAME.service
```

## Man Page Quick Navigation

### Essential Man Pages
- `man systemctl` - Service management
- `man nmcli` - Network configuration
- `man firewall-cmd` - Firewall management
- `man semanage` - SELinux management
- `man mount` - Filesystem mounting options
- `man crontab` - Cron scheduling syntax
- `man fstab` - Filesystem table format

### Man Page Navigation
- `/search_term` - Search forward
- `n` - Next search result
- `N` - Previous search result
- `q` - Quit
- `G` - Go to end
- `1G` - Go to beginning

## Time-Saving Tips

### Verification Commands
```bash
# Quick system overview
lsblk  # storage overview
systemctl --failed  # failed services
getenforce  # SELinux status
firewall-cmd --list-all  # firewall rules
mount | grep -v tmpfs  # mounted filesystems
```

### Common Gotchas
1. **SELinux contexts**: Always `restorecon -Rv` after file operations
2. **Firewall**: Remember `--permanent` and `--reload`
3. **Systemd**: Use `--now` to enable and start simultaneously
4. **LVM**: XFS uses `xfs_growfs`, ext4 uses `resize2fs`
5. **SSH**: Test connection before disabling password auth
6. **Cron**: Use `crontab -e`, not direct file editing

### Fast File Editing
```bash
# Quick configuration edits
echo "config_line" >> /etc/file  # append
sed -i 's/old/new/g' /etc/file  # replace
```

## Emergency Procedures

### Boot Issues
```bash
# GRUB rescue
# At GRUB menu: e -> linux line -> add rd.break
# mount -o remount,rw /sysroot
# chroot /sysroot
# passwd
# touch /.autorelabel
# exit; exit

# Systemd rescue
# At GRUB: systemd.unit=rescue.target
```

### SELinux Troubleshooting
```bash
# If service fails after SELinux changes
ausearch -m AVC -ts recent
sealert -a /var/log/audit/audit.log
# Look for suggested commands in output
```

### Network Issues
```bash
# Reset network connection
nmcli con down CONNECTION
nmcli con up CONNECTION

# Check interfaces
ip link show
ip addr show
```

## Exam Strategy

### Time Management
- **Hour 1**: Storage, users, basic services (40% of tasks)
- **Hour 2**: Network, SELinux, advanced services (40% of tasks)  
- **Hour 3**: Containers, troubleshooting, verification (20% of tasks)

### Task Prioritization
1. **High points, low risk**: User management, basic services
2. **High points, medium risk**: Storage, network configuration
3. **Medium points, high risk**: Complex SELinux, containers
4. **Always verify**: Each completed task immediately

### Common Mistakes
- Forgetting to make changes permanent (`--permanent`, `-P`)
- Not reloading services after configuration changes
- Skipping verification steps
- Spending too much time on one difficult task
- Not using man pages effectively

## Last-Minute Review

### Quick Syntax Check
```bash
# These should be muscle memory
systemctl enable --now httpd
firewall-cmd --add-service=http --permanent && firewall-cmd --reload
nmcli con modify ens33 ipv4.method manual ipv4.addresses 192.168.1.100/24
useradd -u 1001 -G wheel alice
chage -M 90 -W 7 alice
semanage fcontext -a -t httpd_exec_t "/web(/.*)?"
restorecon -Rv /web
```

Remember: **Accuracy over speed. Verify everything. Use man pages when uncertain.**