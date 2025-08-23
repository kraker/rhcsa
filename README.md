# RHCSA Certification Study Repository

A comprehensive study repository for Red Hat Certified System Administrator (RHCSA) exam preparation, containing practical lab scenarios, skills assessments, and memorization aids.

## Repository Contents

### 📚 Study Materials (`reference/` directory)
- **`anki_rhcsa_flashcards.csv`** - 146 comprehensive flashcards covering all RHCSA exam objectives
- **`exam_quick_reference.md`** - Quick reference guide for exam day
- **`command_reference_by_topic.md`** - Commands organized by functional area
- **`rhcsa_acronyms_glossary.md`** - Comprehensive glossary of RHCSA acronyms and terms
- **`ebook_summary.md`** - Comprehensive analysis and topic organization from both major RHCSA study books

### 🏗️ Lab Environment
- **`vagrant/`** - Automated RHEL 9 VM provisioning with Vagrant
  - `Vagrantfile` - VM configuration for rhel9a and rhel9b instances
  - `playbook.yml` - Ansible playbook for environment setup

### 📖 External Resources (`resources/` directory, not tracked)
- Official Red Hat documentation (PDFs)  
- Study book materials (EPUBs)
- Book summaries and extracted content
- Reference images from study materials

## Quick Start

### Using the Anki Flashcards
1. Import `reference/anki_rhcsa_flashcards.csv` into Anki
2. The deck includes 146 cards organized by topic tags:
   - `user_management`, `permissions`, `systemd`
   - `storage`, `lvm`, `selinux`, `firewall`  
   - `networking`, `containers`, `monitoring`
   - `rhel9_specific`, `exam_pressure`, `syntax_heavy`

### Lab Environment Setup

**Vagrant VM Provisioning**:
- See `vagrant/` directory for automated lab environment setup
- RHEL 9 VMs configured with proper resources and networking
- Automated subscription registration and storage disk configuration
- Prerequisites: Vagrant, VirtualBox, Red Hat Developer subscription

**Setup Steps**:
1. Edit `vagrant/.rhel-credentials` with your Red Hat Developer credentials
2. Source credentials and start VMs: `cd vagrant && source .rhel-credentials && vagrant up`

### Study Workflow
1. Use Anki flashcards for command memorization and spaced repetition
2. Reference the quick guides in `reference/` for exam preparation
3. Practice with Vagrant VMs using the Asghar Ghori book labs
4. Focus on hands-on command execution and verification

## Key RHCSA Command Categories

The flashcards and lab scenarios cover all essential areas:
- **System Management**: systemctl, journalctl, service configuration
- **User/Group Management**: useradd, usermod, chage, permissions
- **Storage & LVM**: fdisk, pvcreate, vgcreate, lvcreate, filesystem management
- **Security & SELinux**: getenforce, setsebool, restorecon, firewall-cmd
- **Networking**: nmcli, static IP configuration, SSH setup
- **Containers**: podman operations with systemd integration

## Lab Scenarios

Each lab includes:
- Time limits matching exam conditions
- Step-by-step task instructions
- Verification commands to confirm completion
- Prerequisites and setup requirements

## Notes
- Lab 3 (SELinux) contains a TODO section requiring completion
- All scenarios designed for RHEL 9 environments
- Commands in flashcards represent real exam tasks
