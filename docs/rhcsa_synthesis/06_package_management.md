# 06 - Package Management

**Navigation**: [← Process Management](05_process_service_management.md) | [Index](index.md) | [Next → Storage & LVM](07_storage_lvm.md)

---

## 1. Executive Summary

**Topic Scope**: DNF package manager, RPM operations, repository management, and software installation in RHEL 9

**RHCSA Relevance**: Essential system administration skill - package management is fundamental for maintaining RHEL systems

**Exam Weight**: Medium-High - Package operations appear in various exam scenarios

**Prerequisites**: Basic understanding of Linux file system and command line operations

**Related Topics**: [System Installation](01_system_installation.md), [Service Management](05_process_service_management.md), [Security](09_selinux.md)

---

## 2. Conceptual Foundation

### Core Theory
RHEL 9 uses DNF (Dandified YUM) as the primary package manager, which provides:

- **Dependency resolution**: Automatic handling of package dependencies
- **Repository management**: Centralized software distribution points
- **Transaction safety**: Rollback capability for failed installations
- **Metadata caching**: Improved performance through local metadata storage
- **Modular content**: Support for application streams and modules

### Real-World Applications
- **System maintenance**: Installing security updates and patches
- **Software deployment**: Installing applications and development tools
- **Environment setup**: Configuring development or production environments
- **Security compliance**: Keeping systems updated with latest security fixes
- **Custom repositories**: Managing internal software distributions

### Common Misconceptions
- **DNF vs YUM**: DNF is the successor to YUM with better dependency resolution
- **Package vs RPM**: Packages are distributed as RPMs, but package managers handle dependencies
- **Repository priority**: Higher numbers mean lower priority (opposite of what you might expect)
- **Clean vs remove**: Clean removes cache, remove uninstalls packages
- **Modules vs packages**: Modules provide different versions/streams of software

### Key Terminology
- **Package**: Software bundle with metadata, dependencies, and installation scripts
- **Repository**: Collection of packages available for installation
- **Metadata**: Information about packages, dependencies, and repositories
- **Transaction**: Complete package operation (install, update, remove)
- **Dependency**: Required packages for software to function
- **Module**: Collection of packages representing different versions of software
- **Stream**: Specific version of a module
- **Profile**: Set of packages within a module for specific use cases

---

## 3. Command Mastery

### Basic DNF Operations
```bash
# Package installation and removal
dnf install packagename              # Install package
dnf install package1 package2       # Install multiple packages
dnf remove packagename               # Remove package
dnf autoremove                       # Remove unneeded dependencies
dnf reinstall packagename            # Reinstall package

# Package updates
dnf update                           # Update all packages
dnf update packagename               # Update specific package
dnf check-update                     # Check for available updates
dnf upgrade                          # Alias for update

# Package information
dnf info packagename                 # Show package details
dnf list installed                   # List installed packages
dnf list available                   # List available packages
dnf list updates                     # List available updates
dnf search keyword                   # Search packages by keyword
dnf provides */filename              # Find package providing file
```

### Advanced DNF Operations
```bash
# Package groups
dnf grouplist                        # List available groups
dnf groupinstall "Group Name"        # Install package group
dnf groupremove "Group Name"         # Remove package group
dnf groupinfo "Group Name"           # Show group information

# Transaction history
dnf history                          # Show transaction history
dnf history info transaction-id      # Details of specific transaction
dnf history undo transaction-id      # Undo transaction
dnf history redo transaction-id      # Redo transaction

# Local package installation
dnf localinstall package.rpm         # Install local RPM
dnf install /path/to/package.rpm     # Alternative syntax

# Download operations
dnf download packagename             # Download package without installing
dnf download --resolve packagename   # Download with dependencies
```

### Repository Management
```bash
# Repository operations
dnf repolist                         # List enabled repositories
dnf repolist --all                   # List all repositories
dnf repolist --disabled              # List disabled repositories
dnf config-manager --add-repo URL    # Add repository
dnf config-manager --enable repo     # Enable repository
dnf config-manager --disable repo    # Disable repository

# Cache management
dnf makecache                        # Download repository metadata
dnf clean all                        # Clean all cache
dnf clean packages                   # Clean downloaded packages
dnf clean metadata                   # Clean repository metadata
dnf clean expire-cache               # Clean expired cache
```

### Module Management
```bash
# Module operations
dnf module list                      # List available modules
dnf module list --installed          # List installed modules
dnf module info modulename           # Show module information
dnf module install modulename:stream # Install specific stream
dnf module enable modulename:stream  # Enable module stream
dnf module disable modulename        # Disable module
dnf module reset modulename          # Reset module state
```

### RPM Commands
```bash
# Package information
rpm -qa                              # List all installed packages
rpm -qi packagename                  # Query package information
rpm -ql packagename                  # List package files
rpm -qd packagename                  # List package documentation
rpm -qc packagename                  # List configuration files
rpm -qf /path/to/file               # Find package owning file

# Package verification
rpm -V packagename                   # Verify package integrity
rpm -Va                             # Verify all packages

# Package installation (not recommended, use DNF instead)
rpm -ivh package.rpm                # Install package
rpm -Uvh package.rpm                # Upgrade package
rpm -e packagename                  # Erase package
```

### Command Reference Table
| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `dnf install` | Install packages | `-y`, `--nogpgcheck` | `dnf install -y httpd` |
| `dnf remove` | Remove packages | `-y` | `dnf remove -y packagename` |
| `dnf update` | Update packages | `-y`, `--security` | `dnf update -y` |
| `dnf search` | Search packages | | `dnf search web server` |
| `dnf info` | Package information | | `dnf info httpd` |
| `dnf history` | Transaction history | `info`, `undo`, `redo` | `dnf history undo 5` |

---

## 4. Procedural Workflows

### Standard Procedure: Software Installation
1. **Search for package**
   ```bash
   dnf search keyword
   dnf info packagename
   ```

2. **Install package**
   ```bash
   dnf install -y packagename
   ```

3. **Verify installation**
   ```bash
   dnf list installed | grep packagename
   rpm -qi packagename
   ```

4. **Configure and start if it's a service**
   ```bash
   systemctl enable --now servicename
   systemctl status servicename
   ```

### Standard Procedure: System Updates
1. **Check for updates**
   ```bash
   dnf check-update
   dnf list updates
   ```

2. **Review security updates**
   ```bash
   dnf updateinfo list security
   dnf updateinfo info security
   ```

3. **Apply updates**
   ```bash
   # Test updates first
   dnf update --downloadonly
   
   # Apply all updates
   dnf update -y
   
   # Or security only
   dnf update --security -y
   ```

4. **Verify and reboot if needed**
   ```bash
   dnf history info last
   # Reboot if kernel updated
   needs-restarting -r
   ```

### Decision Tree: Package Management Strategy
```
Package Task
├── Installing new software?
│   ├── Available in repositories? → dnf install
│   └── Local RPM file? → dnf localinstall
├── System maintenance?
│   ├── Security updates? → dnf update --security
│   └── Full update? → dnf update
├── Removing software?
│   ├── Remove package only? → dnf remove
│   └── Remove dependencies too? → dnf autoremove
└── Troubleshooting?
    ├── Package conflicts? → Check dnf history
    ├── Dependency issues? → dnf check
    └── Corrupted packages? → rpm -V
```

### Standard Procedure: Repository Management
1. **Add new repository**
   ```bash
   # Method 1: Using config-manager
   dnf config-manager --add-repo https://example.com/repo
   
   # Method 2: Manual file creation
   cat > /etc/yum.repos.d/custom.repo << 'EOF'
   [custom-repo]
   name=Custom Repository
   baseurl=https://example.com/repo
   enabled=1
   gpgcheck=1
   gpgkey=https://example.com/repo/RPM-GPG-KEY
   EOF
   ```

2. **Update repository metadata**
   ```bash
   dnf makecache
   ```

3. **Verify repository**
   ```bash
   dnf repolist
   dnf repoinfo custom-repo
   ```

---

## 5. Configuration Deep Dive

### DNF Configuration Files
#### Main Configuration
```bash
# /etc/dnf/dnf.conf
[main]
gpgcheck=1                    # Verify package signatures
installonly_limit=3           # Keep 3 kernels maximum
clean_requirements_on_remove=True  # Clean unused dependencies
best=True                     # Use best available package versions
skip_if_unavailable=False     # Fail if repository unavailable
```

#### Repository Configuration
```bash
# /etc/yum.repos.d/example.repo
[repository-id]
name=Human Readable Repository Name
baseurl=https://example.com/repo/
        file:///path/to/local/repo
mirrorlist=https://example.com/mirrors
metalink=https://example.com/metalink.xml
enabled=1                     # 1=enabled, 0=disabled
gpgcheck=1                    # 1=check signatures, 0=don't check
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-example
       https://example.com/RPM-GPG-KEY
priority=1                    # Lower number = higher priority
cost=1000                     # Repository cost (lower = preferred)
includepkgs=package1,package2 # Only include these packages
excludepkgs=package3,package4 # Exclude these packages
```

### Package Groups Configuration
#### Common Package Groups
```bash
# Development tools
dnf groupinstall "Development Tools"

# Web server
dnf groupinstall "Web Server"

# Virtualization
dnf groupinstall "Virtualization Hypervisor"
dnf groupinstall "Virtualization Client"

# Desktop environments
dnf groupinstall "GNOME Desktop Environment"
dnf groupinstall "KDE Plasma Workspaces"
```

### Module Configuration
#### Module Stream Management
```bash
# List available streams for a module
dnf module list nodejs

# Enable specific stream
dnf module enable nodejs:14

# Install module with specific profile
dnf module install nodejs:14/development

# Switch to different stream
dnf module reset nodejs
dnf module enable nodejs:16
dnf module install nodejs:16/minimal
```

---

## 6. Hands-On Labs

### Lab 6.1: Basic Package Operations (Asghar Ghori Style)
**Objective**: Master fundamental DNF package management operations

**Steps**:
1. **Explore package information**
   ```bash
   # Search for web server packages
   dnf search "web server"
   dnf search apache
   
   # Get detailed information
   dnf info httpd
   dnf info nginx
   
   # Check what's installed
   dnf list installed | grep -i web
   ```

2. **Install and configure packages**
   ```bash
   # Install web server
   dnf install -y httpd
   
   # Install additional packages
   dnf install -y wget curl
   
   # Verify installations
   dnf list installed | grep -E "(httpd|wget|curl)"
   rpm -qi httpd
   ```

3. **Manage package groups**
   ```bash
   # List available groups
   dnf grouplist | head -20
   
   # Get information about development tools
   dnf groupinfo "Development Tools"
   
   # Install development group (if not already installed)
   dnf groupinstall -y "Development Tools"
   
   # List installed groups
   dnf grouplist --installed
   ```

4. **Practice package removal**
   ```bash
   # Remove a package
   dnf remove -y wget
   
   # Check for orphaned dependencies
   dnf autoremove
   
   # Reinstall package
   dnf install -y wget
   ```

**Verification**:
```bash
# Verify package operations
dnf history | head -10
dnf list installed | grep -E "(httpd|curl)"
systemctl status httpd
```

### Lab 6.2: Repository Management (Sander van Vugt Style)
**Objective**: Configure and manage software repositories

**Steps**:
1. **Explore existing repositories**
   ```bash
   # List current repositories
   dnf repolist
   dnf repolist --all
   
   # Get detailed repository information
   dnf repoinfo baseos
   dnf repoinfo appstream
   
   # Check repository configuration files
   ls /etc/yum.repos.d/
   cat /etc/yum.repos.d/redhat.repo
   ```

2. **Add EPEL repository (Extra Packages for Enterprise Linux)**
   ```bash
   # Install EPEL release package
   dnf install -y epel-release
   
   # Verify EPEL repository is added
   dnf repolist | grep epel
   
   # Search for packages in EPEL
   dnf search --enablerepo=epel htop
   dnf info --enablerepo=epel htop
   ```

3. **Practice repository management**
   ```bash
   # Disable a repository temporarily
   dnf config-manager --disable epel
   dnf repolist | grep epel
   
   # Enable repository
   dnf config-manager --enable epel
   dnf repolist | grep epel
   
   # Update repository metadata
   dnf makecache
   dnf clean expire-cache
   ```

4. **Work with repository priorities**
   ```bash
   # View repository configuration
   cat /etc/yum.repos.d/epel.repo
   
   # Install package from specific repository
   dnf install --enablerepo=epel -y htop
   
   # Verify installation
   which htop
   htop --version
   ```

**Verification**:
```bash
# Verify repository configuration
dnf repolist
dnf list installed | grep epel
ls -la /etc/yum.repos.d/
```

### Lab 6.3: Advanced Package Management (Synthesis Challenge)
**Objective**: Handle complex package scenarios including modules, local packages, and troubleshooting

**Scenario**: Set up a development environment with specific software versions and handle package conflicts

**Requirements**:
- Install development tools
- Configure specific module streams
- Install local packages
- Handle dependency conflicts
- Document the configuration

**Solution Steps**:
1. **Set up development environment**
   ```bash
   # Install base development tools
   dnf groupinstall -y "Development Tools"
   
   # Install additional development packages
   dnf install -y git vim-enhanced tree
   
   # List installed development packages
   dnf groupinfo "Development Tools" | grep "Installed Packages"
   ```

2. **Work with modules for specific versions**
   ```bash
   # List available modules
   dnf module list | head -20
   
   # Work with Node.js module (example)
   dnf module list nodejs
   
   # Enable specific stream and install
   dnf module enable -y nodejs:16
   dnf module install -y nodejs:16/development
   
   # Verify module installation
   node --version
   npm --version
   ```

3. **Handle local package installation**
   ```bash
   # Create a directory for downloaded packages
   mkdir ~/packages
   cd ~/packages
   
   # Download a package without installing
   dnf download --resolve tree
   
   # List downloaded packages
   ls -la *.rpm
   
   # Reinstall from local file
   dnf remove -y tree
   dnf localinstall -y tree-*.rpm
   ```

4. **Troubleshoot package issues**
   ```bash
   # Check for package problems
   dnf check
   
   # Verify package integrity
   rpm -Va | head -10
   
   # Check transaction history
   dnf history | head -10
   dnf history info last
   
   # Clean up if needed
   dnf autoremove -y
   dnf clean all
   ```

5. **Document the environment**
   ```bash
   # Create environment documentation
   cat > ~/development-environment.md << 'EOF'
   # Development Environment Setup
   
   ## Installed Components
   - Development Tools group
   - Node.js version 16.x with development profile
   - Git, Vim, Tree utilities
   
   ## Repository Configuration
   - BaseOS and AppStream (default RHEL repositories)
   - EPEL repository for additional packages
   
   ## Module Configuration
   - nodejs:16 stream enabled with development profile
   
   ## Package Verification Commands
   ```bash
   dnf grouplist --installed
   dnf module list --installed
   node --version && npm --version
   ```
   EOF
   
   # Create package list backup
   dnf list installed > ~/installed-packages-$(date +%Y%m%d).txt
   ```

**Verification**:
```bash
# Complete environment verification
dnf grouplist --installed | grep -i development
dnf module list --installed
node --version
npm --version
git --version
tree --version
cat ~/development-environment.md
```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: Package Installation Failures
**Symptoms**:
- "Nothing to do" message when installing
- Dependency conflicts
- Repository errors

**Diagnosis**:
```bash
# Check if package exists
dnf search packagename
dnf info packagename

# Check repository status
dnf repolist
dnf makecache

# Check for conflicts
dnf check
```

**Resolution**:
```bash
# Update repository metadata
dnf clean expire-cache
dnf makecache

# Try alternative package name
dnf search keyword

# Install with specific repository
dnf install --enablerepo=repository packagename

# Force reinstall if corrupted
dnf reinstall packagename
```

**Prevention**: Regular repository metadata updates and system maintenance

#### Issue 2: Dependency Hell
**Symptoms**:
- Circular dependency errors
- "Package does not exist" for dependencies
- Transaction test failures

**Diagnosis**:
```bash
# Check package dependencies
dnf deplist packagename
rpm -qR packagename

# Review transaction history
dnf history info problematic-transaction
```

**Resolution**:
```bash
# Reset transaction
dnf history undo problematic-transaction

# Use different installation method
dnf shell
> install package1
> install package2
> run

# Exclude problematic packages temporarily
dnf install packagename --exclude=problematic-package
```

#### Issue 3: Repository Problems
**Symptoms**:
- "Repository not found" errors
- GPG signature failures
- Slow or failed downloads

**Diagnosis**:
```bash
# Check repository configuration
cat /etc/yum.repos.d/problematic.repo

# Test repository connectivity
curl -I repository-baseurl

# Check GPG keys
rpm -qa gpg-pubkey*
```

**Resolution**:
```bash
# Fix repository URL
vim /etc/yum.repos.d/problematic.repo

# Import missing GPG keys
rpm --import /path/to/RPM-GPG-KEY

# Disable GPG check temporarily (not recommended)
dnf install --nogpgcheck packagename

# Update repository metadata
dnf clean all
dnf makecache
```

### Diagnostic Command Sequence
```bash
# Package troubleshooting workflow
dnf check                    # Check for problems
dnf repolist                 # Verify repositories
dnf history                  # Check recent transactions
rpm -Va | head -20          # Verify package integrity
df -h                       # Check disk space
```

### Log File Analysis
- **`/var/log/dnf.log`**: DNF transaction logs
- **`/var/log/dnf.librepo.log`**: Repository access logs
- **`/var/log/dnf.rpm.log`**: RPM transaction logs
- **`/var/log/hawkey.log`**: Dependency resolution logs

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance
```bash
# Basic operations
dnf install packagename      # Install package
dnf remove packagename       # Remove package
dnf update                   # Update all packages
dnf search keyword           # Search packages

# Information
dnf info packagename         # Package details
dnf list installed          # Installed packages
dnf provides filename       # Find package providing file

# Repository management
dnf repolist                # List repositories
dnf makecache              # Update metadata
dnf clean all              # Clean cache
```

### Common Package Groups
- **"Development Tools"**: Compilers, build tools
- **"Web Server"**: Apache HTTP server and related
- **"Virtualization Host"**: KVM and virtualization tools
- **"Security Tools"**: Security-related packages

### RPM Query Options
- **`-qa`**: List all installed packages
- **`-qi`**: Package information
- **`-ql`**: List package files  
- **`-qf`**: Find package owning file
- **`-qd`**: List documentation files
- **`-qc`**: List configuration files

### DNF History Operations
- **`dnf history`**: Show transaction history
- **`dnf history info ID`**: Transaction details
- **`dnf history undo ID`**: Undo transaction
- **`dnf history redo ID`**: Redo transaction

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What's the difference between `dnf remove` and `dnf autoremove`?
   **Answer**: `dnf remove` removes specified packages and their dependencies that are no longer needed by other packages. `dnf autoremove` removes packages that were installed as dependencies but are no longer required by any installed packages. Use `autoremove` to clean up orphaned dependencies.

2. **Question**: Why would you use modules instead of regular packages?
   **Answer**: Modules provide different versions (streams) of software that aren't available as separate packages. For example, you can choose Node.js 14, 16, or 18 streams. Modules also offer different profiles (minimal, development, etc.) with different sets of packages for specific use cases.

3. **Question**: When should you use `rpm` commands instead of `dnf`?
   **Answer**: Use `rpm` for querying information about installed packages, verifying package integrity, and installing local packages when you don't need dependency resolution. Use `dnf` for installation, updates, and dependency management. Never use `rpm -e` to remove packages - use `dnf remove` instead.

### Practical Scenarios
1. **Scenario**: You need to install a specific version of Python that's not available in the default repositories.
   **Solution**: Check for Python modules with `dnf module list python*`, enable the desired stream with `dnf module enable python39:3.9`, then install with `dnf module install python39:3.9`.

2. **Scenario**: A package installation failed halfway through and the system is in an inconsistent state.
   **Solution**: Use `dnf history` to find the failed transaction, then `dnf history undo transaction-id` to roll back the changes.

### Command Challenges
1. **Challenge**: Find which package provides the `netstat` command.
   **Answer**: `dnf provides */netstat` or `dnf whatprovides netstat`
   **Explanation**: The `provides` subcommand searches for packages that provide a specific file or command

2. **Challenge**: Install all available security updates without installing other updates.
   **Answer**: `dnf update --security`
   **Explanation**: The `--security` flag limits updates to only security-related packages

---

## 10. Exam Strategy

### Topic-Specific Tips
- Master the difference between `dnf` and `rpm` - use the right tool for each task
- Practice repository management - know how to add, enable, and disable repos
- Understand package groups - they're often used in exam scenarios
- Remember that modules provide version flexibility

### Common Exam Scenarios
1. **Scenario**: Install software development tools
   **Approach**: Use `dnf groupinstall "Development Tools"` for comprehensive setup

2. **Scenario**: Configure custom repository
   **Approach**: Create repository file in `/etc/yum.repos.d/` or use `dnf config-manager --add-repo`

3. **Scenario**: Troubleshoot failed package installation
   **Approach**: Check `dnf history`, use `dnf check`, verify repository configuration

### Time Management
- **Package installation**: 2-3 minutes including verification
- **Repository configuration**: 4-5 minutes for complete setup
- **Package troubleshooting**: 5-7 minutes depending on issue complexity
- **Always verify**: Check installation with `dnf list installed` or `rpm -q`

### Pitfalls to Avoid
- Don't mix `rpm` and `dnf` operations (use `dnf` for dependency management)
- Remember to enable repositories after adding them
- Always update metadata (`dnf makecache`) after adding repositories
- Don't forget to enable services after installing server packages
- Use `dnf history` to track and potentially undo problematic changes

---

## Summary

### Key Takeaways
- **DNF is the modern package manager** - it replaces YUM with better dependency resolution
- **Repository management is crucial** - proper repository configuration enables software installation
- **Modules provide version flexibility** - use them for software requiring specific versions
- **Package groups simplify installation** - use them for installing related software collections

### Critical Commands to Remember
```bash
dnf install packagename                      # Install software
dnf update                                   # Update system
dnf groupinstall "Group Name"               # Install package group
dnf repolist                                # List repositories
dnf search keyword                          # Find packages
dnf history                                 # View transaction history
```

### Next Steps
- Continue to [Module 07: Storage & LVM](07_storage_lvm.md)
- Practice package management in the Vagrant environment  
- Review related topics: [System Installation](01_system_installation.md), [Service Management](05_process_service_management.md)

---

**Navigation**: [← Process Management](05_process_service_management.md) | [Index](index.md) | [Next → Storage & LVM](07_storage_lvm.md)