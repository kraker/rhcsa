# 09 - SELinux Management

**Navigation**: [← Network Configuration](08_networking.md) | [Index](index.md) | [Next → Firewall Configuration](10_firewall.md)

---

## 1. Executive Summary

**Topic Scope**: SELinux configuration, contexts, booleans, troubleshooting, and security policy management in RHEL 9

**RHCSA Relevance**: Critical security topic - SELinux is a major component of RHEL security and frequently tested

**Exam Weight**: High - SELinux tasks are complex and carry significant point values on the exam

**Prerequisites**: Understanding of Linux file permissions, processes, and network services

**Related Topics**: [File Permissions](04_file_permissions.md), [Process Management](05_process_service_management.md), [Firewall](10_firewall.md)

---

## 2. Conceptual Foundation

### Core Theory
SELinux (Security-Enhanced Linux) is a Mandatory Access Control (MAC) system that provides an additional layer of security beyond traditional discretionary access controls:

- **Mandatory Access Control**: System enforces security policies that users cannot override
- **Security contexts**: Every process and file has a security context (labels)
- **Policy enforcement**: Rules determine what processes can access what resources
- **Multi-level security**: Supports classification levels and compartmentalization
- **Least privilege**: Processes run with minimal required permissions

### Real-World Applications
- **Web server security**: Preventing web applications from accessing system files
- **Database protection**: Isolating database processes from unauthorized file access
- **Container security**: Providing isolation between containers and host system
- **Compliance**: Meeting security requirements for government and enterprise environments
- **Threat mitigation**: Limiting damage from compromised applications

### Common Misconceptions
- **SELinux breaks things**: Properly configured SELinux enhances security without breaking functionality
- **Just disable it**: Disabling SELinux removes a critical security layer
- **Too complex**: Understanding basic concepts makes SELinux manageable
- **Performance impact**: Modern SELinux has minimal performance overhead
- **All or nothing**: SELinux can be selectively configured for different services

### Key Terminology
- **Security Context**: Label format (user:role:type:level) assigned to processes and files
- **Type Enforcement**: Primary SELinux access control mechanism using type labels
- **Domain**: Security context type assigned to processes
- **Type**: Security context label for files and directories
- **Boolean**: Runtime switch to enable/disable specific SELinux policy rules
- **Policy**: Set of rules defining allowed interactions between domains and types
- **AVC (Access Vector Cache)**: SELinux access decisions and denials
- **Confined/Unconfined**: Whether a process is subject to SELinux restrictions

---

## 3. Command Mastery

### SELinux Status and Mode Commands
```bash
# Check SELinux status
getenforce                      # Show current enforcement mode
sestatus                        # Detailed SELinux status
sestatus -v                     # Verbose status with policy details

# Change SELinux mode
setenforce 0                    # Set to permissive (temporary)
setenforce 1                    # Set to enforcing (temporary)
setenforce Enforcing            # Alternative syntax
setenforce Permissive           # Alternative syntax

# Permanent mode changes (requires reboot)
# Edit /etc/selinux/config:
# SELINUX=enforcing|permissive|disabled
```

### Context Management Commands
```bash
# View file contexts
ls -Z file                      # Show file security context
ls -lZ /path/                   # Show directory contents with contexts
stat filename                   # Includes SELinux context information

# View process contexts  
ps -eZ                          # All processes with contexts
ps -eZ | grep processname       # Specific process contexts
ps auxZ                         # Alternative format with contexts

# Change file contexts
chcon -t httpd_exec_t /path/file        # Change type only
chcon -R -t httpd_config_t /path/dir/   # Recursive type change
chcon --reference=/etc/passwd /path/file # Copy context from reference

# Restore default contexts
restorecon /path/file           # Restore single file
restorecon -R /path/dir/        # Restore directory recursively
restorecon -Rv /path/dir/       # Verbose recursive restore
```

### Context Policy Management
```bash
# View context policies
semanage fcontext -l            # List all file context policies
semanage fcontext -l | grep httpd  # Show HTTP-related contexts

# Add new context policies
semanage fcontext -a -t httpd_exec_t "/opt/webapp/bin/.*"
semanage fcontext -a -t httpd_config_t "/opt/webapp/conf(/.*)?"

# Modify existing context policies  
semanage fcontext -m -t httpd_log_t "/var/log/webapp/.*"

# Delete context policies
semanage fcontext -d "/opt/webapp/bin/.*"

# Apply context policies to files
semanage fcontext -a -t httpd_exec_t "/opt/webapp/bin/.*"
restorecon -Rv /opt/webapp/bin/
```

### Boolean Management
```bash
# List SELinux booleans
getsebool -a                    # All booleans
getsebool -a | grep httpd       # HTTP-related booleans
getsebool boolean_name          # Specific boolean status

# Set booleans (temporary)
setsebool httpd_can_network_connect on
setsebool httpd_enable_homedirs off

# Set booleans (persistent)
setsebool -P httpd_can_network_connect on
setsebool -P httpd_enable_homedirs off

# Common useful booleans
setsebool -P httpd_can_network_connect on      # HTTP proxy/external connections
setsebool -P httpd_can_network_relay on        # HTTP as reverse proxy
setsebool -P httpd_enable_homedirs on          # Access user home directories
setsebool -P ftpd_anon_write on                # Anonymous FTP uploads
setsebool -P samba_enable_home_dirs on         # Samba home directory access
```

### Troubleshooting Commands
```bash
# View SELinux denials
ausearch -m AVC -ts recent      # Recent access vector cache denials
ausearch -m AVC -ts today       # Today's denials
ausearch -m AVC -c httpd        # Denials for specific command/process

# SELinux log analysis
sealert -a /var/log/audit/audit.log    # Analyze all denials with suggestions
tail -f /var/log/audit/audit.log | grep AVC  # Watch for real-time denials

# Generate policy modules for denials
ausearch -m AVC -ts recent | audit2allow -M mypolicy
semodule -i mypolicy.pp         # Install generated policy module

# Port context management
semanage port -l                # List port contexts
semanage port -l | grep http    # HTTP-related ports
semanage port -a -t http_port_t -p tcp 8080  # Add custom HTTP port
semanage port -d -t http_port_t -p tcp 8080  # Delete custom port context
```

### User and Role Management
```bash
# SELinux users (different from Linux users)
semanage user -l                # List SELinux users
semanage login -l               # List user login mappings

# Map Linux users to SELinux users
semanage login -a -s user_u john    # Map john to user_u
semanage login -m -s staff_u jane   # Change jane's mapping
semanage login -d john              # Delete mapping

# Role management
semanage user -a -R "staff_r sysadm_r" myuser_u  # Add roles to SELinux user
```

### Command Reference Table
| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `getenforce` | Check SELinux mode | | `getenforce` |
| `setenforce` | Change mode temporarily | `0` (permissive), `1` (enforcing) | `setenforce 0` |
| `ls -Z` | Show file contexts | `-R` (recursive) | `ls -lZ /var/www/` |
| `restorecon` | Restore file contexts | `-R`, `-v` | `restorecon -Rv /var/www/` |
| `semanage fcontext` | Manage context policies | `-a`, `-m`, `-d`, `-l` | `semanage fcontext -a -t httpd_exec_t "/opt/bin/.*"` |
| `setsebool` | Set SELinux booleans | `-P` (persistent) | `setsebool -P httpd_can_network_connect on` |
| `ausearch` | Search audit logs | `-m AVC`, `-ts` | `ausearch -m AVC -ts recent` |

---

## 4. Procedural Workflows

### Standard Procedure: Configure Custom Application for SELinux
1. **Install application in non-standard location**
   ```bash
   # Example: Installing custom web application
   mkdir -p /opt/webapp/{bin,conf,logs}
   # Copy application files to /opt/webapp/
   ```

2. **Set appropriate file contexts**
   ```bash
   # Define context policies for the application
   semanage fcontext -a -t httpd_exec_t "/opt/webapp/bin(/.*)?"
   semanage fcontext -a -t httpd_config_t "/opt/webapp/conf(/.*)?"
   semanage fcontext -a -t httpd_log_t "/opt/webapp/logs(/.*)?"
   
   # Apply the contexts to existing files
   restorecon -Rv /opt/webapp/
   ```

3. **Configure required booleans**
   ```bash
   # Enable booleans for application functionality
   setsebool -P httpd_can_network_connect on
   setsebool -P httpd_can_network_relay on
   ```

4. **Test and troubleshoot**
   ```bash
   # Start the service and test
   systemctl start httpd
   
   # Monitor for denials
   ausearch -m AVC -ts recent
   
   # If denials occur, analyze and fix
   sealert -a /var/log/audit/audit.log
   ```

### Standard Procedure: SELinux Troubleshooting
1. **Identify the problem**
   ```bash
   # Check if SELinux is causing the issue
   getenforce
   
   # Temporarily set to permissive to test
   setenforce 0
   # Test if application works now
   # If yes, SELinux is the cause
   setenforce 1
   ```

2. **Find specific denials**
   ```bash
   # Search for recent AVC denials
   ausearch -m AVC -ts recent
   
   # Or monitor in real-time
   tail -f /var/log/audit/audit.log | grep AVC
   ```

3. **Analyze denial messages**
   ```bash
   # Get human-readable analysis
   sealert -a /var/log/audit/audit.log
   
   # Look for specific patterns in denial
   ausearch -m AVC -c httpd -ts recent
   ```

4. **Apply appropriate fix**
   ```bash
   # Option 1: Set boolean (if suggested)
   setsebool -P boolean_name on
   
   # Option 2: Fix file context
   semanage fcontext -a -t correct_type_t "/path/to/file"
   restorecon -v /path/to/file
   
   # Option 3: Add port context (for network services)
   semanage port -a -t http_port_t -p tcp 8080
   
   # Option 4: Generate custom policy module (last resort)
   ausearch -m AVC -ts recent | audit2allow -M mypolicy
   semodule -i mypolicy.pp
   ```

### Decision Tree: SELinux Problem Resolution
```
SELinux Access Denied
├── File access denied?
│   ├── Wrong file context? → Use semanage fcontext + restorecon
│   ├── File in wrong location? → Move file or create custom policy
│   └── Process running as wrong domain? → Check process context
├── Network access denied?
│   ├── Port not allowed? → Use semanage port
│   ├── Network connection blocked? → Set network booleans
│   └── Proxy/relay blocked? → Set appropriate booleans
├── Service functionality disabled?
│   ├── Feature disabled by boolean? → Use setsebool -P
│   └── Policy restriction? → Generate custom policy
└── Unknown issue?
    ├── Check ausearch -m AVC → Analyze denial messages
    ├── Use sealert → Get recommendations
    └── Test in permissive mode → Confirm SELinux cause
```

### Standard Procedure: Custom Web Service SELinux Setup
1. **Create service structure**
   ```bash
   # Create custom web service directory
   mkdir -p /srv/mywebapp/{htdocs,cgi-bin,logs}
   
   # Create sample content
   echo "<h1>My Web App</h1>" > /srv/mywebapp/htdocs/index.html
   ```

2. **Configure SELinux contexts**
   ```bash
   # Set context policies for custom directories
   semanage fcontext -a -t httpd_config_t "/srv/mywebapp(/.*)?"
   semanage fcontext -a -t httpd_exec_t "/srv/mywebapp/cgi-bin(/.*)?"
   semanage fcontext -a -t httpd_log_t "/srv/mywebapp/logs(/.*)?"
   
   # Apply contexts
   restorecon -Rv /srv/mywebapp/
   
   # Verify contexts
   ls -lZ /srv/mywebapp/
   ```

3. **Configure Apache for custom location**
   ```bash
   # Create Apache virtual host configuration
   cat > /etc/httpd/conf.d/mywebapp.conf << 'EOF'
   <VirtualHost *:8080>
       DocumentRoot /srv/mywebapp/htdocs
       ErrorLog /srv/mywebapp/logs/error.log
       CustomLog /srv/mywebapp/logs/access.log combined
       
       <Directory /srv/mywebapp/htdocs>
           AllowOverride None
           Require all granted
       </Directory>
   </VirtualHost>
   EOF
   ```

4. **Configure SELinux for custom port**
   ```bash
   # Add port 8080 to HTTP port context
   semanage port -a -t http_port_t -p tcp 8080
   
   # Verify port context
   semanage port -l | grep 8080
   ```

---

## 5. Configuration Deep Dive

### SELinux Configuration Files
#### Main Configuration
```bash
# /etc/selinux/config
SELINUX=enforcing          # enforcing|permissive|disabled
SELINUXTYPE=targeted       # targeted|minimum|mls
```

#### Policy Files Location
```bash
# SELinux policy files
/etc/selinux/targeted/     # Targeted policy files
/etc/selinux/targeted/contexts/files/file_contexts  # Default file contexts
/etc/selinux/targeted/modules/active/  # Active policy modules
```

### Understanding SELinux Contexts
#### Context Format: user:role:type:level
```bash
# Example contexts:
system_u:object_r:admin_home_t:s0           # Administrative home directory
system_u:object_r:httpd_exec_t:s0           # Apache executable
unconfined_u:unconfined_r:unconfined_t:s0   # Unconfined user process
system_u:system_r:httpd_t:s0                # Apache daemon process
```

#### Common Types and Their Uses
```bash
# File types:
httpd_config_t      # Apache configuration files
httpd_log_t         # Apache log files
httpd_exec_t        # Apache executable files
admin_home_t        # Administrator home directories
user_home_t         # Regular user home directories
etc_t               # System configuration files
bin_t               # System binaries

# Process domains:
httpd_t             # Apache web server process
sshd_t              # SSH daemon process
unconfined_t        # Unconfined user processes
kernel_t            # Kernel processes
```

### SELinux Booleans Categories
#### Web Server Booleans
```bash
httpd_can_network_connect=off      # HTTP proxy connections
httpd_can_network_relay=off        # HTTP reverse proxy
httpd_enable_homedirs=off          # Access user home directories  
httpd_builtin_scripting=on         # Built-in scripting support
httpd_enable_cgi=on                # CGI script execution
httpd_can_sendmail=off             # Send email from web apps
```

#### File Sharing Booleans
```bash
samba_enable_home_dirs=off         # Samba access to home directories
use_samba_home_dirs=off            # Users access Samba homes
ftpd_anon_write=off                # Anonymous FTP uploads
ftpd_use_nfs=off                   # FTP access to NFS mounts
```

### Port Context Management
#### Common Port Contexts
```bash
# Web services
http_port_t: 80, 81, 443, 488, 8008, 8009, 8443, 9000
# SSH
ssh_port_t: 22
# FTP  
ftp_port_t: 21, 989, 990
# DNS
dns_port_t: 53
# SMTP
smtp_port_t: 25, 465, 587
```

---

## 6. Hands-On Labs

### Lab 6.1: Basic SELinux Configuration (Asghar Ghori Style)
**Objective**: Understand SELinux modes, contexts, and basic troubleshooting

**Steps**:
1. **Explore current SELinux status**
   ```bash
   # Check SELinux enforcement status
   getenforce
   sestatus
   sestatus -v
   
   # View SELinux configuration
   cat /etc/selinux/config
   
   # Check current process contexts
   ps -eZ | head -10
   
   # Check file contexts in common directories
   ls -lZ /etc/ | head -5
   ls -lZ /var/www/html/
   ```

2. **Practice mode changes**
   ```bash
   # Change to permissive mode temporarily
   setenforce 0
   getenforce
   
   # Change back to enforcing
   setenforce 1
   getenforce
   
   # View current boolean settings
   getsebool -a | grep httpd | head -5
   getsebool httpd_can_network_connect
   ```

3. **Work with file contexts**
   ```bash
   # Create test files
   mkdir -p /tmp/selinux-test
   touch /tmp/selinux-test/testfile.txt
   echo "Test content" > /tmp/selinux-test/testfile.txt
   
   # Check current context
   ls -lZ /tmp/selinux-test/
   
   # Change context manually
   chcon -t admin_home_t /tmp/selinux-test/testfile.txt
   ls -lZ /tmp/selinux-test/testfile.txt
   
   # Restore default context
   restorecon -v /tmp/selinux-test/testfile.txt
   ls -lZ /tmp/selinux-test/testfile.txt
   ```

4. **Practice boolean management**
   ```bash
   # Check current boolean status
   getsebool httpd_enable_homedirs
   
   # Set boolean temporarily
   setsebool httpd_enable_homedirs on
   getsebool httpd_enable_homedirs
   
   # Set boolean permanently
   setsebool -P httpd_enable_homedirs off
   getsebool httpd_enable_homedirs
   ```

**Verification**:
```bash
# Verify SELinux is working properly
getenforce
sestatus
ps -eZ | grep httpd || echo "Apache not running"
getsebool -a | grep httpd | head -3
```

### Lab 6.2: Advanced Context Management (Sander van Vugt Style)
**Objective**: Configure custom file contexts and manage SELinux policies

**Steps**:
1. **Create custom web application directory**
   ```bash
   # Create directory structure for custom web app
   sudo mkdir -p /srv/webapp/{html,cgi-bin,logs}
   
   # Create sample files
   echo "<h1>Custom Web Application</h1>" | sudo tee /srv/webapp/html/index.html
   echo "#!/bin/bash" | sudo tee /srv/webapp/cgi-bin/test.cgi
   echo "echo 'Content-type: text/html'" | sudo tee -a /srv/webapp/cgi-bin/test.cgi
   echo "echo '<h2>CGI Test</h2>'" | sudo tee -a /srv/webapp/cgi-bin/test.cgi
   sudo chmod +x /srv/webapp/cgi-bin/test.cgi
   
   # Check initial contexts
   ls -lZ /srv/webapp/
   ls -lZ /srv/webapp/html/
   ls -lZ /srv/webapp/cgi-bin/
   ```

2. **Configure appropriate SELinux contexts**
   ```bash
   # Add file context policies for custom directories
   sudo semanage fcontext -a -t httpd_config_t "/srv/webapp(/.*)?"
   sudo semanage fcontext -a -t httpd_exec_t "/srv/webapp/cgi-bin(/.*)?"
   sudo semanage fcontext -a -t httpd_log_t "/srv/webapp/logs(/.*)?"
   
   # Apply the contexts to existing files
   sudo restorecon -Rv /srv/webapp/
   
   # Verify new contexts
   ls -lZ /srv/webapp/
   ls -lZ /srv/webapp/html/
   ls -lZ /srv/webapp/cgi-bin/
   ```

3. **Configure custom port context**
   ```bash
   # Check current port contexts for HTTP
   semanage port -l | grep http_port_t
   
   # Add custom port for web application
   sudo semanage port -a -t http_port_t -p tcp 8080
   
   # Verify port was added
   semanage port -l | grep 8080
   ```

4. **Test context policies**
   ```bash
   # Create new file in managed directory
   echo "<p>New file</p>" | sudo tee /srv/webapp/html/newfile.html
   
   # Check if it got the correct context automatically
   ls -lZ /srv/webapp/html/newfile.html
   
   # Create file with wrong context and fix it
   sudo touch /tmp/wrongcontext.html
   sudo mv /tmp/wrongcontext.html /srv/webapp/html/
   ls -lZ /srv/webapp/html/wrongcontext.html
   
   # Restore correct context
   sudo restorecon -v /srv/webapp/html/wrongcontext.html
   ls -lZ /srv/webapp/html/wrongcontext.html
   ```

**Verification**:
```bash
# Verify all context policies are working
sudo semanage fcontext -l | grep "/srv/webapp"
ls -lZ /srv/webapp/ /srv/webapp/html/ /srv/webapp/cgi-bin/
semanage port -l | grep 8080
```

### Lab 6.3: SELinux Troubleshooting Scenario (Synthesis Challenge)
**Objective**: Diagnose and resolve SELinux access denials in a realistic scenario

**Scenario**: A custom web application is experiencing SELinux denials and needs systematic troubleshooting

**Requirements**:
- Set up a scenario that generates SELinux denials
- Use proper troubleshooting methodology
- Resolve issues with appropriate SELinux configurations
- Document the troubleshooting process

**Solution Steps**:
1. **Create problematic scenario**
   ```bash
   # Create a web service that will have SELinux issues
   sudo mkdir -p /opt/customapp/{bin,data,config}
   
   # Create executable that will cause SELinux denial
   cat << 'EOF' | sudo tee /opt/customapp/bin/webapp.sh
   #!/bin/bash
   # Simple web service that writes to non-standard location
   echo "Starting custom web application..."
   echo "$(date): Web app started" > /opt/customapp/data/app.log
   echo "Config loaded" >> /opt/customapp/config/status.conf
   python3 -m http.server 9090 --directory /opt/customapp/data
   EOF
   
   sudo chmod +x /opt/customapp/bin/webapp.sh
   
   # Create initial files with wrong contexts
   echo "Initial log entry" | sudo tee /opt/customapp/data/app.log
   echo "config=loaded" | sudo tee /opt/customapp/config/status.conf
   
   # Check contexts (these will be wrong)
   ls -lZ /opt/customapp/bin/
   ls -lZ /opt/customapp/data/
   ls -lZ /opt/customapp/config/
   ```

2. **Attempt to run and identify SELinux denials**
   ```bash
   # Try to run the application (this may cause SELinux denials)
   sudo /opt/customapp/bin/webapp.sh &
   WEBAPP_PID=$!
   sleep 2
   sudo kill $WEBAPP_PID 2>/dev/null
   
   # Check for recent SELinux denials
   sudo ausearch -m AVC -ts recent
   
   # If no denials yet, try accessing the files as web service would
   sudo -u apache cat /opt/customapp/config/status.conf 2>/dev/null || echo "Access denied (this is expected)"
   
   # Check for denials again
   sudo ausearch -m AVC -ts recent
   ```

3. **Systematic troubleshooting**
   ```bash
   # Step 1: Identify the denial details
   echo "=== SELINUX DENIAL ANALYSIS ==="
   sudo ausearch -m AVC -ts recent | head -20
   
   # Step 2: Get human-readable analysis
   sudo sealert -a /var/log/audit/audit.log | tail -50
   
   # Step 3: Check current contexts
   echo "=== CURRENT CONTEXTS ==="
   ls -lZ /opt/customapp/bin/webapp.sh
   ls -lZ /opt/customapp/data/app.log
   ls -lZ /opt/customapp/config/status.conf
   
   # Step 4: Check what contexts should be
   echo "=== CHECKING POLICY FOR SIMILAR PATHS ==="
   sudo semanage fcontext -l | grep -E "(httpd|web)" | head -5
   ```

4. **Apply systematic fixes**
   ```bash
   # Fix 1: Set appropriate file contexts for web application
   echo "=== APPLYING CONTEXT FIXES ==="
   
   # Define appropriate contexts for our custom app
   sudo semanage fcontext -a -t httpd_exec_t "/opt/customapp/bin(/.*)?"
   sudo semanage fcontext -a -t httpd_config_t "/opt/customapp/config(/.*)?"
   sudo semanage fcontext -a -t httpd_log_t "/opt/customapp/data(/.*)?"
   
   # Apply contexts to existing files
   sudo restorecon -Rv /opt/customapp/
   
   # Fix 2: Add custom port if needed
   if ! semanage port -l | grep -q "9090"; then
       echo "Adding custom port 9090 to HTTP context..."
       sudo semanage port -a -t http_port_t -p tcp 9090
   fi
   
   # Fix 3: Enable necessary booleans
   echo "=== SETTING REQUIRED BOOLEANS ==="
   sudo setsebool -P httpd_can_network_connect on
   sudo setsebool -P httpd_builtin_scripting on
   
   # Verify contexts after fixes
   echo "=== CONTEXTS AFTER FIXES ==="
   ls -lZ /opt/customapp/bin/
   ls -lZ /opt/customapp/data/
   ls -lZ /opt/customapp/config/
   ```

5. **Test resolution and document**
   ```bash
   # Test the application again
   echo "=== TESTING AFTER FIXES ==="
   sudo /opt/customapp/bin/webapp.sh &
   WEBAPP_PID=$!
   sleep 3
   
   # Test if it's working (try to access the service)
   curl -s http://localhost:9090/ >/dev/null && echo "Web service accessible" || echo "Web service not accessible"
   
   # Clean up the test
   sudo kill $WEBAPP_PID 2>/dev/null
   
   # Check for new denials
   NEW_DENIALS=$(sudo ausearch -m AVC -ts recent | wc -l)
   if [ "$NEW_DENIALS" -eq 0 ]; then
       echo "SUCCESS: No new SELinux denials found"
   else
       echo "ISSUE: Still getting SELinux denials"
       sudo ausearch -m AVC -ts recent | tail -5
   fi
   
   # Create troubleshooting documentation
   cat > /tmp/selinux-troubleshooting-report.md << EOF
   # SELinux Troubleshooting Report
   Date: $(date)
   
   ## Problem Description
   Custom web application experiencing SELinux access denials
   
   ## Investigation Steps
   1. **Initial Analysis**
      - Checked for AVC denials: \`ausearch -m AVC -ts recent\`
      - Analyzed denials: \`sealert -a /var/log/audit/audit.log\`
      - Reviewed current file contexts
   
   2. **Root Cause**
      - Custom application files had incorrect SELinux contexts
      - Files in /opt/customapp/ had default contexts instead of web server contexts
      - Custom port 9090 not in HTTP port context
   
   ## Resolution Applied
   1. **File Context Policies**:
      \`\`\`bash
      semanage fcontext -a -t httpd_exec_t "/opt/customapp/bin(/.*)?"
      semanage fcontext -a -t httpd_config_t "/opt/customapp/config(/.*)?"
      semanage fcontext -a -t httpd_log_t "/opt/customapp/data(/.*)?"
      restorecon -Rv /opt/customapp/
      \`\`\`
   
   2. **Port Context**:
      \`\`\`bash
      semanage port -a -t http_port_t -p tcp 9090
      \`\`\`
   
   3. **Boolean Configuration**:
      \`\`\`bash
      setsebool -P httpd_can_network_connect on
      setsebool -P httpd_builtin_scripting on
      \`\`\`
   
   ## Verification
   - No new AVC denials after fixes
   - Application runs without SELinux interference
   - All file contexts properly configured
   
   ## Lessons Learned
   - Custom applications need explicit SELinux context policies
   - Always check ausearch and sealert for troubleshooting guidance
   - File contexts should match the application's intended use
   - Port contexts required for non-standard network services
   EOF
   
   echo "=== TROUBLESHOOTING REPORT CREATED ==="
   cat /tmp/selinux-troubleshooting-report.md
   ```

**Verification**:
```bash
# Final comprehensive verification
echo "=== FINAL SELINUX CONFIGURATION STATUS ==="
getenforce
sudo semanage fcontext -l | grep "/opt/customapp"
sudo semanage port -l | grep 9090
sudo getsebool httpd_can_network_connect
sudo getsebool httpd_builtin_scripting
ls -lZ /opt/customapp/bin/ /opt/customapp/data/ /opt/customapp/config/
echo "Recent AVC denials: $(sudo ausearch -m AVC -ts recent 2>/dev/null | wc -l)"
```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: Service Won't Start After SELinux Enforcement
**Symptoms**:
- Service fails to start when SELinux is enforcing
- Works fine in permissive mode
- No clear error messages in service logs

**Diagnosis**:
```bash
# Check SELinux denials
ausearch -m AVC -ts recent
sealert -a /var/log/audit/audit.log

# Check service contexts
systemctl status servicename
ps -eZ | grep servicename

# Verify file contexts
ls -lZ /path/to/service/files
```

**Resolution**:
```bash
# Common fixes based on denial type:

# Fix file contexts
semanage fcontext -a -t appropriate_type_t "/path/to/service/files(/.*)?"
restorecon -Rv /path/to/service/files

# Enable required booleans
setsebool -P boolean_name on

# Add custom port contexts
semanage port -a -t service_port_t -p tcp port_number

# Generate custom policy (last resort)
ausearch -m AVC -ts recent | audit2allow -M servicepolicy
semodule -i servicepolicy.pp
```

**Prevention**: Plan SELinux configuration during service deployment

#### Issue 2: Web Application Cannot Access Files
**Symptoms**:
- HTTP 403 forbidden errors
- Web server logs show permission denied
- Files have correct traditional permissions

**Diagnosis**:
```bash
# Check file contexts for web content
ls -lZ /var/www/html/
ls -lZ /path/to/web/content/

# Check web server process context
ps -eZ | grep httpd

# Look for AVC denials related to httpd
ausearch -m AVC -c httpd -ts recent
```

**Resolution**:
```bash
# Fix web content contexts
semanage fcontext -a -t httpd_config_t "/path/to/web/content(/.*)?"
restorecon -Rv /path/to/web/content/

# Enable web server booleans as needed
setsebool -P httpd_enable_homedirs on      # For user directories
setsebool -P httpd_can_network_connect on  # For proxy/external connections
setsebool -P httpd_builtin_scripting on    # For CGI/scripts
```

#### Issue 3: Custom Port Access Denied
**Symptoms**:
- Service cannot bind to custom port
- "Permission denied" when connecting to port
- Standard ports work fine

**Diagnosis**:
```bash
# Check current port contexts
semanage port -l | grep port_number
semanage port -l | grep service_name

# Look for port-related denials
ausearch -m AVC -ts recent | grep port
```

**Resolution**:
```bash
# Add port to appropriate context
semanage port -a -t http_port_t -p tcp 8080
semanage port -a -t ssh_port_t -p tcp 2222

# Verify port was added
semanage port -l | grep port_number
```

### Diagnostic Command Sequence
```bash
# SELinux troubleshooting workflow
getenforce                      # Check SELinux mode
ausearch -m AVC -ts recent     # Check for recent denials
sealert -a /var/log/audit/audit.log  # Analyze denials
ps -eZ | grep process-name     # Check process contexts
ls -lZ /path/to/files          # Check file contexts
semanage fcontext -l | grep path  # Check context policies
getsebool -a | grep relevant   # Check boolean settings
```

### Log File Analysis
- **`/var/log/audit/audit.log`**: Primary SELinux denial log
- **`ausearch -m AVC`**: Extract AVC (Access Vector Cache) denials
- **`sealert`**: Human-readable denial analysis with suggestions
- **`journalctl -u auditd`**: Audit daemon logs

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance
```bash
# Status and mode
getenforce                     # Check current mode
setenforce 0|1                # Change mode temporarily
sestatus                      # Detailed status

# File contexts
ls -lZ file                   # Show file context
restorecon -Rv /path/         # Restore file contexts
semanage fcontext -a -t type "/path(/.*)?"  # Add context policy

# Booleans
getsebool boolean_name        # Check boolean status
setsebool -P boolean_name on  # Set boolean permanently

# Troubleshooting
ausearch -m AVC -ts recent    # Recent denials
sealert -a /var/log/audit/audit.log  # Analyze denials
```

### Common File Types
- **httpd_config_t**: Web server configuration files
- **httpd_exec_t**: Web server executable files
- **httpd_log_t**: Web server log files
- **admin_home_t**: Administrator home directories
- **user_home_t**: User home directories
- **etc_t**: System configuration files

### Critical Booleans
- **httpd_can_network_connect**: HTTP proxy connections
- **httpd_enable_homedirs**: Access user home directories
- **samba_enable_home_dirs**: Samba home directory access
- **ftpd_anon_write**: Anonymous FTP uploads

### Port Context Commands
```bash
semanage port -l              # List port contexts
semanage port -a -t http_port_t -p tcp 8080  # Add HTTP port
semanage port -d -t http_port_t -p tcp 8080  # Remove port context
```

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What's the difference between discretionary access control and mandatory access control in SELinux?
   **Answer**: Discretionary access control (traditional permissions) allows users to control access to their own files. Mandatory access control (SELinux) enforces system-wide security policies that users cannot override, providing an additional security layer based on security contexts and policies.

2. **Question**: Why is it better to use semanage fcontext instead of chcon for permanent changes?
   **Answer**: `chcon` only changes the context temporarily - it's lost if the file is moved, copied, or if `restorecon` is run. `semanage fcontext` creates a permanent policy rule, so the context is automatically applied to matching files and persists through system operations.

3. **Question**: When would you create a custom SELinux policy module instead of using existing tools?
   **Answer**: Custom policy modules are a last resort when legitimate application behavior triggers denials that can't be resolved with existing booleans, file contexts, or port contexts. They're typically needed for applications with unusual security requirements or behaviors not covered by standard policies.

### Practical Scenarios
1. **Scenario**: Web server needs to connect to a database on a non-standard port.
   **Solution**: Enable the `httpd_can_network_connect` boolean with `setsebool -P httpd_can_network_connect on` and possibly add the database port to appropriate context with `semanage port`.

2. **Scenario**: Custom application installed in /opt needs to be accessed by Apache.
   **Solution**: Set appropriate contexts with `semanage fcontext -a -t httpd_config_t "/opt/myapp(/.*)?"` and apply with `restorecon -Rv /opt/myapp/`.

### Command Challenges
1. **Challenge**: Find all files in /var/www that have the wrong SELinux context.
   **Answer**: `find /var/www -exec ls -lZ {} \; | grep -v httpd_config_t | grep -v httpd_exec_t`

2. **Challenge**: Create a policy to allow Apache to write to a custom log directory.
   **Answer**: 
   ```bash
   semanage fcontext -a -t httpd_log_t "/custom/logs(/.*)?"
   restorecon -Rv /custom/logs/
   setsebool -P httpd_can_network_connect on  # if network logging
   ```

---

## 10. Exam Strategy

### Topic-Specific Tips
- Always check `getenforce` first when troubleshooting access issues
- Use `ausearch -m AVC -ts recent` to find specific SELinux denials
- Remember that `setsebool -P` makes changes persistent (crucial for exam)
- Practice the systematic approach: check contexts, booleans, ports, then custom policies

### Common Exam Scenarios
1. **Scenario**: Configure web server to serve content from custom directory
   **Approach**: Use `semanage fcontext` to set appropriate httpd contexts, then `restorecon`

2. **Scenario**: Web application needs network access
   **Approach**: Enable `httpd_can_network_connect` boolean with `-P` flag

3. **Scenario**: Service won't start, works in permissive mode
   **Approach**: Check `ausearch -m AVC`, analyze with `sealert`, apply appropriate fix

### Time Management
- **SELinux boolean changes**: 2-3 minutes including verification
- **File context configuration**: 5-7 minutes for complete setup
- **Troubleshooting denials**: 8-12 minutes depending on complexity
- **Always verify**: Test functionality after applying SELinux changes

### Pitfalls to Avoid
- Don't disable SELinux unless explicitly asked (major point deduction)
- Remember `-P` flag with `setsebool` for persistence
- Don't use `chcon` for permanent changes - use `semanage fcontext`
- Always run `restorecon` after setting context policies
- Test applications after SELinux changes to ensure they work

---

## Summary

### Key Takeaways
- **SELinux provides mandatory access control** - an essential security layer beyond traditional permissions
- **Understand the context format** - user:role:type:level labels control access
- **Use proper tools for permanent changes** - `semanage` for policies, `setsebool -P` for booleans
- **Systematic troubleshooting works** - check denials, analyze with sealert, apply appropriate fixes

### Critical Commands to Remember
```bash
getenforce                                    # Check SELinux status
setenforce 0|1                               # Change mode temporarily
setsebool -P boolean_name on                 # Set boolean permanently
semanage fcontext -a -t type "/path(/.*)?"   # Add file context policy
restorecon -Rv /path/                        # Apply context policies
ausearch -m AVC -ts recent                   # Find recent denials
sealert -a /var/log/audit/audit.log          # Analyze denials
```

### Next Steps
- Continue to [Module 10: Firewall Configuration](10_firewall.md)
- Practice SELinux scenarios in the Vagrant environment
- Review related topics: [File Permissions](04_file_permissions.md), [Process Management](05_process_service_management.md)

---

**Navigation**: [← Network Configuration](08_networking.md) | [Index](index.md) | [Next → Firewall Configuration](10_firewall.md)