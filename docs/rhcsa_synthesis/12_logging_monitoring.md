# Module 12: Logging & Monitoring

## 1. Learning Objectives
- Master systemd journald and traditional syslog logging systems
- Configure rsyslog for centralized log management
- Monitor system performance using built-in RHEL tools
- Set up log rotation and retention policies
- Implement log filtering and analysis techniques
- Configure system monitoring alerts and notifications
- Troubleshoot system issues using log analysis

## 2. Key Concepts

### Logging Architecture in RHEL 9
- **systemd-journald**: Primary logging daemon for systemd services
- **rsyslog**: Traditional syslog daemon for compatibility and advanced features
- **Log Storage**: Binary journal files and text-based syslog files
- **Log Forwarding**: Integration between journald and rsyslog

### Journal vs Syslog
- **Journal**: Binary format, structured metadata, automatic rotation
- **Syslog**: Text format, traditional facilities/priorities, manual rotation
- **Integration**: journald forwards to rsyslog for persistent storage

### Log Facilities and Priorities
```
Facilities: kern, user, mail, daemon, auth, syslog, lpr, news, uucp, cron, authpriv, ftp, local0-7
Priorities: emerg, alert, crit, err, warning, notice, info, debug
```

### System Monitoring Tools
- **top/htop**: Real-time process monitoring
- **vmstat**: Virtual memory statistics
- **iostat**: I/O statistics
- **sar**: System activity reporter
- **netstat/ss**: Network statistics

## 3. Essential Commands

### Journal Management
```bash
# View journal logs
journalctl                                            # All logs
journalctl -b                                         # Current boot
journalctl -b -1                                      # Previous boot
journalctl -f                                         # Follow (tail -f equivalent)
journalctl -u sshd                                    # Specific unit
journalctl -p err                                     # By priority level

# Time-based filtering
journalctl --since "2023-01-01 12:00:00"
journalctl --since yesterday
journalctl --since "1 hour ago"
journalctl --until "2023-12-31"

# Advanced filtering
journalctl -u httpd -p warning --since today
journalctl _PID=1234                                  # By process ID
journalctl _UID=1000                                  # By user ID
journalctl -k                                         # Kernel messages only
```

### Journal Configuration
```bash
# Journal persistence configuration
mkdir -p /var/log/journal
systemctl restart systemd-journald

# Journal storage limits
# Edit /etc/systemd/journald.conf:
SystemMaxUse=1G                                       # Maximum disk usage
SystemKeepFree=500M                                   # Minimum free space
MaxRetentionSec=1month                               # Maximum retention time

# Verify journal statistics
journalctl --disk-usage                              # Current disk usage
journalctl --vacuum-time=1week                       # Clean old entries
journalctl --vacuum-size=100M                        # Limit size
```

### Rsyslog Configuration
```bash
# Main configuration file: /etc/rsyslog.conf
# Additional configs: /etc/rsyslog.d/*.conf

# Basic rsyslog rules syntax:
# facility.priority    action
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
authpriv.*                                  /var/log/secure
mail.*                                      /var/log/maillog
cron.*                                      /var/log/cron

# Restart rsyslog after configuration changes
systemctl restart rsyslog
```

### Log Rotation Management
```bash
# Logrotate configuration
/etc/logrotate.conf                                   # Main config
/etc/logrotate.d/                                     # Service-specific configs

# Manual logrotate execution
logrotate -f /etc/logrotate.conf                      # Force rotation
logrotate -d /etc/logrotate.conf                      # Debug/dry-run
logrotate -v /etc/logrotate.conf                      # Verbose output

# Example logrotate configuration
cat > /etc/logrotate.d/custom << 'EOF'
/var/log/custom/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0644 root root
}
EOF
```

### System Monitoring Commands
```bash
# Process and memory monitoring
top                                                   # Real-time process viewer
htop                                                  # Enhanced process viewer
ps aux                                                # Process snapshot
free -h                                               # Memory usage
uptime                                                # System uptime and load

# I/O and disk monitoring
iostat -x 1                                           # I/O statistics
iotop                                                 # I/O by process
df -h                                                 # Disk usage
du -sh /path/*                                        # Directory sizes

# Network monitoring
ss -tulnp                                             # Socket statistics
netstat -i                                            # Network interface statistics
iftop                                                 # Network traffic by connection
```

## 4. Asghar Ghori's Approach

### Systematic Log Analysis Method
Ghori emphasizes structured log examination:
```bash
# Step-by-step log analysis workflow
# 1. Identify the time frame
journalctl --since "10 minutes ago" --until now

# 2. Filter by service or component
journalctl -u httpd --since "1 hour ago"

# 3. Focus on error levels
journalctl -p err --since today

# 4. Extract specific patterns
journalctl | grep -i "error\|fail\|denied"

# 5. Correlate with system events
journalctl -k --since "30 minutes ago"              # Kernel messages
```

### Rsyslog Centralization Setup
Ghori's approach to centralized logging:
```bash
# Server configuration (/etc/rsyslog.conf)
$ModLoad imudp
$UDPServerRun 514
$AllowedSender UDP, 192.168.1.0/24

# Client configuration
*.* @192.168.1.100:514                               # UDP forwarding
*.* @@192.168.1.100:514                              # TCP forwarding

# Restart services
systemctl restart rsyslog
firewall-cmd --add-port=514/udp --permanent
firewall-cmd --reload
```

### Performance Monitoring Workflow
```bash
# Ghori's systematic performance analysis
# 1. Overall system health
uptime && free -h && df -h

# 2. Process analysis
top -b -n1 | head -20
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10

# 3. I/O analysis
iostat -x 1 3
sar -d 1 5

# 4. Network analysis
ss -s                                                 # Socket summary
netstat -i                                           # Interface statistics
```

## 5. Sander van Vugt's Approach

### Advanced Journal Queries
Van Vugt focuses on sophisticated filtering techniques:
```bash
# Complex journal queries using field matching
journalctl _COMM=sshd _PID=1234                      # Multiple field filters
journalctl _SYSTEMD_UNIT=httpd.service + _SYSTEMD_UNIT=nginx.service  # OR logic
journalctl PRIORITY=3 _TRANSPORT=kernel              # Critical kernel messages

# JSON output for scripting
journalctl -o json --since today | jq '._PID'        # Extract PIDs with jq
journalctl -o json-pretty -n 5                       # Pretty JSON format

# Field discovery
journalctl -N                                         # List all field names
journalctl -F _SYSTEMD_UNIT                          # List all units
journalctl -F PRIORITY                               # List priority values
```

### Rsyslog Advanced Configuration
Van Vugt's sophisticated rsyslog setup:
```bash
# Template-based logging
# Add to /etc/rsyslog.conf:
$template CustomFormat,"%timegenerated% %HOSTNAME% %syslogtag% %msg%\n"
*.info;mail.none;authpriv.none    /var/log/messages;CustomFormat

# Property-based filtering
:programname, isequal, "sshd"    /var/log/ssh.log
:msg, contains, "error"          /var/log/errors.log
:msg, regex, "Failed.*from"      /var/log/failed_logins.log

# Rate limiting
$SystemLogRateLimitInterval 0                        # Disable rate limiting
$ModLoad imjournal                                   # Load journal module
$IMJournalStateFile imjournal.state                 # State file location
```

### SAR-based Long-term Monitoring
```bash
# Configure SAR data collection
# Edit /etc/sysconfig/sysstat
HISTORY=60                                           # Keep 60 days of data

# Manual SAR commands
sar -u 1 10                                          # CPU usage, 10 samples
sar -r 1 5                                           # Memory usage
sar -d 1 3                                           # Disk I/O
sar -n DEV 1 5                                       # Network statistics

# Historical analysis
sar -u -f /var/log/sa/sa15                          # CPU data from 15th
sar -A -s 09:00:00 -e 17:00:00                      # All stats, time range
```

## 6. Command Examples and Scenarios

### Scenario 1: Troubleshooting Service Failures
```bash
# Service failed to start - comprehensive analysis
systemctl status httpd                               # Service status
journalctl -u httpd --since "1 hour ago" -p err     # Recent errors
journalctl -xeu httpd                                # Detailed failure info

# Check configuration and permissions
httpd -t                                             # Test configuration
ls -la /etc/httpd/conf/                              # Check file permissions
semanage port -l | grep http                        # Check SELinux ports
```

### Scenario 2: Performance Investigation
```bash
# System running slowly - systematic analysis
# 1. Quick overview
uptime                                               # Load averages
free -h                                              # Memory usage
df -h                                                # Disk space

# 2. Process analysis
top -b -n1 -o %CPU | head -15                       # CPU-intensive processes
ps aux --sort=-%mem | head -10                      # Memory-intensive processes

# 3. I/O analysis
iostat -x 1 5                                       # I/O wait times
iotop -ao                                            # I/O by process

# 4. Log correlation
journalctl --since "30 minutes ago" -p warning      # Recent warnings
dmesg | tail -20                                     # Recent kernel messages
```

### Scenario 3: Security Event Analysis
```bash
# Investigating failed login attempts
journalctl -u sshd | grep "Failed password"         # SSH failures
grep "Failed password" /var/log/secure | tail -20   # Recent failures
lastb | head -10                                     # Bad logins

# Authentication analysis
journalctl _COMM=sudo --since today                 # Sudo usage
grep "authentication failure" /var/log/secure       # Auth failures
aureport --auth --summary                           # SELinux auth summary
```

## 7. Lab Exercises

### Lab 12A: Journal and Rsyslog Configuration (Ghori-focused)
**Time Limit**: 25 minutes
**Objective**: Configure comprehensive logging system with journal persistence and rsyslog customization

**Prerequisites**:
- RHEL 9 system with systemd and rsyslog installed
- Root access for configuration modifications

**Tasks**:
1. Configure journal persistence with 2GB maximum usage
2. Set up rsyslog to separate SSH logs to `/var/log/ssh.log`
3. Configure log rotation for SSH logs (daily, keep 30 days)
4. Create custom rsyslog template with hostname and timestamp
5. Forward all critical messages to remote server (simulated)

**Verification Commands**:
```bash
ls -la /var/log/journal/                             # Check journal persistence
grep -i ssh /etc/rsyslog.conf                       # Verify SSH logging config
tail -10 /var/log/ssh.log                           # Check SSH log file
cat /etc/logrotate.d/ssh                            # Check rotation config
```

### Lab 12B: System Monitoring and Analysis (van Vugt-focused)
**Time Limit**: 30 minutes
**Objective**: Implement comprehensive system monitoring using built-in tools

**Prerequisites**:
- RHEL 9 system with full monitoring tools installed
- Network connectivity for remote logging tests

**Tasks**:
1. Configure SAR to collect data every 2 minutes
2. Analyze system performance during high load simulation
3. Set up advanced journal queries to identify security events
4. Create monitoring script that alerts on high CPU usage
5. Generate performance report covering 24-hour period

**Verification Commands**:
```bash
crontab -l | grep sa                                 # Check SAR cron job
sar -u 1 3                                          # Test SAR functionality
journalctl -F _COMM | wc -l                         # Count unique commands
ls -la /var/log/sa/                                  # Check SAR data files
```

### Lab 12C: Synthesis Challenge - Complete Logging Infrastructure
**Time Limit**: 35 minutes
**Objective**: Build enterprise-grade logging and monitoring system

**Prerequisites**:
- Multiple RHEL 9 systems (or containers) for centralized logging
- Administrative access to all systems

**Tasks**:
1. Set up centralized rsyslog server with client forwarding
2. Configure journal with structured logging for application troubleshooting
3. Implement automated log analysis with alerting mechanisms
4. Create comprehensive monitoring dashboard using system tools
5. Design log retention policy balancing storage and compliance needs
6. Document incident response procedures using log analysis

**Advanced Requirements**:
- Combine both Ghori's systematic approach and van Vugt's advanced techniques
- Implement security-focused logging with audit integration
- Create automated scripts for common troubleshooting scenarios

**Verification Commands**:
```bash
ss -tulnp | grep :514                               # Check rsyslog server
journalctl --disk-usage                             # Check journal usage
grep "@@.*:514" /etc/rsyslog.conf                   # Verify log forwarding
systemctl status rsyslog systemd-journald           # Check service status
```

## 8. Troubleshooting Common Issues

### Journal Not Persisting
```bash
# Symptoms: Logs lost after reboot
# Solution: Enable persistent journal storage

# Create journal directory
mkdir -p /var/log/journal
chown root:systemd-journal /var/log/journal
chmod 2755 /var/log/journal

# Configure persistence in /etc/systemd/journald.conf
Storage=persistent
SystemMaxUse=1G

# Restart journald
systemctl restart systemd-journald
```

### High Log Volume Consuming Disk Space
```bash
# Symptoms: Logs filling up filesystem
# Solutions: Implement proper rotation and retention

# Emergency cleanup
journalctl --vacuum-time=1week
journalctl --vacuum-size=500M

# Configure journal limits in /etc/systemd/journald.conf
SystemMaxUse=2G
SystemKeepFree=1G
RuntimeMaxUse=200M

# Check logrotate configuration
logrotate -d /etc/logrotate.conf | grep -A5 -B5 error
```

### Rsyslog Not Receiving Remote Logs
```bash
# Symptoms: Central log server not receiving client logs
# Solution: Check network and configuration

# On server - check listening ports
ss -ulnp | grep :514
netstat -ulnp | grep :514

# Check firewall
firewall-cmd --list-services --permanent
firewall-cmd --add-service=syslog --permanent
firewall-cmd --reload

# Test connectivity from client
telnet logserver 514
logger -n logserver "Test message from client"
```

### Missing Log Entries
```bash
# Symptoms: Expected log entries not appearing
# Solution: Check service status and configuration

# Verify logging services
systemctl status systemd-journald rsyslog

# Check journal integration
grep -i "imjournal" /etc/rsyslog.conf
grep -i "ForwardToSyslog" /etc/systemd/journald.conf

# Test logging
logger "Test message"
journalctl -f &                                     # Monitor in background
logger "Another test message"
```

### Performance Impact from Logging
```bash
# Symptoms: System slowdown due to excessive logging
# Solution: Optimize logging configuration

# Check I/O impact
iostat -x 1 5                                       # Monitor disk I/O
iotop | grep -E "(rsyslog|journal)"                 # Check logging processes

# Optimize journal sync settings in /etc/systemd/journald.conf
SyncIntervalSec=60                                  # Reduce sync frequency
Storage=volatile                                    # Use memory storage temporarily

# Implement log filtering
# In /etc/rsyslog.conf:
:msg, regex, ".*verbose debug.*" stop              # Filter verbose messages
```

## 9. Best Practices

### Log Management Strategy
- Implement centralized logging for multi-server environments
- Configure appropriate retention policies based on compliance requirements
- Use structured logging formats for easier analysis
- Separate application logs from system logs
- Monitor log growth and implement automated cleanup

### Performance Optimization
- Balance between log detail and system performance
- Use asynchronous logging for high-volume applications
- Configure appropriate buffer sizes for network log forwarding
- Monitor I/O impact of logging operations
- Implement log compression for long-term storage

### Security Considerations
- Protect log files with appropriate permissions (640 or 644)
- Implement log integrity checking for critical systems
- Use encrypted connections for remote log forwarding
- Separate security logs from application logs
- Regular security log analysis and alerting

### Monitoring Best Practices
- Establish baseline performance metrics
- Set up automated alerting for critical thresholds
- Document normal system behavior patterns
- Create runbooks for common performance issues
- Regular review and analysis of monitoring data

## 10. Integration with Other RHCSA Topics

### Security Integration
- Correlate SELinux denials with application errors
- Monitor authentication and authorization events
- Track file permission changes and access attempts
- Integrate with audit subsystem for compliance logging

### Network Integration
- Monitor network service performance and errors
- Track connection attempts and failures
- Correlate network issues with system performance
- Monitor firewall rule effectiveness through logs

### Storage Integration
- Monitor filesystem usage and I/O performance
- Track LVM operations and storage events
- Correlate storage errors with application failures
- Monitor backup and restore operations

### Service Integration
- Monitor systemd service dependencies and failures
- Track service startup and shutdown times
- Correlate service errors with system events
- Monitor resource usage by services

---

**Module 12 Summary**: Effective logging and monitoring are essential for maintaining system health and security. This module combines traditional syslog management with modern systemd journal capabilities, providing comprehensive coverage of RHEL 9 logging infrastructure. Understanding both reactive troubleshooting through log analysis and proactive monitoring for performance optimization is crucial for RHCSA certification and production system management.