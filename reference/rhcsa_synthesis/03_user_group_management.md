# 03 - User & Group Management

**Navigation**: [← File Management](02_file_management.md) | [Index](index.md) | [Next → File Permissions](04_file_permissions.md)

---

## 1. Executive Summary

**Topic Scope**: User account creation, modification, deletion, group management, and password policies in RHEL 9

**RHCSA Relevance**: Critical exam topic - user management appears in multiple exam tasks

**Exam Weight**: High - Essential system administration skill tested frequently

**Prerequisites**: Understanding of Linux file system and basic command line operations

**Related Topics**: [File Permissions](04_file_permissions.md), [SELinux Management](09_selinux.md), [SSH Configuration](08_networking.md)

---

## 2. Conceptual Foundation

### Core Theory
User and group management in RHEL 9 is based on the traditional Unix model with modern enhancements:

- **User accounts**: Unique identities with UID, home directory, and shell
- **Groups**: Collections of users for permission management (primary and supplementary)
- **System accounts**: Special accounts for services and daemons (UID < 1000)
- **Regular users**: Human users with interactive login capabilities (UID ≥ 1000)
- **Password policies**: Rules governing password complexity and expiration

### Real-World Applications
- **Multi-user environments**: Corporate servers with multiple administrators
- **Service accounts**: Running applications with specific privileges
- **Temporary access**: Creating accounts for contractors or temporary staff
- **Security compliance**: Implementing password policies for regulatory requirements
- **Resource management**: Controlling access to files and system resources

### Common Misconceptions
- **Root is UID 0**: Root always has UID 0, but UID 0 doesn't always mean "root" name
- **Group membership**: Users can belong to multiple groups simultaneously
- **Home directories**: Not automatically deleted when users are removed
- **Shell access**: Users can exist without shell access (nologin)
- **Password expiration**: Affects login but not running processes

### Key Terminology
- **UID**: User Identifier (numeric ID for user accounts)
- **GID**: Group Identifier (numeric ID for groups)
- **Primary group**: User's main group (stored in /etc/passwd)
- **Supplementary groups**: Additional groups a user belongs to
- **Shadow file**: Encrypted password storage with aging information
- **Login shell**: Program executed when user logs in
- **Home directory**: User's personal directory space
- **Skeleton directory**: Template for new user home directories

---

## 3. Command Mastery

### User Management Commands
```bash
# Creating users
useradd username                    # Basic user creation
useradd -u 1500 -g users username   # Specify UID and primary group
useradd -G wheel,admin username     # Add to supplementary groups
useradd -s /bin/bash username       # Specify shell
useradd -d /custom/home username    # Custom home directory
useradd -m username                 # Create home directory
useradd -c "Full Name" username     # Add comment/description

# Modifying users
usermod -l newname oldname          # Change username
usermod -u 1600 username            # Change UID
usermod -g newgroup username        # Change primary group
usermod -aG group username          # Add to supplementary group
usermod -G group1,group2 username   # Set all supplementary groups
usermod -s /sbin/nologin username   # Change shell
usermod -L username                 # Lock account
usermod -U username                 # Unlock account
usermod -d /new/home username       # Change home directory

# Removing users
userdel username                    # Delete user (keep home)
userdel -r username                 # Delete user and home directory
```

### Group Management Commands
```bash
# Creating groups
groupadd groupname                  # Basic group creation
groupadd -g 2000 groupname         # Specify GID
groupadd -r systemgroup            # Create system group

# Modifying groups
groupmod -n newname oldname         # Rename group
groupmod -g 2500 groupname         # Change GID

# Group membership
gpasswd -a username groupname       # Add user to group
gpasswd -d username groupname       # Remove user from group
gpasswd -A admin groupname          # Set group administrator

# Removing groups
groupdel groupname                  # Delete group
```

### Password Management Commands
```bash
# Setting passwords
passwd username                     # Set/change password
passwd -l username                  # Lock password
passwd -u username                  # Unlock password
passwd -d username                  # Delete password (disable)
passwd -e username                  # Expire password (force change)

# Password aging
chage -M 90 username               # Max age 90 days
chage -m 7 username                # Min age 7 days
chage -W 14 username               # Warning 14 days before expiry
chage -I 30 username               # Inactive 30 days after expiry
chage -E 2024-12-31 username       # Account expires on date
chage -l username                  # List aging information
```

### Information Commands
```bash
# User information
id username                        # Show UID, GID, and groups
groups username                    # Show group memberships
finger username                    # Detailed user information (if available)
who                               # Currently logged-in users
w                                 # Detailed who information
last username                     # Login history
lastb                            # Failed login attempts

# System information
cat /etc/passwd                   # All user accounts
cat /etc/group                    # All groups
cat /etc/shadow                   # Password information (root only)
getent passwd username            # Get user info from all sources
getent group groupname            # Get group info from all sources
```

### Command Reference Table
| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `useradd` | Create user account | `-u`, `-g`, `-G`, `-s`, `-d` | `useradd -G wheel john` |
| `usermod` | Modify user account | `-aG`, `-L`, `-U`, `-s` | `usermod -aG admins john` |
| `userdel` | Delete user account | `-r` | `userdel -r john` |
| `groupadd` | Create group | `-g`, `-r` | `groupadd -g 2000 developers` |
| `passwd` | Manage passwords | `-l`, `-u`, `-e` | `passwd -e john` |
| `chage` | Password aging | `-M`, `-m`, `-W`, `-E` | `chage -M 90 john` |

---

## 4. Procedural Workflows

### Standard Procedure: Creating a New User
1. **Plan user requirements**
   ```bash
   # Determine: UID, primary group, supplementary groups, shell, home directory
   ```

2. **Create the user account**
   ```bash
   useradd -u 1500 -g users -G wheel,developers -s /bin/bash -m username
   ```

3. **Set initial password**
   ```bash
   passwd username
   # Force password change on first login
   chage -d 0 username
   ```

4. **Configure password policy**
   ```bash
   chage -M 90 -m 7 -W 14 username
   ```

5. **Verify account creation**
   ```bash
   id username
   ls -ld /home/username
   getent passwd username
   ```

### Standard Procedure: User Account Maintenance
1. **Regular account review**
   ```bash
   # Check for unused accounts
   last | grep username
   # Review password aging
   chage -l username
   ```

2. **Modify account as needed**
   ```bash
   # Add to new group
   usermod -aG newgroup username
   # Change shell
   usermod -s /bin/zsh username
   ```

3. **Handle account issues**
   ```bash
   # Temporarily lock account
   usermod -L username
   # Force password change
   passwd -e username
   ```

### Decision Tree: Account Creation Strategy
```
New User Request
├── Regular user? 
│   ├── Standard UID range (≥1000)
│   ├── Create home directory
│   └── Interactive shell
├── Service account?
│   ├── System UID range (<1000)
│   ├── No home directory
│   └── /sbin/nologin shell
└── Temporary user?
    ├── Set account expiration
    ├── Force password change
    └── Document removal date
```

### Standard Procedure: Group Management
1. **Create group structure**
   ```bash
   # Create functional groups
   groupadd -g 2000 developers
   groupadd -g 2001 admins
   groupadd -g 2002 operations
   ```

2. **Assign users to groups**
   ```bash
   # Add existing users
   usermod -aG developers user1,user2
   gpasswd -a user3 admins
   ```

3. **Verify group memberships**
   ```bash
   # Check specific user
   groups username
   # Check specific group
   getent group groupname
   ```

---

## 5. Configuration Deep Dive

### Primary Configuration Files

#### /etc/passwd - User Account Information
```bash
# Format: username:password:UID:GID:comment:home:shell
root:x:0:0:root:/root:/bin/bash
john:x:1000:1000:John Doe:/home/john:/bin/bash
apache:x:48:48:Apache:/usr/share/httpd:/sbin/nologin
```

#### /etc/shadow - Password Information
```bash
# Format: username:password:lastchange:min:max:warn:inactive:expire:reserved
root:$6$encrypted$hash:19000:0:99999:7:::
john:$6$encrypted$hash:19000:7:90:14:30:19200:
```

#### /etc/group - Group Information
```bash
# Format: groupname:password:GID:members
root:x:0:
wheel:x:10:john,admin
developers:x:2000:john,jane,bob
```

#### /etc/gshadow - Group Password Information
```bash
# Format: groupname:password:admins:members
root:::
wheel:::john,admin
developers:!!::john,jane,bob
```

### Default Configuration Files

#### /etc/default/useradd - Default User Settings
```bash
# Default values for useradd command
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/bash
SKEL=/etc/skel
CREATE_MAIL_SPOOL=yes
```

#### /etc/login.defs - Login Definitions
```bash
# Password aging controls
PASS_MAX_DAYS   90
PASS_MIN_DAYS   7
PASS_WARN_AGE   14

# User ID ranges
UID_MIN         1000
UID_MAX         60000
SYS_UID_MIN     201
SYS_UID_MAX     999

# Group ID ranges
GID_MIN         1000
GID_MAX         60000
SYS_GID_MIN     201
SYS_GID_MAX     999
```

#### /etc/skel/ - Skeleton Directory
```bash
# Template files copied to new user home directories
/etc/skel/.bash_logout
/etc/skel/.bash_profile
/etc/skel/.bashrc
```

### Password Policy Configuration

#### System-wide Password Policies
```bash
# /etc/security/pwquality.conf
minlen = 8              # Minimum password length
dcredit = -1           # Require at least 1 digit
ucredit = -1           # Require at least 1 uppercase
lcredit = -1           # Require at least 1 lowercase
ocredit = -1           # Require at least 1 special character
```

---

## 6. Hands-On Labs

### Lab 6.1: Basic User Management (Asghar Ghori Style)
**Objective**: Create, modify, and manage user accounts with various configurations

**Steps**:
1. **Create users with different specifications**
   ```bash
   # Regular user with defaults
   useradd alice
   passwd alice
   
   # User with custom UID and group
   useradd -u 1500 -g wheel -s /bin/bash bob
   passwd bob
   
   # Service account
   useradd -r -s /sbin/nologin -d /var/lib/webservice webservice
   ```

2. **Modify existing users**
   ```bash
   # Add alice to additional groups
   usermod -aG wheel,developers alice
   
   # Change bob's shell
   usermod -s /bin/zsh bob
   
   # Lock webservice account
   usermod -L webservice
   ```

3. **Configure password policies**
   ```bash
   # Set password aging for alice
   chage -M 60 -m 5 -W 10 alice
   
   # Force password change for bob
   passwd -e bob
   ```

**Verification**:
```bash
# Verify user creation and modifications
id alice
id bob
id webservice
groups alice
chage -l alice
getent passwd | grep -E "(alice|bob|webservice)"
```

### Lab 6.2: Group Management and Membership (Sander van Vugt Style)
**Objective**: Create groups and manage complex membership scenarios

**Steps**:
1. **Create organizational groups**
   ```bash
   # Create department groups
   groupadd -g 2000 marketing
   groupadd -g 2001 sales
   groupadd -g 2002 engineering
   
   # Create role-based groups
   groupadd -g 3000 managers
   groupadd -g 3001 leads
   ```

2. **Create users and assign group memberships**
   ```bash
   # Marketing team
   useradd -g marketing -G leads marketing_lead
   useradd -g marketing marketing_user1
   useradd -g marketing marketing_user2
   
   # Engineering team
   useradd -g engineering -G managers,leads engineering_lead
   useradd -g engineering engineering_dev1
   useradd -g engineering engineering_dev2
   
   # Set passwords
   echo "password123" | passwd --stdin marketing_lead
   echo "password123" | passwd --stdin marketing_user1
   echo "password123" | passwd --stdin engineering_lead
   echo "password123" | passwd --stdin engineering_dev1
   ```

3. **Modify group memberships**
   ```bash
   # Add cross-functional team members
   usermod -aG sales marketing_lead
   usermod -aG marketing engineering_lead
   
   # Use gpasswd for group management
   gpasswd -a marketing_user1 leads
   gpasswd -A marketing_lead marketing
   ```

**Verification**:
```bash
# Verify group structure
getent group | grep -E "(marketing|sales|engineering|managers|leads)"
# Check user memberships
groups marketing_lead
groups engineering_lead
# Verify group administrators
getent gshadow | grep marketing
```

### Lab 6.3: Advanced User Account Scenarios (Synthesis Challenge)
**Objective**: Handle complex user management scenarios combining both methodologies

**Scenario**: Set up a development environment with different user types and access requirements

**Requirements**:
- Create system service accounts
- Set up developer accounts with specific group memberships
- Implement password policies and account expiration
- Handle temporary contractor accounts

**Solution Steps**:
1. **Create service accounts for applications**
   ```bash
   # Database service account
   useradd -r -u 500 -g daemon -s /sbin/nologin -d /var/lib/database database
   
   # Web service account
   useradd -r -u 501 -g daemon -s /sbin/nologin -d /var/lib/webapp webapp
   
   # Backup service account
   useradd -r -u 502 -g daemon -s /bin/bash -d /var/lib/backup backup
   ```

2. **Create developer environment**
   ```bash
   # Create developer groups
   groupadd -g 5000 developers
   groupadd -g 5001 senior_devs
   groupadd -g 5002 devops
   
   # Create developer accounts
   useradd -g developers -G wheel -s /bin/bash -c "Senior Developer" senior_dev1
   useradd -g developers -s /bin/bash -c "Junior Developer" junior_dev1
   useradd -g developers -G devops,wheel -s /bin/bash -c "DevOps Engineer" devops1
   
   # Set strong password policies for developers
   for user in senior_dev1 junior_dev1 devops1; do
       passwd $user
       chage -M 30 -m 3 -W 5 $user
   done
   ```

3. **Handle contractor accounts**
   ```bash
   # Create temporary contractor account (expires in 90 days)
   future_date=$(date -d "+90 days" +%Y-%m-%d)
   useradd -g developers -s /bin/bash -c "Contractor" -e $future_date contractor1
   passwd contractor1
   
   # Force password change on first login
   chage -d 0 contractor1
   
   # Set shorter password validity
   chage -M 14 -m 1 -W 3 contractor1
   ```

4. **Verification and documentation**
   ```bash
   # Generate user report
   echo "=== Service Accounts ===" > user_report.txt
   getent passwd | awk -F: '$3 < 1000 && $3 != 0 {print $1, $3, $7}' >> user_report.txt
   
   echo -e "\n=== Developer Accounts ===" >> user_report.txt
   getent passwd | awk -F: '$3 >= 1000 {print $1, $3, $5}' >> user_report.txt
   
   echo -e "\n=== Group Memberships ===" >> user_report.txt
   for user in $(getent passwd | awk -F: '$3 >= 1000 {print $1}'); do
       echo "$user: $(groups $user | cut -d: -f2)" >> user_report.txt
   done
   
   # Check account expiration
   echo -e "\n=== Account Expiration ===" >> user_report.txt
   chage -l contractor1 | grep "Account expires" >> user_report.txt
   ```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: User Cannot Login
**Symptoms**:
- Authentication failures
- Account locked messages
- Permission denied errors

**Diagnosis**:
```bash
# Check account status
passwd -S username
chage -l username
# Check login attempts
lastb username
# Verify home directory
ls -ld /home/username
# Check shell validity
grep username /etc/passwd
```

**Resolution**:
```bash
# Unlock account if locked
passwd -u username
usermod -U username
# Fix expired password
passwd -e username
# Correct home directory permissions
chown username:username /home/username
chmod 700 /home/username
# Fix invalid shell
usermod -s /bin/bash username
```

**Prevention**: Implement regular account audits and proper password policies

#### Issue 2: Group Permission Problems
**Symptoms**:
- Users cannot access group files
- "Permission denied" for group resources
- Inconsistent group memberships

**Diagnosis**:
```bash
# Check current group membership
groups username
id username
# Verify group exists
getent group groupname
# Check if user needs to re-login
# (group changes require new login)
```

**Resolution**:
```bash
# Add user to correct group
usermod -aG groupname username
# Or use gpasswd
gpasswd -a username groupname
# Verify group membership
getent group groupname
# User must logout and login again
```

#### Issue 3: UID/GID Conflicts
**Symptoms**:
- User creation fails with "UID already exists"
- File ownership shows numbers instead of names
- Permission inconsistencies

**Diagnosis**:
```bash
# Check for UID conflicts
getent passwd | sort -t: -k3 -n | uniq -D -f2
# Check for GID conflicts
getent group | sort -t: -k3 -n | uniq -D -f2
# Find files owned by numeric UIDs
find / -nouser -o -nogroup 2>/dev/null
```

**Resolution**:
```bash
# Change conflicting UID
usermod -u newuid username
# Change conflicting GID
groupmod -g newgid groupname
# Update file ownership
find /home/username -uid olduid -exec chown username {} \;
```

### Diagnostic Command Sequence
```bash
# User account troubleshooting workflow
getent passwd username      # Verify account exists
id username                 # Check UID/GID and groups
chage -l username          # Check password aging
passwd -S username         # Check password status
ls -ld /home/username      # Verify home directory
last username              # Check login history
```

### Log File Analysis
- **`/var/log/secure`**: Authentication events, login attempts
- **`/var/log/messages`**: General system messages including user management
- **`/var/log/audit/audit.log`**: SELinux denials related to user operations
- **`journalctl -u systemd-logind`**: Login service messages

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance
```bash
# User management
useradd -G wheel username   # Create user with sudo access
usermod -aG group username  # Add user to group
userdel -r username         # Delete user and home directory
passwd username             # Set password

# Group management
groupadd groupname          # Create group
gpasswd -a user group      # Add user to group
groupdel groupname         # Delete group

# Information
id username                # Show user/group IDs
groups username            # Show group memberships
chage -l username          # Show password aging info
```

### Key File Locations
- **User accounts**: `/etc/passwd`
- **Password hashes**: `/etc/shadow`
- **Group information**: `/etc/group`
- **Group passwords**: `/etc/gshadow`
- **User defaults**: `/etc/default/useradd`
- **Login policies**: `/etc/login.defs`
- **Skeleton directory**: `/etc/skel/`

### Important UID/GID Ranges
- **Root**: UID 0, GID 0
- **System accounts**: UID 1-999
- **Regular users**: UID ≥ 1000
- **System groups**: GID 1-999
- **Regular groups**: GID ≥ 1000

### Password Aging Parameters
- **Maximum age**: `-M days` (default 99999)
- **Minimum age**: `-m days` (default 0)
- **Warning period**: `-W days` (default 7)
- **Inactive period**: `-I days` (account locked after password expires)
- **Expiration date**: `-E date` (account expires)

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What's the difference between primary and supplementary groups?
   **Answer**: A primary group is a user's default group (stored in /etc/passwd, field 4) used for file creation. Supplementary groups are additional groups a user belongs to, providing access to resources owned by those groups. Users can have one primary group but multiple supplementary groups.

2. **Question**: Why might you use a system account instead of a regular user account?
   **Answer**: System accounts (UID < 1000) are designed for services and daemons. They typically don't have home directories, use /sbin/nologin as shell, and follow the principle of least privilege. This provides better security isolation and prevents interactive login for service accounts.

3. **Question**: What happens when you lock a user account with `usermod -L`?
   **Answer**: Account locking prepends an exclamation mark (!) to the password hash in /etc/shadow, preventing password authentication. However, the user might still login using SSH keys. For complete access blocking, also set shell to /sbin/nologin and consider expiring the account.

### Practical Scenarios
1. **Scenario**: Create a contractor account that expires in 30 days and must change password every 14 days.
   **Solution**:
   ```bash
   future_date=$(date -d "+30 days" +%Y-%m-%d)
   useradd -e $future_date -s /bin/bash contractor
   passwd contractor
   chage -M 14 -m 1 -W 3 -d 0 contractor
   ```

2. **Scenario**: A user reports they can't access files owned by the "projects" group despite being added to it.
   **Solution**: The user needs to logout and login again for group membership changes to take effect, or use `newgrp projects` to switch to the new group in the current session.

### Command Challenges
1. **Challenge**: Write a command to show all users with UID between 1000 and 2000.
   **Answer**: `getent passwd | awk -F: '$3 >= 1000 && $3 <= 2000 {print $1, $3}'`
   **Explanation**: Uses getent to get all passwd entries, awk to filter by UID range in field 3

2. **Challenge**: Create a user with no login shell, custom home directory, and specific UID.
   **Answer**: `useradd -u 1555 -d /opt/service -s /sbin/nologin -m serviceuser`
   **Explanation**: `-u` sets UID, `-d` sets custom home, `-s` sets shell, `-m` creates home directory

---

## 10. Exam Strategy

### Topic-Specific Tips
- Always verify user creation with `id username` and `getent passwd username`
- Remember that group changes require logout/login or `newgrp` to take effect
- Use `chage -l` to verify password policies are correctly applied
- Practice creating users with multiple requirements in single commands

### Common Exam Scenarios
1. **Scenario**: Create users with specific group memberships and password policies
   **Approach**: Use `useradd` with multiple options, then `chage` for password aging

2. **Scenario**: Troubleshoot user access problems
   **Approach**: Check account status, group memberships, and home directory permissions

3. **Scenario**: Set up service accounts for applications
   **Approach**: Use system UID range, /sbin/nologin shell, and appropriate group

### Time Management
- **Basic user creation**: 2-3 minutes including verification
- **Complex user with groups and policies**: 4-5 minutes
- **Troubleshooting user issues**: 5-7 minutes depending on complexity
- **Always verify**: Use `id` and `groups` commands to confirm

### Pitfalls to Avoid
- Don't forget `-m` flag when creating home directories with `useradd`
- Remember that `usermod -G` replaces all supplementary groups (use `-aG` to append)
- Always set passwords after creating users
- Verify group membership changes take effect (may need re-login)
- Check that service accounts have appropriate shells and home directories

---

## Summary

### Key Takeaways
- **User and group management is foundational** - required for virtually all system administration
- **Understand the difference between primary and supplementary groups** - critical for file permissions
- **Master password policies and account aging** - important for security compliance
- **System accounts vs. regular users** - different configuration requirements and security implications

### Critical Commands to Remember
```bash
useradd -G wheel -s /bin/bash -m username    # Create user with sudo access
usermod -aG groupname username               # Add user to supplementary group
passwd username                              # Set password
chage -M 90 -m 7 -W 14 username             # Set password aging policy
id username                                  # Verify user configuration
```

### Next Steps
- Continue to [Module 04: File Permissions](04_file_permissions.md)
- Practice user management in the Vagrant environment
- Review related topics: [SELinux](09_selinux.md), [SSH Configuration](08_networking.md)

---

**Navigation**: [← File Management](02_file_management.md) | [Index](index.md) | [Next → File Permissions](04_file_permissions.md)