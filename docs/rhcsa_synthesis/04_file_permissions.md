# 04 - File Permissions & Access Control

**Navigation**: [← User Management](03_user_group_management.md) | [Index](index.md) | [Next → Process Management](05_process_service_management.md)

---

## 1. Executive Summary

**Topic Scope**: File permissions, ownership, and umask configuration in RHEL 10

**RHCSA Relevance**: Critical security topic - file permissions are fundamental to Linux security model

**Exam Weight**: High - Permission management appears in multiple exam scenarios

**RHEL 10 Exam Note**: ACLs (setfacl/getfacl) and special permissions (setuid/setgid/sticky bit) are **no longer RHCSA exam objectives** as of RHEL 10. They are retained below as supplementary reference material.

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

### Real-World Applications

- **System security**: Protecting sensitive configuration files
- **Collaboration**: Shared directories for team projects
- **Service accounts**: Restricting application access to specific files
- **Backup systems**: Ensuring backup files are readable only by authorized users
- **Web servers**: Setting appropriate permissions for web content

### Common Misconceptions

- **Directory permissions**: Execute permission on directories means "traverse" not "run"
- **Group permissions**: Group permission applies to primary group, not all user's groups
- **Root override**: Root can read/write most files regardless of permissions (but not execute)

### Key Terminology

- **Octal notation**: Numeric representation of permissions (755, 644, etc.)
- **Symbolic notation**: Letter-based permission representation (rwxr-xr-x)
- **umask**: Default permission mask for new files and directories

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
    chmod 775 /shared/project
    chown :projectteam /shared/project
    ```

2. **Test directory functionality**

    ```bash
    # Test as different users
    touch /shared/project/testfile
    ls -l /shared/project/testfile
    ```

### Decision Tree: Permission Strategy

```text
Permission Requirements
├── Simple user/group/other? → Use chmod with octal notation
├── Shared directory? → Use group permissions + chmod
└── System service? → Restrict to specific user/group only
```

### Standard Procedure: Security Audit

1. **Find potentially dangerous permissions**

    ```bash
    # World-writable files
    find / -type f -perm -002 2>/dev/null

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

**Verification**:

```bash
ls -la                       # Check all permissions
stat file1 file2 file3       # Detailed permission info
```

### Lab 6.2: Ownership and umask Configuration

**Objective**: Practice ownership changes and understand umask

**Steps**:

1. **Practice ownership changes**

    ```bash
    mkdir ~/ownership_lab
    cd ~/ownership_lab
    touch file1 file2
    mkdir dir1

    # Change ownership (requires root or owning the files)
    chown :users file1
    chgrp users dir1
    ```

2. **Understand umask effects**

    ```bash
    # Check current umask
    umask
    umask -S

    # Set restrictive umask and test
    umask 077
    touch private_file
    mkdir private_dir
    ls -l private_file         # Should be rw-------
    ls -ld private_dir         # Should be rwx------

    # Set collaborative umask
    umask 002
    touch shared_file
    ls -l shared_file          # Should be rw-rw-r--
    ```

3. **Configure persistent umask**

    ```bash
    # Add umask to ~/.bashrc for persistence
    echo "umask 027" >> ~/.bashrc
    ```

**Verification**:

```bash
ls -la ~/ownership_lab/
stat ~/ownership_lab/private_file
umask
```

### Lab 6.3: Shared Directory Setup (Synthesis Challenge)

**Objective**: Create a collaborative workspace using standard permissions

**Scenario**: Set up a project directory where a team can collaborate.

**Requirements**:

- Project team members: read/write access
- Others: no access

**Solution Steps**:

1. **Create directory structure**

    ```bash
    sudo mkdir -p /projects/webapp
    sudo groupadd developers

    # Add users to group (assuming users exist)
    # sudo usermod -aG developers alice
    # sudo usermod -aG developers bob
    ```

2. **Set permissions and ownership**

    ```bash
    sudo chown :developers /projects/webapp
    sudo chmod 770 /projects/webapp
    ```

3. **Verify**

    ```bash
    ls -ld /projects/webapp/
    # Test as a member of the developers group
    touch /projects/webapp/testfile
    ls -l /projects/webapp/testfile
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

### Diagnostic Command Sequence

```bash
# Permission troubleshooting workflow
ls -la filename             # Check basic permissions
stat filename               # Detailed permission info
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
# Permissions
chmod 755 file              # Standard executable/directory
chmod 644 file              # Standard file
chown user:group file       # Change ownership
chgrp group file            # Change group
umask 022                   # Set default permission mask
```

### Octal Permission Reference

- **755**: rwxr-xr-x (directories, executables)
- **644**: rw-r--r-- (regular files)
- **600**: rw------- (private files)
- **777**: rwxrwxrwx (dangerous, avoid)
- **000**: --------- (no permissions)

### Common umask Values

- **022**: Default (644 for files, 755 for directories)
- **027**: Group-friendly (640 for files, 750 for directories)
- **077**: Private (600 for files, 700 for directories)

---

## 9. Knowledge Check

### Conceptual Questions

1. **Question**: What is the difference between octal and symbolic permission notation?
    **Answer**: Octal notation uses numbers (e.g., `755` = rwxr-xr-x) where each digit represents user/group/other permissions (r=4, w=2, x=1). Symbolic notation uses letters (e.g., `u+x`, `g=rw`, `o-w`) to add, set, or remove specific permissions.

2. **Question**: What does the execute permission mean on a directory?
    **Answer**: On a directory, execute (x) means "traverse" — the ability to cd into the directory and access files within it. Without execute on a directory, you cannot access its contents even if you have read permission (which only lets you list filenames).

3. **Question**: How does umask affect new file and directory permissions?
    **Answer**: umask subtracts from the default permissions. New files start at 666 (no execute) and directories at 777. With umask 022, files become 644 (rw-r--r--) and directories become 755 (rwxr-xr-x).

### Practical Scenarios

1. **Scenario**: Create a directory where only members of the "project" group can access files.
    **Solution**:

    ```bash
    mkdir /project
    chown :project /project
    chmod 770 /project
    ```

2. **Scenario**: A user creates files that are world-readable by default. Make them private.
    **Solution**: Set a restrictive umask:

    ```bash
    umask 077
    # Or add to ~/.bashrc for persistence
    echo "umask 077" >> ~/.bashrc
    ```

### Command Challenges

1. **Challenge**: Change ownership of all files in /data to user "admin" and group "staff" recursively.
    **Answer**: `chown -R admin:staff /data`
    **Explanation**: `-R` applies the change recursively to all files and subdirectories.

2. **Challenge**: Find all files owned by a user who no longer exists on the system.
    **Answer**: `find / -nouser 2>/dev/null`
    **Explanation**: `-nouser` finds files whose numeric UID doesn't match any user in /etc/passwd.

---

## 10. Exam Strategy

### Topic-Specific Tips

- Master octal notation — it's faster than symbolic for complex permissions
- Always verify permissions after setting them with `ls -l`
- Know how umask affects default permissions for new files and directories
- Practice chmod, chown, chgrp until they are second nature

### Common Exam Scenarios

1. **Scenario**: Set up a shared directory for a group
    **Approach**: Create group, set group ownership with `chown :group dir`, set `chmod 770` or `chmod 775`

2. **Scenario**: Set appropriate permissions on configuration files
    **Approach**: Restrictive permissions like `chmod 600` for sensitive files, `chmod 644` for readable configs

### Time Management

- **Basic permission tasks**: 2-3 minutes including verification
- **Ownership changes**: 1-2 minutes
- **Always verify**: Use `ls -l` and `stat` to confirm settings

### Pitfalls to Avoid

- Don't forget that directory execute permission is needed for traversal
- Remember that changing group membership requires logout/login to take effect
- Don't use 777 permissions unless absolutely necessary (security risk)
- Remember umask subtracts from defaults: files start at 666, directories at 777

---

## Summary

### Key Takeaways

- **File permissions are the foundation of Linux security** — master chmod, chown, chgrp
- **umask controls default permissions** — understand its impact on file creation
- **Ownership determines access** — proper user:group assignment is critical

### Critical Commands to Remember

```bash
chmod 755 directory                      # Standard directory permissions
chmod 644 file                          # Standard file permissions
chown user:group file                   # Change ownership
chgrp group file                       # Change group
umask 022                              # Set default permissions
find / -nouser                         # Find orphaned files
```

### Next Steps

- Continue to [Module 05: Process & Service Management](05_process_service_management.md)
- Practice permission scenarios in the Vagrant environment
- Review related topics: [User Management](03_user_group_management.md), [SELinux](09_selinux.md)

---

## Supplementary Reference: ACLs (Not on RHEL 10 Exam)

> **Note**: Access Control Lists (ACLs) are no longer an RHCSA exam objective as of RHEL 10. This section is retained for reference only.

### ACL Commands

```bash
# View ACLs
getfacl file                  # Show ACL information
getfacl -R directory          # Recursive ACL display

# Set ACLs
setfacl -m u:username:rwx file        # Set user ACL
setfacl -m g:groupname:rx file        # Set group ACL
setfacl -m d:u:username:rwx directory # Set default user ACL

# Remove ACLs
setfacl -x u:username file            # Remove user ACL
setfacl -b file                       # Remove all ACLs
setfacl -k directory                  # Remove default ACLs

# Copy ACLs
getfacl file1 | setfacl --set-file=- file2  # Copy ACLs between files
```

---

## Supplementary Reference: Special Permissions (Not on RHEL 10 Exam)

> **Note**: setuid, setgid, and sticky bit are no longer RHCSA exam objectives as of RHEL 10. This section is retained for reference only.

### Special Permission Commands

```bash
# setuid (4000) — execute file with owner's privileges
chmod u+s file                # Add setuid bit
chmod 4755 file               # Set permissions with setuid

# setgid (2000) — execute with group's privileges / inherit group on directories
chmod g+s directory           # Set group inheritance on directory
chmod 2755 directory          # Set permissions with setgid

# Sticky bit (1000) — prevent deletion by non-owners
chmod +t directory            # Add sticky bit to directory
chmod 1755 directory          # Set permissions with sticky bit
```

### Special Permission Values

- **4000**: setuid bit
- **2000**: setgid bit
- **1000**: sticky bit

### Finding Special Permission Files

```bash
find / -perm -4000 2>/dev/null   # Find setuid files
find / -perm -2000 2>/dev/null   # Find setgid files
find / -perm -1000 2>/dev/null   # Find sticky bit directories
```

---

**Navigation**: [← User Management](03_user_group_management.md) | [Index](index.md) | [Next → Process Management](05_process_service_management.md)
