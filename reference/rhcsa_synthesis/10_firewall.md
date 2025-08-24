# 10 - Firewall Configuration

**Navigation**: [← SELinux Management](09_selinux.md) | [Index](index.md) | [Next → Boot Process & GRUB](11_boot_grub.md)

---

## 1. Executive Summary

**Topic Scope**: Firewall configuration using firewalld, zones, services, ports, and rich rules in RHEL 9

**RHCSA Relevance**: Essential security skill - firewall management is fundamental for server security

**Exam Weight**: Medium-High - Firewall tasks appear regularly in security-focused exam scenarios

**Prerequisites**: Understanding of network services, ports, and basic TCP/IP concepts

**Related Topics**: [Network Configuration](08_networking.md), [SELinux Management](09_selinux.md), [Service Management](05_process_service_management.md)

---

## 2. Conceptual Foundation

### Core Theory
RHEL 9 uses firewalld as the default firewall management service, which provides:

- **Zone-based management**: Different security levels for different network contexts
- **Dynamic configuration**: Changes without service restart or connection drops
- **Service definitions**: Predefined collections of ports and protocols
- **Rich rules**: Advanced firewall rules with complex conditions
- **Runtime vs permanent**: Immediate changes vs persistent configuration

### Real-World Applications
- **Web server protection**: Allowing HTTP/HTTPS while blocking unauthorized access
- **SSH hardening**: Restricting remote access to specific networks or ports
- **Database security**: Limiting database access to application servers only
- **Service isolation**: Separating different services into appropriate security zones
- **Compliance requirements**: Meeting security standards for regulated environments

### Common Misconceptions
- **iptables vs firewalld**: RHEL 9 uses firewalld by default, not direct iptables
- **Zone complexity**: Zones are logical groupings, not physical network segments
- **Runtime changes**: Runtime changes are temporary unless made permanent
- **Service vs port rules**: Services are collections of ports with meaningful names
- **Default deny**: firewalld uses default deny - only explicitly allowed traffic passes

### Key Terminology
- **Zone**: Security context with specific rules applied to network interfaces
- **Service**: Predefined firewall rule for common applications (http, ssh, etc.)
- **Port**: Specific TCP/UDP port number that can be opened
- **Rich rule**: Complex firewall rule with advanced conditions and actions
- **Runtime configuration**: Currently active rules (lost on restart)
- **Permanent configuration**: Persistent rules saved to configuration files
- **Source**: IP address or network range for rule targeting
- **Target**: Default action for traffic not matching any rules in a zone

---

## 3. Command Mastery

### Basic Firewall Status and Control
```bash
# Service management
systemctl status firewalld             # Check firewalld service status
systemctl start firewalld              # Start firewall service
systemctl stop firewalld               # Stop firewall service
systemctl enable firewalld             # Enable firewall at boot
systemctl disable firewalld            # Disable firewall at boot

# Firewall status
firewall-cmd --state                   # Check if firewall is running
firewall-cmd --get-active-zones        # Show active zones with interfaces
firewall-cmd --list-all                # Show all rules for default zone
firewall-cmd --list-all-zones          # Show rules for all zones
firewall-cmd --get-default-zone        # Show default zone
```

### Zone Management
```bash
# Zone operations
firewall-cmd --get-zones               # List all available zones
firewall-cmd --set-default-zone=public # Set default zone
firewall-cmd --zone=public --list-all  # Show rules for specific zone
firewall-cmd --get-zone-of-interface=ens3  # Show zone of interface

# Interface assignment
firewall-cmd --zone=public --add-interface=ens3     # Add interface to zone
firewall-cmd --zone=dmz --change-interface=ens3     # Move interface to zone
firewall-cmd --zone=public --remove-interface=ens3  # Remove interface from zone

# Source-based zones
firewall-cmd --zone=trusted --add-source=192.168.1.0/24  # Add source to zone
firewall-cmd --zone=public --remove-source=192.168.1.100 # Remove source
firewall-cmd --zone=work --list-sources                   # List sources in zone
```

### Service Management
```bash
# Service operations
firewall-cmd --get-services            # List all available services
firewall-cmd --list-services           # List enabled services in default zone
firewall-cmd --zone=public --list-services  # List services in specific zone

# Add/remove services
firewall-cmd --add-service=http         # Add HTTP service (runtime)
firewall-cmd --add-service=https        # Add HTTPS service (runtime)
firewall-cmd --remove-service=ssh       # Remove SSH service (runtime)
firewall-cmd --zone=dmz --add-service=mysql  # Add service to specific zone

# Permanent service changes
firewall-cmd --permanent --add-service=http     # Add service permanently
firewall-cmd --permanent --remove-service=ftp   # Remove service permanently
firewall-cmd --reload                           # Apply permanent changes

# Query services
firewall-cmd --query-service=http       # Check if service is enabled
firewall-cmd --zone=public --query-service=ssh  # Check service in specific zone
```

### Port Management
```bash
# Port operations
firewall-cmd --list-ports               # List open ports in default zone
firewall-cmd --zone=public --list-ports # List ports in specific zone

# Add/remove ports
firewall-cmd --add-port=8080/tcp        # Add TCP port 8080
firewall-cmd --add-port=53/udp          # Add UDP port 53
firewall-cmd --add-port=8000-8010/tcp   # Add port range
firewall-cmd --remove-port=8080/tcp     # Remove port

# Permanent port changes
firewall-cmd --permanent --add-port=9090/tcp    # Add port permanently
firewall-cmd --permanent --remove-port=23/tcp   # Remove port permanently

# Query ports
firewall-cmd --query-port=8080/tcp      # Check if port is open
```

### Rich Rules
```bash
# Rich rule syntax examples
# Accept SSH from specific subnet
firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" service name="ssh" accept'

# Reject HTTP from specific IP
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.0.0.50" service name="http" reject'

# Allow port 8080 from specific network
firewall-cmd --add-rich-rule='rule family="ipv4" source address="172.16.0.0/16" port protocol="tcp" port="8080" accept'

# Log and accept HTTPS traffic
firewall-cmd --add-rich-rule='rule family="ipv4" service name="https" log prefix="HTTPS-ACCESS" level="info" accept'

# Rate limit SSH connections
firewall-cmd --add-rich-rule='rule family="ipv4" service name="ssh" accept limit value="3/m"'

# Rich rule management
firewall-cmd --list-rich-rules          # List all rich rules
firewall-cmd --remove-rich-rule='rule...'  # Remove specific rich rule
```

### Configuration Persistence
```bash
# Runtime vs permanent configurations
firewall-cmd --list-all                 # Show runtime configuration
firewall-cmd --permanent --list-all     # Show permanent configuration

# Make changes permanent
firewall-cmd --runtime-to-permanent     # Save current runtime to permanent
firewall-cmd --permanent --add-service=http  # Add to permanent directly
firewall-cmd --reload                   # Load permanent config to runtime

# Configuration management
firewall-cmd --complete-reload          # Full reload (breaks connections)
firewall-cmd --check-config            # Validate configuration
```

### Advanced Features
```bash
# Custom services
firewall-cmd --permanent --new-service=myapp       # Create custom service
firewall-cmd --permanent --service=myapp --set-description="My Application"
firewall-cmd --permanent --service=myapp --add-port=9000/tcp
firewall-cmd --reload

# Port forwarding
firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8080:toaddr=192.168.1.100
firewall-cmd --add-masquerade           # Enable NAT/masquerading

# Direct rules (advanced)
firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -p tcp --dport 22 -j ACCEPT
```

### Command Reference Table
| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `firewall-cmd --state` | Check firewall status | | `firewall-cmd --state` |
| `firewall-cmd --list-all` | Show zone configuration | `--zone=name` | `firewall-cmd --zone=public --list-all` |
| `firewall-cmd --add-service` | Add service rule | `--permanent`, `--zone=name` | `firewall-cmd --permanent --add-service=http` |
| `firewall-cmd --add-port` | Add port rule | `--permanent`, `--zone=name` | `firewall-cmd --add-port=8080/tcp` |
| `firewall-cmd --add-rich-rule` | Add complex rule | `--permanent` | `firewall-cmd --add-rich-rule='rule...'` |
| `firewall-cmd --reload` | Apply permanent config | | `firewall-cmd --reload` |

---

## 4. Procedural Workflows

### Standard Procedure: Configure Web Server Firewall
1. **Check current firewall status**
   ```bash
   systemctl status firewalld
   firewall-cmd --state
   firewall-cmd --get-default-zone
   firewall-cmd --list-all
   ```

2. **Add web services**
   ```bash
   # Add HTTP and HTTPS services
   firewall-cmd --permanent --add-service=http
   firewall-cmd --permanent --add-service=https
   
   # Apply changes
   firewall-cmd --reload
   ```

3. **Verify configuration**
   ```bash
   firewall-cmd --list-services
   firewall-cmd --query-service=http
   firewall-cmd --query-service=https
   ```

4. **Test connectivity**
   ```bash
   # Test from external system
   telnet server-ip 80
   telnet server-ip 443
   ```

### Standard Procedure: Restrict SSH Access
1. **Check current SSH access**
   ```bash
   firewall-cmd --query-service=ssh
   firewall-cmd --list-all | grep ssh
   ```

2. **Remove SSH from default zone and add restricted access**
   ```bash
   # Remove SSH from public zone
   firewall-cmd --permanent --remove-service=ssh
   
   # Add SSH access only from management network
   firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" service name="ssh" accept'
   
   # Apply changes
   firewall-cmd --reload
   ```

3. **Verify restricted access**
   ```bash
   firewall-cmd --list-rich-rules
   firewall-cmd --list-services | grep ssh || echo "SSH not in services"
   ```

### Decision Tree: Firewall Rule Strategy
```
Firewall Configuration Need
├── Standard service (http, ssh, ftp)?
│   ├── Use predefined service → --add-service=name
│   └── Custom port needed? → --add-port=port/protocol
├── Source-based restrictions?
│   ├── Simple allow/deny? → Use zones with sources
│   └── Complex conditions? → Use rich rules
├── Multiple conditions?
│   ├── Log traffic? → Rich rules with logging
│   ├── Rate limiting? → Rich rules with limits
│   └── Time-based? → Rich rules with time conditions
└── Advanced networking?
    ├── Port forwarding? → --add-forward-port
    ├── NAT/Masquerading? → --add-masquerade
    └── Direct iptables? → --direct rules
```

### Standard Procedure: Database Server Security
1. **Create dedicated zone for database servers**
   ```bash
   # Create database zone
   firewall-cmd --permanent --new-zone=database
   firewall-cmd --permanent --zone=database --set-description="Database servers zone"
   firewall-cmd --permanent --zone=database --set-target=DROP
   ```

2. **Configure database zone rules**
   ```bash
   # Allow SSH from management network
   firewall-cmd --permanent --zone=database --add-rich-rule='rule family="ipv4" source address="192.168.100.0/24" service name="ssh" accept'
   
   # Allow MySQL from application servers
   firewall-cmd --permanent --zone=database --add-rich-rule='rule family="ipv4" source address="192.168.10.0/24" port protocol="tcp" port="3306" accept'
   
   # Apply changes
   firewall-cmd --reload
   ```

3. **Assign interface to database zone**
   ```bash
   # Move interface to database zone
   firewall-cmd --permanent --zone=database --change-interface=ens3
   firewall-cmd --reload
   
   # Verify assignment
   firewall-cmd --get-zone-of-interface=ens3
   firewall-cmd --zone=database --list-all
   ```

---

## 5. Configuration Deep Dive

### Firewall Zones Overview
#### Default Zones and Their Purposes
```bash
# Drop zone - deny all incoming, allow outgoing
# Target: DROP - most restrictive

# Block zone - reject all incoming with icmp-host-prohibited
# Target: %%REJECT%% - provides feedback to sender

# Public zone - default for public networks
# Target: default - deny all except explicitly allowed
# Default services: ssh, dhcpv6-client

# External zone - for external networks with masquerading
# Target: default - includes NAT functionality

# DMZ zone - for demilitarized zone servers
# Target: default - limited services for public access

# Work zone - for work networks
# Target: default - allows some additional services

# Home zone - for home networks  
# Target: default - more permissive than public

# Internal zone - for internal networks
# Target: default - trusts internal traffic more

# Trusted zone - all traffic allowed
# Target: ACCEPT - least restrictive
```

#### Zone Configuration Files
```bash
# Zone configuration location
/etc/firewalld/zones/         # Custom and modified zones
/usr/lib/firewalld/zones/     # Default system zones

# Example zone file: /etc/firewalld/zones/public.xml
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>Public</short>
  <description>For use in public areas.</description>
  <service name="ssh"/>
  <service name="dhcpv6-client"/>
  <port protocol="tcp" port="80"/>
  <rule family="ipv4">
    <source address="192.168.1.0/24"/>
    <service name="http"/>
    <accept/>
  </rule>
</zone>
```

### Service Definitions
#### Service Configuration Files
```bash
# Service definitions location
/etc/firewalld/services/      # Custom services
/usr/lib/firewalld/services/  # Default system services

# Example service file: /usr/lib/firewalld/services/http.xml
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>WWW (HTTP)</short>
  <description>HTTP is the protocol used to serve Web pages.</description>
  <port protocol="tcp" port="80"/>
</service>
```

#### Creating Custom Services
```bash
# Create custom web application service
firewall-cmd --permanent --new-service=webapp
firewall-cmd --permanent --service=webapp --set-description="Custom Web Application"
firewall-cmd --permanent --service=webapp --add-port=8080/tcp
firewall-cmd --permanent --service=webapp --add-port=8443/tcp
firewall-cmd --reload

# Use custom service
firewall-cmd --permanent --add-service=webapp
```

### Rich Rules Syntax
#### Rich Rule Components
```bash
# Basic syntax:
rule [family="ipv4|ipv6"]
     [source [address="address[/mask]"] [mac="mac-address"] [ipset="ipset-name"]]
     [destination [address="address[/mask]"]]
     [element]
     [log [prefix="prefix-text"] [level="log-level"] [limit value="rate/duration"]]
     [audit]
     [action]

# Elements can be:
# service name="service-name"
# port protocol="tcp|udp" port="port-number|port-range"
# protocol value="protocol"
# icmp-block name="icmp-type"
# masquerade
# forward-port port="port-number" protocol="tcp|udp" to-port="port-number" to-addr="address"

# Actions can be:
# accept, reject [type="reject-type"], drop
```

#### Rich Rule Examples
```bash
# Accept SSH from management network with logging
firewall-cmd --add-rich-rule='rule family="ipv4" source address="10.0.1.0/24" service name="ssh" log prefix="SSH-MGMT" level="info" accept'

# Reject FTP from specific IP
firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.100" service name="ftp" reject type="icmp-admin-prohibited"'

# Allow HTTP with rate limiting
firewall-cmd --add-rich-rule='rule family="ipv4" service name="http" accept limit value="100/s"'

# Port forwarding with rich rule
firewall-cmd --add-rich-rule='rule family="ipv4" forward-port port="2222" protocol="tcp" to-port="22"'
```

---

## 6. Hands-On Labs

### Lab 6.1: Basic Firewall Configuration (Asghar Ghori Style)
**Objective**: Configure basic firewall rules for common services

**Steps**:
1. **Explore current firewall configuration**
   ```bash
   # Check firewall status and default configuration
   systemctl status firewalld
   firewall-cmd --state
   firewall-cmd --get-default-zone
   firewall-cmd --get-active-zones
   firewall-cmd --list-all
   
   # Check available zones and services
   firewall-cmd --get-zones
   firewall-cmd --get-services | head -20
   ```

2. **Configure web server firewall rules**
   ```bash
   # Add HTTP and HTTPS services permanently
   firewall-cmd --permanent --add-service=http
   firewall-cmd --permanent --add-service=https
   
   # Add custom port for web application
   firewall-cmd --permanent --add-port=8080/tcp
   
   # Apply changes
   firewall-cmd --reload
   
   # Verify configuration
   firewall-cmd --list-services
   firewall-cmd --list-ports
   firewall-cmd --list-all
   ```

3. **Test runtime vs permanent changes**
   ```bash
   # Add FTP service to runtime only
   firewall-cmd --add-service=ftp
   
   # Check runtime vs permanent
   firewall-cmd --list-services
   firewall-cmd --permanent --list-services
   
   # Reload and see FTP disappear
   firewall-cmd --reload
   firewall-cmd --list-services
   
   # Add FTP permanently
   firewall-cmd --permanent --add-service=ftp
   firewall-cmd --reload
   firewall-cmd --list-services
   ```

4. **Practice zone management**
   ```bash
   # Check current zone assignment
   firewall-cmd --get-zone-of-interface=ens3
   
   # Temporarily change zone
   firewall-cmd --zone=work --change-interface=ens3
   firewall-cmd --get-active-zones
   
   # Check different zone rules
   firewall-cmd --list-all
   firewall-cmd --zone=work --list-all
   
   # Change back to public
   firewall-cmd --zone=public --change-interface=ens3
   ```

**Verification**:
```bash
# Complete verification of configuration
firewall-cmd --get-default-zone
firewall-cmd --get-active-zones
firewall-cmd --list-all
firewall-cmd --permanent --list-all
systemctl is-enabled firewalld
```

### Lab 6.2: Advanced Firewall Rules (Sander van Vugt Style)
**Objective**: Implement complex firewall rules using rich rules and custom zones

**Steps**:
1. **Create custom zone for DMZ servers**
   ```bash
   # Create DMZ zone
   firewall-cmd --permanent --new-zone=dmz-servers
   firewall-cmd --permanent --zone=dmz-servers --set-description="DMZ servers with restricted access"
   firewall-cmd --permanent --zone=dmz-servers --set-target=DROP
   
   # Apply changes
   firewall-cmd --reload
   
   # Verify zone creation
   firewall-cmd --get-zones | grep dmz-servers
   firewall-cmd --zone=dmz-servers --list-all
   ```

2. **Configure rich rules for specific access control**
   ```bash
   # Allow SSH only from management network
   firewall-cmd --permanent --zone=dmz-servers --add-rich-rule='rule family="ipv4" source address="192.168.100.0/24" service name="ssh" accept'
   
   # Allow HTTP from any source but log connections
   firewall-cmd --permanent --zone=dmz-servers --add-rich-rule='rule family="ipv4" service name="http" log prefix="DMZ-HTTP" level="info" accept'
   
   # Allow HTTPS with rate limiting
   firewall-cmd --permanent --zone=dmz-servers --add-rich-rule='rule family="ipv4" service name="https" accept limit value="50/s"'
   
   # Reject FTP from specific problematic network
   firewall-cmd --permanent --zone=dmz-servers --add-rich-rule='rule family="ipv4" source address="10.0.0.0/8" service name="ftp" reject'
   
   # Apply changes
   firewall-cmd --reload
   ```

3. **Create custom service definition**
   ```bash
   # Create custom application service
   firewall-cmd --permanent --new-service=custom-app
   firewall-cmd --permanent --service=custom-app --set-description="Custom Application Service"
   firewall-cmd --permanent --service=custom-app --add-port=9090/tcp
   firewall-cmd --permanent --service=custom-app --add-port=9091/udp
   
   # Add custom service to DMZ zone
   firewall-cmd --permanent --zone=dmz-servers --add-service=custom-app
   
   # Apply changes
   firewall-cmd --reload
   
   # Verify custom service
   firewall-cmd --get-services | grep custom-app
   firewall-cmd --zone=dmz-servers --list-services
   ```

4. **Test zone assignment and rules**
   ```bash
   # Assign interface to DMZ zone
   firewall-cmd --permanent --zone=dmz-servers --change-interface=ens3
   firewall-cmd --reload
   
   # Verify active configuration
   firewall-cmd --get-active-zones
   firewall-cmd --zone=dmz-servers --list-all
   
   # Test rule queries
   firewall-cmd --zone=dmz-servers --query-service=http
   firewall-cmd --zone=dmz-servers --query-service=custom-app
   firewall-cmd --zone=dmz-servers --list-rich-rules
   ```

**Verification**:
```bash
# Complete verification of advanced configuration
firewall-cmd --get-zones | grep dmz-servers
firewall-cmd --zone=dmz-servers --list-all
firewall-cmd --get-services | grep custom-app
firewall-cmd --zone=dmz-servers --list-rich-rules
```

### Lab 6.3: Firewall Troubleshooting Scenario (Synthesis Challenge)
**Objective**: Diagnose and resolve firewall connectivity issues

**Scenario**: A multi-tier application is experiencing connectivity issues that appear to be firewall-related

**Requirements**:
- Web tier needs HTTP/HTTPS access from internet
- Application tier needs custom port access from web tier only
- Database tier needs MySQL access from application tier only
- SSH access should be restricted to management network
- All configuration must be persistent

**Solution Steps**:
1. **Set up the problematic scenario**
   ```bash
   # Reset firewall to default state
   firewall-cmd --complete-reload
   
   # Create restrictive configuration that will cause problems
   firewall-cmd --set-default-zone=drop
   firewall-cmd --permanent --zone=drop --remove-service=ssh
   firewall-cmd --reload
   
   # This should now block most traffic - simulating the problem
   echo "=== PROBLEMATIC CONFIGURATION APPLIED ==="
   firewall-cmd --list-all
   ```

2. **Diagnose connectivity issues**
   ```bash
   # Step 1: Check firewall status and configuration
   echo "=== FIREWALL DIAGNOSIS ==="
   systemctl status firewalld
   firewall-cmd --state
   firewall-cmd --get-default-zone
   firewall-cmd --get-active-zones
   firewall-cmd --list-all
   
   # Step 2: Check what services should be running
   echo "=== EXPECTED SERVICES ==="
   echo "Web tier should allow: HTTP (80), HTTPS (443)"
   echo "App tier should allow: Custom app (9090) from web tier"
   echo "DB tier should allow: MySQL (3306) from app tier"
   echo "Management: SSH (22) from 192.168.100.0/24"
   
   # Step 3: Identify the problems
   echo "=== PROBLEMS IDENTIFIED ==="
   echo "1. Default zone is 'drop' - blocks everything"
   echo "2. No services are allowed through firewall"
   echo "3. SSH access is completely blocked"
   ```

3. **Implement systematic fix**
   ```bash
   # Fix 1: Change to appropriate default zone
   echo "=== FIXING DEFAULT ZONE ==="
   firewall-cmd --set-default-zone=public
   firewall-cmd --get-default-zone
   
   # Fix 2: Configure web tier access (public zone)
   echo "=== CONFIGURING WEB TIER ==="
   firewall-cmd --permanent --zone=public --add-service=http
   firewall-cmd --permanent --zone=public --add-service=https
   
   # Fix 3: Create application zone with restricted access
   echo "=== CREATING APPLICATION ZONE ==="
   firewall-cmd --permanent --new-zone=application
   firewall-cmd --permanent --zone=application --set-description="Application tier with restricted access"
   firewall-cmd --permanent --zone=application --set-target=DROP
   
   # Allow SSH from management network
   firewall-cmd --permanent --zone=application --add-rich-rule='rule family="ipv4" source address="192.168.100.0/24" service name="ssh" accept'
   
   # Allow application port 9090 from web servers (assuming web servers are in 192.168.1.0/24)
   firewall-cmd --permanent --zone=application --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" port protocol="tcp" port="9090" accept'
   
   # Fix 4: Create database zone with even more restricted access
   echo "=== CREATING DATABASE ZONE ==="
   firewall-cmd --permanent --new-zone=database
   firewall-cmd --permanent --zone=database --set-description="Database tier with MySQL access from app tier only"
   firewall-cmd --permanent --zone=database --set-target=DROP
   
   # Allow SSH from management network
   firewall-cmd --permanent --zone=database --add-rich-rule='rule family="ipv4" source address="192.168.100.0/24" service name="ssh" accept'
   
   # Allow MySQL from application servers (assuming app servers are in 192.168.2.0/24)
   firewall-cmd --permanent --zone=database --add-rich-rule='rule family="ipv4" source address="192.168.2.0/24" port protocol="tcp" port="3306" accept'
   
   # Apply all changes
   firewall-cmd --reload
   ```

4. **Verify and test the fix**
   ```bash
   # Verify zone configurations
   echo "=== VERIFYING CONFIGURATIONS ==="
   
   echo "Public zone (web tier):"
   firewall-cmd --zone=public --list-all
   
   echo "Application zone (app tier):"
   firewall-cmd --zone=application --list-all
   
   echo "Database zone (db tier):"
   firewall-cmd --zone=database --list-all
   
   # Test basic connectivity (simulation)
   echo "=== CONNECTIVITY TESTS ==="
   
   # Test HTTP service
   firewall-cmd --zone=public --query-service=http && echo "✓ HTTP allowed in public zone" || echo "✗ HTTP blocked"
   
   # Test HTTPS service
   firewall-cmd --zone=public --query-service=https && echo "✓ HTTPS allowed in public zone" || echo "✗ HTTPS blocked"
   
   # Test SSH in management networks
   firewall-cmd --zone=application --list-rich-rules | grep ssh && echo "✓ SSH restricted in application zone" || echo "✗ SSH not configured"
   firewall-cmd --zone=database --list-rich-rules | grep ssh && echo "✓ SSH restricted in database zone" || echo "✗ SSH not configured"
   
   # Verify rich rules for application and database access
   firewall-cmd --zone=application --list-rich-rules | grep 9090 && echo "✓ App port 9090 configured" || echo "✗ App port not configured"
   firewall-cmd --zone=database --list-rich-rules | grep 3306 && echo "✓ MySQL port 3306 configured" || echo "✗ MySQL port not configured"
   ```

5. **Document the solution**
   ```bash
   # Create comprehensive troubleshooting report
   cat > /tmp/firewall-troubleshooting-report.md << 'EOF'
   # Firewall Troubleshooting Report
   Date: $(date)
   
   ## Problem Description
   Multi-tier application experiencing connectivity issues due to overly restrictive firewall configuration.
   
   ## Issues Found
   1. **Default Zone**: Set to 'drop' zone blocking all traffic
   2. **Missing Services**: No HTTP/HTTPS services allowed for web tier
   3. **SSH Access**: Completely blocked, including from management network
   4. **Tier Isolation**: No proper network segmentation between application tiers
   
   ## Resolution Strategy
   ### 1. Zone-Based Security Architecture
   - **Public Zone**: Web tier with HTTP/HTTPS access
   - **Application Zone**: Restricted access, custom application ports
   - **Database Zone**: Highly restricted, MySQL access only from app tier
   
   ### 2. Implemented Rules
   #### Public Zone (Web Tier)
   ```bash
   firewall-cmd --permanent --zone=public --add-service=http
   firewall-cmd --permanent --zone=public --add-service=https
   ```
   
   #### Application Zone
   ```bash
   firewall-cmd --permanent --zone=application --add-rich-rule='rule family="ipv4" source address="192.168.100.0/24" service name="ssh" accept'
   firewall-cmd --permanent --zone=application --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" port protocol="tcp" port="9090" accept'
   ```
   
   #### Database Zone
   ```bash
   firewall-cmd --permanent --zone=database --add-rich-rule='rule family="ipv4" source address="192.168.100.0/24" service name="ssh" accept'
   firewall-cmd --permanent --zone=database --add-rich-rule='rule family="ipv4" source address="192.168.2.0/24" port protocol="tcp" port="3306" accept'
   ```
   
   ## Security Benefits
   1. **Defense in Depth**: Multiple zones provide layered security
   2. **Least Privilege**: Each tier only allows necessary access
   3. **Source Restriction**: SSH limited to management network
   4. **Service Isolation**: Database only accessible from application tier
   
   ## Testing Results
   - ✓ Web services (HTTP/HTTPS) accessible from internet
   - ✓ SSH access restricted to management network (192.168.100.0/24)
   - ✓ Application port (9090) accessible from web tier only
   - ✓ MySQL port (3306) accessible from application tier only
   - ✓ All configurations are permanent and survive reboots
   
   ## Maintenance Commands
   ```bash
   # Check zone assignments
   firewall-cmd --get-active-zones
   
   # Review specific zone rules
   firewall-cmd --zone=zonename --list-all
   
   # Test service access
   firewall-cmd --zone=zonename --query-service=servicename
   
   # Monitor firewall logs (if logging enabled)
   journalctl -u firewalld -f
   ```
   EOF
   
   # Display the report
   echo "=== TROUBLESHOOTING REPORT ==="
   cat /tmp/firewall-troubleshooting-report.md
   ```

**Verification**:
```bash
# Final comprehensive verification
echo "=== FINAL FIREWALL CONFIGURATION ==="
firewall-cmd --get-default-zone
firewall-cmd --get-zones | grep -E "(application|database)"
firewall-cmd --zone=public --list-all
firewall-cmd --zone=application --list-all  
firewall-cmd --zone=database --list-all
echo "Configuration is persistent: $(firewall-cmd --permanent --list-all > /dev/null 2>&1 && echo "Yes" || echo "No")"
```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: Service Can't Be Accessed After Firewall Configuration
**Symptoms**:
- Connection timeouts to service ports
- Service logs show no connection attempts
- Works when firewall is disabled

**Diagnosis**:
```bash
# Check firewall status and rules
firewall-cmd --state
firewall-cmd --list-all
firewall-cmd --list-services
firewall-cmd --list-ports

# Check if service is in correct zone
firewall-cmd --get-active-zones
firewall-cmd --get-zone-of-interface=interface-name

# Test from different zones
firewall-cmd --zone=trusted --list-all
```

**Resolution**:
```bash
# Add missing service or port
firewall-cmd --permanent --add-service=service-name
firewall-cmd --permanent --add-port=port/protocol

# Or check if interface is in wrong zone
firewall-cmd --zone=appropriate-zone --change-interface=interface-name

# Apply changes
firewall-cmd --reload

# Verify fix
firewall-cmd --list-all
```

**Prevention**: Always test connectivity after firewall changes

#### Issue 2: Rich Rules Not Working as Expected
**Symptoms**:
- Traffic not matching rich rule conditions
- Rules appear correct but don't apply
- Complex rules causing conflicts

**Diagnosis**:
```bash
# Check rich rule syntax
firewall-cmd --list-rich-rules

# Verify rule order (first match wins)
firewall-cmd --zone=zone-name --list-all

# Check for conflicting rules
firewall-cmd --list-all | grep -A 5 -B 5 problematic-rule
```

**Resolution**:
```bash
# Remove problematic rule
firewall-cmd --remove-rich-rule='rule family="ipv4"...'

# Add corrected rule
firewall-cmd --permanent --add-rich-rule='corrected-rule'

# Reload configuration
firewall-cmd --reload
```

#### Issue 3: Changes Not Persisting After Reboot
**Symptoms**:
- Firewall rules work but disappear after reboot
- Runtime configuration differs from permanent
- Services fail to start after system restart

**Diagnosis**:
```bash
# Compare runtime vs permanent
firewall-cmd --list-all
firewall-cmd --permanent --list-all

# Check configuration files
ls -la /etc/firewalld/zones/
cat /etc/firewalld/zones/zone-name.xml
```

**Resolution**:
```bash
# Make runtime changes permanent
firewall-cmd --runtime-to-permanent

# Or add rules with --permanent flag
firewall-cmd --permanent --add-service=service-name
firewall-cmd --reload

# Verify permanent configuration
firewall-cmd --permanent --list-all
```

### Diagnostic Command Sequence
```bash
# Firewall troubleshooting workflow
systemctl status firewalld       # Check service status
firewall-cmd --state             # Verify firewall is running
firewall-cmd --get-active-zones  # Check zone assignments
firewall-cmd --list-all          # Show current rules
firewall-cmd --permanent --list-all  # Show permanent rules
journalctl -u firewalld          # Check firewall logs
```

### Log File Analysis
- **`journalctl -u firewalld`**: Firewalld service logs
- **`/var/log/messages`**: System messages including firewall events
- **Rich rule logging**: Custom logs based on rich rule log statements
- **`dmesg`**: Kernel messages about netfilter/iptables

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance
```bash
# Basic status
firewall-cmd --state             # Check if firewall running
firewall-cmd --list-all          # Show all rules for default zone
firewall-cmd --get-active-zones  # Show active zones

# Services and ports
firewall-cmd --add-service=http  # Add service (runtime)
firewall-cmd --permanent --add-service=https  # Add service (permanent)
firewall-cmd --add-port=8080/tcp # Add port
firewall-cmd --reload            # Apply permanent changes

# Zones
firewall-cmd --set-default-zone=public  # Set default zone
firewall-cmd --zone=dmz --add-interface=ens3  # Assign interface to zone
```

### Common Services
- **http**: TCP port 80 (web server)
- **https**: TCP port 443 (secure web)
- **ssh**: TCP port 22 (secure shell)
- **ftp**: TCP port 21 (file transfer)
- **mysql**: TCP port 3306 (MySQL database)
- **dns**: TCP/UDP port 53 (domain name service)
- **smtp**: TCP port 25 (email)

### Zone Security Levels (Most to Least Restrictive)
1. **drop**: Drop all incoming, allow outgoing
2. **block**: Reject all incoming with ICMP error
3. **dmz**: Limited services for DMZ servers
4. **public**: Default zone, limited services
5. **external**: For external networks with NAT
6. **work**: Work networks, more services
7. **home**: Home networks, even more services  
8. **internal**: Internal networks, most services
9. **trusted**: Allow all traffic

### Rich Rule Template
```bash
firewall-cmd --add-rich-rule='
rule family="ipv4" 
     source address="192.168.1.0/24" 
     service name="http" 
     log prefix="HTTP-ACCESS" level="info" 
     accept'
```

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What's the difference between runtime and permanent firewall configuration?
   **Answer**: Runtime configuration is active immediately but lost on service restart or reboot. Permanent configuration is saved to files and survives restarts but requires `--reload` to become active. Use `--permanent` flag to modify saved configuration.

2. **Question**: Why would you use rich rules instead of simple service or port rules?
   **Answer**: Rich rules allow complex conditions like source/destination restrictions, logging, rate limiting, and time-based rules. Use them when simple service/port rules aren't sufficient for your security requirements.

3. **Question**: How do firewall zones relate to network interfaces?
   **Answer**: Zones are security contexts applied to network interfaces. Each interface can be assigned to one zone, and all traffic through that interface follows the zone's rules. This allows different security policies for different network connections.

### Practical Scenarios
1. **Scenario**: Web server needs HTTP access from internet but SSH only from management network.
   **Solution**: 
   ```bash
   firewall-cmd --permanent --add-service=http
   firewall-cmd --permanent --remove-service=ssh
   firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.100.0/24" service name="ssh" accept'
   ```

2. **Scenario**: Need to temporarily allow FTP access for maintenance without making it permanent.
   **Solution**: Use runtime-only configuration: `firewall-cmd --add-service=ftp` (without --permanent flag)

### Command Challenges
1. **Challenge**: Create a zone that only allows HTTPS and SSH from specific network, logging all connections.
   **Answer**: 
   ```bash
   firewall-cmd --permanent --new-zone=secure-web
   firewall-cmd --permanent --zone=secure-web --set-target=DROP
   firewall-cmd --permanent --zone=secure-web --add-rich-rule='rule family="ipv4" source address="trusted.network/24" service name="https" log prefix="HTTPS" accept'
   firewall-cmd --permanent --zone=secure-web --add-rich-rule='rule family="ipv4" source address="trusted.network/24" service name="ssh" log prefix="SSH" accept'
   ```

---

## 10. Exam Strategy

### Topic-Specific Tips
- Always check both runtime and permanent configurations
- Use `--permanent` flag for persistent changes, then `--reload`
- Remember that first matching rule wins in rich rules
- Test connectivity after every firewall change

### Common Exam Scenarios
1. **Scenario**: Configure web server with HTTP/HTTPS access
   **Approach**: Use standard service definitions with `--add-service=http` and `--add-service=https`

2. **Scenario**: Restrict SSH access to management network only
   **Approach**: Remove SSH service, add rich rule with source restriction

3. **Scenario**: Allow custom application port from specific sources
   **Approach**: Use rich rules with source and port specifications

### Time Management
- **Basic service configuration**: 3-4 minutes including verification
- **Zone configuration**: 5-7 minutes for custom zones with rules
- **Rich rule implementation**: 6-8 minutes for complex rules
- **Always verify**: Test rules with query commands and connectivity tests

### Pitfalls to Avoid
- Don't forget `--permanent` flag for persistent changes
- Remember to `--reload` after permanent changes
- Don't block SSH access without alternative access method
- Test connectivity before and after firewall changes
- Watch out for typos in rich rule syntax (they fail silently)

---

## Summary

### Key Takeaways
- **Firewalld is zone-based** - understand how zones work and use them effectively
- **Permanent vs runtime** - always use --permanent for lasting changes
- **Rich rules provide flexibility** - use them for complex access control requirements
- **Test everything** - firewall mistakes can lock you out of systems

### Critical Commands to Remember
```bash
firewall-cmd --permanent --add-service=http     # Add service permanently
firewall-cmd --permanent --add-port=8080/tcp    # Add port permanently
firewall-cmd --reload                           # Apply permanent changes
firewall-cmd --list-all                         # Show current zone config
firewall-cmd --add-rich-rule='rule...'          # Add complex rule
firewall-cmd --zone=zone-name --change-interface=ens3  # Assign interface to zone
```

### Next Steps
- Continue to [Module 11: Boot Process & GRUB](11_boot_grub.md)
- Practice firewall configuration in the Vagrant environment
- Review related topics: [Network Configuration](08_networking.md), [SELinux Management](09_selinux.md)

---

**Navigation**: [← SELinux Management](09_selinux.md) | [Index](index.md) | [Next → Boot Process & GRUB](11_boot_grub.md)