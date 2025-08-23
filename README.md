# RHCSA Certification Study Repository

A comprehensive study repository for Red Hat Certified System Administrator (RHCSA) exam preparation, containing practical lab scenarios, skills assessments, and memorization aids.

## Repository Contents

### 📚 Study Materials
- **`anki_rhcsa_flashcards.csv`** - 146 comprehensive flashcards covering all RHCSA exam objectives
- **`skills_assessment.md`** - Self-assessment checklist with confidence ratings for all RHCSA topics
- **`study_plan.md`** - Structured study plan for exam preparation
- **`exam_quick_reference.md`** - Quick reference guide for exam day
- **`command_reference_by_topic.md`** - Commands organized by functional area
- **`ebook_summary.md`** - Summary of key concepts from study materials

### 🧪 Hands-On Labs
- **`lab_scenarios/01_user_management.md`** - User/group creation, sudo configuration, password policies
- **`lab_scenarios/02_storage_management.md`** - LVM, partitioning, filesystem creation, and swap setup  
- **`lab_scenarios/03_selinux_security.md`** - SELinux contexts, Apache configuration, security troubleshooting

### 💾 Additional Resources
- Study materials in various formats (EPUB, ZIP archives)
- COPYRIGHT notices and documentation

## Quick Start

### Using the Anki Flashcards
1. Import `anki_rhcsa_flashcards.csv` into Anki
2. The deck includes 146 cards organized by topic tags:
   - `user_management`, `permissions`, `systemd`
   - `storage`, `lvm`, `selinux`, `firewall`  
   - `networking`, `containers`, `monitoring`
   - `rhel9_specific`, `exam_pressure`, `syntax_heavy`

### Lab Environment Setup

**Vagrant VM Provisioning**:
- See `../vagrant/` directory for automated lab environment setup
- RHEL 9 VMs configured with proper resources and networking
- Automated subscription registration and storage disk configuration
- Prerequisites: Vagrant, VirtualBox, Red Hat Developer subscription

### Study Workflow
1. Complete the skills assessment to identify knowledge gaps
2. Practice lab scenarios in order of increasing difficulty
3. Use Anki flashcards for command memorization
4. Focus study time: 60% Learn topics, 30% Review topics, 10% Confident topics

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
