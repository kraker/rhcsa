# Lab Scenario 3: SELinux and Security Management

**VM:** rhel9a  
**Time Limit:** 40 minutes  
**Difficulty:** Advanced

## Scenario
Your organization wants to host a web application with a custom document root outside the standard `/var/www/html` location. You need to configure Apache httpd with proper SELinux contexts and troubleshoot any security denials.

## Prerequisites
```bash
# Ensure SELinux is enforcing
sudo setenforce 1
getenforce

# Install required packages
sudo dnf install -y httpd setroubleshoot-server
```

## Tasks

### 1. Configure Custom Document Root (10 minutes)
```bash
# Create custom document root
sudo mkdir -p /web/html

# Create test web content
echo "<h1>Custom Web Server</h1>" | sudo tee /web/html/index.html
echo "<h2>Test Page</h2><p>This is a test page in custom location.</p>" | sudo tee /web/html/test.html

# Set basic ownership
sudo chown -R apache:apache /web/html
sudo chmod -R 755 /web/html
```

### 2. Configure Apache for Custom Document Root (10 minutes)
```bash
# Backup original configuration
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.backup

# Configure custom document root
sudo sed -i 's|DocumentRoot "/var/www/html"|DocumentRoot "/web/html"|g' /etc/httpd/conf/httpd.conf
sudo sed -i 's|<Directory "/var/www/html">|<Directory "/web/html">|g' /etc/httpd/conf/httpd.conf

# Enable and start httpd
sudo systemctl enable httpd
sudo systemctl start httpd

# Configure firewall
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

### 3. SELinux Context Configuration (15 minutes)
```bash
# Check current SELinux contexts
ls -Z /web/html/
getenforce

# Set proper SELinux file contexts for web content
sudo semanage fcontext -a -t httpd_exec_t "/web/html(/.*)?"
sudo restorecon -Rv /web/html/

# Verify contexts are correct
ls -Z /web/html/

# If httpd still fails, check for denials
sudo ausearch -m AVC -ts recent

# Common SELinux boolean that might be needed
sudo setsebool -P httpd_read_user_content on

# Alternative context if above doesn't work
sudo semanage fcontext -a -t httpd_exec_t "/web/html(/.*)?"
sudo restorecon -Rv /web/html/
```

### 4. Troubleshooting and Testing (5 minutes)
```bash
# Test web server functionality
curl http://localhost/
curl http://localhost/test.html

# Check httpd status and logs
sudo systemctl status httpd
sudo journalctl -u httpd --no-pager

# Check for SELinux denials and get suggestions
sudo sealert -a /var/log/audit/audit.log | tail -50

# If needed, check what contexts are available for web content
sudo semanage fcontext -l | grep httpd
```

## Verification Commands
```bash
# Check SELinux status
getenforce
sestatus

# Verify httpd service
systemctl status httpd
systemctl is-enabled httpd

# Check file contexts
ls -Z /web/html/
ls -Z /web/html/index.html

# Test web access
curl http://localhost/
curl http://localhost/test.html

# Check for SELinux denials
sudo ausearch -m AVC -ts recent
```

## Expected Results
- SELinux in enforcing mode
- httpd service running and enabled
- Custom document root accessible via web browser
- No SELinux denials in audit log
- Proper file contexts on web files

## Advanced SELinux Troubleshooting Section

### Comprehensive ausearch Command Reference
```bash
# Essential ausearch commands for SELinux troubleshooting
ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts today
ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts boot
ausearch -m AVC -ts recent
ausearch -c 'httpd' --raw | audit2allow -M my-httpd
ausearch -m AVC -ts recent | audit2allow -R
```

### Step-by-Step Troubleshooting Workflow
1. **Check for SELinux denials:**
```bash
# Look for recent Access Vector Cache (AVC) denials
ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts boot
```

2. **If no matches, verify audit daemon:**
```bash
# Check if auditd is running
systemctl status auditd
# If not running, restart and re-test
systemctl restart auditd
```

3. **Analyze denials with setroubleshoot:**
```bash
# Get human-readable analysis
sealert -a /var/log/audit/audit.log
```

4. **Generate policy suggestions:**
```bash
# Use audit2allow to suggest policy changes
ausearch -m AVC -ts recent | audit2allow -R
# Create custom policy module if needed
ausearch -c 'mydaemon' --raw | audit2allow -M my-mydaemon
semodule -X 300 -i my-mydaemon.pp
```

### Alternative Troubleshooting Methods
```bash
# If auditd is not running, check dmesg for SELinux messages
dmesg | grep -i -e type=1300 -e type=1400

# Check for setroubleshoot messages in system logs
grep "SELinux is preventing" /var/log/messages
```

## TODO(human)
Complete the troubleshooting section with:
- Custom daemon policy creation example
- Boolean troubleshooting for specific services
- Port labeling examples for non-standard ports

## Troubleshooting Tips
- If httpd fails to start: Check SELinux denials in `/var/log/audit/audit.log`
- If web pages don't load: Verify file contexts and ownership
- Use `sealert` to analyze denials: `sealert -a /var/log/audit/audit.log`
- If boolean changes don't persist: Use `-P` flag with `setsebool`
- Check firewall if external access fails: `firewall-cmd --list-services`