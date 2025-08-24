# Module 15: System Troubleshooting & Recovery

## 1. Learning Objectives
- Master systematic troubleshooting methodologies
- Diagnose and resolve boot, network, and service failures
- Analyze system performance issues and resource constraints
- Recover from filesystem corruption and storage failures
- Troubleshoot SELinux, firewall, and security-related issues
- Implement preventive maintenance and monitoring strategies
- Document troubleshooting procedures and solutions

## 2. Key Concepts

### Troubleshooting Methodology
- **Problem identification**: Define symptoms and scope
- **Information gathering**: Collect system state and logs
- **Analysis**: Correlate data and identify root causes
- **Solution implementation**: Apply fixes systematically
- **Verification**: Confirm problem resolution
- **Documentation**: Record solutions for future reference

### System State Analysis
- **Boot process**: GRUB, kernel, systemd initialization
- **Service status**: systemd unit states and dependencies
- **Resource utilization**: CPU, memory, disk, network usage
- **Log analysis**: System and application log examination
- **Configuration validation**: Syntax and logical correctness

### Recovery Techniques
- **Boot recovery**: Rescue mode, emergency mode, single-user mode
- **Filesystem repair**: fsck, xfs_repair, data recovery
- **Service restoration**: Dependency resolution, configuration fixes
- **Network recovery**: Interface configuration, routing, DNS
- **Security recovery**: SELinux troubleshooting, permission fixes

### Diagnostic Tools
- **System information**: lscpu, lsmem, lsblk, lspci, lsusb
- **Performance monitoring**: top, htop, iotop, vmstat, iostat
- **Network diagnostics**: ping, traceroute, netstat, ss, tcpdump
- **Storage analysis**: df, du, lsof, fuser, blkid

## 3. Essential Commands

### System Information Gathering
```bash
# Hardware information
lscpu                                               # CPU information
lsmem                                               # Memory information
lsblk                                               # Block device information
lspci                                               # PCI device information
lsusb                                               # USB device information
dmidecode                                           # DMI/SMBIOS information

# System state
uptime                                              # System uptime and load
uname -a                                            # Kernel and system info
hostnamectl                                         # System hostname info
timedatectl                                         # Time and timezone info
systemctl status                                    # Overall system status
```

### Process and Resource Analysis
```bash
# Process monitoring
ps aux                                              # Process snapshot
ps -ef --forest                                    # Process tree
top -b -n1                                         # One-time top output
htop                                                # Interactive process viewer
pstree                                              # Process tree visualization

# Resource utilization
free -h                                             # Memory usage
df -h                                               # Disk usage
du -sh /path/*                                     # Directory sizes
lsof                                                # Open files
fuser -v /path/file                                # Processes using file
```

### Network Diagnostics
```bash
# Network connectivity
ping -c 4 target                                    # Test connectivity
traceroute target                                   # Route tracing
mtr target                                          # Combined ping/traceroute

# Network configuration
ip addr show                                        # Interface addresses
ip route show                                       # Routing table
ss -tulnp                                          # Socket statistics
netstat -rn                                        # Routing table (legacy)

# DNS resolution
nslookup hostname                                   # DNS lookup
dig hostname                                        # Detailed DNS query
host hostname                                       # Simple DNS lookup
```

### Service Troubleshooting
```bash
# Service analysis
systemctl status service_name                       # Service status
systemctl is-active service_name                   # Check if active
systemctl is-enabled service_name                  # Check if enabled
systemctl list-dependencies service_name           # Service dependencies

# Configuration validation
nginx -t                                            # Nginx config test
httpd -t                                            # Apache config test
sshd -T                                             # SSH config test
postfix check                                       # Postfix config test
```

### Log Analysis
```bash
# System logs
journalctl -b                                       # Current boot logs
journalctl --since "1 hour ago"                    # Recent logs
journalctl -u service_name                         # Service-specific logs
journalctl -p err                                  # Error-level messages
journalctl -f                                      # Follow logs (tail -f)

# Traditional logs
tail -f /var/log/messages                          # System messages
grep -i error /var/log/messages                    # Error messages
awk '/ERROR/ {print $1, $2, $3, $NF}' /var/log/secure  # Extract error info
```

## 4. Asghar Ghori's Approach

### Systematic Problem Analysis
Ghori emphasizes structured troubleshooting workflow:
```bash
# Step 1: Problem definition and scope
echo "Problem: Service X not responding"
echo "Scope: Single service on one server"
echo "Impact: Users cannot access application"
echo "Timeline: Started 2 hours ago"

# Step 2: Initial system health check
uptime && free -h && df -h
systemctl --failed                                 # Failed services
journalctl -p err --since "3 hours ago"           # Recent errors

# Step 3: Service-specific analysis
systemctl status httpd
journalctl -u httpd --since "3 hours ago"
httpd -t                                           # Config validation
```

### Boot Troubleshooting Methodology
Ghori's systematic boot problem resolution:
```bash
# Boot analysis workflow
# 1. Identify boot stage failure
dmesg | grep -i error                              # Kernel messages
journalctl -b | grep -i fail                      # Boot failures

# 2. GRUB issues
grub2-editenv list                                 # Check default kernel
grub2-mkconfig -o /boot/grub2/grub.cfg            # Regenerate GRUB config

# 3. Filesystem issues
mount | grep " / "                                 # Check root filesystem
fsck /dev/sda1                                     # Filesystem check (unmounted)

# 4. Service startup issues
systemctl list-units --failed                     # Failed services
systemctl list-jobs                               # Pending jobs
```

### Network Troubleshooting Steps
```bash
# Ghori's network diagnosis process
# 1. Physical/Link layer
ip link show                                       # Interface status
ethtool eth0                                       # Interface details

# 2. Network layer
ip addr show                                       # IP configuration
ip route show                                      # Routing table
ping -c 4 gateway_ip                              # Gateway connectivity

# 3. Application layer
ss -tulnp | grep :80                              # Service listening
curl -I http://localhost                          # Local service test
nmap -p 80 target_server                          # Remote service test
```

## 5. Sander van Vugt's Approach

### Advanced Diagnostic Techniques
Van Vugt focuses on deep system analysis:
```bash
# Comprehensive system performance analysis
# 1. CPU analysis
vmstat 1 10                                        # CPU and memory stats
mpstat 1 5                                         # Per-CPU statistics
sar -u 1 10                                        # CPU utilization over time

# 2. Memory analysis
vmstat -s                                          # Memory statistics
slabtop                                            # Kernel slab allocation
/proc/meminfo                                      # Detailed memory info

# 3. I/O analysis
iostat -x 1 10                                     # Extended I/O statistics
iotop                                              # I/O by process
lsof +D /path                                      # Files open in directory
```

### Root Cause Analysis Framework
Van Vugt's systematic root cause identification:
```bash
# Multi-layer analysis approach
# 1. Hardware layer
dmesg | grep -i "hardware error"                   # Hardware issues
mcelog --client                                    # Machine check errors
smartctl -a /dev/sda                               # Disk health

# 2. Kernel layer
dmesg | grep -i "kernel"                           # Kernel messages
cat /proc/sys/kernel/tainted                       # Kernel taint status
modinfo module_name                                # Module information

# 3. Application layer
strace -p PID                                      # System call tracing
ltrace -p PID                                      # Library call tracing
gdb --pid PID                                      # Debug running process
```

### Advanced Log Correlation
```bash
# Van Vugt's log correlation methodology
# 1. Timeline reconstruction
journalctl --since "2023-01-01 14:00" --until "2023-01-01 15:00" | head -50
aureport --start 01/01/2023 14:00:00 --end 01/01/2023 15:00:00

# 2. Multi-source correlation
# Combine system logs, application logs, and audit logs
tail -f /var/log/messages /var/log/secure /var/log/audit/audit.log

# 3. Pattern analysis
awk '/pattern/ {count++} END {print count}' /var/log/messages
grep -E "ERROR|CRITICAL|FATAL" /var/log/application.log | sort | uniq -c
```

## 6. Command Examples and Scenarios

### Scenario 1: Service Startup Failure
```bash
# Problem: Web server won't start after system reboot
# Systematic diagnosis:

# 1. Check service status
systemctl status httpd
systemctl is-enabled httpd

# 2. Check configuration
httpd -t
ls -la /etc/httpd/conf/httpd.conf

# 3. Check dependencies
systemctl list-dependencies httpd
systemctl status network.target

# 4. Check logs
journalctl -u httpd --since boot
grep httpd /var/log/messages

# 5. Check ports and firewall
ss -tulnp | grep :80
firewall-cmd --list-services
```

### Scenario 2: System Performance Degradation
```bash
# Problem: System running slowly, high load average
# Performance analysis:

# 1. Overall system health
uptime                                             # Load averages
free -h                                            # Memory usage
df -h                                              # Disk space

# 2. Process analysis
top -b -n1 -o %CPU | head -15                     # CPU-intensive processes
ps aux --sort=-%mem | head -10                    # Memory-intensive processes

# 3. I/O analysis
iostat -x 1 5                                     # I/O wait times
iotop -ao                                          # I/O by process

# 4. Network analysis
ss -s                                              # Socket summary
netstat -i                                         # Interface statistics
```

### Scenario 3: Boot Failure Recovery
```bash
# Problem: System won't boot, dropped to emergency shell
# Recovery procedure:

# 1. Check filesystem integrity
mount -o remount,rw /                              # Remount root writable
fsck /dev/sda2                                     # Check root filesystem

# 2. Check and fix fstab
cat /etc/fstab                                     # Review mount points
blkid                                              # Verify UUIDs

# 3. Regenerate initramfs if needed
dracut -f                                          # Force regenerate initramfs

# 4. Fix GRUB if necessary
grub2-install /dev/sda
grub2-mkconfig -o /boot/grub2/grub.cfg
```

## 7. Lab Exercises

### Lab 15A: Service and Configuration Troubleshooting (Ghori-focused)
**Time Limit**: 30 minutes
**Objective**: Diagnose and resolve common service configuration issues

**Prerequisites**:
- RHEL 9 system with intentionally misconfigured services
- Apache httpd and SSH services installed

**Setup** (Instructor creates these issues):
1. Apache httpd service fails to start due to configuration syntax error
2. SSH service running but refusing connections due to permission issue
3. Network service configured with conflicting IP addresses
4. Cron service not executing jobs due to permission problems

**Tasks**:
1. Identify and fix Apache configuration syntax error
2. Resolve SSH connection issues and verify remote access
3. Correct network configuration conflicts
4. Troubleshoot and fix cron job execution problems
5. Document all findings and solutions

**Verification Commands**:
```bash
systemctl status httpd sshd                        # Service status
curl http://localhost                               # Test web service
ssh localhost id                                   # Test SSH access
ip addr show                                        # Network configuration
crontab -l && grep CRON /var/log/cron             # Cron verification
```

### Lab 15B: Performance and Resource Troubleshooting (van Vugt-focused)
**Time Limit**: 35 minutes
**Objective**: Analyze and resolve system performance issues using advanced diagnostic techniques

**Prerequisites**:
- RHEL 9 system with performance monitoring tools installed
- Simulated high load conditions

**Setup** (Instructor creates these conditions):
1. Memory leak causing system slowdown
2. High I/O wait times due to disk issues
3. Network connectivity problems affecting services
4. CPU-intensive process consuming resources

**Tasks**:
1. Identify memory leak source and implement solution
2. Diagnose and resolve I/O performance bottleneck
3. Troubleshoot network connectivity issues
4. Find and manage resource-intensive processes
5. Create monitoring strategy to prevent recurrence

**Verification Commands**:
```bash
free -h && vmstat 1 3                              # Memory status
iostat -x 1 3                                      # I/O performance
ss -tulnp && ping -c 4 8.8.8.8                    # Network status
top -b -n1 | head -15                             # Process overview
```

### Lab 15C: Synthesis Challenge - Complete System Recovery
**Time Limit**: 45 minutes
**Objective**: Perform comprehensive system recovery using integrated troubleshooting methodologies

**Prerequisites**:
- RHEL 9 system with multiple simulated failures
- Access to rescue media and documentation

**Setup** (Multiple interconnected issues):
1. Boot failure due to corrupted filesystem
2. Network services not starting due to SELinux denials
3. Storage issues affecting application data
4. Security configuration preventing user access
5. Logging system failures hiding other issues

**Tasks**:
1. Recover system from boot failure using rescue mode
2. Resolve SELinux issues preventing service startup
3. Repair storage problems and recover application data
4. Fix security configuration issues
5. Restore logging functionality and analyze root causes
6. Implement preventive measures and monitoring
7. Create comprehensive incident report

**Advanced Requirements**:
- Combine both Ghori's systematic approach and van Vugt's deep analysis
- Use multiple diagnostic tools and correlation techniques
- Document complete recovery timeline and lessons learned

**Verification Commands**:
```bash
systemctl status && systemctl --failed             # Overall system health
mount && df -h                                     # Storage status
getenforce && ausearch -m AVC -ts recent          # SELinux status
journalctl --disk-usage && journalctl -p err      # Logging status
ss -tulnp | grep -E ":22|:80|:443"                # Critical services
```

## 8. Troubleshooting Common Issues

### Boot Failure Scenarios
```bash
# GRUB not loading
# Symptoms: System boots directly to BIOS/UEFI
# Solution: Reinstall GRUB bootloader
grub2-install /dev/sda
grub2-mkconfig -o /boot/grub2/grub.cfg

# Kernel panic
# Symptoms: Kernel panic messages, system halt
# Solution: Boot with older kernel or recovery mode
# From GRUB menu: select older kernel version

# Root filesystem corruption
# Symptoms: Cannot mount root filesystem
# Solution: Boot to rescue mode and run fsck
mount -o remount,ro /
fsck /dev/sda2                                     # Replace with correct device
mount -o remount,rw /
```

### Network Connectivity Issues
```bash
# No network connectivity
# Symptoms: Cannot reach external hosts
# Diagnosis and resolution:

# 1. Check interface status
ip link show                                       # Interface up/down status
nmcli device status                                # NetworkManager status

# 2. Check IP configuration
ip addr show                                       # IP addresses assigned
ip route show                                      # Routing table

# 3. Test connectivity layers
ping -c 4 127.0.0.1                               # Loopback test
ping -c 4 gateway_ip                              # Gateway test
ping -c 4 8.8.8.8                                 # External IP test
ping -c 4 google.com                              # DNS resolution test

# 4. Fix common issues
systemctl restart NetworkManager                   # Restart network service
nmcli connection up connection_name                # Bring up connection
```

### High Load and Performance Issues
```bash
# System running slowly
# Symptoms: High load average, slow response
# Analysis and solutions:

# 1. Identify resource constraints
uptime                                             # Load averages
free -h                                            # Memory availability
df -h                                              # Disk space

# 2. Find resource consumers
ps aux --sort=-%cpu | head -10                     # CPU usage
ps aux --sort=-%mem | head -10                     # Memory usage
iotop -ao                                          # I/O activity

# 3. Address specific issues
# Kill runaway processes
kill -TERM PID
kill -KILL PID                                     # If TERM doesn't work

# Clean up disk space
du -sh /var/log/* | sort -h                       # Find large log files
journalctl --vacuum-time=1week                    # Clean journal logs
```

### Service Dependencies and Failures
```bash
# Service won't start due to dependencies
# Symptoms: Service fails with dependency errors
# Resolution approach:

# 1. Check service dependencies
systemctl list-dependencies service_name
systemctl status dependency_service

# 2. Start dependencies manually
systemctl start dependency_service
systemctl enable dependency_service

# 3. Check for circular dependencies
systemctl show service_name | grep -E "Requires|After|Before"

# 4. Resolve configuration issues
# Check service configuration files
# Validate syntax where applicable
service_name -t                                    # If applicable
```

## 9. Best Practices

### Troubleshooting Methodology
- Document all symptoms before making changes
- Follow systematic approach from general to specific
- Make one change at a time and test results
- Keep detailed log of all actions taken
- Back up configuration files before modifications
- Have rollback plan for all changes

### Information Gathering
- Collect system information immediately when issue occurs
- Preserve log files and system state for analysis
- Use multiple information sources for correlation
- Take screenshots or save command output
- Interview users about what they were doing when issue occurred

### Solution Implementation
- Test solutions in non-production environment first
- Implement least disruptive solution first
- Monitor system closely after implementing fixes
- Document all changes made for future reference
- Verify that solution doesn't create new problems

### Preventive Measures
- Implement comprehensive monitoring and alerting
- Perform regular system health checks
- Keep system and applications updated
- Maintain current documentation and runbooks
- Regular backup and disaster recovery testing
- Train team on common troubleshooting procedures

## 10. Integration with Other RHCSA Topics

### Service Management Integration
- Understand systemd service dependencies and failures
- Troubleshoot service startup and runtime issues
- Analyze service logs and performance metrics
- Implement service monitoring and alerting

### Storage Integration
- Diagnose filesystem corruption and recovery procedures
- Troubleshoot LVM and storage performance issues
- Implement storage monitoring and capacity planning
- Recover from storage hardware failures

### Security Integration
- Troubleshoot SELinux denials and policy issues
- Diagnose firewall rule conflicts and connectivity problems
- Investigate security incidents and unauthorized access
- Implement security monitoring and incident response

### Network Integration
- Diagnose network connectivity and performance issues
- Troubleshoot DNS resolution and service discovery
- Analyze network traffic and security events
- Implement network monitoring and capacity planning

---

**Module 15 Summary**: System troubleshooting is the culmination of all RHCSA skills, requiring deep understanding of Linux system components and their interactions. This module provides comprehensive coverage of systematic troubleshooting methodologies, from basic problem identification to complex system recovery scenarios. Mastering both structured diagnostic approaches and advanced analysis techniques is essential for RHCSA certification and effective system administration in production environments. The synthesis of different troubleshooting philosophies ensures comprehensive problem-solving capabilities across all system components.