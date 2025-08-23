# 05 - Process & Service Management

**Navigation**: [← File Permissions](04_file_permissions.md) | [Index](index.md) | [Next → Package Management](06_package_management.md)

---

## 1. Executive Summary

**Topic Scope**: Process monitoring, control, systemd service management, and system targets in RHEL 9

**RHCSA Relevance**: Critical operational skill - process and service management is essential for system administration

**Exam Weight**: High - Service management and process control appear in multiple exam scenarios

**Prerequisites**: Basic understanding of Linux command line and system concepts

**Related Topics**: [Boot Process](11_boot_grub.md), [Logging](12_logging_monitoring.md), [Troubleshooting](15_troubleshooting.md)

---

## 2. Conceptual Foundation

### Core Theory
RHEL 9 uses systemd as the init system and service manager, which fundamentally changed how processes and services are managed:

- **Process hierarchy**: All processes descend from PID 1 (systemd)
- **Service units**: Standardized configuration for system services
- **Targets**: Groups of services that define system states
- **Dependencies**: Services can depend on other services or system states
- **Process control**: Signal-based communication for process management

### Real-World Applications
- **Web server management**: Starting, stopping, and monitoring Apache/Nginx
- **Database operations**: Managing MySQL/PostgreSQL service lifecycle
- **System maintenance**: Controlling system services during maintenance windows
- **Performance troubleshooting**: Identifying resource-intensive processes
- **Service reliability**: Ensuring critical services restart automatically

### Common Misconceptions
- **systemctl vs service**: Old `service` command still works but `systemctl` is preferred
- **Enable vs start**: Services must be both enabled (auto-start) and started (running now)
- **Process vs service**: Not all processes are services; services are managed processes
- **Kill vs terminate**: Different signals have different effects on processes
- **Targets vs runlevels**: systemd targets are more flexible than traditional runlevels

### Key Terminology
- **Process**: Running instance of a program with unique PID
- **Service**: Long-running process managed by systemd
- **Unit**: systemd configuration object (service, target, socket, etc.)
- **Target**: Group of units that define a system state
- **Signal**: Inter-process communication mechanism
- **Daemon**: Background process providing system services
- **Job**: systemd task for starting/stopping units
- **Slice**: Resource management group for processes

---

## 3. Command Mastery

### Process Monitoring Commands
```bash
# Basic process listing
ps aux                      # All processes, detailed format
ps -ef                      # All processes, full format
ps -eLf                     # Include threads
ps -o pid,ppid,user,comm    # Custom output format

# Dynamic process monitoring
top                         # Interactive process viewer
htop                        # Enhanced interactive viewer (if installed)
top -u username             # Filter by user
top -p PID                  # Monitor specific process

# Process hierarchy
pstree                      # Process tree view
pstree -p                   # Include PIDs
pstree username             # User's process tree

# Process information
pgrep processname           # Find process IDs by name
pidof processname           # Alternative to pgrep
ps -C processname           # Show processes by command name
lsof -p PID                 # Files opened by process
```

### Process Control Commands
```bash
# Process signals
kill PID                    # Send TERM signal (graceful termination)
kill -9 PID                 # Send KILL signal (force termination)
kill -HUP PID               # Send HUP signal (often reload config)
kill -USR1 PID              # Send USR1 signal (user-defined)
killall processname         # Kill all processes by name
pkill -u username           # Kill processes by user

# Job control
nohup command &             # Run command immune to hangups
command &                   # Run in background
jobs                        # List active jobs
fg %jobnumber              # Bring job to foreground
bg %jobnumber              # Send job to background
disown %jobnumber          # Remove job from shell's job table

# Process priority
nice -n 10 command          # Start with adjusted priority
renice 5 PID               # Change priority of running process
ionice -c 2 -n 7 PID       # Set I/O priority
```

### systemd Service Management
```bash
# Service status and control
systemctl status servicename        # Show service status
systemctl start servicename         # Start service
systemctl stop servicename          # Stop service
systemctl restart servicename       # Restart service
systemctl reload servicename        # Reload configuration
systemctl enable servicename        # Enable auto-start at boot
systemctl disable servicename       # Disable auto-start
systemctl mask servicename          # Prevent service from starting
systemctl unmask servicename        # Remove mask

# Service information
systemctl is-active servicename     # Check if running
systemctl is-enabled servicename    # Check if enabled
systemctl is-failed servicename     # Check if failed
systemctl list-units --type=service # List all services
systemctl list-unit-files --type=service # List service files

# Service dependencies
systemctl list-dependencies servicename    # Show dependencies
systemctl list-dependencies --reverse servicename # Reverse dependencies
```

### System Targets
```bash
# Target management
systemctl get-default               # Show default target
systemctl set-default target       # Set default target
systemctl isolate target           # Switch to target immediately
systemctl list-units --type=target # List active targets

# Common targets
systemctl isolate rescue.target    # Single-user mode
systemctl isolate multi-user.target # Multi-user (no GUI)
systemctl isolate graphical.target  # Multi-user with GUI
systemctl isolate poweroff.target   # Shutdown system
systemctl isolate reboot.target     # Restart system
```

### Advanced systemd Commands
```bash
# Unit file management
systemctl daemon-reload             # Reload systemd configuration
systemctl edit servicename          # Edit service override
systemctl cat servicename           # Show service unit file
systemctl show servicename          # Show all service properties

# System control
systemctl poweroff                  # Shutdown system
systemctl reboot                    # Restart system
systemctl suspend                   # Suspend to RAM
systemctl hibernate                 # Suspend to disk
systemctl hybrid-sleep              # Suspend to both RAM and disk
```

### Command Reference Table
| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `ps` | List processes | `aux`, `-ef`, `-C` | `ps aux | grep httpd` |
| `top` | Monitor processes | `-u`, `-p` | `top -u apache` |
| `kill` | Send signals | `-9`, `-HUP`, `-USR1` | `kill -HUP 1234` |
| `systemctl` | Manage services | `start`, `stop`, `enable`, `status` | `systemctl enable httpd` |
| `pgrep` | Find processes | `-u`, `-f` | `pgrep -u root sshd` |
| `nohup` | Run immune to hangups | `&` | `nohup ./script.sh &` |

---

## 4. Procedural Workflows

### Standard Procedure: Service Installation and Configuration
1. **Install and enable service**
   ```bash
   dnf install servicename
   systemctl enable servicename
   systemctl start servicename
   ```

2. **Verify service status**
   ```bash
   systemctl status servicename
   systemctl is-active servicename
   systemctl is-enabled servicename
   ```

3. **Configure service**
   ```bash
   # Edit main configuration
   vim /etc/servicename/config.conf
   
   # Or create systemd override
   systemctl edit servicename
   ```

4. **Apply changes**
   ```bash
   systemctl daemon-reload
   systemctl restart servicename
   systemctl status servicename
   ```

### Standard Procedure: Process Troubleshooting
1. **Identify problematic process**
   ```bash
   top                    # Look for high CPU/memory usage
   ps aux --sort=-%cpu    # Sort by CPU usage
   ps aux --sort=-%mem    # Sort by memory usage
   ```

2. **Gather process information**
   ```bash
   ps -p PID -o pid,ppid,user,cmd
   lsof -p PID           # Files opened by process
   strace -p PID         # System calls (use carefully)
   ```

3. **Take appropriate action**
   ```bash
   # Graceful termination
   kill PID
   
   # Force termination if needed
   kill -9 PID
   
   # Or restart associated service
   systemctl restart servicename
   ```

### Decision Tree: Process Management Strategy
```
Process Issue
├── High CPU usage?
│   ├── Expected behavior? → Monitor and document
│   └── Unexpected? → Investigate cause, consider restart
├── High memory usage?
│   ├── Memory leak suspected? → Restart service
│   └── Normal operation? → Check system capacity
├── Process not responding?
│   ├── Try graceful termination → kill PID
│   └── If unsuccessful → kill -9 PID
└── Service keeps failing?
    ├── Check logs → journalctl -u servicename
    ├── Verify configuration
    └── Check dependencies
```

### Standard Procedure: System Target Management
1. **Check current target**
   ```bash
   systemctl get-default
   who -r                # Alternative method
   ```

2. **Change target temporarily**
   ```bash
   systemctl isolate multi-user.target
   ```

3. **Change default target**
   ```bash
   systemctl set-default graphical.target
   ```

4. **Verify target change**
   ```bash
   systemctl get-default
   systemctl list-units --type=target
   ```

---

## 5. Configuration Deep Dive

### systemd Unit Files
#### Service Unit Structure
```bash
# /etc/systemd/system/myservice.service
[Unit]
Description=My Custom Service
After=network.target
Requires=network.target

[Service]
Type=simple
User=myuser
Group=mygroup
ExecStart=/usr/local/bin/myservice
ExecStop=/bin/kill -TERM $MAINPID
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
```

#### Common Unit File Sections
```bash
[Unit]
Description=Service description
Documentation=man:service(8)
After=dependency.service
Before=dependent.service
Requires=hard.dependency
Wants=soft.dependency
Conflicts=conflicting.service

[Service]
Type=simple|forking|oneshot|notify|idle
ExecStart=/path/to/executable
ExecStop=/path/to/stop/command
ExecReload=/path/to/reload/command
User=username
Group=groupname
Restart=no|on-success|on-failure|on-abnormal|on-watchdog|always
RestartSec=seconds

[Install]
WantedBy=target.target
RequiredBy=target.target
Also=other.service
```

### Process Priority and Nice Values
#### Understanding Priority
```bash
# Nice values range from -20 (highest priority) to 19 (lowest priority)
# Default nice value is 0
# Only root can set negative nice values

# Examples:
nice -n 10 ./cpu-intensive-task     # Lower priority
nice -n -10 ./critical-task         # Higher priority (root only)
renice 5 1234                       # Change running process priority
```

### Resource Control with systemd
#### Systemd Slices and Resource Limits
```bash
# Create custom slice for resource management
# /etc/systemd/system/myapp.slice
[Unit]
Description=My Application Slice
Before=slices.target

[Slice]
CPUQuota=50%
MemoryLimit=1G
TasksMax=100
```

#### Service Resource Limits
```bash
# In service unit file [Service] section:
CPUQuota=50%                # Limit CPU usage to 50%
MemoryLimit=512M            # Limit memory to 512MB
TasksMax=50                 # Limit number of tasks
IOWeight=100                # I/O priority weight
```

---

## 6. Hands-On Labs

### Lab 6.1: Process Monitoring and Control (Asghar Ghori Style)
**Objective**: Master process identification, monitoring, and control techniques

**Steps**:
1. **Start background processes for testing**
   ```bash
   # Create some test processes
   sleep 300 &
   PID1=$!
   dd if=/dev/zero of=/dev/null &
   PID2=$!
   find / -name "*.log" > /dev/null 2>&1 &
   PID3=$!
   
   echo "Started processes: $PID1 $PID2 $PID3"
   ```

2. **Practice process monitoring**
   ```bash
   # View all processes
   ps aux | head -20
   
   # Find specific processes
   ps aux | grep sleep
   pgrep sleep
   pidof sleep
   
   # Monitor resource usage
   top -p $PID1,$PID2,$PID3
   # Press 'q' to quit top
   
   # View process tree
   pstree $$    # Show tree from current shell
   ```

3. **Practice process control**
   ```bash
   # Send different signals
   kill -USR1 $PID1        # User signal (sleep will ignore)
   kill -STOP $PID2        # Suspend process
   kill -CONT $PID2        # Resume process
   
   # Check process status
   ps -o pid,state,comm -p $PID1,$PID2,$PID3
   
   # Terminate processes
   kill $PID1              # Graceful termination
   kill -9 $PID2           # Force termination
   killall find            # Kill by name
   ```

4. **Practice job control**
   ```bash
   # Start job in foreground
   sleep 100
   # Press Ctrl+Z to suspend
   
   # Manage jobs
   jobs                    # List jobs
   bg %1                   # Send to background
   fg %1                   # Bring to foreground
   # Press Ctrl+C to terminate
   ```

**Verification**:
```bash
# Verify no test processes remain
ps aux | grep -E "(sleep|dd|find)" | grep -v grep
jobs                     # Should show no jobs
```

### Lab 6.2: systemd Service Management (Sander van Vugt Style)
**Objective**: Master systemd service lifecycle and configuration

**Steps**:
1. **Explore existing services**
   ```bash
   # List all services
   systemctl list-units --type=service --all
   
   # Check specific service status
   systemctl status sshd
   systemctl is-active sshd
   systemctl is-enabled sshd
   
   # View service dependencies
   systemctl list-dependencies sshd
   systemctl list-dependencies --reverse sshd
   ```

2. **Practice service control**
   ```bash
   # Work with chronyd (time synchronization)
   systemctl status chronyd
   systemctl stop chronyd
   systemctl status chronyd
   systemctl start chronyd
   systemctl reload chronyd    # If reload is supported
   systemctl restart chronyd
   ```

3. **Configure service startup**
   ```bash
   # Check and modify service enablement
   systemctl is-enabled chronyd
   systemctl disable chronyd
   systemctl is-enabled chronyd
   systemctl enable chronyd
   systemctl is-enabled chronyd
   ```

4. **Explore service configuration**
   ```bash
   # View service unit file
   systemctl cat chronyd
   
   # Show all service properties
   systemctl show chronyd | head -20
   
   # Create service override (don't actually modify)
   systemctl edit chronyd --drop-in=custom
   # This would open an editor, but let's skip actual changes
   ```

**Verification**:
```bash
# Verify service is properly configured
systemctl status chronyd
systemctl is-active chronyd
systemctl is-enabled chronyd
```

### Lab 6.3: Custom Service Creation (Synthesis Challenge)
**Objective**: Create and manage a custom systemd service

**Scenario**: Create a custom web log monitor service that watches for specific patterns in web server logs

**Requirements**:
- Service runs as non-root user
- Automatically restarts if it fails
- Starts after network is available
- Can be stopped and started with systemctl

**Solution Steps**:
1. **Create the monitoring script**
   ```bash
   sudo mkdir -p /opt/logmonitor
   sudo tee /opt/logmonitor/weblog-monitor.sh << 'EOF'
   #!/bin/bash
   # Simple web log monitor
   
   LOGFILE="/var/log/httpd/access_log"
   MONITOR_LOG="/var/log/logmonitor.log"
   
   # Create log file if it doesn't exist
   touch "$MONITOR_LOG"
   
   echo "$(date): Web log monitor started" >> "$MONITOR_LOG"
   
   while true; do
       # Monitor for 404 errors (customize as needed)
       if tail -n 1 "$LOGFILE" 2>/dev/null | grep -q " 404 "; then
           echo "$(date): 404 error detected" >> "$MONITOR_LOG"
       fi
       sleep 5
   done
   EOF
   
   sudo chmod +x /opt/logmonitor/weblog-monitor.sh
   ```

2. **Create service user**
   ```bash
   sudo useradd -r -s /sbin/nologin -d /opt/logmonitor logmonitor
   sudo chown -R logmonitor:logmonitor /opt/logmonitor
   sudo touch /var/log/logmonitor.log
   sudo chown logmonitor:logmonitor /var/log/logmonitor.log
   ```

3. **Create systemd service unit**
   ```bash
   sudo tee /etc/systemd/system/weblog-monitor.service << 'EOF'
   [Unit]
   Description=Web Log Monitor Service
   Documentation=man:tail(1)
   After=network.target httpd.service
   Wants=network.target
   
   [Service]
   Type=simple
   User=logmonitor
   Group=logmonitor
   ExecStart=/opt/logmonitor/weblog-monitor.sh
   ExecStop=/bin/kill -TERM $MAINPID
   Restart=always
   RestartSec=30
   StandardOutput=journal
   StandardError=journal
   
   [Install]
   WantedBy=multi-user.target
   EOF
   ```

4. **Enable and test the service**
   ```bash
   # Reload systemd configuration
   sudo systemctl daemon-reload
   
   # Enable and start the service
   sudo systemctl enable weblog-monitor
   sudo systemctl start weblog-monitor
   
   # Check service status
   sudo systemctl status weblog-monitor
   
   # Test service functionality
   sudo systemctl stop weblog-monitor
   sudo systemctl start weblog-monitor
   sudo systemctl restart weblog-monitor
   ```

5. **Monitor and verify service**
   ```bash
   # Check service logs
   sudo journalctl -u weblog-monitor -f --no-pager
   # Press Ctrl+C to stop following
   
   # Verify service is running as correct user
   ps aux | grep weblog-monitor
   
   # Check if service auto-restarts (simulate crash)
   sudo pkill -f weblog-monitor.sh
   sleep 35  # Wait for restart
   sudo systemctl status weblog-monitor
   ```

**Verification**:
```bash
# Complete service verification
sudo systemctl is-active weblog-monitor
sudo systemctl is-enabled weblog-monitor
sudo journalctl -u weblog-monitor --no-pager -n 10
ls -l /var/log/logmonitor.log
```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: Service Won't Start
**Symptoms**:
- `systemctl start` fails with error
- Service shows "failed" status
- Application not responding

**Diagnosis**:
```bash
# Check service status and errors
systemctl status servicename
systemctl --failed

# View detailed logs
journalctl -u servicename --no-pager
journalctl -xe

# Check service dependencies
systemctl list-dependencies servicename
```

**Resolution**:
```bash
# Fix common issues
systemctl daemon-reload      # Reload if unit file changed
systemctl reset-failed      # Clear failed status

# Check and fix configuration
systemctl cat servicename   # Review unit file
vim /etc/servicename/config  # Fix application config

# Restart dependencies if needed
systemctl restart dependency.service
systemctl start servicename
```

**Prevention**: Always test configuration changes before applying to production

#### Issue 2: High System Load
**Symptoms**:
- System responds slowly
- High load average
- Applications timing out

**Diagnosis**:
```bash
# Check system load
uptime
top
htop (if available)

# Identify resource-intensive processes
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10

# Check I/O activity
iotop (if available)
iostat 1 5
```

**Resolution**:
```bash
# Adjust process priorities
renice 10 PID              # Lower priority
ionice -c 3 PID           # Idle I/O class

# Restart problematic services
systemctl restart servicename

# Kill runaway processes if necessary
kill PID
kill -9 PID  # If graceful doesn't work
```

#### Issue 3: Process Won't Terminate
**Symptoms**:
- Process ignores TERM signal
- `kill` command has no effect
- Process shows as zombie

**Diagnosis**:
```bash
# Check process state
ps -o pid,ppid,state,comm -p PID

# Check what process is doing
lsof -p PID
strace -p PID (use carefully)

# Check for zombie processes
ps aux | grep -E '<defunct>|<zombie>'
```

**Resolution**:
```bash
# Try escalating signals
kill PID           # TERM signal
sleep 5
kill -QUIT PID     # QUIT signal
sleep 5  
kill -9 PID        # KILL signal (last resort)

# For zombie processes, kill parent
ps -o pid,ppid -p PID
kill PPID
```

### Diagnostic Command Sequence
```bash
# Service troubleshooting workflow
systemctl status servicename    # Check service status
journalctl -u servicename       # Check service logs
systemctl cat servicename       # Review unit file
ps aux | grep servicename       # Check if process running
lsof -i :port                   # Check port usage
```

### Log File Analysis
- **`journalctl`**: Primary systemd log viewer
- **`/var/log/messages`**: General system messages
- **`/var/log/secure`**: Authentication and security events
- **Service-specific logs**: Application logs in `/var/log/`

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance
```bash
# Process monitoring
ps aux                          # List all processes
top                            # Interactive process monitor
pgrep processname              # Find process by name
kill PID                       # Terminate process

# Service management
systemctl start servicename    # Start service
systemctl stop servicename     # Stop service
systemctl enable servicename   # Enable auto-start
systemctl status servicename   # Check service status

# System targets
systemctl get-default          # Show default target
systemctl isolate target       # Switch to target
```

### Important Signals
- **TERM (15)**: Graceful termination (default for `kill`)
- **KILL (9)**: Force termination (cannot be caught)
- **HUP (1)**: Hangup (often used to reload config)
- **STOP (19)**: Suspend process
- **CONT (18)**: Resume suspended process

### Common systemd Targets
- **poweroff.target**: Shutdown system
- **rescue.target**: Single-user mode
- **multi-user.target**: Multi-user, no GUI
- **graphical.target**: Multi-user with GUI
- **reboot.target**: Restart system

### Process States
- **R**: Running or runnable
- **S**: Sleeping (waiting for event)
- **D**: Uninterruptible sleep (usually I/O)
- **T**: Stopped (by signal)
- **Z**: Zombie (terminated but not cleaned up)

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What's the difference between `systemctl start` and `systemctl enable`?
   **Answer**: `start` immediately begins running the service, while `enable` configures the service to start automatically at boot. A service can be enabled but not running, or running but not enabled. For complete setup, you typically need both commands.

2. **Question**: Why might a process become a zombie?
   **Answer**: A zombie process occurs when a child process has finished executing but its parent hasn't read its exit status yet. The process entry remains in the process table until the parent calls wait(). If the parent never calls wait() or terminates, the zombie persists.

3. **Question**: What happens when you send SIGKILL (-9) to a process?
   **Answer**: SIGKILL cannot be caught or ignored by the process - the kernel immediately terminates it. This bypasses any cleanup code, potentially leaving files open, shared memory segments allocated, or other resources in an inconsistent state. Use only as a last resort.

### Practical Scenarios
1. **Scenario**: A web service keeps crashing and needs to restart automatically.
   **Solution**: Configure the systemd service with `Restart=always` and `RestartSec=30` in the `[Service]` section of the unit file.

2. **Scenario**: You need to temporarily stop a service without preventing future automatic starts.
   **Solution**: Use `systemctl stop servicename`. This stops the service but leaves it enabled, so it will still start automatically at next boot.

### Command Challenges
1. **Challenge**: Find all processes owned by the user "apache" and show their CPU usage.
   **Answer**: `ps -u apache -o pid,user,%cpu,comm`
   **Explanation**: `-u apache` filters by user, `-o` specifies custom output format

2. **Challenge**: Create a command to monitor the top 5 CPU-consuming processes, updating every 2 seconds.
   **Answer**: `top -n 0 -d 2 | head -12 | tail -5` or use `watch -n 2 "ps aux --sort=-%cpu | head -5"`

---

## 10. Exam Strategy

### Topic-Specific Tips
- Always use `systemctl status` to verify service operations
- Remember to both `enable` and `start` services for complete setup
- Practice signal usage - know when to use graceful vs force termination
- Understand systemd dependencies - services may fail if dependencies aren't met

### Common Exam Scenarios
1. **Scenario**: Configure a service to start automatically at boot
   **Approach**: Use `systemctl enable servicename` then `systemctl start servicename`

2. **Scenario**: Troubleshoot a service that won't start
   **Approach**: Check `systemctl status`, review `journalctl -u servicename`, verify dependencies

3. **Scenario**: Find and terminate a runaway process
   **Approach**: Use `top` or `ps` to identify, then `kill` with appropriate signal

### Time Management
- **Basic service operations**: 2-3 minutes including verification
- **Process troubleshooting**: 5-7 minutes depending on complexity
- **Custom service creation**: 8-10 minutes for complete setup
- **Always verify**: Check service status after changes

### Pitfalls to Avoid
- Don't forget to `systemctl daemon-reload` after editing unit files
- Remember that stopping a service doesn't disable it (still starts at boot)
- Avoid `kill -9` unless absolutely necessary - try graceful termination first
- Check service dependencies - some services require others to be running
- Verify both that service is running AND enabled for boot

---

## Summary

### Key Takeaways
- **systemd is the modern service manager** - master its commands and concepts
- **Process management requires understanding signals** - different signals have different effects
- **Service dependencies matter** - services may fail if dependencies aren't met
- **Always verify changes** - check status after making service modifications

### Critical Commands to Remember
```bash
systemctl start servicename                 # Start service now
systemctl enable servicename                # Start service at boot  
systemctl status servicename                # Check service status
ps aux                                       # List all processes
kill PID                                     # Graceful process termination
journalctl -u servicename                   # View service logs
```

### Next Steps
- Continue to [Module 06: Package Management](06_package_management.md)
- Practice service management in the Vagrant environment
- Review related topics: [Boot Process](11_boot_grub.md), [Logging](12_logging_monitoring.md)

---

**Navigation**: [← File Permissions](04_file_permissions.md) | [Index](index.md) | [Next → Package Management](06_package_management.md)