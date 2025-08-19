# Lab Scenario 4: RHCSA Exam Simulation

**VM:** rhel9a + rhel9b  
**Time Limit:** 180 minutes (3 hours)  
**Difficulty:** Exam-level

## Scenario
You are a system administrator tasked with configuring multiple systems for a small company. Complete all tasks within the time limit. Each task represents typical RHCSA exam objectives.

## Important Notes
- Use man pages when needed - internet is not available
- Verify each task before moving to the next
- Some tasks depend on others - read carefully
- Partial credit may be given for partially completed tasks

## Tasks - System A (rhel9a)

### Task 1: User and Group Management (15 minutes)
1. Create group `developers` with GID 3000
2. Create users:
   - `alice` (UID 3001, primary group developers, secondary group wheel)
   - `bob` (UID 3002, primary group developers, shell /sbin/nologin)
3. Set password aging for alice: max 60 days, min 5 days, warning 7 days
4. Configure sudo access for developers group to run systemctl commands without password

**Verification:**
```bash
id alice && id bob
groups alice
sudo -u alice systemctl status httpd
chage -l alice
```

### Task 2: Network Configuration (10 minutes)
1. Configure static IP 192.168.100.10/24 on primary interface
2. Set gateway to 192.168.100.1
3. Configure DNS servers: 8.8.8.8, 8.8.4.4
4. Set hostname to `server1.lab.local`

**Verification:**
```bash
ip addr show
cat /etc/resolv.conf
hostnamectl
ping -c 2 8.8.8.8
```

### Task 3: Firewall and SSH (10 minutes)
1. Configure firewall to allow SSH and HTTP services
2. Change SSH port to 2222
3. Disable SSH password authentication
4. Generate SSH key pair for alice and copy to system B

**Verification:**
```bash
firewall-cmd --list-services
ss -tlnp | grep :2222
ssh-keygen -l -f /home/alice/.ssh/id_rsa.pub
```

## Tasks - System B (rhel9b)

### Task 4: Storage Management (25 minutes)
1. Create 2GB partition on /dev/sdb, type Linux LVM
2. Create physical volume from the partition
3. Create volume group `vg_data` using the physical volume
4. Create logical volumes:
   - `lv_web` (1GB, XFS filesystem, mount at /web)
   - `lv_logs` (500MB, ext4 filesystem, mount at /logs)
5. Configure automatic mounting in /etc/fstab
6. Create 512MB swap partition on /dev/sdc and activate permanently

**Verification:**
```bash
lsblk
df -h | grep -E '/web|/logs'
swapon --show
cat /etc/fstab
```

### Task 5: Service Configuration (20 minutes)
1. Install and configure Apache HTTP server
2. Configure custom document root at /web/html
3. Create index.html with content "Welcome to Lab Server"
4. Configure Apache to start automatically at boot
5. Ensure service starts successfully with SELinux enforcing

**Verification:**
```bash
systemctl status httpd
curl http://localhost/
ls -Z /web/html/
getenforce
```

### Task 6: SELinux Management (15 minutes)
1. Ensure SELinux is in enforcing mode
2. Configure proper SELinux contexts for /web/html directory
3. If Apache fails to start, troubleshoot and fix SELinux issues
4. Enable httpd_can_network_connect boolean permanently

**Verification:**
```bash
getenforce
ls -Z /web/html/
getsebool httpd_can_network_connect
ausearch -m AVC -ts recent
```

## Combined Tasks (Both Systems)

### Task 7: Container Services (20 minutes)
**System A:**
1. Install podman
2. Pull registry.redhat.io/ubi8/nginx-118 image
3. Create container named `web-app` with port mapping 8080:8080
4. Configure container to start automatically with systemd
5. Ensure container survives reboot

**Verification:**
```bash
podman ps
curl http://localhost:8080
systemctl status container-web-app.service
```

### Task 8: Scheduled Tasks (10 minutes)
**System B:**
1. Create cron job for alice to backup /logs to /backup every day at 2:30 AM
2. Create at job to restart httpd service in 5 minutes
3. Configure logrotate for /logs/application.log (weekly, keep 4 weeks)

**Verification:**
```bash
crontab -u alice -l
atq
cat /etc/logrotate.d/application
```

### Task 9: File Permissions and ACLs (10 minutes)
**System A:**
1. Create directory /shared with group ownership developers
2. Set group sticky bit on /shared
3. Set default umask for developers group to 002
4. Use ACL to give bob read/write access to /shared/project.txt
5. Create /shared/project.txt owned by alice

**Verification:**
```bash
ls -ld /shared
getfacl /shared/project.txt
touch /shared/test && ls -l /shared/test
```

### Task 10: System Monitoring and Logs (10 minutes)
**Both Systems:**
1. Configure persistent systemd journal logging
2. Configure rsyslog to send all mail facility logs to /var/log/mailsystem.log
3. Find all files larger than 50MB in /var directory
4. Set nice value of -5 for any running httpd processes

**Verification:**
```bash
ls -la /var/log/journal/
tail /var/log/mailsystem.log
ps axo pid,ni,comm | grep httpd
```

## Troubleshooting Scenarios

If you encounter issues:

1. **Service won't start:** Check systemctl status, journalctl, and SELinux denials
2. **Network issues:** Verify nmcli settings and firewall rules
3. **Mount failures:** Check /etc/fstab syntax and filesystem types
4. **Permission denied:** Review file ownership, permissions, and SELinux contexts
5. **Container issues:** Check podman logs and systemd service status

## Scoring Guidelines

Each task is worth 10 points (100 points total):
- Full completion: 10 points
- Partial completion: 5-8 points
- Attempted but non-functional: 2-4 points
- Not attempted: 0 points

**Passing score: 70 points**

## Time Management Tips

- Spend no more than allocated time per task
- If stuck, move to next task and return if time permits
- Verify each task immediately after completion
- Use man pages efficiently - know what to look for
- Practice typing commands accurately under pressure

## Post-Lab Review

After completion:
1. Review any failed tasks and understand why
2. Time yourself on weak areas
3. Practice the troubleshooting scenarios separately
4. Identify which man pages you needed most often
5. Note any syntax errors made under pressure