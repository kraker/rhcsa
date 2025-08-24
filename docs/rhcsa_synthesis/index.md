# RHCSA Synthesis - Unified Knowledge Base

**A comprehensive synthesis combining the methodologies of Asghar Ghori and Sander van Vugt's RHCSA study guides**

## Overview

This knowledge base synthesizes content from two authoritative RHCSA study resources:
- **Asghar Ghori**: "RHCSA Red Hat Enterprise Linux 9" (34,346+ lines of content)
- **Sander van Vugt**: "Red Hat RHCSA 9 Cert Guide" (53,622+ lines of content)

Each topic module combines the best approaches from both authors, providing comprehensive coverage with practical labs, detailed explanations, and exam-focused strategies.

## Study Approach

### For First-Time Learners
1. Start with [Exam Overview](00_exam_overview.md) for context
2. Follow modules in numerical order (01-15)
3. Complete all hands-on labs in each module
4. Use Quick Reference Cards for review

### For Exam Preparation
1. Review [Exam Overview](00_exam_overview.md) for strategy
2. Focus on modules matching your weak areas
3. Practice all troubleshooting scenarios
4. Use Knowledge Checks for self-assessment

### For Reference/Review
1. Use this index to jump to specific topics
2. Leverage Quick Reference Cards for rapid lookup
3. Consult Troubleshooting Playbooks for specific issues

## Module Index

### Foundation Topics
| Module | Topic | Focus Areas | Exam Weight |
|--------|-------|-------------|-------------|
| [00](00_exam_overview.md) | **Exam Overview** | Format, strategy, environment setup | Essential |
| [01](01_system_installation.md) | **System Installation** | RHEL installation, initial configuration | High |
| [02](02_file_management.md) | **File Management** | Basic operations, text processing | High |
| [03](03_permissions_security.md) | **Permissions & Security** | File permissions, access controls | Critical |

### System Administration
| Module | Topic | Focus Areas | Exam Weight |
|--------|-------|-------------|-------------|
| [04](04_user_group_mgmt.md) | **User & Group Management** | Account creation, policies, sudo | Critical |
| [05](05_process_services.md) | **Process & Service Management** | Systemd, process control | Critical |
| [06](06_package_management.md) | **Package Management** | RPM, YUM, DNF, repositories | High |
| [07](07_storage_lvm.md) | **Storage & LVM** | Partitions, filesystems, LVM | Critical |
| [08](08_networking.md) | **Network Configuration** | IP configuration, DNS, routing | High |

### Security and Advanced Topics
| Module | Topic | Focus Areas | Exam Weight |
|--------|-------|-------------|-------------|
| [09](09_firewall.md) | **Firewall Configuration** | firewall-cmd, zones, services | High |
| [10](10_selinux.md) | **SELinux Management** | Contexts, booleans, troubleshooting | Critical |
| [11](11_boot_grub.md) | **Boot Process & GRUB** | Boot sequence, GRUB configuration | Medium |
| [12](12_logging_monitoring.md) | **Logging & Monitoring** | rsyslog, journald, log analysis | Medium |
| [13](13_scheduled_tasks.md) | **Scheduled Tasks** | cron, at, systemd timers | Medium |

### Modern RHEL Features
| Module | Topic | Focus Areas | Exam Weight |
|--------|-------|-------------|-------------|
| [14](14_containers.md) | **Container Management** | Podman, container services | High |
| [15](15_network_services.md) | **Network Services** | SSH, NFS, time services | Medium |

## Quick Navigation

### By Exam Objective
- **Understand and use essential tools** → Modules 01, 02
- **Create simple shell scripts** → Module 02, 13
- **Operate running systems** → Modules 05, 06, 12, 13
- **Configure local storage** → Module 07
- **Create and configure file systems** → Modules 03, 07
- **Deploy, configure, and maintain systems** → Modules 01, 08, 09, 14, 15
- **Manage basic networking** → Module 08
- **Manage users and groups** → Module 04
- **Manage security** → Modules 03, 09, 10

### By Common Tasks
- **System Setup**: Modules 01, 04, 08
- **Storage Configuration**: Modules 03, 07
- **Security Hardening**: Modules 03, 04, 09, 10
- **Service Management**: Modules 05, 13, 14, 15
- **Troubleshooting**: All modules (dedicated sections)

## Study Progress Tracking

Track your progress through the synthesis modules:

- [ ] 00 - Exam Overview
- [ ] 01 - System Installation
- [ ] 02 - File Management
- [ ] 03 - Permissions & Security
- [ ] 04 - User & Group Management
- [ ] 05 - Process & Service Management
- [ ] 06 - Package Management
- [ ] 07 - Storage & LVM
- [ ] 08 - Network Configuration
- [ ] 09 - Firewall Configuration
- [ ] 10 - SELinux Management
- [ ] 11 - Boot Process & GRUB
- [ ] 12 - Logging & Monitoring
- [ ] 13 - Scheduled Tasks
- [ ] 14 - Container Management
- [ ] 15 - Network Services

## Additional Resources

### Original Sources
- Current ebook analysis: [ebook_summary.md](../ebook_summary.md)
- Comprehensive flashcards: [anki_rhcsa_flashcards.csv](../anki_rhcsa_flashcards.csv)
- Quick exam reference: [exam_quick_reference.md](../exam_quick_reference.md)

### Command References
- Organized by topic: [command_reference_by_topic.md](../command_reference_by_topic.md)
- Acronyms and terminology: [rhcsa_acronyms_glossary.md](../rhcsa_acronyms_glossary.md)

---

**Study Tip**: Each module is self-contained but cross-references related topics. Don't feel obligated to read linearly - jump to what you need to learn or review!