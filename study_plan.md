# RHCSA Study Plan for Experienced Administrators

## Phase 1: Gap Assessment (Days 1-3)

### Day 1: Skills Assessment and Planning
- [ ] Complete enhanced skills assessment (skills_assessment.md)
- [ ] Focus on ⭐ High-Risk Areas for Experienced Admins section
- [ ] Import both Anki decks (anki_deck.csv + anki_deck_advanced.csv)
- [ ] Take initial review quiz from basic deck to establish baseline

**Time Investment:** 2-3 hours
**Output:** Identified weak areas and customized study focus

### Day 2: RHEL 9 Specific Changes
- [ ] Review container management with podman (new requirement)
- [ ] Practice nmcli network configuration syntax
- [ ] Test firewall-cmd vs iptables differences
- [ ] Verify systemd-resolved vs traditional DNS configuration

**Lab Work:** Practice scenarios from anki_deck_advanced.csv
**Anki:** Review 20 advanced cards focusing on RHEL 9 changes

### Day 3: Syntax Verification Under Pressure
- [ ] Time yourself on common command sequences
- [ ] Practice typing complex commands from memory
- [ ] Use only man pages for syntax verification
- [ ] Complete lab_scenarios/01_user_management.md under time pressure

**Goal:** Identify which commands need more muscle memory development

## Phase 2: Intensive Practice (Days 4-10)

### Day 4: Storage Management Deep Dive
- [ ] Complete lab_scenarios/02_storage_management.md
- [ ] Practice LVM extension scenarios multiple times
- [ ] Focus on swap configuration variations
- [ ] Time yourself on complete storage setup workflows

**Anki Focus:** LVM and storage-related cards
**Lab Goal:** Complete storage lab in 30 minutes or less

### Day 5: SELinux and Security
- [ ] Complete lab_scenarios/03_selinux_security.md (now finished)
- [ ] Practice troubleshooting SELinux denials
- [ ] Work through common boolean configurations
- [ ] Focus on exam-style SELinux scenarios

**Critical Skills:** restorecon, semanage, setsebool, ausearch

### Day 6: Network and Services
- [ ] Master nmcli static IP configuration
- [ ] Practice SSH key authentication setup
- [ ] Configure firewalld for various services
- [ ] Work on service startup and troubleshooting

**Time Challenge:** Complete network + SSH setup in 15 minutes

### Day 7: Container Management (New RHEL 9)
- [ ] Practice podman operations from advanced Anki deck
- [ ] Focus on systemd integration with containers
- [ ] Work through persistent storage scenarios
- [ ] Practice container troubleshooting

**Goal:** Comfortable with podman basics and systemd integration

### Day 8: Weak Area Focus Day
- [ ] Review skills assessment results
- [ ] Spend entire day on your lowest confidence areas
- [ ] Use advanced Anki cards for challenging syntax
- [ ] Practice problem areas until comfortable

**Customized:** Based on your specific weak areas

### Day 9-10: Exam Simulation
- [ ] Complete lab_scenarios/04_exam_simulation.md
- [ ] Take full 3-hour timed exam simulation
- [ ] Analyze results and identify remaining gaps
- [ ] Practice verification commands and troubleshooting

**Goal:** Score 70+ points on simulation exam

## Phase 3: Mastery and Review (Days 11-14)

### Day 11: Speed and Accuracy
- [ ] Repeat weak lab scenarios for speed
- [ ] Practice typing commands accurately under pressure
- [ ] Focus on time-saving techniques
- [ ] Use exam_quick_reference.md for syntax checks

**Target:** Complete familiar tasks 25% faster

### Day 12: Troubleshooting Scenarios
- [ ] Practice boot issues and rescue mode
- [ ] Work through SELinux denial scenarios
- [ ] Practice service failure troubleshooting
- [ ] Focus on systematic debugging approaches

**Skill:** Confidence in unknown problem solving

### Day 13: Final Review
- [ ] Review all Anki cards (aim for 90%+ accuracy)
- [ ] Quick run through exam_quick_reference.md
- [ ] Practice critical command sequences
- [ ] Light review of man page navigation

**Mental Prep:** Build confidence, avoid over-studying

### Day 14: Exam Preparation
- [ ] Light review only
- [ ] Organize notes and reference materials
- [ ] Ensure lab environment is ready
- [ ] Mental preparation and rest

## Daily Anki Schedule

### Week 1-2: Building Foundation
- **New cards per day:** 15-20
- **Review cards:** All due cards
- **Focus:** Basic commands and RHEL 9 specifics
- **Time:** 20-30 minutes daily

### Week 3: Intensive Practice
- **New cards per day:** 10
- **Review cards:** All due + problem cards
- **Focus:** Advanced scenarios and weak areas
- **Time:** 30-40 minutes daily

### Week 4: Maintenance
- **New cards per day:** 5
- **Review cards:** Focus on difficult cards
- **Focus:** Speed and accuracy
- **Time:** 15-20 minutes daily

## Lab Practice Schedule

### Week 1: Individual Labs
- Day 1-2: User management (lab 01)
- Day 3-4: Storage management (lab 02)  
- Day 5-6: SELinux security (lab 03)
- Day 7: Review and weak areas

### Week 2: Combined Scenarios
- Day 8-10: Exam simulation (lab 04)
- Day 11-12: Custom scenarios based on weak areas
- Day 13-14: Speed runs and verification practice

## Success Metrics

### Week 1 Goals:
- [ ] Complete all individual labs successfully
- [ ] Anki accuracy >80% on basic deck
- [ ] Identify and document specific weak areas

### Week 2 Goals:
- [ ] Complete exam simulation with 70+ score
- [ ] Anki accuracy >90% on both decks
- [ ] Demonstrate speed improvement on repeated tasks

### Exam Readiness Indicators:
- [ ] Complete any lab scenario within time limits
- [ ] Navigate man pages efficiently for syntax help
- [ ] Troubleshoot unknown issues systematically
- [ ] Type common command sequences without errors

## Emergency Review Strategy (1-3 Days Before Exam)

If you're short on time, prioritize:

### Day -3: Core Skills
- Storage management (LVM workflows)
- User management with password aging
- Basic network configuration with nmcli

### Day -2: Problem Areas
- SELinux troubleshooting
- Service configuration and troubleshooting
- Container basics with podman

### Day -1: Verification and Confidence
- Review exam_quick_reference.md
- Practice verification commands
- Light Anki review (high-confidence cards only)

## Study Resources Priority

1. **Primary:** Your lab scenarios + Anki decks
2. **Reference:** exam_quick_reference.md for syntax
3. **Backup:** Man pages during practice
4. **EPUB guides:** For concept clarification only

## Tips for Experienced Administrators

1. **Don't Skip Basics:** Even familiar tasks may have RHEL 9-specific syntax
2. **Practice Typing:** Muscle memory is critical under exam pressure
3. **Use Man Pages:** Practice finding information quickly
4. **Verify Everything:** Build habits of checking your work
5. **Time Management:** Don't get stuck on any single task

Remember: You already know Linux administration. This study plan focuses on RHEL 9 specifics, exam format familiarity, and building confidence under time pressure.