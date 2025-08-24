# Module 13: Scheduled Tasks & Automation

## 1. Learning Objectives
- Master cron and anacron scheduling systems
- Configure systemd timers for service automation
- Implement at and batch commands for one-time tasks
- Manage user access to scheduling systems
- Automate system maintenance tasks
- Monitor and troubleshoot scheduled tasks
- Design efficient automation strategies for system administration

## 2. Key Concepts

### Task Scheduling Systems in RHEL 9
- **cron**: Traditional time-based job scheduler
- **anacron**: Enhanced scheduler for systems not always running
- **systemd timers**: Modern systemd-based scheduling
- **at**: One-time task execution
- **batch**: Queue-based task execution

### Cron Architecture
- **crond**: Main cron daemon
- **User crontabs**: Individual user scheduling
- **System crontab**: `/etc/crontab` for system-wide tasks
- **Cron directories**: `/etc/cron.{hourly,daily,weekly,monthly}/`

### Systemd Timer Types
- **Realtime timers**: Calendar-based scheduling (like cron)
- **Monotonic timers**: Relative to system events (boot, service start)
- **Transient timers**: Temporary timers created on-the-fly

### Access Control
- **Allow files**: `/etc/cron.allow`, `/etc/at.allow`
- **Deny files**: `/etc/cron.deny`, `/etc/at.deny`
- **Default behavior**: If no allow file exists, all users except those in deny file can schedule tasks

## 3. Essential Commands

### Cron Management
```bash
# User crontab management
crontab -e                                           # Edit current user's crontab
crontab -l                                           # List current user's crontab
crontab -r                                           # Remove current user's crontab
crontab -u username -e                               # Edit another user's crontab (root only)

# System crontab files
/etc/crontab                                         # System-wide crontab
/etc/cron.d/                                         # Additional system cron files
/var/spool/cron/                                     # User crontab storage

# Cron service management
systemctl status crond
systemctl enable --now crond
systemctl restart crond
```

### Crontab Syntax
```bash
# Format: minute hour day_of_month month day_of_week command
# Fields:    0-59  0-23    1-31        1-12      0-7 (0 and 7 are Sunday)

# Special characters:
# *     - any value
# ,     - list separator (1,3,5)
# -     - range (1-5)
# /     - step values (*/5 = every 5)
# @     - special strings (@reboot, @daily, @hourly, @weekly, @monthly, @annually)

# Examples:
0 2 * * *     /usr/local/bin/backup.sh             # Daily at 2:00 AM
30 14 * * 1   /usr/bin/update-system               # Mondays at 2:30 PM  
0 */6 * * *   /usr/bin/system-check                # Every 6 hours
@daily        /usr/local/bin/cleanup.sh            # Once per day
@reboot       /usr/local/bin/startup.sh            # At system boot
```

### Systemd Timer Management
```bash
# List all timers
systemctl list-timers                               # Active timers
systemctl list-timers --all                        # All timers (active and inactive)

# Timer control
systemctl enable timer-name.timer
systemctl start timer-name.timer
systemctl status timer-name.timer
systemctl stop timer-name.timer

# View timer logs
journalctl -u timer-name.timer
journalctl -u timer-name.service
```

### At and Batch Commands
```bash
# Schedule one-time tasks with at
at 15:30                                            # Run at 3:30 PM today
at now + 2 hours                                    # Run in 2 hours
at 2:30 PM tomorrow                                 # Run at 2:30 PM tomorrow
at -f script.sh now + 5 minutes                     # Run script in 5 minutes

# At command interface
at> command to run
at> <Ctrl+D>                                        # End input

# Manage at jobs
atq                                                 # List queued at jobs
atrm job_number                                     # Remove at job
at -c job_number                                    # Show job details

# Batch command (runs when system load permits)
batch
batch> command to run
batch> <Ctrl+D>
```

### Access Control Management
```bash
# Cron access control
echo "username" >> /etc/cron.allow                  # Allow user
echo "username" >> /etc/cron.deny                   # Deny user
ls -la /etc/cron.{allow,deny}                       # Check existing files

# At access control
echo "username" >> /etc/at.allow                    # Allow user
echo "username" >> /etc/at.deny                     # Deny user

# Default permissions (if no allow file exists):
# - All users except root can use cron/at
# - Users listed in deny file cannot use cron/at
```

## 4. Asghar Ghori's Approach

### Systematic Cron Implementation
Ghori emphasizes step-by-step cron configuration:
```bash
# 1. Plan the task schedule
# Identify task frequency and timing requirements
# Document task dependencies and prerequisites

# 2. Create and test the script
cat > /usr/local/bin/system-backup.sh << 'EOF'
#!/bin/bash
# System backup script
BACKUP_DIR="/backup/$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/system-backup.tar.gz" /etc /home /var/log
echo "Backup completed at $(date)" >> /var/log/backup.log
EOF

chmod +x /usr/local/bin/system-backup.sh

# 3. Test script manually
/usr/local/bin/system-backup.sh

# 4. Add to crontab with logging
crontab -e
# Add: 0 3 * * * /usr/local/bin/system-backup.sh >> /var/log/cron-backup.log 2>&1
```

### Anacron Configuration for Laptops
Ghori's approach for systems not always running:
```bash
# Configure anacron in /etc/anacrontab
# period_in_days delay_in_minutes job-identifier command

# Example anacron entries:
1    10    backup.daily      /usr/local/bin/daily-backup.sh
7    20    backup.weekly     /usr/local/bin/weekly-backup.sh
30   30    backup.monthly    /usr/local/bin/monthly-backup.sh

# Anacron execution
anacron -f                                          # Force run all jobs
anacron -T                                          # Test configuration
```

### Cron Security Best Practices
```bash
# Ghori's security recommendations:
# 1. Use full paths in cron scripts
# 2. Set PATH variable in crontab
# 3. Redirect output for debugging
# 4. Use dedicated service accounts

# Example secure crontab entry:
PATH=/usr/local/bin:/usr/bin:/bin
MAILTO=admin@company.com
0 2 * * * /usr/local/bin/secure-backup.sh >> /var/log/backup.log 2>&1
```

## 5. Sander van Vugt's Approach

### Systemd Timer Implementation
Van Vugt emphasizes modern systemd timers over traditional cron:
```bash
# Create service unit file
cat > /etc/systemd/system/system-cleanup.service << 'EOF'
[Unit]
Description=Daily system cleanup
Wants=system-cleanup.timer

[Service]
Type=oneshot
ExecStart=/usr/local/bin/cleanup.sh
User=cleanup
Group=cleanup

[Install]
WantedBy=multi-user.target
EOF

# Create timer unit file
cat > /etc/systemd/system/system-cleanup.timer << 'EOF'
[Unit]
Description=Daily system cleanup timer
Requires=system-cleanup.service

[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=1800

[Install]
WantedBy=timers.target
EOF

# Enable and start timer
systemctl daemon-reload
systemctl enable --now system-cleanup.timer
```

### Advanced Timer Scheduling
Van Vugt's sophisticated timer configurations:
```bash
# Complex calendar specifications
OnCalendar=Mon,Tue,Wed,Thu,Fri *-*-* 02:00:00      # Weekdays at 2 AM
OnCalendar=*-*-* 00/3:00:00                        # Every 3 hours
OnCalendar=monthly                                 # First day of each month
OnCalendar=weekly                                  # Every Monday
OnCalendar=*-01,04,07,10-01 12:00:00              # Quarterly

# Monotonic timers
OnBootSec=15min                                    # 15 minutes after boot
OnStartupSec=1h                                    # 1 hour after systemd start
OnUnitActiveSec=2w                                 # 2 weeks after service activation

# Combined timer example
[Timer]
OnBootSec=10min
OnUnitActiveSec=1h
Persistent=true
```

### Timer Debugging and Analysis
```bash
# Van Vugt's timer troubleshooting approach
systemctl list-timers --all                       # Show all timer status
systemctl cat timer-name.timer                    # Show timer configuration
systemd-analyze calendar "Mon *-*-* 02:00:00"     # Validate calendar syntax

# Detailed timer analysis
systemctl show timer-name.timer                   # All timer properties
journalctl -u timer-name.timer -f                 # Follow timer logs
systemctl status timer-name.timer timer-name.service  # Combined status
```

## 6. Command Examples and Scenarios

### Scenario 1: System Maintenance Automation
```bash
# Comprehensive system maintenance crontab
# Edit: crontab -e

# Daily tasks
0 1 * * * /usr/sbin/updatedb                      # Update locate database
30 1 * * * /usr/bin/find /tmp -type f -atime +7 -delete  # Clean old temp files
0 2 * * * /usr/local/bin/backup-logs.sh           # Backup log files

# Weekly tasks
0 3 * * 0 /usr/bin/yum clean all                  # Clean package cache (Sunday)
30 3 * * 0 /usr/bin/package-security-update.sh    # Security updates

# Monthly tasks
0 4 1 * * /usr/local/bin/rotate-archives.sh       # Archive rotation
0 5 1 * * /usr/bin/find /var/log -name "*.gz" -mtime +365 -delete  # Old log cleanup
```

### Scenario 2: User-specific Task Scheduling
```bash
# User crontab for development environment
# Run as regular user: crontab -e

# Environment variables
PATH=/usr/local/bin:/usr/bin:/bin
SHELL=/bin/bash
MAILTO=developer@company.com

# Development tasks
0 9 * * 1-5 /home/user/bin/project-sync.sh        # Workday morning sync
*/15 * * * * /home/user/bin/check-services.sh     # Every 15 minutes
0 18 * * * /home/user/bin/daily-commit.sh         # End of day commit
0 0 * * 6 /home/user/bin/weekly-backup.sh         # Saturday midnight backup
```

### Scenario 3: One-time and Conditional Tasks
```bash
# Schedule immediate one-time tasks
echo "systemctl restart httpd" | at now + 5 minutes
echo "/usr/local/bin/maintenance.sh" | at 02:00 tomorrow

# Batch processing for resource-intensive tasks
echo "/usr/local/bin/generate-reports.sh" | batch
echo "/usr/local/bin/video-processing.sh" | batch

# Conditional execution in cron
*/5 * * * * [ $(uptime | cut -d',' -f4 | cut -d':' -f2 | cut -d' ' -f2) -lt 2.0 ] && /usr/local/bin/backup.sh
```

## 7. Lab Exercises

### Lab 13A: Cron and Anacron Configuration (Ghori-focused)
**Time Limit**: 25 minutes
**Objective**: Implement comprehensive cron-based task scheduling with proper security and logging

**Prerequisites**:
- RHEL 9 system with crond and anacron installed
- Multiple user accounts for testing access control

**Tasks**:
1. Create system-wide backup script that runs daily at 2:30 AM
2. Configure user crontab for log rotation every 6 hours
3. Set up anacron for weekly system updates (for laptop usage)
4. Implement cron access control allowing only specific users
5. Create monitoring script that checks cron job execution

**Verification Commands**:
```bash
crontab -l                                          # Check user crontab
cat /etc/crontab                                    # Check system crontab
ls -la /etc/cron.allow /etc/cron.deny              # Check access control
grep CRON /var/log/cron                            # Check cron execution logs
```

### Lab 13B: Systemd Timer Implementation (van Vugt-focused)
**Time Limit**: 30 minutes
**Objective**: Build modern systemd-based scheduling system with advanced timer features

**Prerequisites**:
- RHEL 9 system with systemd
- Understanding of systemd unit files

**Tasks**:
1. Create systemd service and timer for automated system cleanup
2. Configure calendar-based timer for business hours only (9 AM - 5 PM, weekdays)
3. Implement persistent timer that catches up missed executions
4. Set up monotonic timer for post-boot system configuration
5. Create timer with randomized delay for distributed execution

**Verification Commands**:
```bash
systemctl list-timers --all                        # Check all timers
systemctl status cleanup.timer cleanup.service     # Check timer status
journalctl -u cleanup.timer                        # Check timer logs
systemd-analyze calendar "Mon..Fri *-*-* 09..17:00:00"  # Validate calendar
```

### Lab 13C: Synthesis Challenge - Enterprise Task Scheduling
**Time Limit**: 35 minutes
**Objective**: Design comprehensive enterprise scheduling system combining all methodologies

**Prerequisites**:
- Multiple RHEL 9 systems for distributed scheduling
- Network connectivity for centralized monitoring

**Tasks**:
1. Design multi-tier scheduling system using both cron and systemd timers
2. Implement centralized task monitoring and alerting
3. Create backup scheduling with dependency management
4. Set up user-specific development environment automation
5. Design disaster recovery procedures for scheduling systems
6. Implement security hardening for all scheduled tasks

**Advanced Requirements**:
- Combine Ghori's systematic approach with van Vugt's modern timer techniques
- Implement cross-system task coordination
- Create automated failover mechanisms for critical tasks

**Verification Commands**:
```bash
systemctl list-timers && crontab -l                # Check all scheduling
grep -r "CRON\|Timer" /var/log/                    # Check execution logs
ss -tulnp | grep -E "(cron|systemd)"               # Check related services
find /etc -name "*cron*" -o -name "*.timer" | head -10  # Find config files
```

## 8. Troubleshooting Common Issues

### Cron Jobs Not Executing
```bash
# Symptoms: Scheduled tasks not running
# Check cron service status
systemctl status crond

# Check cron logs
journalctl -u crond
tail -f /var/log/cron

# Common issues:
# 1. Incorrect crontab syntax
crontab -l | head -5                                # Check syntax

# 2. Missing executable permissions
ls -la /path/to/script.sh
chmod +x /path/to/script.sh

# 3. PATH issues in script
# Add to script: PATH=/usr/local/bin:/usr/bin:/bin

# 4. User access denied
ls -la /etc/cron.{allow,deny}
```

### Environment Variables in Cron
```bash
# Symptoms: Script works manually but fails in cron
# Solution: Set environment variables in crontab

# Method 1: In crontab
SHELL=/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin
HOME=/home/username
MAILTO=admin@company.com

# Method 2: Source environment in script
#!/bin/bash
source /etc/environment
source ~/.bashrc
# Rest of script...
```

### Systemd Timer Not Triggering
```bash
# Symptoms: Timer exists but service doesn't run
# Check timer status
systemctl status timer-name.timer
systemctl list-timers timer-name.timer

# Check service dependencies
systemctl cat timer-name.timer
systemctl show timer-name.timer | grep Requires

# Verify calendar syntax
systemd-analyze calendar "Mon *-*-* 02:00:00"

# Check logs
journalctl -u timer-name.timer -f
journalctl -u timer-name.service
```

### At Jobs Not Running
```bash
# Symptoms: at command accepts job but doesn't execute
# Check atd service
systemctl status atd

# Check job queue
atq
at -c job_number                                    # Show job details

# Check permissions
ls -la /etc/at.{allow,deny}
ls -la /var/spool/at/

# Check logs
journalctl -u atd
tail -f /var/log/cron                               # at uses cron logging
```

### Permission Denied Errors
```bash
# Symptoms: Jobs fail with permission errors
# Check script ownership and permissions
ls -la /path/to/script.sh
chmod 755 /path/to/script.sh
chown username:group /path/to/script.sh

# Check SELinux contexts
ls -Z /path/to/script.sh
restorecon -v /path/to/script.sh

# Check sudo requirements for system tasks
# Add to /etc/sudoers if needed:
username ALL=(ALL) NOPASSWD: /usr/local/bin/script.sh
```

## 9. Best Practices

### Security Considerations
- Use full paths for all commands and scripts
- Set restrictive permissions on cron scripts (755 or 750)
- Implement proper logging and monitoring
- Use service accounts for system tasks
- Regularly review and audit scheduled tasks
- Implement access control using allow/deny files

### Performance Optimization
- Avoid scheduling multiple resource-intensive tasks simultaneously
- Use batch command for CPU-intensive tasks
- Implement task dependencies to prevent conflicts
- Monitor system resources during scheduled task execution
- Use randomized delays for distributed environments

### Error Handling and Monitoring
- Redirect output to log files for debugging
- Implement notification mechanisms for task failures
- Use MAILTO variable for cron error notifications
- Create monitoring scripts to verify task completion
- Maintain audit logs of all scheduled task changes

### Modern Scheduling Strategy
- Prefer systemd timers for new implementations
- Use persistent timers for critical tasks
- Implement proper service dependencies
- Leverage systemd's logging and status capabilities
- Design for easy monitoring and troubleshooting

## 10. Integration with Other RHCSA Topics

### Service Management Integration
- Schedule service restarts and updates
- Coordinate scheduled tasks with service dependencies
- Monitor service health through scheduled checks
- Implement service failover through automation

### Storage Integration
- Schedule filesystem cleanup and maintenance
- Automate backup and archive operations
- Monitor disk usage and implement alerts
- Coordinate with LVM operations for snapshots

### Security Integration
- Schedule security updates and patches
- Automate log analysis and security monitoring
- Coordinate with SELinux policy updates
- Implement automated security scanning

### Network Integration
- Schedule network monitoring and diagnostics
- Automate network configuration backups
- Coordinate with network service maintenance
- Implement distributed task coordination

---

**Module 13 Summary**: Task scheduling and automation are essential for maintaining efficient and reliable systems. This module provides comprehensive coverage of both traditional cron-based scheduling and modern systemd timer approaches. Understanding how to design, implement, and troubleshoot automated tasks is crucial for RHCSA certification and effective system administration. The synthesis of different scheduling methodologies ensures flexibility and reliability in diverse environments.