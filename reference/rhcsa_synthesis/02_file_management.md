# 02 - File Management & Text Processing

**Navigation**: [← System Installation](01_system_installation.md) | [Index](index.md) | [Next → User Management](03_user_group_management.md)

---

## 1. Executive Summary

**Topic Scope**: Essential file operations, text processing, archiving, and linking in RHEL 9

**RHCSA Relevance**: Critical foundation skill - file management appears in virtually every exam task

**Exam Weight**: High - File operations are fundamental to all system administration tasks

**Prerequisites**: Basic Linux command line familiarity

**Related Topics**: [File Permissions](04_file_permissions.md), [Storage & LVM](07_storage_lvm.md), [Troubleshooting](15_troubleshooting.md)

---

## 2. Conceptual Foundation

### Core Theory
File management in Linux operates on the principle that "everything is a file." This includes:

- **Regular files**: Documents, scripts, configuration files
- **Directories**: Containers for organizing files and other directories
- **Links**: References to files that can be hard (same inode) or symbolic (pathname reference)
- **Special files**: Device files, pipes, sockets

### Real-World Applications
- **Configuration management**: Editing system configuration files
- **Log analysis**: Processing and searching through system logs
- **Backup operations**: Creating and extracting archives
- **Documentation**: Creating and maintaining system documentation
- **Automation**: Writing and managing shell scripts

### Common Misconceptions
- **Case sensitivity**: Linux is case-sensitive (`File.txt` ≠ `file.txt`)
- **File extensions**: Extensions are for humans; Linux determines file type by content
- **Hidden files**: Files starting with `.` are hidden from `ls` by default
- **Directory permissions**: Different from file permissions; affect access to directory contents

### Key Terminology
- **Inode**: Index node containing file metadata and disk block locations
- **Hard link**: Multiple directory entries pointing to the same inode
- **Symbolic link**: File containing the pathname of another file
- **Archive**: Single file containing multiple files and directories
- **Compression**: Reducing file size using algorithms like gzip or bzip2
- **Glob patterns**: Wildcards for matching multiple files (`*`, `?`, `[]`)

---

## 3. Command Mastery

### Essential File Operations
```bash
# Listing files and directories
ls -la                   # Long format with hidden files
ls -lh                   # Human-readable sizes
ls -lt                   # Sort by modification time
ls -lS                   # Sort by size
ls -R                    # Recursive listing

# Creating and removing
touch filename           # Create empty file or update timestamp
mkdir -p path/to/dir     # Create directory path recursively
rmdir directory          # Remove empty directory
rm -rf directory         # Remove directory and contents recursively

# Copying and moving
cp source destination    # Copy file
cp -r source dest        # Copy directory recursively
cp -p source dest        # Preserve permissions and timestamps
mv source destination    # Move/rename file or directory
```

### Text Processing Commands
```bash
# Viewing file contents
cat filename             # Display entire file
less filename            # Page through file content
head -n 10 file          # First 10 lines
tail -n 10 file          # Last 10 lines
tail -f file             # Follow file changes (logs)

# Text manipulation
grep pattern file        # Search for pattern in file
grep -i pattern file     # Case-insensitive search
grep -r pattern dir      # Recursive search in directory
grep -v pattern file     # Invert match (exclude pattern)

# Text processing tools
sort file                # Sort lines alphabetically
sort -n file             # Sort numerically
uniq file                # Remove duplicate lines
wc -l file               # Count lines
cut -d: -f1 /etc/passwd  # Extract first field (delimiter :)
```

### Archiving and Compression
```bash
# Tar archives
tar -czf archive.tar.gz directory/    # Create compressed archive
tar -xzf archive.tar.gz               # Extract compressed archive
tar -tzf archive.tar.gz               # List archive contents
tar -xzf archive.tar.gz file.txt      # Extract specific file

# Alternative compression
gzip file                # Compress file (creates file.gz)
gunzip file.gz           # Decompress file
zip archive.zip files    # Create zip archive
unzip archive.zip        # Extract zip archive
```

### File Linking
```bash
# Hard links
ln source hardlink       # Create hard link
ls -li file*             # Show inode numbers

# Symbolic links
ln -s target symlink     # Create symbolic link
ls -l symlink            # Show link target
readlink symlink         # Display link target
```

### Command Reference Table
| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `ls` | List directory contents | `-l`, `-a`, `-h`, `-t` | `ls -lah /home` |
| `find` | Search for files | `-name`, `-type`, `-size` | `find / -name "*.conf"` |
| `locate` | Quick file search | `-i`, `-c` | `locate passwd` |
| `grep` | Search text patterns | `-i`, `-r`, `-v` | `grep -r "error" /var/log` |
| `tar` | Archive files | `-c`, `-x`, `-z`, `-f` | `tar -czf backup.tar.gz /home` |

---

## 4. Procedural Workflows

### Standard Procedure: File Search and Analysis
1. **Initial search**: Use `locate` for quick filename searches
   ```bash
   locate filename
   updatedb  # Update locate database if needed
   ```

2. **Detailed search**: Use `find` for complex criteria
   ```bash
   find /path -name "pattern" -type f -size +1M
   ```

3. **Content analysis**: Examine file contents
   ```bash
   file filename                # Determine file type
   less filename               # Review content
   grep "pattern" filename     # Search within file
   ```

4. **Verification**: Confirm file properties
   ```bash
   ls -l filename             # Check permissions and size
   stat filename              # Detailed file information
   ```

### Decision Tree: Archive Strategy
```
Archive Task
├── Backup entire directory? → tar -czf backup.tar.gz directory/
├── Selective file backup? → tar -czf backup.tar.gz file1 file2 file3
├── Cross-platform compatibility? → zip -r archive.zip directory/
└── Maximum compression? → tar -cjf backup.tar.bz2 directory/
```

### Standard Procedure: Log Analysis Workflow
1. **Identify log location**: Common locations
   ```bash
   ls /var/log/                # System logs
   journalctl --list-boots     # Systemd journal
   ```

2. **Filter relevant entries**: Use grep patterns
   ```bash
   grep -i "error\|fail\|warn" /var/log/messages
   tail -f /var/log/secure     # Monitor authentication
   ```

3. **Time-based analysis**: Focus on specific periods
   ```bash
   grep "$(date '+%b %d')" /var/log/messages  # Today's entries
   journalctl --since "1 hour ago"           # Recent systemd logs
   ```

---

## 5. Configuration Deep Dive

### File System Navigation
- **`/etc/`**: System configuration files
- **`/var/log/`**: System and application logs
- **`/tmp/`**: Temporary files (cleared on reboot)
- **`/home/`**: User home directories
- **`/opt/`**: Optional software packages

### Glob Pattern Usage
```bash
# Wildcards
ls *.txt                # All .txt files
ls file?.log            # file1.log, file2.log, etc.
ls file[1-3].txt        # file1.txt, file2.txt, file3.txt
ls file[!1].txt         # All except file1.txt

# Complex patterns
find . -name "*.conf" -o -name "*.cfg"     # Multiple patterns
ls {*.txt,*.log}                           # Brace expansion
```

### Archive Best Practices
```bash
# Include/exclude patterns
tar --exclude="*.tmp" -czf backup.tar.gz directory/
tar --exclude-from=exclude-list.txt -czf backup.tar.gz /

# Verification
tar -tzf archive.tar.gz | head -10        # List first 10 files
tar -df archive.tar.gz                    # Compare with filesystem
```

---

## 6. Hands-On Labs

### Lab 6.1: File Operations Mastery (Asghar Ghori Style)
**Objective**: Master essential file operations and text processing

**Steps**:
1. **Create test environment**
   ```bash
   mkdir -p ~/lab02/{documents,logs,archives}
   cd ~/lab02
   ```

2. **Generate test files**
   ```bash
   echo "System log entry 1" > logs/system.log
   echo "Error message here" >> logs/system.log
   echo "Normal operation" >> logs/system.log
   echo "Configuration data" > documents/config.txt
   ```

3. **Practice file operations**
   ```bash
   # Copy with different options
   cp documents/config.txt documents/config.backup
   cp -p logs/system.log logs/system.$(date +%Y%m%d)
   
   # Search operations
   find . -name "*.log" -type f
   grep -r "Error" .
   ```

**Verification**:
```bash
ls -la logs/                     # Verify file creation
find . -name "*.backup"          # Check backup files
wc -l logs/system.log           # Count log entries
```

### Lab 6.2: Advanced Text Processing (Sander van Vugt Style)
**Objective**: Master text processing and analysis techniques

**Steps**:
1. **Create sample data**
   ```bash
   cp /etc/passwd ~/lab02/passwd.sample
   cp /var/log/messages ~/lab02/messages.sample 2>/dev/null || \
   journalctl > ~/lab02/messages.sample
   ```

2. **Text analysis tasks**
   ```bash
   # User analysis
   cut -d: -f1,3 ~/lab02/passwd.sample | sort -t: -k2 -n
   grep -c "bash\|sh" ~/lab02/passwd.sample
   
   # Log analysis
   grep -i "error\|fail" ~/lab02/messages.sample | wc -l
   tail -20 ~/lab02/messages.sample | grep -v "systemd"
   ```

3. **Advanced filtering**
   ```bash
   # Complex grep patterns
   grep -E "(error|fail|warn)" ~/lab02/messages.sample
   awk '{print $1, $2, $3}' ~/lab02/messages.sample | head -10
   ```

**Verification**:
```bash
# Verify text processing results
cut -d: -f1 ~/lab02/passwd.sample | sort | head -5
grep -c ":" ~/lab02/passwd.sample
```

### Lab 6.3: Archive and Link Management (Synthesis Challenge)
**Objective**: Master archiving, compression, and linking

**Scenario**: Create a backup system with different archive types and linking strategies

**Requirements**:
- Create compressed archives of different directories
- Implement hard and symbolic links
- Practice archive extraction and verification

**Solution Steps**:
1. **Prepare directory structure**
   ```bash
   mkdir -p ~/lab02/backup-test/{dir1,dir2,dir3}
   echo "File in dir1" > ~/lab02/backup-test/dir1/file1.txt
   echo "File in dir2" > ~/lab02/backup-test/dir2/file2.txt
   echo "Shared content" > ~/lab02/backup-test/shared.txt
   ```

2. **Create various archives**
   ```bash
   # Different compression methods
   tar -czf ~/lab02/archives/backup-gzip.tar.gz ~/lab02/backup-test/
   tar -cjf ~/lab02/archives/backup-bzip2.tar.bz2 ~/lab02/backup-test/
   zip -r ~/lab02/archives/backup.zip ~/lab02/backup-test/
   ```

3. **Implement linking strategy**
   ```bash
   # Hard links
   ln ~/lab02/backup-test/shared.txt ~/lab02/backup-test/dir1/shared-hard
   
   # Symbolic links
   ln -s ../shared.txt ~/lab02/backup-test/dir2/shared-soft
   ```

4. **Verification and analysis**
   ```bash
   # Compare archive sizes
   ls -lh ~/lab02/archives/
   
   # Verify links
   ls -li ~/lab02/backup-test/shared.txt ~/lab02/backup-test/dir1/shared-hard
   ls -l ~/lab02/backup-test/dir2/shared-soft
   ```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: "No such file or directory" errors
**Symptoms**:
- Commands fail with file not found errors
- Scripts cannot locate files

**Diagnosis**:
```bash
# Check current directory
pwd
# Verify file existence
ls -la filename
# Check path components
ls -ld /path/to/file
```

**Resolution**:
```bash
# Use absolute paths
ls /full/path/to/file
# Check spelling and case sensitivity
ls -la | grep -i filename
# Verify permissions on parent directories
ls -ld /path/to/
```

**Prevention**: Always use tab completion and absolute paths in scripts

#### Issue 2: Archive extraction failures
**Symptoms**:
- tar command fails with "not in gzip format" error
- Archive appears corrupted

**Diagnosis**:
```bash
# Check file type
file archive.tar.gz
# Verify archive integrity
tar -tzf archive.tar.gz >/dev/null
# Check available disk space
df -h .
```

**Resolution**:
```bash
# Use correct extraction flags
tar -xf archive.tar.gz    # Auto-detect compression
# Try without compression flag
tar -xf archive.tar
# Check for partial download
ls -l archive.tar.gz
```

#### Issue 3: Symbolic link problems
**Symptoms**:
- Symlinks point to non-existent files
- Permission denied accessing through symlinks

**Diagnosis**:
```bash
# Check link status
ls -l symlink
# Test link target
readlink symlink
# Verify target existence
ls -l $(readlink symlink)
```

**Resolution**:
```bash
# Fix broken link
ln -sf correct/target symlink
# Remove and recreate
rm symlink && ln -s new/target symlink
```

### Diagnostic Command Sequence
```bash
# File system troubleshooting workflow
pwd                     # Confirm current location
ls -la                  # List all files with details
file suspicious_file    # Determine file type
stat filename          # Detailed file information
lsof filename          # Check if file is open
```

### Log File Analysis
- **`/var/log/messages`**: General system messages
- **`/var/log/secure`**: Authentication and security events
- **`/var/log/boot.log`**: Boot process messages
- **`journalctl`**: Systemd journal entries

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance
```bash
# File operations
ls -lah                 # List all files with details
find / -name pattern    # Search for files
cp -r source dest       # Copy recursively
mv source dest          # Move/rename

# Text processing
grep pattern file       # Search in file
sort file               # Sort lines
uniq file              # Remove duplicates
wc -l file             # Count lines

# Archives
tar -czf archive.tar.gz dir/    # Create compressed archive
tar -xzf archive.tar.gz         # Extract archive
```

### Key File Locations
- **Configuration**: `/etc/` directory
- **Logs**: `/var/log/` directory
- **User data**: `/home/username/`
- **Temporary**: `/tmp/` directory

### Important Patterns
- **Hidden files**: Start with `.` (dot)
- **Backup files**: Often end with `~` or `.bak`
- **Log files**: Usually in `/var/log/` with `.log` extension

### Verification Commands
```bash
# Quick file checks
ls -l filename         # File details
file filename          # File type
stat filename          # Complete file information
du -sh directory       # Directory size
```

---

## 9. Knowledge Check

### Conceptual Questions
1. **Question**: What's the difference between hard links and symbolic links?
   **Answer**: Hard links point to the same inode (same file data), while symbolic links contain the pathname of another file. Hard links cannot cross filesystems or point to directories; symbolic links can. If the original file is deleted, hard links still access the data, but symbolic links become broken.

2. **Question**: Why might you use `tar` instead of `zip` for archiving?
   **Answer**: Tar preserves Unix file permissions, ownership, and metadata better than zip. It's the standard in Unix/Linux environments and integrates seamlessly with compression tools. Tar also handles symbolic links correctly and is more efficient for backing up entire directory structures.

3. **Question**: When would you use `find` versus `locate`?
   **Answer**: Use `locate` for quick filename searches across the entire system (faster, uses database). Use `find` for complex searches based on file attributes, content, or when you need real-time results. Find searches the actual filesystem; locate searches a database that may be outdated.

### Practical Scenarios
1. **Scenario**: You need to find all configuration files modified in the last 24 hours.
   **Solution**: 
   ```bash
   find /etc -name "*.conf" -mtime -1 -type f
   find /etc -name "*.cfg" -mtime -1 -type f
   ```

2. **Scenario**: Create a backup excluding temporary files and logs.
   **Solution**:
   ```bash
   tar --exclude="*.tmp" --exclude="*.log" --exclude="/var/log/*" \
       -czf backup.tar.gz /home/user/
   ```

### Command Challenges
1. **Challenge**: Write a command to find all files larger than 100MB in /var directory
   **Answer**: `find /var -type f -size +100M`
   **Explanation**: `-type f` ensures only regular files, `-size +100M` finds files larger than 100 megabytes

2. **Challenge**: Create a command to show the 10 largest files in the current directory
   **Answer**: `ls -lS | head -11 | tail -10`
   **Explanation**: `-S` sorts by size (largest first), `head -11` gets first 11 lines (including header), `tail -10` shows last 10 (excluding header)

---

## 10. Exam Strategy

### Topic-Specific Tips
- Practice file operations until they're automatic - speed matters in the exam
- Master grep patterns as they're used throughout the exam
- Know the difference between absolute and relative paths
- Understand when to use different archive formats

### Common Exam Scenarios
1. **Scenario**: Find and copy configuration files to a backup directory
   **Approach**: Use `find` with appropriate criteria, then `cp` with `-p` to preserve attributes

2. **Scenario**: Search log files for specific error patterns
   **Approach**: Combine `grep`, `tail`, and date filtering for targeted searches

3. **Scenario**: Create archives of user data with specific exclusions
   **Approach**: Use `tar` with `--exclude` patterns for clean backups

### Time Management
- **File operations**: 2-3 minutes for basic tasks
- **Archive creation**: 3-5 minutes including verification
- **Text searching**: 2-4 minutes depending on complexity
- **Quick verification**: Always test your commands before moving on

### Pitfalls to Avoid
- Don't forget the `-r` flag when copying directories
- Remember that Linux is case-sensitive
- Always verify archive contents before considering task complete
- Watch out for hidden files when copying directories
- Test symbolic links after creation

---

## Summary

### Key Takeaways
- **File management is fundamental** - these skills are used in every exam task
- **Master text processing tools** - grep, sort, and cut are essential for analysis
- **Archive operations are common** - know tar syntax and compression options
- **Practice makes perfect** - file operations must be automatic for exam success

### Critical Commands to Remember
```bash
ls -la                          # List files with details
find /path -name "pattern"      # Search for files
grep -r "pattern" directory     # Search text recursively
tar -czf archive.tar.gz dir/    # Create compressed archive
ln -s target linkname           # Create symbolic link
```

### Next Steps
- Continue to [Module 03: User & Group Management](03_user_group_management.md)
- Practice file operations in the Vagrant environment
- Review related topics: [File Permissions](04_file_permissions.md), [Storage](07_storage_lvm.md)

---

**Navigation**: [← System Installation](01_system_installation.md) | [Index](index.md) | [Next → User Management](03_user_group_management.md)