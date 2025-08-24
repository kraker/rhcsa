# 08 - Network Configuration

**Navigation**: [← Storage & LVM](07_storage_lvm.md) | [Index](index.md) | [Next → SELinux Management](09_selinux.md)

---

## 1. Executive Summary

**Topic Scope**: Network interface configuration, static IP assignment, hostname management, and network troubleshooting in RHEL 9

**RHCSA Relevance**: Essential system administration skill - network configuration is fundamental for server management

**Exam Weight**: Medium-High - Network tasks appear frequently in exam scenarios

**Prerequisites**: Basic understanding of TCP/IP networking and Linux command line operations

**Related Topics**: [System Installation](01_system_installation.md), [SSH Configuration](08_networking.md), [Firewall](10_firewall.md)

---

## 2. Conceptual Foundation

### Core Theory
RHEL 9 uses NetworkManager as the primary network management service:

- **NetworkManager**: Modern network configuration service replacing traditional networking scripts
- **Connection profiles**: Persistent network configurations stored by NetworkManager
- **Device vs Connection**: Devices are physical/virtual interfaces; connections are configurations applied to devices
- **Static vs DHCP**: Manual IP assignment versus automatic configuration
- **Network namespaces**: Isolated network environments (advanced topic)

### Real-World Applications
- **Server deployment**: Configuring static IPs for production servers
- **Network troubleshooting**: Diagnosing connectivity issues in enterprise environments
- **Remote management**: Ensuring SSH access through proper network configuration
- **Service hosting**: Setting up networks for web servers, databases, and applications
- **Network isolation**: Separating different types of traffic for security

### Common Misconceptions
- **NetworkManager vs network scripts**: RHEL 9 uses NetworkManager, not legacy scripts
- **Interface naming**: Modern systems use predictable names (ens3, enp0s3) not eth0
- **Connection vs device state**: A device can be up but connection down
- **DNS configuration**: Managed by NetworkManager, not directly in /etc/resolv.conf
- **Gateway terminology**: Default route and default gateway are the same concept

### Key Terminology
- **Interface**: Physical or virtual network device (ens3, enp0s3, virbr0)
- **Connection**: NetworkManager configuration profile applied to interface
- **Profile**: Persistent network configuration including IP, DNS, gateway
- **DHCP**: Dynamic Host Configuration Protocol for automatic IP assignment
- **Static IP**: Manually configured IP address that doesn't change
- **Gateway**: Router that connects local network to other networks
- **DNS**: Domain Name System for resolving hostnames to IP addresses
- **MTU**: Maximum Transmission Unit - largest packet size for interface

---

## 3. Command Mastery

### NetworkManager Commands (nmcli)
```bash
# Connection management
nmcli connection show                    # List all connections
nmcli connection show --active           # Show active connections
nmcli connection show "connection-name"  # Show specific connection details
nmcli connection up "connection-name"    # Activate connection
nmcli connection down "connection-name"  # Deactivate connection
nmcli connection delete "connection-name" # Delete connection
nmcli connection reload                  # Reload connection files

# Device information
nmcli device status                      # Show device status
nmcli device show                        # Show all device details
nmcli device show ens3                   # Show specific device details
nmcli device connect ens3                # Connect device to auto connection
nmcli device disconnect ens3             # Disconnect device

# Creating connections
nmcli connection add type ethernet con-name "static-ens3" ifname ens3 \
  ipv4.addresses 192.168.1.100/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "8.8.8.8 8.8.4.4" \
  ipv4.method manual

nmcli connection add type ethernet con-name "dhcp-ens3" ifname ens3 \
  ipv4.method auto

# Modifying connections
nmcli connection modify "static-ens3" ipv4.addresses 192.168.1.150/24
nmcli connection modify "static-ens3" ipv4.dns "8.8.8.8,1.1.1.1"
nmcli connection modify "static-ens3" connection.autoconnect yes
```

### Traditional Network Commands
```bash
# Interface information
ip addr show                    # Show all interface addresses
ip addr show ens3               # Show specific interface
ip link show                    # Show link layer information
ip route show                   # Show routing table
ip route show default           # Show default route only

# Legacy commands (still useful for information)
ifconfig                        # Show interface configuration (if installed)
route -n                        # Show routing table (if installed)
netstat -rn                     # Show routing table
ss -tuln                        # Show listening sockets (replaces netstat)
```

### Network Testing Commands
```bash
# Connectivity testing
ping -c 4 8.8.8.8              # Test internet connectivity
ping -c 4 192.168.1.1          # Test gateway connectivity
traceroute google.com          # Trace route to destination
tracepath google.com           # Alternative to traceroute

# DNS testing
nslookup google.com            # Basic DNS lookup
dig google.com                 # Detailed DNS query
host google.com                # Simple DNS lookup

# Port and service testing
telnet host 80                 # Test TCP port connectivity
nc -zv host 80                 # Test port with netcat
ss -tuln | grep :80            # Check if service listening on port
```

### Hostname Management
```bash
# Hostname commands
hostnamectl                     # Show hostname information
hostnamectl set-hostname server1.example.com  # Set hostname
hostnamectl status             # Detailed hostname status

# Legacy hostname commands
hostname                       # Show current hostname
hostname server1               # Set hostname (temporary)
```

### Network Configuration Files
```bash
# NetworkManager connection files
ls /etc/NetworkManager/system-connections/  # Connection profiles
cat /etc/NetworkManager/NetworkManager.conf # NetworkManager config

# System network files
cat /etc/hosts                 # Local hostname resolution
cat /etc/resolv.conf           # DNS configuration (managed by NetworkManager)
cat /etc/nsswitch.conf         # Name resolution order
```

### Command Reference Table
| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `nmcli con show` | List connections | `--active` | `nmcli con show --active` |
| `nmcli con add` | Create connection | `type`, `con-name`, `ifname` | `nmcli con add type ethernet con-name static ifname ens3` |
| `nmcli con modify` | Modify connection | `ipv4.addresses`, `ipv4.method` | `nmcli con modify static ipv4.addresses 192.168.1.100/24` |
| `ip addr show` | Show IP addresses | `dev` | `ip addr show dev ens3` |
| `ping` | Test connectivity | `-c` | `ping -c 4 8.8.8.8` |
| `hostnamectl` | Manage hostname | `set-hostname` | `hostnamectl set-hostname server1` |

---

## 4. Procedural Workflows

### Standard Procedure: Configure Static IP Address
1. **Identify available interface**
   ```bash
   nmcli device status
   ip link show
   ```

2. **Create static connection**
   ```bash
   nmcli connection add type ethernet \
     con-name "static-connection" \
     ifname ens3 \
     ipv4.addresses 192.168.1.100/24 \
     ipv4.gateway 192.168.1.1 \
     ipv4.dns "8.8.8.8 8.8.4.4" \
     ipv4.method manual \
     connection.autoconnect yes
   ```

3. **Activate connection**
   ```bash
   nmcli connection up "static-connection"
   ```

4. **Verify configuration**
   ```bash
   ip addr show ens3
   ip route show
   cat /etc/resolv.conf
   ping -c 2 8.8.8.8
   ```

### Standard Procedure: Switch from DHCP to Static
1. **Check current configuration**
   ```bash
   nmcli connection show --active
   nmcli device show ens3
   ```

2. **Modify existing connection**
   ```bash
   # Get current connection name
   CON_NAME=$(nmcli -t -f NAME connection show --active | head -1)
   
   # Modify to static
   nmcli connection modify "$CON_NAME" \
     ipv4.method manual \
     ipv4.addresses 192.168.1.100/24 \
     ipv4.gateway 192.168.1.1 \
     ipv4.dns "8.8.8.8,8.8.4.4"
   ```

3. **Apply changes**
   ```bash
   nmcli connection down "$CON_NAME"
   nmcli connection up "$CON_NAME"
   ```

4. **Verify changes**
   ```bash
   ip addr show
   ping -c 2 google.com
   ```

### Decision Tree: Network Configuration Strategy
```
Network Configuration Need
├── New system setup?
│   ├── DHCP available? → Use auto method
│   └── Static required? → Configure manual method
├── Change existing config?
│   ├── Modify current connection → nmcli con modify
│   └── Create new connection → nmcli con add
├── Troubleshooting?
│   ├── Check device status → nmcli device status
│   ├── Check connection status → nmcli con show --active
│   └── Test connectivity → ping, traceroute
└── Advanced needs?
    ├── Multiple IPs? → Add secondary addresses
    ├── VLANs? → Create VLAN connections
    └── Bonding? → Create bond connections
```

### Standard Procedure: Network Troubleshooting
1. **Check physical connectivity**
   ```bash
   nmcli device status
   ip link show
   # Look for "connected" state and "UP" flags
   ```

2. **Check IP configuration**
   ```bash
   ip addr show
   nmcli connection show --active
   ```

3. **Test network layers**
   ```bash
   # Layer 3 - IP connectivity
   ping -c 2 127.0.0.1        # Loopback
   ping -c 2 $(ip route | grep default | awk '{print $3}')  # Gateway
   ping -c 2 8.8.8.8          # External IP
   
   # Layer 7 - DNS resolution
   nslookup google.com
   ping -c 2 google.com
   ```

4. **Check services and ports**
   ```bash
   ss -tuln                   # Listening services
   systemctl status NetworkManager
   ```

---

## 5. Configuration Deep Dive

### NetworkManager Connection Files
#### Static IP Connection
```bash
# /etc/NetworkManager/system-connections/static-ens3.nmconnection
[connection]
id=static-ens3
uuid=12345678-1234-1234-1234-123456789012
type=ethernet
interface-name=ens3
autoconnect=true

[ethernet]

[ipv4]
address1=192.168.1.100/24,192.168.1.1
dns=8.8.8.8;8.8.4.4;
method=manual

[ipv6]
addr-gen-mode=eui64
method=auto

[proxy]
```

#### DHCP Connection
```bash
# /etc/NetworkManager/system-connections/dhcp-ens3.nmconnection
[connection]
id=dhcp-ens3
uuid=87654321-4321-4321-4321-210987654321
type=ethernet
interface-name=ens3
autoconnect=true

[ethernet]

[ipv4]
method=auto

[ipv6]
addr-gen-mode=eui64
method=auto

[proxy]
```

### Advanced Network Configuration
#### Multiple IP Addresses
```bash
# Add secondary IP to existing connection
nmcli connection modify "static-ens3" \
  +ipv4.addresses 192.168.1.101/24

# Or specify multiple IPs during creation
nmcli connection add type ethernet con-name "multi-ip" ifname ens3 \
  ipv4.addresses "192.168.1.100/24,192.168.1.101/24" \
  ipv4.gateway 192.168.1.1 \
  ipv4.method manual
```

#### DNS Configuration
```bash
# Set specific DNS servers
nmcli connection modify "connection-name" \
  ipv4.dns "8.8.8.8,8.8.4.4,1.1.1.1"

# Set DNS search domains
nmcli connection modify "connection-name" \
  ipv4.dns-search "example.com,lab.local"

# Ignore auto DNS (use manual only)
nmcli connection modify "connection-name" \
  ipv4.ignore-auto-dns yes
```

### Network Interface Naming
#### Predictable Network Interface Names
```bash
# Modern naming scheme (RHEL 9):
# ens3    - Ethernet slot 3
# enp0s3  - Ethernet PCI bus 0, slot 3  
# enp1s0f0 - Ethernet PCI bus 1, slot 0, function 0
# wls1    - Wireless LAN slot 1

# View interface naming details
udevadm info /sys/class/net/ens3
```

---

## 6. Hands-On Labs

### Lab 6.1: Basic Network Configuration (Asghar Ghori Style)
**Objective**: Configure static IP address and test connectivity

**Steps**:
1. **Explore current network configuration**
   ```bash
   # Check current interfaces and connections
   nmcli device status
   nmcli connection show
   
   # Show detailed interface information
   ip addr show
   ip route show
   
   # Check current connectivity
   ping -c 2 8.8.8.8
   ```

2. **Create static IP configuration**
   ```bash
   # Create new static connection (adjust IP range for your environment)
   nmcli connection add type ethernet \
     con-name "lab-static" \
     ifname ens3 \
     ipv4.addresses 192.168.1.150/24 \
     ipv4.gateway 192.168.1.1 \
     ipv4.dns "8.8.8.8 8.8.4.4" \
     ipv4.method manual \
     connection.autoconnect yes
   
   # Activate the new connection
   nmcli connection up "lab-static"
   ```

3. **Verify static configuration**
   ```bash
   # Check new IP configuration
   ip addr show ens3
   ip route show
   cat /etc/resolv.conf
   
   # Test connectivity
   ping -c 3 192.168.1.1        # Gateway
   ping -c 3 8.8.8.8            # External IP
   ping -c 3 google.com         # DNS resolution
   ```

4. **Test connection management**
   ```bash
   # Bring connection down and up
   nmcli connection down "lab-static"
   ip addr show ens3            # Should show no IP
   
   nmcli connection up "lab-static"
   ip addr show ens3            # Should show static IP
   
   # Show connection details
   nmcli connection show "lab-static"
   ```

**Verification**:
```bash
# Complete verification
nmcli connection show --active | grep lab-static
ping -c 2 google.com
nslookup google.com
ip route show | grep default
```

### Lab 6.2: Advanced Network Management (Sander van Vugt Style)
**Objective**: Modify existing connections and manage multiple network configurations

**Steps**:
1. **Analyze existing network setup**
   ```bash
   # Document current configuration
   nmcli connection show > /tmp/original-connections.txt
   nmcli device show > /tmp/original-devices.txt
   ip addr show > /tmp/original-ips.txt
   ```

2. **Create DHCP backup connection**
   ```bash
   # Create DHCP connection for same interface
   nmcli connection add type ethernet \
     con-name "lab-dhcp-backup" \
     ifname ens3 \
     ipv4.method auto \
     connection.autoconnect no
   
   # Test switching between static and DHCP
   nmcli connection down "lab-static"
   nmcli connection up "lab-dhcp-backup"
   
   # Check what IP was assigned by DHCP
   ip addr show ens3
   ```

3. **Modify connection properties**
   ```bash
   # Switch back to static and modify it
   nmcli connection down "lab-dhcp-backup"
   nmcli connection up "lab-static"
   
   # Add secondary IP address
   nmcli connection modify "lab-static" \
     +ipv4.addresses 192.168.1.151/24
   
   # Change DNS servers
   nmcli connection modify "lab-static" \
     ipv4.dns "1.1.1.1,8.8.8.8"
   
   # Apply changes
   nmcli connection down "lab-static"
   nmcli connection up "lab-static"
   ```

4. **Verify multiple IPs and DNS changes**
   ```bash
   # Check multiple IP addresses
   ip addr show ens3 | grep inet
   
   # Verify DNS changes
   cat /etc/resolv.conf
   
   # Test connectivity from both IPs
   ping -c 2 -I 192.168.1.150 google.com
   ping -c 2 -I 192.168.1.151 google.com
   ```

**Verification**:
```bash
# Document final configuration
nmcli connection show "lab-static"
ip addr show ens3
nslookup google.com
```

### Lab 6.3: Network Troubleshooting Scenario (Synthesis Challenge)
**Objective**: Diagnose and resolve complex network connectivity issues

**Scenario**: A server has lost network connectivity and needs systematic troubleshooting

**Requirements**:
- Systematically diagnose network issues
- Test connectivity at multiple network layers
- Document findings and resolution steps
- Restore full network functionality

**Solution Steps**:
1. **Create a "broken" network scenario**
   ```bash
   # Simulate network problems (choose one or more):
   
   # Problem 1: Wrong gateway
   nmcli connection modify "lab-static" ipv4.gateway 192.168.1.99
   
   # Problem 2: Wrong DNS
   nmcli connection modify "lab-static" ipv4.dns "192.168.1.99"
   
   # Problem 3: Wrong IP range
   nmcli connection modify "lab-static" ipv4.addresses 10.0.0.100/24
   
   # Apply one of these problematic configs
   nmcli connection down "lab-static"
   nmcli connection up "lab-static"
   
   # Verify the problem exists
   ping -c 2 google.com  # This should fail
   ```

2. **Systematic network troubleshooting**
   ```bash
   # Step 1: Check physical and link layer
   echo "=== LAYER 1 & 2 DIAGNOSTICS ==="
   nmcli device status
   ip link show ens3
   
   # Step 2: Check network layer (IP configuration)
   echo "=== LAYER 3 DIAGNOSTICS ==="
   ip addr show ens3
   ip route show
   
   # Step 3: Test connectivity at each level
   echo "=== CONNECTIVITY TESTS ==="
   
   # Test loopback
   ping -c 1 127.0.0.1 && echo "Loopback: OK" || echo "Loopback: FAIL"
   
   # Test local IP
   LOCAL_IP=$(ip addr show ens3 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
   ping -c 1 $LOCAL_IP && echo "Local IP: OK" || echo "Local IP: FAIL"
   
   # Test gateway
   GATEWAY=$(ip route show default | awk '{print $3}')
   ping -c 1 $GATEWAY && echo "Gateway: OK" || echo "Gateway: FAIL"
   
   # Test external IP
   ping -c 1 8.8.8.8 && echo "External IP: OK" || echo "External IP: FAIL"
   
   # Test DNS resolution
   nslookup google.com > /dev/null 2>&1 && echo "DNS Resolution: OK" || echo "DNS Resolution: FAIL"
   ```

3. **Diagnose and fix the specific problem**
   ```bash
   # Based on the test results, fix the issue:
   
   # If gateway test failed:
   echo "Fixing gateway configuration..."
   nmcli connection modify "lab-static" ipv4.gateway 192.168.1.1
   
   # If DNS resolution failed but external IP worked:
   echo "Fixing DNS configuration..."
   nmcli connection modify "lab-static" ipv4.dns "8.8.8.8,8.8.4.4"
   
   # If external IP failed but gateway worked (wrong IP range):
   echo "Fixing IP address configuration..."
   nmcli connection modify "lab-static" ipv4.addresses 192.168.1.150/24
   
   # Apply the fix
   nmcli connection down "lab-static"
   nmcli connection up "lab-static"
   ```

4. **Verify resolution and document**
   ```bash
   # Re-run connectivity tests
   echo "=== POST-FIX VERIFICATION ==="
   ping -c 2 127.0.0.1      # Loopback
   ping -c 2 192.168.1.1    # Gateway
   ping -c 2 8.8.8.8        # External IP
   ping -c 2 google.com     # DNS resolution
   
   # Create troubleshooting report
   cat > /tmp/network-troubleshooting-report.txt << EOF
   Network Troubleshooting Report
   Date: $(date)
   
   Problem Description:
   - Network connectivity was lost
   - Systematic diagnostics performed
   
   Diagnostics Performed:
   1. Physical layer check: nmcli device status
   2. IP configuration check: ip addr show, ip route show
   3. Connectivity tests: loopback, gateway, external IP, DNS
   
   Issue Found:
   $(if ping -c 1 google.com > /dev/null 2>&1; then echo "Issue resolved successfully"; else echo "Issue still present"; fi)
   
   Resolution Applied:
   - Modified connection: lab-static
   - Updated configuration parameters
   - Reactivated network connection
   
   Final Configuration:
   $(nmcli connection show "lab-static" | grep ipv4)
   
   Post-Fix Tests:
   - Gateway connectivity: $(ping -c 1 192.168.1.1 > /dev/null 2>&1 && echo "PASS" || echo "FAIL")
   - External connectivity: $(ping -c 1 8.8.8.8 > /dev/null 2>&1 && echo "PASS" || echo "FAIL")
   - DNS resolution: $(ping -c 1 google.com > /dev/null 2>&1 && echo "PASS" || echo "FAIL")
   EOF
   
   # Display the report
   cat /tmp/network-troubleshooting-report.txt
   ```

**Verification**:
```bash
# Final comprehensive verification
echo "=== FINAL NETWORK STATUS ==="
nmcli connection show --active
ip addr show ens3
ip route show | grep default
ping -c 2 google.com
nslookup google.com
cat /tmp/network-troubleshooting-report.txt
```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: No Network Connectivity After Configuration
**Symptoms**:
- Cannot ping gateway or external hosts
- New IP configuration not applied
- Connection shows as activated but no connectivity

**Diagnosis**:
```bash
# Check connection and device status
nmcli connection show --active
nmcli device status

# Verify IP configuration applied
ip addr show interface-name
ip route show

# Check NetworkManager logs
journalctl -u NetworkManager --since "10 minutes ago"
```

**Resolution**:
```bash
# Restart NetworkManager service
systemctl restart NetworkManager

# Reload connection configuration
nmcli connection reload

# Manually bring connection down and up
nmcli connection down "connection-name"
nmcli connection up "connection-name"

# Check for conflicting connections
nmcli connection show | grep interface-name
```

**Prevention**: Always verify configuration before applying, test in stages

#### Issue 2: DNS Resolution Not Working
**Symptoms**:
- Can ping IP addresses but not hostnames
- /etc/resolv.conf has wrong or no DNS servers
- nslookup/dig commands fail

**Diagnosis**:
```bash
# Check DNS configuration
cat /etc/resolv.conf
nmcli connection show active-connection | grep dns

# Test DNS directly
nslookup google.com 8.8.8.8
dig @8.8.8.8 google.com

# Check DNS service
systemctl status systemd-resolved  # If using resolved
```

**Resolution**:
```bash
# Fix DNS in connection configuration
nmcli connection modify "connection-name" \
  ipv4.dns "8.8.8.8,8.8.4.4"

# Ignore auto-assigned DNS if needed
nmcli connection modify "connection-name" \
  ipv4.ignore-auto-dns yes

# Restart connection
nmcli connection down "connection-name"
nmcli connection up "connection-name"
```

#### Issue 3: Interface Name Changes After Reboot
**Symptoms**:
- Network interface has different name after reboot
- Connection tied to specific interface fails
- Previous interface name no longer exists

**Diagnosis**:
```bash
# Check current interfaces
nmcli device status
ip link show

# Check for renamed interfaces
dmesg | grep -i "renamed network interface"
journalctl -b | grep "renamed network interface"
```

**Resolution**:
```bash
# Update connection to use correct interface
nmcli connection modify "connection-name" \
  connection.interface-name new-interface-name

# Or create new connection with correct interface
nmcli connection clone "old-connection" "new-connection"
nmcli connection modify "new-connection" \
  connection.interface-name new-interface-name
```

### Diagnostic Command Sequence
```bash
# Network troubleshooting workflow
nmcli device status              # Check device status
nmcli connection show --active   # Check active connections  
ip addr show                     # Check IP assignments
ip route show                    # Check routing table
ping -c 2 gateway-ip            # Test gateway connectivity
ping -c 2 8.8.8.8              # Test external connectivity
nslookup google.com             # Test DNS resolution
```

### Log File Analysis
- **`journalctl -u NetworkManager`**: NetworkManager service logs
- **`/var/log/messages`**: General system messages including network events
- **`dmesg`**: Kernel messages about network interfaces
- **`journalctl -f`**: Real-time log monitoring during troubleshooting

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance
```bash
# Connection management
nmcli con show                   # List connections
nmcli con up "name"             # Activate connection
nmcli con down "name"           # Deactivate connection

# Static IP setup
nmcli con add type ethernet con-name "static" ifname ens3 \
  ipv4.addresses 192.168.1.100/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "8.8.8.8" \
  ipv4.method manual

# Network information
ip addr show                    # Show IP addresses
ip route show                   # Show routing table
ping -c 2 host                  # Test connectivity
```

### NetworkManager Configuration Structure
```bash
# Connection properties:
connection.id                   # Connection name
connection.interface-name       # Interface to use
connection.autoconnect         # Auto-connect on boot

# IPv4 properties:
ipv4.method                    # auto (DHCP) or manual (static)
ipv4.addresses                 # IP address/netmask
ipv4.gateway                   # Default gateway
ipv4.dns                       # DNS servers
```

### Common Network Ranges
- **Private Class A**: 10.0.0.0/8 (10.0.0.0 - 10.255.255.255)
- **Private Class B**: 172.16.0.0/12 (172.16.0.0 - 172.31.255.255)  
- **Private Class C**: 192.168.0.0/16 (192.168.0.0 - 192.168.255.255)
- **Loopback**: 127.0.0.0/8 (127.0.0.1 is localhost)

### DNS Servers
- **Google**: 8.8.8.8, 8.8.4.4
- **Cloudflare**: 1.1.1.1, 1.0.0.1
- **Quad9**: 9.9.9.9, 149.112.112.112

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What's the difference between a network device and a network connection in NetworkManager?
   **Answer**: A device is a physical or virtual network interface (like ens3), while a connection is a configuration profile that can be applied to a device. One device can have multiple connection profiles, but only one can be active at a time.

2. **Question**: Why might /etc/resolv.conf show different DNS servers than what you configured?
   **Answer**: NetworkManager dynamically manages /etc/resolv.conf. If you have multiple connections or DHCP is providing DNS servers, NetworkManager combines them. Use `nmcli connection show` to see the actual DNS configuration for each connection.

3. **Question**: What happens when you set ipv4.method to "auto" versus "manual"?
   **Answer**: "auto" uses DHCP to automatically obtain IP address, gateway, and DNS servers from a DHCP server. "manual" requires you to explicitly specify all network parameters and creates a static configuration.

### Practical Scenarios
1. **Scenario**: Server needs to be accessible from multiple subnets but only has one interface.
   **Solution**: Add multiple IP addresses to the same connection:
   ```bash
   nmcli con modify "connection" ipv4.addresses "192.168.1.100/24,10.0.1.100/24"
   ```

2. **Scenario**: Need to quickly switch between office and home network configurations.
   **Solution**: Create two connection profiles for the same interface and switch between them:
   ```bash
   nmcli con add type ethernet con-name "office" ifname ens3 ipv4.method manual ...
   nmcli con add type ethernet con-name "home" ifname ens3 ipv4.method auto
   # Switch: nmcli con up "office" or nmcli con up "home"
   ```

### Command Challenges
1. **Challenge**: Create a connection that gets IP via DHCP but uses custom DNS servers.
   **Answer**: 
   ```bash
   nmcli con add type ethernet con-name "dhcp-custom-dns" ifname ens3 \
     ipv4.method auto \
     ipv4.dns "8.8.8.8,8.8.4.4" \
     ipv4.ignore-auto-dns yes
   ```

2. **Challenge**: Find all interfaces that are up but don't have an IP address.
   **Answer**: `ip link show | grep "state UP" -A1 | grep -B1 "NO-CARRIER\|state UP" | grep "^[0-9]" | cut -d: -f2`

---

## 10. Exam Strategy

### Topic-Specific Tips
- Always use `nmcli` for configuration - it's the modern RHEL 9 way
- Verify configuration with both `nmcli` and `ip` commands
- Remember that connections must be activated after creation
- Test connectivity at multiple levels (gateway, external, DNS)

### Common Exam Scenarios
1. **Scenario**: Configure static IP address on server
   **Approach**: Use `nmcli con add` with manual method, specify all required parameters

2. **Scenario**: Fix server that lost network connectivity
   **Approach**: Check device status, connection status, IP configuration, test connectivity systematically

3. **Scenario**: Change hostname of server
   **Approach**: Use `hostnamectl set-hostname` and verify with `hostnamectl status`

### Time Management
- **Static IP configuration**: 5-7 minutes including verification
- **Network troubleshooting**: 8-10 minutes for systematic diagnosis
- **Hostname changes**: 2-3 minutes
- **Always verify**: Test connectivity after any network changes

### Pitfalls to Avoid
- Don't forget to activate connections after creating them
- Remember that interface names may not be eth0 (use `nmcli device status` to find correct names)
- Always test both IP connectivity and DNS resolution
- Don't modify /etc/resolv.conf directly - use NetworkManager
- Verify changes persist after reboot if required

---

## Summary

### Key Takeaways
- **NetworkManager is the standard** in RHEL 9 - master `nmcli` commands
- **Connections are profiles** applied to devices - understand this relationship
- **Systematic troubleshooting** saves time - test connectivity at each network layer
- **Always verify configuration** with multiple commands and connectivity tests

### Critical Commands to Remember
```bash
nmcli con add type ethernet con-name "static" ifname ens3 \
  ipv4.addresses 192.168.1.100/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "8.8.8.8" \
  ipv4.method manual               # Create static IP connection

nmcli con show --active            # Show active connections
ip addr show                       # Show interface IP addresses
ping -c 2 gateway-ip              # Test connectivity
hostnamectl set-hostname name      # Set system hostname
```

### Next Steps
- Continue to [Module 09: SELinux Management](09_selinux.md)
- Practice network configuration in the Vagrant environment
- Review related topics: [Firewall Configuration](10_firewall.md), [SSH Setup](08_networking.md)

---

**Navigation**: [← Storage & LVM](07_storage_lvm.md) | [Index](index.md) | [Next → SELinux Management](09_selinux.md)