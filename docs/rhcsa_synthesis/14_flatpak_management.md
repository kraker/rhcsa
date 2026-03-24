# 14 - Flatpak Software Management

**Navigation**: [← Scheduled Tasks](13_scheduled_tasks.md) | [Index](index.md) | [Next → Troubleshooting](15_troubleshooting.md)

---

## 1. Executive Summary

**Topic Scope**: Flatpak application packaging, repository management, and software distribution on RHEL 10

**RHCSA Relevance**: Flatpak replaces container management (Podman) as an RHCSA exam objective starting with RHEL 10. Candidates must be able to configure Flatpak repositories and manage Flatpak-based software.

**Exam Weight**: High

**Prerequisites**: Basic package management (Module 06), familiarity with DNF/RPM

**Related Topics**: [Package Management](06_package_management.md)

---

## 2. Conceptual Foundation

### What is Flatpak?

Flatpak is a framework for distributing desktop and command-line applications on Linux. It provides a sandboxed environment where applications run isolated from the host system, with their own bundled dependencies.

**Key characteristics**:

- **Sandboxed execution**: Applications run in isolated environments with controlled access to host resources
- **Bundled dependencies**: Each application ships with its own runtime and libraries, avoiding dependency conflicts
- **Distribution-agnostic**: The same Flatpak runs on any Linux distribution
- **Automatic updates**: Applications can be updated independently of the host OS
- **OSTree-based**: Uses content-addressable storage for efficient deduplication and delta updates

### Flatpak Architecture

- **Runtimes**: Shared sets of base libraries (e.g., `org.freedesktop.Platform`, `org.gnome.Platform`) that provide common dependencies. Multiple applications can share the same runtime.
- **Applications**: The actual software packages, built against a specific runtime
- **Remotes**: Repositories from which runtimes and applications are fetched (similar to DNF repositories)
- **Refs**: References to specific versions of applications or runtimes (e.g., `app/org.gimp.GIMP/x86_64/stable`)
- **Sandbox**: The isolation boundary using namespaces, seccomp, and portals

### System vs User Installs

Flatpak supports two installation scopes:

- **System installs** (`--system`, default): Available to all users, stored in `/var/lib/flatpak/`. Requires root or polkit authorization.
- **User installs** (`--user`): Available only to the current user, stored in `~/.local/share/flatpak/`. No root required.

### Remotes and Repositories

- **Flathub** (`https://flathub.org/repo/flathub.flatpakrepo`): The largest Flatpak repository with thousands of community and vendor applications
- **RHEL Flatpak remote**: Red Hat's curated Flatpak repository for enterprise applications
- **Fedora Flatpaks**: Fedora's official Flatpak repository

### Sandboxing and Permissions

Flatpak uses a portal-based permission system:

- **Filesystem access**: Controlled via `--filesystem=` overrides
- **Network access**: Enabled/disabled per application
- **Device access**: Camera, GPU, etc. via portals
- **D-Bus access**: Controlled bus access for desktop integration
- Applications request permissions at install time; users can override them

### Common Misconceptions

- **Flatpak is not a container runtime** — Unlike Podman/Docker, Flatpak is designed for desktop/CLI applications, not server workloads
- **Flatpaks are not always large** — Runtimes are shared across applications, so the second Flatpak using the same runtime adds minimal disk usage
- **Flatpak does not replace RPM/DNF** — System packages (kernel, systemd, libraries) are still managed by DNF. Flatpak is for application-layer software

---

## 3. Command Mastery

### Essential Commands

```bash
# Repository (remote) management
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo  # Add Flathub
flatpak remote-add --user myremote https://example.com/repo/example.flatpakrepo          # Add user remote
flatpak remote-delete flathub                          # Remove a remote
flatpak remote-ls flathub                              # List available apps from remote
flatpak remotes                                        # List configured remotes

# Search and information
flatpak search gimp                                    # Search for applications
flatpak info org.gimp.GIMP                             # Show detailed app information

# Install and uninstall
flatpak install flathub org.gimp.GIMP                  # Install from specific remote
flatpak install org.gimp.GIMP                          # Install (auto-selects remote)
flatpak install --user org.gimp.GIMP                   # Install for current user only
flatpak uninstall org.gimp.GIMP                        # Uninstall application
flatpak uninstall --unused                             # Remove unused runtimes

# List installed applications
flatpak list                                           # List all installed Flatpaks
flatpak list --app                                     # List only applications (not runtimes)
flatpak list --runtime                                 # List only runtimes

# Run and update
flatpak run org.gimp.GIMP                              # Run application
flatpak update                                         # Update all Flatpaks
flatpak update org.gimp.GIMP                           # Update specific application
```

### Command Reference Table

| Command | Purpose | Key Options | Example |
|---------|---------|-------------|---------|
| `flatpak remote-add` | Add repository | `--if-not-exists`, `--user` | `flatpak remote-add flathub URL` |
| `flatpak remote-delete` | Remove repository | `--force` | `flatpak remote-delete flathub` |
| `flatpak remote-ls` | List remote apps | `--app`, `--runtime` | `flatpak remote-ls flathub` |
| `flatpak remotes` | Show configured remotes | `--show-details` | `flatpak remotes` |
| `flatpak search` | Search for apps | — | `flatpak search firefox` |
| `flatpak install` | Install application | `--user`, `--system`, `-y` | `flatpak install flathub org.gimp.GIMP` |
| `flatpak uninstall` | Remove application | `--unused` | `flatpak uninstall org.gimp.GIMP` |
| `flatpak list` | List installed | `--app`, `--runtime` | `flatpak list --app` |
| `flatpak run` | Run application | `--command=` | `flatpak run org.gimp.GIMP` |
| `flatpak update` | Update apps | `-y` | `flatpak update` |
| `flatpak info` | Show app details | — | `flatpak info org.gimp.GIMP` |

---

## 4. Procedural Workflows

### Standard Procedure: Adding a Remote and Installing Software

1. **Add the Flathub remote** (if not already configured):

    ```bash
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ```

2. **Verify the remote is configured**:

    ```bash
    flatpak remotes
    ```

3. **Search for the desired application**:

    ```bash
    flatpak search gimp
    ```

4. **Install the application**:

    ```bash
    flatpak install flathub org.gimp.GIMP -y
    ```

5. **Verify installation**:

    ```bash
    flatpak list --app | grep -i gimp
    flatpak info org.gimp.GIMP
    ```

6. **Run the application**:

    ```bash
    flatpak run org.gimp.GIMP
    ```

### Standard Procedure: User-Level Installation

1. **Add remote for current user only**:

    ```bash
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ```

2. **Install application for current user**:

    ```bash
    flatpak install --user flathub org.mozilla.firefox -y
    ```

3. **Verify user-level install**:

    ```bash
    flatpak list --user --app
    ls ~/.local/share/flatpak/app/
    ```

### Standard Procedure: Updating and Cleaning Up

1. **Check for available updates**:

    ```bash
    flatpak update --appstream    # Update metadata
    flatpak remote-ls --updates   # List available updates
    ```

2. **Update all installed Flatpaks**:

    ```bash
    flatpak update -y
    ```

3. **Remove unused runtimes** (after uninstalling applications):

    ```bash
    flatpak uninstall --unused -y
    ```

---

## 5. Configuration Deep Dive

### Primary Configuration Locations

- **System remotes**: `/var/lib/flatpak/repo/`
- **System installations**: `/var/lib/flatpak/app/`, `/var/lib/flatpak/runtime/`
- **User remotes and installations**: `~/.local/share/flatpak/`
- **Remote configuration**: `/etc/flatpak/remotes.d/` (system-wide remote definitions)

### Adding Remotes via Configuration File

Flatpak remotes can be pre-configured by placing `.flatpakrepo` files in `/etc/flatpak/remotes.d/`:

```ini
# /etc/flatpak/remotes.d/flathub.flatpakrepo
[Flatpak Repo]
Title=Flathub
Url=https://dl.flathub.org/repo/
Homepage=https://flathub.org/
Comment=Central repository of Flatpak applications
Icon=https://dl.flathub.org/repo/logo.svg
GPGKey=mQINBFlD2sABEADsiUZUO...
```

### Permission Overrides

Override application sandbox permissions:

```bash
# Grant filesystem access
flatpak override --user --filesystem=home org.gimp.GIMP

# Remove network access
flatpak override --user --no-network org.example.App

# View current overrides
flatpak override --user --show org.gimp.GIMP

# Reset overrides to defaults
flatpak override --user --reset org.gimp.GIMP
```

Override files are stored in:

- System: `/var/lib/flatpak/overrides/`
- User: `~/.local/share/flatpak/overrides/`

---

## 6. Hands-On Labs

### Lab 14.1: Configure Flatpak and Install Applications (Ghori Ch 12)

**Objective**: Set up Flatpak repositories and install applications at system and user levels

**Steps**:

1. **Verify Flatpak is installed** (it should be on RHEL 10 by default):

    ```bash
    rpm -q flatpak
    flatpak --version
    ```

2. **List currently configured remotes**:

    ```bash
    flatpak remotes
    ```

3. **Add the Flathub repository** (system-wide, requires root):

    ```bash
    sudo flatpak remote-add --if-not-exists flathub \
      https://flathub.org/repo/flathub.flatpakrepo
    ```

4. **Verify the remote was added**:

    ```bash
    flatpak remotes --show-details
    ```

5. **Search for and install an application**:

    ```bash
    flatpak search calculator
    sudo flatpak install flathub org.gnome.Calculator -y
    ```

6. **Verify the installation**:

    ```bash
    flatpak list --app
    flatpak info org.gnome.Calculator
    ```

7. **Run the installed application**:

    ```bash
    flatpak run org.gnome.Calculator
    ```

8. **Install an application at user level** (no root needed):

    ```bash
    flatpak remote-add --user --if-not-exists flathub \
      https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub org.gnome.TextEditor -y
    flatpak list --user --app
    ```

**Verification**:

```bash
flatpak remotes                    # Should show flathub
flatpak list --app                 # Should show installed apps
flatpak info org.gnome.Calculator  # Should show app details
```

**Expected Result**: Flathub is configured, applications are installed at both system and user levels, and can be launched successfully.

### Lab 14.2: Managing Flatpak Applications

**Objective**: Practice updating, removing, and managing Flatpak applications

**Steps**:

1. **Update all installed Flatpaks**:

    ```bash
    flatpak update -y
    ```

2. **List installed runtimes**:

    ```bash
    flatpak list --runtime
    ```

3. **Uninstall an application**:

    ```bash
    sudo flatpak uninstall org.gnome.Calculator -y
    ```

4. **Clean up unused runtimes**:

    ```bash
    sudo flatpak uninstall --unused -y
    ```

5. **Verify removal**:

    ```bash
    flatpak list --app
    ```

6. **Check disk usage**:

    ```bash
    du -sh /var/lib/flatpak/
    du -sh ~/.local/share/flatpak/
    ```

**Verification**:

```bash
flatpak list --app                 # Removed apps should be gone
flatpak list --runtime             # Unused runtimes should be cleaned
```

### Lab 14.3: Synthesis Challenge - Enterprise Flatpak Deployment

**Objective**: Configure a complete Flatpak environment suitable for enterprise use

**Scenario**: As a system administrator, configure Flatpak on a RHEL 10 system so that:

- Flathub is available as a system-wide remote
- A standard set of applications is installed for all users
- A regular user can install additional applications at the user level

**Requirements**:

1. Add Flathub as a system-wide remote
2. Install two system-wide applications
3. As a regular user, add a user-level remote and install one application
4. Update all installed Flatpaks
5. Verify system vs user install locations

**Solution Steps**:

1. **System-wide setup** (as root):

    ```bash
    sudo flatpak remote-add --if-not-exists flathub \
      https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak install flathub org.gnome.Calculator org.gnome.TextEditor -y
    ```

2. **User-level setup** (as regular user):

    ```bash
    flatpak remote-add --user --if-not-exists flathub \
      https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub org.gnome.Logs -y
    ```

3. **Update everything**:

    ```bash
    sudo flatpak update -y
    flatpak update --user -y
    ```

4. **Verify**:

    ```bash
    flatpak list --app                              # All apps
    flatpak list --app --system                     # System apps
    flatpak list --app --user                       # User apps
    ls /var/lib/flatpak/app/                        # System install path
    ls ~/.local/share/flatpak/app/                  # User install path
    ```

---

## 7. Troubleshooting Playbook

### Common Issues

#### Issue 1: Remote Add Fails with GPG Error

**Symptoms**:

- Error about GPG verification when adding a remote
- "GPG signatures found, but none are in trusted keyring"

**Diagnosis**:

```bash
flatpak remotes --show-details     # Check existing remote config
```

**Resolution**:

```bash
# Re-add the remote (the .flatpakrepo file includes the GPG key)
flatpak remote-delete flathub
flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
```

**Prevention**: Always use the official `.flatpakrepo` URL which bundles the GPG key.

#### Issue 2: Application Won't Install — Missing Runtime

**Symptoms**:

- Installation fails with "runtime not found" error

**Diagnosis**:

```bash
flatpak info --show-runtime org.example.App    # Check required runtime
flatpak list --runtime                          # List installed runtimes
```

**Resolution**:

```bash
# Install the required runtime manually
flatpak install flathub org.freedesktop.Platform//24.08 -y
# Then retry the application install
flatpak install flathub org.example.App -y
```

#### Issue 3: Application Crashes or Cannot Access Files

**Symptoms**:

- Application starts but cannot read/write files
- Permission denied errors in application

**Diagnosis**:

```bash
flatpak info --show-permissions org.example.App
flatpak override --user --show org.example.App
```

**Resolution**:

```bash
# Grant filesystem access
flatpak override --user --filesystem=home org.example.App
# Or grant access to a specific path
flatpak override --user --filesystem=/path/to/data org.example.App
```

### Diagnostic Command Sequence

```bash
flatpak --version                  # Verify Flatpak installation
flatpak remotes --show-details     # Check remote configuration
flatpak list --app                 # List installed applications
flatpak list --runtime             # List installed runtimes
flatpak info org.example.App       # Check specific app details
journalctl --user -b | grep flatpak  # Check logs for errors
```

---

## 8. Quick Reference Card

### Essential Commands At-a-Glance

```bash
# Remotes
flatpak remotes                                        # List remotes
flatpak remote-add --if-not-exists NAME URL            # Add remote
flatpak remote-delete NAME                             # Remove remote
flatpak remote-ls NAME                                 # List apps in remote

# Applications
flatpak search KEYWORD                                 # Search for apps
flatpak install REMOTE APP_ID                          # Install app
flatpak uninstall APP_ID                               # Remove app
flatpak list --app                                     # List installed apps
flatpak run APP_ID                                     # Run app
flatpak update                                         # Update all
flatpak info APP_ID                                    # App details

# Cleanup
flatpak uninstall --unused                             # Remove unused runtimes
```

### Key File Locations

- **System installations**: `/var/lib/flatpak/`
- **User installations**: `~/.local/share/flatpak/`
- **System remote configs**: `/etc/flatpak/remotes.d/`
- **Permission overrides (system)**: `/var/lib/flatpak/overrides/`
- **Permission overrides (user)**: `~/.local/share/flatpak/overrides/`

### Verification Commands

```bash
flatpak remotes                    # Confirm remotes are configured
flatpak list --app                 # Confirm apps are installed
flatpak info APP_ID                # Confirm app details
flatpak run APP_ID                 # Confirm app runs
```

---

## 9. Knowledge Check

### Conceptual Questions

1. **Question**: What is the difference between a Flatpak runtime and a Flatpak application?
    **Answer**: A runtime is a shared set of base libraries (like `org.freedesktop.Platform`) that provides common dependencies. An application is the actual software built against a specific runtime. Multiple applications can share the same runtime, reducing disk usage.

2. **Question**: What is the difference between system-level and user-level Flatpak installs?
    **Answer**: System installs (default) are stored in `/var/lib/flatpak/` and available to all users but require root privileges. User installs (`--user`) are stored in `~/.local/share/flatpak/` and available only to the installing user but require no elevated privileges.

3. **Question**: How does Flatpak differ from RPM/DNF package management?
    **Answer**: DNF manages system-level packages (kernel, libraries, system services) from RPM repositories. Flatpak manages sandboxed applications with bundled dependencies, providing isolation from the host system. They serve complementary roles — DNF for the base OS, Flatpak for application-layer software.

### Practical Scenarios

1. **Scenario**: A user needs to install GIMP from Flathub but Flathub is not configured on the system.
    **Solution**:

    ```bash
    sudo flatpak remote-add --if-not-exists flathub \
      https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak install flathub org.gimp.GIMP -y
    ```

2. **Scenario**: A regular user wants to install applications without root access.
    **Solution**:

    ```bash
    flatpak remote-add --user --if-not-exists flathub \
      https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub org.example.App -y
    ```

### Command Challenges

1. **Challenge**: List all Flatpak applications (not runtimes) installed on the system.
    **Answer**: `flatpak list --app`
    **Explanation**: The `--app` flag filters output to show only applications, excluding shared runtimes.

2. **Challenge**: Remove all unused runtimes left over from uninstalled applications.
    **Answer**: `flatpak uninstall --unused`
    **Explanation**: After uninstalling applications, their runtimes may remain. `--unused` identifies and removes runtimes no longer needed by any installed application.

---

## 10. Exam Strategy

### Topic-Specific Tips

- Know the difference between `--system` (default) and `--user` installation scopes
- Remember that `flatpak remote-add` requires a URL to a `.flatpakrepo` file, not just a hostname
- Use `--if-not-exists` when adding remotes to make commands idempotent
- The Flatpak application ID format is reverse-DNS: `org.gimp.GIMP`, `org.mozilla.firefox`

### Common Exam Scenarios

1. **Scenario**: Configure Flathub repository and install a specified application
    **Approach**:

    ```bash
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub org.example.App -y
    flatpak list --app    # Verify
    ```

2. **Scenario**: Install a Flatpak application for a specific user without root
    **Approach**:

    ```bash
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub org.example.App -y
    ```

### Time Management

- **Estimated Time**: 5-8 minutes for Flatpak tasks (remote setup + install + verify)
- **Quick Verification**: `flatpak list --app` confirms installation immediately

### Pitfalls to Avoid

- Forgetting to add the remote before trying to install
- Not using `--if-not-exists` (causes errors if remote already configured)
- Confusing system vs user installs (check which the question asks for)
- Not verifying with `flatpak list` after installation

---

## Summary

### Key Takeaways

- Flatpak is the RHEL 10 RHCSA method for application distribution (replacing containers/Podman from RHEL 9)
- Remotes (repositories) must be configured before applications can be installed
- System installs require root; user installs do not
- Applications run sandboxed with controlled permissions
- Unused runtimes should be cleaned up with `flatpak uninstall --unused`

### Critical Commands to Remember

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.example.App
flatpak list --app
flatpak uninstall org.example.App
flatpak uninstall --unused
flatpak update
flatpak search keyword
flatpak run org.example.App
```

### Next Steps

- Continue to [Troubleshooting](15_troubleshooting.md)
- Review related topics: [Package Management](06_package_management.md)
- Practice installing and managing Flatpak applications on your RHEL 10 lab VM

---

**Navigation**: [← Scheduled Tasks](13_scheduled_tasks.md) | [Index](index.md) | [Next → Troubleshooting](15_troubleshooting.md)
