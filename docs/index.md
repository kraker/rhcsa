# RHCSA Certification Study Guide

Welcome to the comprehensive Red Hat Certified System Administrator (RHCSA) study repository. This resource provides everything you need to prepare for the RHCSA exam, including practical lab scenarios, comprehensive study materials, and memorization aids.

## 📚 Study Materials

### [RHCSA Synthesis Modules](rhcsa_synthesis/)
Complete knowledge base with 15 detailed modules covering all RHCSA exam objectives:

- **Module 00**: [Exam Overview](rhcsa_synthesis/00_exam_overview.md) - Strategy and format guide
- **Module 01**: [System Installation](rhcsa_synthesis/01_system_installation.md) - Installation and initial configuration
- **Module 02**: [File Management](rhcsa_synthesis/02_file_management.md) - File operations and navigation
- **Module 03**: [User & Group Management](rhcsa_synthesis/03_user_group_management.md) - Account administration
- **Module 04**: [File Permissions](rhcsa_synthesis/04_file_permissions.md) - Access controls and security
- **Module 05**: [Process & Service Management](rhcsa_synthesis/05_process_service_management.md) - System management
- **Module 06**: [Package Management](rhcsa_synthesis/06_package_management.md) - Software installation
- **Module 07**: [Storage & LVM](rhcsa_synthesis/07_storage_lvm.md) - Storage management
- **Module 08**: [Networking](rhcsa_synthesis/08_networking.md) - Network configuration
- **Module 09**: [SELinux](rhcsa_synthesis/09_selinux.md) - Security Enhanced Linux
- **Module 10**: [Firewall](rhcsa_synthesis/10_firewall.md) - Network security
- **Module 11**: [Boot & GRUB](rhcsa_synthesis/11_boot_grub.md) - System boot process
- **Module 12**: [Logging & Monitoring](rhcsa_synthesis/12_logging_monitoring.md) - System monitoring
- **Module 13**: [Scheduled Tasks](rhcsa_synthesis/13_scheduled_tasks.md) - Automation
- **Module 14**: [Container Management](rhcsa_synthesis/14_container_management.md) - Podman containers
- **Module 15**: [Troubleshooting](rhcsa_synthesis/15_troubleshooting.md) - Problem resolution

### Quick References

- **[Exam Quick Reference](exam_quick_reference.md)** - Essential commands for exam day
- **[Command Reference by Topic](command_reference_by_topic.md)** - Commands organized by functional area
- **[RHCSA Acronyms & Glossary](rhcsa_acronyms_glossary.md)** - Comprehensive terminology guide
- **[Ebook Summary](ebook_summary.md)** - Analysis from major RHCSA study books

## 🎴 Anki Flashcards

Import the comprehensive flashcard deck for spaced repetition learning:

- **Location**: [anki/rhcsa_deck.csv](https://github.com/kraker/rhcsa/blob/main/anki/rhcsa_deck.csv)
- **Cards**: 146 essential commands and concepts
- **Topics**: All RHCSA exam objectives with practical examples

### Flashcard Categories
- User & Group Management
- File Operations & Permissions  
- System Services (systemd)
- Storage & LVM
- SELinux & Security
- Firewall Configuration
- Networking
- Container Management

## 🏗️ Lab Environment

Set up hands-on practice environment using Vagrant:

- **Location**: [vagrant/](https://github.com/kraker/rhcsa/tree/main/vagrant) directory
- **VMs**: RHEL 9 instances (rhel9a, rhel9b)
- **Features**: Automated provisioning, storage configuration, networking
- **Prerequisites**: Vagrant, VirtualBox, Red Hat Developer subscription

## 📖 Study Workflow

1. **Start with Synthesis Modules** - Begin with comprehensive topic coverage
2. **Practice with Anki Deck** - Use spaced repetition for command memorization
3. **Use Quick References** - Keep handy during study sessions
4. **Hands-on Practice** - Use Vagrant VMs for real-world scenarios
5. **Focus on Verification** - Always test and verify your configurations

## 🎯 Exam Preparation Tips

- **Time Management**: Practice under exam time constraints
- **Command Accuracy**: Focus on exact syntax and options
- **Verification**: Always verify your configurations work
- **Documentation**: Use `man pages` and `--help` during practice
- **Persistence**: Ensure configurations survive reboots

## 📁 Repository Structure

```
rhcsa/
├── docs/                    # Study materials (this site)
├── anki/                    # Flashcard deck
├── vagrant/                 # Lab environment  
├── sources/                 # External reference materials
└── README.md               # Quick start guide
```

For the complete repository structure, visit: [github.com/kraker/rhcsa](https://github.com/kraker/rhcsa)

Ready to start your RHCSA journey? Begin with [Module 00: Exam Overview](rhcsa_synthesis/00_exam_overview.md) to understand the exam format and strategy!