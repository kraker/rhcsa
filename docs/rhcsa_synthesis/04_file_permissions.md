# 04 - File Permissions & Access Control

**Navigation**: [← User Management](03_user_group_management.md) | [Index](index.md) | [Next → Process Management](05_process_service_management.md)

---

## 1. Executive Summary

**Topic Scope**: File permissions, special permissions, Access Control Lists (ACLs), and umask configuration in RHEL 9

**RHCSA Relevance**: Critical security topic - file permissions are fundamental to Linux security model

**Exam Weight**: High - Permission management appears in multiple exam scenarios

**Prerequisites**: Understanding of users, groups, and basic file operations

**Related Topics**: [User Management](03_user_group_management.md), [SELinux](09_selinux.md), [Security](09_selinux.md)

---

## 2. Conceptual Foundation

### Core Theory
Linux file permissions operate on a three-tier model:

- **Owner (user)**: The file/directory owner's permissions
- **Group**: Permissions for the file's group members
- **Other**: Permissions for all other users
- **Permission types**: Read (r), Write (w), Execute (x)
- **Special permissions**: setuid, setgid, sticky bit for enhanced security control

### Real-World Applications
- **System security**: Protecting sensitive configuration files
- **Collaboration**: Shared directories for team projects
- **Service accounts**: Restricting application access to specific files
- **Backup systems**: Ensuring backup files are readable only by authorized users
- **Web servers**: Setting appropriate permissions for web content

### Common Misconceptions
- **Directory permissions**: Execute permission on directories means "traverse" not "run"
- **Group permissions**: Group permission applies to primary group, not all user's groups
- **Special permissions**: setuid on directories has no effect (only setgid works)
- **Root override**: Root can read/write most files regardless of permissions (but not execute)
- **ACL inheritance**: Default ACLs only apply to newly created files, not existing ones

### Key Terminology
- **Octal notation**: Numeric representation of permissions (755, 644, etc.)
- **Symbolic notation**: Letter-based permission representation (rwxr-xr-x)
- **setuid bit**: Execute file with owner's privileges
- **setgid bit**: Execute file with group's privileges, or inherit group ownership
- **Sticky bit**: Prevents deletion by non-owners in shared directories
- **umask**: Default permission mask for new files and directories
- **ACL**: Access Control List for fine-grained permission control

---

## 3. Command Mastery

### Basic Permission Commands
```bash
# View permissions
ls -l file                    # Show detailed permissions
ls -ld directory              # Show directory permissions
stat file                    # Detailed file information including permissions

# Change permissions (symbolic)
chmod u+x file                # Add execute for owner
chmod g-w file                # Remove write for group
chmod o=r file                # Set other to read-only
chmod a+r file                # Add read for all (user, group, other)
chmod u=rwx,g=rx,o=r file     # Set specific permissions for each

# Change permissions (octal)
chmod 755 file                # rwxr-xr-x
chmod 644 file                # rw-r--r--
chmod 600 file                # rw-------
chmod 777 file                # rwxrwxrwx (dangerous!)
```

### Ownership Commands
```bash
# Change ownership
chown user file               # Change owner only
chown user:group file         # Change owner and group
chown :group file             # Change group only
chgrp group file              # Change group (alternative method)

# Recursive ownership changes
chown -R user:group directory # Change ownership recursively
chmod -R 755 directory        # Change permissions recursively
```

### Special Permissions
```bash
# setuid (4000)
chmod u+s file                # Add setuid bit
chmod 4755 file               # Set permissions with setuid

# setgid (2000)
chmod g+s file                # Add setgid bit
chmod g+s directory           # Set group inheritance on directory
chmod 2755 directory          # Set permissions with setgid

# Sticky bit (1000)
chmod +t directory            # Add sticky bit to directory
chmod 1755 directory          # Set permissions with sticky bit

# Combined special permissions
chmod 6755 file               # setuid + setgid
chmod 7755 directory          # setuid + setgid + sticky
```

### Access Control Lists (ACLs)
```bash
# View ACLs
getfacl file                  # Show ACL information
getfacl -R directory          # Recursive ACL display

# Set ACLs
setfacl -m u:username:rwx file        # Set user ACL
setfacl -m g:groupname:rx file        # Set group ACL
setfacl -m o::r file                  # Set other ACL
setfacl -m d:u:username:rwx directory # Set default user ACL

# Remove ACLs
setfacl -x u:username file            # Remove user ACL
setfacl -x g:groupname file           # Remove group ACL
setfacl -b file                       # Remove all ACLs
setfacl -k directory                  # Remove default ACLs

# Copy ACLs
getfacl file1 | setfacl --set-file=- file2  # Copy ACLs between files
```

### umask Configuration
```bash
# View current umask
umask                         # Show current umask in octal
umask -S                      # Show current umask symbolically

# Set umask
umask 022                     # Set umask to 022 (default for many systems)
umask 027                     # More restrictive umask
umask u=rwx,g=rx,o=          # Symbolic umask setting
```

### Finding Files by Permissions
```bash
# Find by permission patterns
find / -perm -4000            # Find setuid files
find / -perm -2000            # Find setgid files
find / -perm -1000            # Find sticky bit files
find / -perm 777              # Find world-writable files
find / -perm -o+w             # Find other-writable files

# Find by ownership
find / -user username         # Find files owned by user
find / -group groupname       # Find files owned by group
find / -nouser                # Find files with no valid owner
find / -nogroup               # Find files with no valid group
```

### Command Reference Table
| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `chmod` | Change file permissions | `u+x`, `g-w`, `755`, `-R` | `chmod 644 file.txt` |
| `chown` | Change file ownership | `user:group`, `-R` | `chown alice:staff file` |
| `chgrp` | Change group ownership | `-R` | `chgrp developers file` |
| `setfacl` | Set Access Control Lists | `-m`, `-x`, `-b`, `-R` | `setfacl -m u:john:rwx file` |
| `getfacl` | View Access Control Lists | `-R` | `getfacl file` |
| `umask` | Set default permissions | `-S` | `umask 022` |

---

## 4. Procedural Workflows

### Standard Procedure: Setting Up Secure File Permissions
1. **Determine access requirements**
   ```bash
   # Identify who needs what access:
   # - Owner: full control
   # - Group: read/execute
   # - Others: no access
   ```

2. **Set basic permissions**
   ```bash
   chmod 750 file_or_directory
   # or symbolically:
   chmod u=rwx,g=rx,o= file_or_directory
   ```

3. **Set appropriate ownership**
   ```bash
   chown owner:group file_or_directory
   ```

4. **Verify permissions**
   ```bash
   ls -l file_or_directory
   stat file_or_directory
   ```

### Standard Procedure: Shared Directory Setup
1. **Create directory with appropriate permissions**
   ```bash
   mkdir /shared/project
   chmod 2775 /shared/project      # setgid + group write
   chown :projectteam /shared/project
   ```

2. **Set default ACLs for new files**
   ```bash
   setfacl -d -m u::rwx /shared/project
   setfacl -d -m g::rwx /shared/project
   setfacl -d -m o::r-x /shared/project
   ```

3. **Test directory functionality**
   ```bash
   # Test as different users
   touch /shared/project/testfile
   ls -l /shared/project/testfile
   ```

### Decision Tree: Permission Strategy
```
Permission Requirements
├── Simple user/group/other? → Use chmod with octal notation
├── Fine-grained user access? → Use ACLs with setfacl
├── Shared directory? → Use setgid bit + appropriate permissions
├── Temporary shared space? → Add sticky bit for protection
└── System service? → Restrict to specific user/group only
```

### Standard Procedure: Security Audit
1. **Find potentially dangerous permissions**
   ```bash
   # World-writable files
   find / -type f -perm -002 2>/dev/null
   
   # Setuid/setgid files
   find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null
   
   # Files with no owner/group
   find / \( -nouser -o -nogroup \) 2>/dev/null
   ```

2. **Review critical system files**
   ```bash
   ls -l /etc/passwd /etc/shadow /etc/group
   ls -l /etc/sudoers
   ls -ld /tmp /var/tmp
   ```

3. **Check home directory permissions**
   ```bash
   ls -ld /home/*
   find /home -type d -perm -002 2>/dev/null
   ```

---

## 5. Configuration Deep Dive

### Permission Calculation
#### Octal Permission Values
```bash
# Read (r) = 4, Write (w) = 2, Execute (x) = 1

# Common permission combinations:
755 = rwxr-xr-x    # Standard executable/directory
644 = rw-r--r--    # Standard file
600 = rw-------    # Private file
777 = rwxrwxrwx    # Full permissions (dangerous)
000 = ---------    # No permissions
```

#### Special Permission Values
```bash
# Special permissions (added to regular permissions):
4000 = setuid bit
2000 = setgid bit  
1000 = sticky bit

# Combined examples:
4755 = rwsr-xr-x   # setuid + 755
2755 = rwxr-sr-x   # setgid + 755
1755 = rwxr-xr-t   # sticky + 755
6755 = rwsr-sr-x   # setuid + setgid + 755
```

### umask Configuration Files
#### System-wide umask
```bash
# /etc/bashrc or /etc/profile
umask 022          # Default for most users

# /root/.bashrc
umask 027          # More restrictive for root
```

#### Per-user umask
```bash
# ~/.bashrc or ~/.bash_profile
umask 077          # Very restrictive (user-only access)
```

### ACL Configuration Examples
#### Basic ACL Setup
```bash
# Grant specific user access
setfacl -m u:alice:rw- /path/to/file

# Grant group access
setfacl -m g:developers:rwx /path/to/directory

# Set default ACLs for directory
setfacl -d -m u:alice:rwx /path/to/directory
setfacl -d -m g:developers:rwx /path/to/directory
```

#### Complex ACL Scenario
```bash
# Multi-user project directory
mkdir /project
chmod 2775 /project
chown :project /project

# Set default ACLs
setfacl -d -m u::rwx /project
setfacl -d -m g::rwx /project
setfacl -d -m o::r-x /project

# Add specific user permissions
setfacl -d -m u:manager:rwx /project
setfacl -d -m u:readonly:r-x /project
```

---

## 6. Hands-On Labs

### Lab 6.1: Basic Permission Management (Asghar Ghori Style)
**Objective**: Master fundamental permission operations and special bits

**Steps**:
1. **Create test environment**
   ```bash
   mkdir ~/permissions_lab
   cd ~/permissions_lab
   touch file1 file2 file3
   mkdir dir1 dir2 dir3
   ```

2. **Practice basic permissions**
   ```bash
   # Set different permission combinations
   chmod 644 file1          # Standard file permissions
   chmod 755 dir1           # Standard directory permissions
   chmod 600 file2          # Private file
   chmod 700 dir2           # Private directory
   
   # Use symbolic notation
   chmod u=rw,g=r,o= file3  # Owner: rw, Group: r, Other: none
   chmod u+x dir3           # Add execute for owner
   ```

3. **Test special permissions**
   ```bash
   # Create files for special permission testing
   cp /bin/cat testcat
   chmod u+s testcat        # Add setuid
   
   mkdir shared_dir
   chmod g+s shared_dir     # Add setgid
   
   mkdir temp_shared
   chmod +t temp_shared     # Add sticky bit
   ```

4. **Test permission effects**
   ```bash
   # Test file access as different user (if available)
   # Create a test file in setgid directory
   touch shared_dir/testfile
   ls -l shared_dir/testfile  # Should inherit group
   ```

**Verification**:
```bash
ls -la                       # Check all permissions
stat file1 file2 file3       # Detailed permission info
find . -perm -4000           # Find setuid files
find . -perm -2000           # Find setgid files
find . -perm -1000           # Find sticky bit files
```

### Lab 6.2: Access Control Lists (Sander van Vugt Style)
**Objective**: Implement fine-grained access control using ACLs

**Steps**:
1. **Create ACL test environment**
   ```bash
   mkdir ~/acl_lab
   cd ~/acl_lab
   touch sensitive_file
   mkdir project_dir
   
   # Create some test users (if you have sudo access)
   # sudo useradd alice
   # sudo useradd bob
   # sudo useradd charlie
   ```

2. **Set basic ACLs**
   ```bash
   # Grant specific user access to file
   setfacl -m u:alice:rw- sensitive_file
   setfacl -m u:bob:r-- sensitive_file
   setfacl -m u:charlie:--- sensitive_file
   
   # Verify ACLs
   getfacl sensitive_file
   ls -l sensitive_file      # Notice the '+' indicating ACLs
   ```

3. **Configure directory ACLs**
   ```bash
   # Set directory ACLs
   setfacl -m u:alice:rwx project_dir
   setfacl -m g:developers:r-x project_dir
   
   # Set default ACLs for new files
   setfacl -d -m u:alice:rwx project_dir
   setfacl -d -m g:developers:r-x project_dir
   setfacl -d -m o::r-x project_dir
   ```

4. **Test ACL inheritance**
   ```bash
   # Create files in directory with default ACLs
   touch project_dir/new_file
   mkdir project_dir/new_dir
   
   # Check inherited permissions
   getfacl project_dir/new_file
   getfacl project_dir/new_dir
   ```

**Verification**:
```bash
# Review all ACL configurations
getfacl -R ~/acl_lab
# Test access as different users (if possible)
# su - alice -c "cat ~/acl_lab/sensitive_file"
```

### Lab 6.3: Shared Directory with Complex Permissions (Synthesis Challenge)
**Objective**: Create a collaborative workspace with multiple access levels

**Scenario**: Set up a development project directory with different access levels for team members, managers, and external reviewers.

**Requirements**:
- Project managers: full access
- Developers: read/write access to project files
- Reviewers: read-only access
- Temporary files should be deletable only by creators
- New files should inherit appropriate group ownership

**Solution Steps**:
1. **Create directory structure**
   ```bash
   sudo mkdir -p /projects/webapp/{src,docs,temp}
   sudo groupadd developers
   sudo groupadd managers
   sudo groupadd reviewers
   
   # Add users to groups (assuming users exist)
   # sudo usermod -aG managers alice
   # sudo usermod -aG developers bob,charlie
   # sudo usermod -aG reviewers david
   ```

2. **Set base permissions and ownership**
   ```bash
   # Set group ownership and setgid
   sudo chown :developers /projects/webapp
   sudo chmod 2775 /projects/webapp
   
   # Configure subdirectories
   sudo chown :developers /projects/webapp/src
   sudo chmod 2775 /projects/webapp/src
   
   sudo chown :developers /projects/webapp/docs
   sudo chmod 2775 /projects/webapp/docs
   
   # Temp directory with sticky bit
   sudo chown :developers /projects/webapp/temp
   sudo chmod 3775 /projects/webapp/temp  # setgid + sticky
   ```

3. **Configure ACLs for fine-grained access**
   ```bash
   # Main project directory ACLs
   sudo setfacl -m g:managers:rwx /projects/webapp
   sudo setfacl -m g:developers:rwx /projects/webapp
   sudo setfacl -m g:reviewers:r-x /projects/webapp
   
   # Default ACLs for new files
   sudo setfacl -d -m g:managers:rwx /projects/webapp
   sudo setfacl -d -m g:developers:rwx /projects/webapp
   sudo setfacl -d -m g:reviewers:r-x /projects/webapp
   
   # Source directory - developers need write, reviewers read-only
   sudo setfacl -R -m g:developers:rwx /projects/webapp/src
   sudo setfacl -R -m g:reviewers:r-x /projects/webapp/src
   sudo setfacl -d -m g:developers:rwx /projects/webapp/src
   sudo setfacl -d -m g:reviewers:r-x /projects/webapp/src
   
   # Docs directory - all can read, developers can write
   sudo setfacl -R -m g:reviewers:r-x /projects/webapp/docs
   sudo setfacl -d -m g:reviewers:r-x /projects/webapp/docs
   ```

4. **Test and document configuration**
   ```bash
   # Create test files
   sudo touch /projects/webapp/src/main.py
   sudo touch /projects/webapp/docs/README.md
   sudo touch /projects/webapp/temp/build.log
   
   # Verify permissions and ACLs
   ls -la /projects/webapp/
   getfacl /projects/webapp/
   getfacl /projects/webapp/src/
   
   # Document the setup
   cat > /projects/webapp/PERMISSIONS.md << 'EOF'
   # Project Permissions Documentation
   
   ## Directory Structure
   - `/projects/webapp/`: Main project directory
   - `/projects/webapp/src/`: Source code (developers: rw, reviewers: r)
   - `/projects/webapp/docs/`: Documentation (all: read, developers: write)
   - `/projects/webapp/temp/`: Temporary files (sticky bit for creator-only deletion)
   
   ## Access Levels
   - **Managers**: Full access to all areas
   - **Developers**: Read/write to src and docs
   - **Reviewers**: Read-only access to src and docs
   
   ## Special Features
   - setgid bit ensures new files inherit group ownership
   - Sticky bit in temp/ prevents accidental deletion
   - ACLs provide fine-grained access control
   EOF
   ```

**Verification**:
```bash
# Complete access audit
sudo find /projects/webapp -type d -exec getfacl {} \;
sudo ls -laR /projects/webapp/
# Test with different users if available
```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: Permission Denied Errors
**Symptoms**:
- Users cannot access files they should be able to read
- Applications fail with permission errors
- "Permission denied" messages in logs

**Diagnosis**:
```bash
# Check file permissions and ownership
ls -la filename
stat filename

# Check user's group memberships
id username
groups username

# Check parent directory permissions
ls -ld /path/to/
ls -ld /path/

# Check for ACLs
getfacl filename
```

**Resolution**:
```bash
# Fix basic permissions
chmod 644 filename          # For regular files
chmod 755 directoryname     # For directories

# Fix ownership
chown user:group filename

# Add user to appropriate group
usermod -aG groupname username

# Set ACLs if needed
setfacl -m u:username:r-- filename
```

**Prevention**: Always verify permissions after creating files and directories

#### Issue 2: ACL Configuration Problems
**Symptoms**:
- ACLs not working as expected
- Default ACLs not being inherited
- Performance issues with ACL-enabled filesystems

**Diagnosis**:
```bash
# Check if filesystem supports ACLs
mount | grep acl
tune2fs -l /dev/device | grep acl

# Verify ACL configuration
getfacl filename
getfacl -d directoryname  # Check default ACLs

# Check effective permissions
getfacl filename | grep effective
```

**Resolution**:
```bash
# Enable ACL support on filesystem
mount -o remount,acl /mountpoint
# Or add to /etc/fstab: defaults,acl

# Fix ACL configuration
setfacl -b filename         # Remove all ACLs and start over
setfacl -k directoryname    # Remove default ACLs

# Set correct ACLs
setfacl -m u:username:rwx filename
setfacl -d -m u:username:rwx directoryname
```

#### Issue 3: Special Permission Confusion
**Symptoms**:
- setuid/setgid not working as expected
- Sticky bit not preventing file deletion
- Programs not running with expected privileges

**Diagnosis**:
```bash
# Check special permissions
ls -l filename
stat filename

# Find all special permission files
find /path -perm -4000    # setuid
find /path -perm -2000    # setgid  
find /path -perm -1000    # sticky

# Test execution context
ps aux | grep processname
```

**Resolution**:
```bash
# Set special permissions correctly
chmod u+s executable      # setuid
chmod g+s directory       # setgid for directory
chmod +t directory        # sticky bit

# Remove special permissions if problematic
chmod u-s filename
chmod g-s filename
chmod -t filename
```

### Diagnostic Command Sequence
```bash
# Permission troubleshooting workflow
ls -la filename             # Check basic permissions
stat filename               # Detailed permission info
getfacl filename            # Check ACLs
id username                 # Check user context
groups username             # Check group memberships
lsattr filename             # Check extended attributes
```

### Log File Analysis
- **`/var/log/messages`**: General permission-related errors
- **`/var/log/secure`**: Authentication and access control events
- **`/var/log/audit/audit.log`**: SELinux and detailed access events
- **Application logs**: Specific permission errors from services

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance
```bash
# Basic permissions
chmod 755 file              # Standard executable/directory
chmod 644 file              # Standard file
chown user:group file       # Change ownership

# Special permissions  
chmod u+s file              # Add setuid
chmod g+s directory         # Add setgid
chmod +t directory          # Add sticky bit

# ACLs
setfacl -m u:user:rwx file  # Set user ACL
getfacl file                # View ACLs
setfacl -b file             # Remove all ACLs
```

### Octal Permission Reference
- **755**: rwxr-xr-x (directories, executables)
- **644**: rw-r--r-- (regular files)
- **600**: rw------- (private files)
- **777**: rwxrwxrwx (dangerous, avoid)
- **000**: --------- (no permissions)

### Special Permission Values
- **4000**: setuid bit
- **2000**: setgid bit  
- **1000**: sticky bit
- **6000**: setuid + setgid
- **7000**: setuid + setgid + sticky

### Common umask Values
- **022**: Default (644 for files, 755 for directories)
- **027**: Group-friendly (640 for files, 750 for directories)
- **077**: Private (600 for files, 700 for directories)

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What's the difference between setuid on files versus setgid on directories?
   **Answer**: setuid on files makes the executable run with the owner's privileges instead of the executor's. setgid on directories makes new files created in that directory inherit the directory's group ownership instead of the creator's primary group.

2. **Question**: Why might ACLs show "effective" permissions that differ from granted permissions?
   **Answer**: The effective permission is the intersection of the ACL permission and the group permission (mask). If the mask is more restrictive than the ACL entry, the effective permission will be limited by the mask.

3. **Question**: When would you use the sticky bit and why?
   **Answer**: The sticky bit is used on directories (like /tmp) to prevent users from deleting files owned by others, even if they have write permission on the directory. Only the file owner, directory owner, or root can delete the file.

### Practical Scenarios
1. **Scenario**: Create a shared directory where users can create files but only delete their own files.
   **Solution**:
   ```bash
   mkdir /shared
   chmod 1777 /shared    # world-writable with sticky bit
   # or
   chmod o+t /shared && chmod 777 /shared
   ```

2. **Scenario**: A web application needs read access to user files, but users shouldn't access each other's files.
   **Solution**: Use ACLs to grant the web server user specific access while maintaining user privacy:
   ```bash
   setfacl -m u:www-data:r-- /home/user1/public_file
   ```

### Command Challenges
1. **Challenge**: Find all world-writable files in /tmp that don't have the sticky bit.
   **Answer**: `find /tmp -type f -perm -002 ! -perm -1000`
   **Explanation**: `-perm -002` finds world-writable, `! -perm -1000` excludes sticky bit files

2. **Challenge**: Create a directory where the group can read/write/execute, but new files are readable by everyone.
   **Answer**: 
   ```bash
   mkdir shared_dir
   chmod 2775 shared_dir
   setfacl -d -m o::r-- shared_dir
   ```

---

## 10. Exam Strategy

### Topic-Specific Tips
- Master octal notation - it's faster than symbolic for complex permissions
- Always verify permissions after setting them with `ls -l`
- Remember that ACLs require filesystem support (most modern filesystems support them)
- Practice special permissions until you understand their real-world applications

### Common Exam Scenarios
1. **Scenario**: Set up collaborative directory with group inheritance
   **Approach**: Use setgid bit (`chmod g+s`) on directory, set appropriate group ownership

2. **Scenario**: Restrict file access to specific users beyond standard permissions
   **Approach**: Use ACLs with `setfacl -m u:username:permissions`

3. **Scenario**: Create secure temporary space where users can't delete others' files
   **Approach**: Use sticky bit (`chmod +t`) on directory

### Time Management
- **Basic permission tasks**: 2-3 minutes including verification
- **ACL configuration**: 4-5 minutes for complex scenarios
- **Special permissions**: 3-4 minutes including testing
- **Always verify**: Use `ls -l` and `getfacl` to confirm settings

### Pitfalls to Avoid
- Don't forget that directory execute permission is needed for traversal
- Remember that changing group membership requires logout/login to take effect
- ACLs require `+` to show in `ls -l` output - if missing, ACLs aren't set
- Special permissions only work in specific contexts (setuid on scripts often doesn't work)
- Don't use 777 permissions unless absolutely necessary (security risk)

---

## Summary

### Key Takeaways
- **File permissions are the foundation of Linux security** - master both basic and special permissions
- **ACLs provide fine-grained control** - use when standard permissions aren't sufficient
- **Special permissions solve specific problems** - setuid, setgid, and sticky bit have distinct use cases
- **umask affects default permissions** - understand its impact on file creation

### Critical Commands to Remember
```bash
chmod 755 directory                      # Standard directory permissions
chmod 644 file                          # Standard file permissions  
chown user:group file                   # Change ownership
setfacl -m u:username:rwx file          # Set user ACL
chmod g+s directory                     # setgid for group inheritance
chmod +t directory                      # Sticky bit for shared directories
```

### Next Steps
- Continue to [Module 05: Process & Service Management](05_process_service_management.md)
- Practice permission scenarios in the Vagrant environment
- Review related topics: [User Management](03_user_group_management.md), [SELinux](09_selinux.md)

---

**Navigation**: [← User Management](03_user_group_management.md) | [Index](index.md) | [Next → Process Management](05_process_service_management.md)