# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Context Loading

**IMPORTANT**: When starting work on this project, Claude Code must read these files first to understand the current state and guidelines:

1. **CLAUDE.md** (this file) - Project overview, repository structure, and coding guidelines
2. **README.md** - Public project description, quick start guide, and study workflow
3. **COPYRIGHT_NOTICE.md** - Detailed copyright information for all materials in the repository

These files contain essential context for maintaining consistency with established patterns and avoiding copyright violations.

## Project Overview

This is a Red Hat Certified System Administrator (RHCSA) certification study repository. It contains practical lab scenarios, skills assessments, study materials, and memorization aids for RHCSA exam preparation. This is NOT a software development project - it's a learning resource for Linux system administration.

## Repository Structure

- `reference/` - Core study materials (tracked in git)
  - `rhcsa_synthesis/` - **Comprehensive knowledge base with 15 detailed modules** covering all RHCSA topics
    - `00_exam_overview.md` - RHCSA exam strategy and format guide
    - `01_system_installation.md` - System installation and initial configuration
    - `02_file_management.md` through `15_troubleshooting.md` - Complete topic coverage
    - `index.md` - Master navigation and progress tracking
    - `_template.md` - Consistent module structure template
  - `anki_rhcsa_flashcards.csv` - 146 comprehensive flashcards covering all RHCSA exam objectives
  - `exam_quick_reference.md` - Quick reference guide for exam day with comprehensive command examples
  - `command_reference_by_topic.md` - Commands organized by functional area for systematic study
  - `rhcsa_acronyms_glossary.md` - Comprehensive glossary of RHCSA acronyms and terms
  - `ebook_summary.md` - Analysis and topic organization from both major RHCSA study books
- `vagrant/` - Automated lab environment provisioning with RHEL 9 VMs
  - `Vagrantfile` - VM configuration for rhel9a and rhel9b instances
  - `playbook.yml` - Ansible playbook for environment setup
  - `.rhel-credentials` - Hidden credentials file for Red Hat Developer subscription (not tracked)
- `resources/` - External resources (not tracked in git, contains copyrighted materials)
  - Official Red Hat documentation (PDFs), study books (EPUBs), book summaries, extracted images

## Lab Environment Requirements

**Vagrant Configuration**: The `../vagrant/` directory provides automated lab environment provisioning:
- RHEL 9 VMs with proper resource allocation and networking
- Automated subscription registration with Red Hat Developer accounts
- Pre-configured storage setup for LVM and filesystem labs
- Prerequisites: Vagrant, VirtualBox, Red Hat Developer subscription

**VM Usage**:
- **rhel9a**: Used for user management and SELinux scenarios
- **rhel9b**: Used for storage management scenarios (multiple disks pre-configured)

## Common Study Tasks

### Working with Study Materials
- **Start with RHCSA Synthesis**: Begin with comprehensive modules in `reference/rhcsa_synthesis/` for complete topic coverage
- **Use Anki flashcards** for spaced repetition and command memorization
- **Reference guides** in `reference/` directory for quick lookup during study
- **Practice with Vagrant VMs** using Asghar Ghori book lab exercises
- **Focus on hands-on** command execution and verification in lab environment

### Anki Flashcard Usage
The `reference/anki_rhcsa_flashcards.csv` file contains 146 essential commands organized by tags:
- `user_management` - useradd, usermod, chage, groupadd
- `permissions` - chmod, chown, file access controls
- `systemd` - systemctl, journalctl, service management
- `storage` - fdisk, mkfs, mount, fstab configuration
- `lvm` - pvcreate, vgcreate, lvcreate, volume management
- `selinux` - getenforce, setsebool, restorecon, ausearch troubleshooting
- `firewall` - firewall-cmd, port and service management
- `networking` - nmcli, static IP, DNS configuration
- `containers` - podman operations, systemd integration

## Key RHCSA Command Categories

### Essential System Management
```bash
# Service Management
systemctl start/stop/enable/disable service
journalctl -u servicename
systemctl set-default target

# User Management  
useradd -u UID -g GROUP username
usermod -aG supplementary-group username
chage -M maxdays -m mindays -W warndays username

# File Operations
chmod 755 filename
chown user:group filename
find / -user username -type f 2>/dev/null
```

### Storage and LVM
```bash
# LVM Workflow
pvcreate /dev/device
vgcreate vgname /dev/device
lvcreate -L size -n lvname vgname
mkfs.xfs /dev/vgname/lvname
mount /dev/vgname/lvname /mountpoint

# Filesystem Management
echo "/dev/vgname/lvname /mountpoint xfs defaults 0 2" >> /etc/fstab
xfs_growfs /mountpoint  # After lvextend
resize2fs /dev/device   # For ext4
```

### Security and SELinux
```bash
# SELinux Management
getenforce / setenforce 0|1
ls -Z filename
restorecon -R /path
setsebool -P boolean on
ausearch -m AVC -ts recent

# Firewall
firewall-cmd --add-service=http --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload
```

## Copyright Management Guidelines

**CRITICAL**: Claude Code must update `COPYRIGHT_NOTICE.md` whenever adding copyrighted content to the repository.

### When Adding New Copyrighted Materials:
1. **Read COPYRIGHT_NOTICE.md first** to understand current copyright inventory
2. **Add new materials to `resources/` directory** (gitignored)
3. **Update COPYRIGHT_NOTICE.md** with:
   - Full title and author/publisher information
   - File path within `resources/` directory
   - License information (if known)
   - Source of the material
4. **Verify .gitignore excludes the new content**
5. **Never commit copyrighted content to git repository**

### Content Classification:
- **Original Work**: Content created for this repository → `reference/` directory (tracked)
- **Copyrighted Materials**: Books, PDFs, images from external sources → `resources/` directory (not tracked)
- **Derived Content**: Analysis or summaries of copyrighted works → `resources/` directory (not tracked)

## Notes for Claude Code

- This repository focuses on RHCSA exam preparation, not software development
- When helping with study materials, emphasize practical command execution and verification
- The study materials in `reference/` are original work and tracked in git
- External resources in `resources/` contain copyrighted materials and are not tracked
- Use Vagrant VMs for hands-on practice with Asghar Ghori book lab exercises
- Commands in the Anki flashcards represent real RHCSA exam tasks and should be executed carefully in lab environments
- **Always read CLAUDE.md, README.md, and COPYRIGHT_NOTICE.md before making changes**

## Git Commit Style Guide

### Atomic Commit Principles
Following [Aleksandr Hovhannisyan's atomic git commits](https://www.aleksandrhovhannisyan.com/blog/atomic-git-commits/):

**Core Rule**: Each commit should represent "a single, complete unit of work" that can be independently reviewed and reverted.

### Commit Message Format

**Simple Changes** (data fixes, small bug fixes):
```bash
git commit -m "Fix malformed times in SELinux troubleshooting examples"
git commit -m "Update Anki flashcard for ausearch command syntax"
git commit -m "Add missing firewall commands to quick reference"
```

**Feature Commits** (new capabilities, significant changes):
```bash
git commit -m "Add comprehensive ausearch troubleshooting section to SELinux lab"
git commit -m "Implement enhanced SELinux flashcards with Red Hat official syntax"
```

**Milestone/Release Commits** (major completions):
```bash
# Use detailed heredoc format for comprehensive changelog
git commit -m "$(cat <<'EOF'
Complete SELinux enhancement with Red Hat official documentation

- Add advanced troubleshooting section to Lab 03 with official ausearch syntax
- Include step-by-step workflow for AVC denial analysis and policy generation
- Add 5 new SELinux flashcards covering comprehensive ausearch message types
- Update quick reference with Red Hat's official troubleshooting commands
- Add PDF exclusion patterns to gitignore for official documentation

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Guidelines
- **Present tense verbs**: "Fix", "Add", "Update", "Remove", "Implement"
- **Component focus**: Mention what study material/system is changed
- **Atomic scope**: One logical change per commit
- **No fear of many commits**: Better to have 5 focused commits than 1 mixed commit
- **Commit early and often**: Make commits as soon as a logical unit is complete

### Examples by Type
- **Content fixes**: `Fix duplicate commands in storage management flashcards`
- **Study material updates**: `Add comprehensive ausearch examples to SELinux lab`
- **Reference enhancements**: `Implement timezone-aware examples in quick reference`
- **Documentation**: `Update README with current study workflow`
- **Resource cleanup**: `Remove redundant lab scenarios in favor of Asghar Ghori labs`

## Study Workflow Recommendations

1. **Begin with RHCSA Synthesis**: Start with `reference/rhcsa_synthesis/` for comprehensive topic coverage
2. **Use Anki deck** for command memorization and quick reference
3. **Practice with Vagrant VMs** using Asghar Ghori book lab exercises
4. **Verify all tasks** with provided verification commands
5. **Focus on practical application** rather than theoretical knowledge