# RHCSA Certification Study Repository

A comprehensive study repository for Red Hat Certified System Administrator (RHCSA) exam preparation, containing practical lab scenarios, skills assessments, and memorization aids.

## Repository Contents

### 📚 Study Materials

#### 🌐 Online Documentation Site
- **GitHub Pages**: https://stovepipe.github.io/rhcsa/ (live documentation site)
- Built with MkDocs using the readthedocs theme
- Mobile-friendly and searchable interface

#### 📁 Local Files
- **`docs/`** - All study materials (MkDocs source)
  - `rhcsa_synthesis/` - 15 comprehensive study modules
  - `exam_quick_reference.md` - Essential commands for exam day
  - `command_reference_by_topic.md` - Commands organized by functional area
  - `rhcsa_acronyms_glossary.md` - Comprehensive glossary
  - `ebook_summary.md` - Analysis from major RHCSA study books
- **`anki/rhcsa_deck.csv`** - 146 comprehensive flashcards for Anki import

### 🏗️ Lab Environment
- **`vagrant/`** - Automated RHEL 9 VM provisioning with Vagrant
  - `Vagrantfile` - VM configuration for rhel9a and rhel9b instances
  - `playbook.yml` - Ansible playbook for environment setup

### 📖 External Resources (`sources/` directory, not tracked)
- Official Red Hat documentation (PDFs)  
- Study book materials (EPUBs)
- Book summaries and extracted content
- Reference images from study materials

## Quick Start

### Using the Anki Flashcards
1. Import `anki/rhcsa_deck.csv` into Anki
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
1. **Visit the Documentation Site**: Browse https://stovepipe.github.io/rhcsa/ for organized study materials
2. **Start with RHCSA Synthesis**: Begin with the 15 comprehensive study modules
3. **Use Anki flashcards** (`anki/rhcsa_deck.csv`) for command memorization and spaced repetition
4. **Reference quick guides** for exam preparation
5. **Practice with Vagrant VMs** using the Asghar Ghori book labs
6. **Focus on hands-on** command execution and verification

### Local Development
To run the documentation site locally:
```bash
# Install dependencies
pip install -r requirements.txt

# Serve the site locally
mkdocs serve

# Build static site
mkdocs build
```
The site will be available at `http://127.0.0.1:8000`

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
