# Module 14: Container Management with Podman

## 1. Learning Objectives
- Master Podman container operations and management
- Configure rootless and rootful container execution
- Implement persistent container storage and networking
- Manage container images, registries, and security
- Integrate containers with systemd services
- Design container-based application deployment strategies
- Troubleshoot container networking and storage issues

## 2. Key Concepts

### Container Technology in RHEL 9
- **Podman**: Pod Manager, daemonless container engine
- **Buildah**: Container image building tool
- **Skopeo**: Container image operations and inspection
- **CRI-O**: Container runtime interface for Kubernetes
- **Rootless containers**: User namespace containers without root privileges

### Podman Architecture
- **Daemonless**: No central daemon, direct fork/exec model
- **Rootless**: Can run containers as regular users
- **Pod support**: Kubernetes-compatible pod management
- **OCI compliance**: Open Container Initiative standard compatibility
- **systemd integration**: Native systemd service generation

### Container Storage and Networking
- **Storage drivers**: overlay, vfs for different storage backends
- **Container images**: Layered filesystem with union mounts
- **Volumes**: Persistent data storage independent of container lifecycle
- **Networks**: Bridge, host, none networking modes
- **Port mapping**: Expose container ports to host system

### Security Features
- **SELinux integration**: Container process confinement
- **User namespaces**: Process isolation and privilege separation
- **Capabilities**: Fine-grained privilege control
- **Seccomp**: System call filtering
- **Image signing**: Digital signature verification

## 3. Essential Commands

### Basic Container Operations
```bash
# Container lifecycle
podman run -it --name mycontainer ubi8 /bin/bash    # Create and start container
podman start container_name                         # Start stopped container
podman stop container_name                          # Stop running container
podman restart container_name                       # Restart container
podman rm container_name                            # Remove container
podman kill container_name                          # Force kill container

# Container information
podman ps                                           # List running containers
podman ps -a                                        # List all containers
podman inspect container_name                       # Detailed container info
podman logs container_name                          # View container logs
podman top container_name                           # Show container processes
```

### Image Management
```bash
# Image operations
podman images                                       # List local images
podman pull registry.redhat.io/ubi8/ubi            # Pull image from registry
podman search httpd                                 # Search for images
podman inspect image_name                           # Image details
podman rmi image_name                               # Remove image
podman tag old_name new_name                       # Tag image with new name

# Image building
podman build -t myapp:v1 .                         # Build from Dockerfile
buildah from ubi8                                   # Create working container
buildah run mycontainer -- yum install httpd       # Run commands in container
buildah commit mycontainer myimage:v1              # Commit to new image
```

### Volume and Storage Management
```bash
# Volume operations
podman volume create myvolume                       # Create named volume
podman volume ls                                    # List volumes
podman volume inspect myvolume                      # Volume details
podman volume rm myvolume                           # Remove volume

# Using volumes in containers
podman run -v myvolume:/data ubi8                   # Mount named volume
podman run -v /host/path:/container/path ubi8       # Bind mount host directory
podman run --mount type=bind,source=/host,target=/container ubi8  # Alternative mount syntax
```

### Network Management
```bash
# Network operations
podman network ls                                   # List networks
podman network create mynetwork                     # Create custom network
podman network inspect mynetwork                    # Network details
podman network rm mynetwork                         # Remove network

# Container networking
podman run -p 8080:80 httpd                        # Port mapping
podman run --network none ubi8                     # No networking
podman run --network host httpd                    # Use host networking
podman run --network mynetwork --name web httpd    # Use custom network
```

### Systemd Integration
```bash
# Generate systemd service files
podman generate systemd --name mycontainer         # Generate service unit
podman generate systemd --name mycontainer --files # Write to files
podman generate systemd --new --name mycontainer   # Include container creation

# Service management (as user)
systemctl --user daemon-reload                     # Reload user systemd
systemctl --user enable container-mycontainer      # Enable container service
systemctl --user start container-mycontainer       # Start container service
loginctl enable-linger username                    # Enable user services at boot
```

## 4. Asghar Ghori's Approach

### Systematic Container Deployment
Ghori emphasizes structured container implementation:
```bash
# Step 1: Environment preparation
dnf install container-tools                        # Install podman suite
podman info                                         # Verify installation

# Step 2: Registry configuration
# Edit /etc/containers/registries.conf
[registries.search]
registries = ['registry.redhat.io', 'registry.fedoraproject.org', 'docker.io']

[registries.insecure]
registries = []

[registries.block]
registries = []

# Step 3: Container deployment workflow
podman pull registry.redhat.io/ubi8/httpd-24       # Pull official image
podman inspect registry.redhat.io/ubi8/httpd-24    # Examine image
podman run -d --name web-server -p 8080:8080 registry.redhat.io/ubi8/httpd-24
podman ps                                           # Verify deployment
curl http://localhost:8080                          # Test functionality
```

### Rootless Container Configuration
Ghori's approach to non-privileged container management:
```bash
# Configure subuid and subgid for regular user
echo "username:100000:65536" >> /etc/subuid
echo "username:100000:65536" >> /etc/subgid

# As regular user
podman unshare cat /proc/self/uid_map              # Verify user namespace
podman run --rm -it ubi8 id                        # Check container user mapping

# Rootless networking (requires special handling)
podman run -p 8080:8080 httpd                      # Unprivileged ports only
```

### Container Persistence Strategy
```bash
# Ghori's systematic approach to data persistence
# 1. Create persistent volume
podman volume create webapp-data

# 2. Deploy container with volume
podman run -d --name webapp \
  -v webapp-data:/var/www/html \
  -p 8080:8080 \
  httpd

# 3. Populate data
podman exec webapp sh -c "echo '<h1>Hello World</h1>' > /var/www/html/index.html"

# 4. Test persistence
podman stop webapp
podman rm webapp
podman run -d --name webapp2 -v webapp-data:/var/www/html -p 8081:8080 httpd
curl http://localhost:8081                          # Data should persist
```

## 5. Sander van Vugt's Approach

### Advanced Podman Configuration
Van Vugt focuses on production-ready container configurations:
```bash
# Configure container storage optimization
# Edit /etc/containers/storage.conf
[storage]
driver = "overlay"
runroot = "/run/containers/storage"
graphroot = "/var/lib/containers/storage"

[storage.options]
additionalimagestores = []
size = ""
remap-uids = ""
remap-gids = ""
ignore_chown_errors = "false"
mount_program = "/usr/bin/fuse-overlayfs"
mountopt = "nodev,metacopy=on"
```

### Multi-Container Pod Management
Van Vugt's pod-based approach:
```bash
# Create pod with shared networking
podman pod create --name webapp-pod -p 8080:80

# Deploy database container in pod
podman run -d --name database \
  --pod webapp-pod \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=webapp \
  registry.redhat.io/rhel8/mysql-80

# Deploy web application in same pod
podman run -d --name webapp \
  --pod webapp-pod \
  -e DB_HOST=localhost \
  -e DB_PASSWORD=secret \
  custom-webapp:latest

# Pod management
podman pod ps                                       # List pods
podman pod stop webapp-pod                          # Stop entire pod
podman pod start webapp-pod                         # Start entire pod
```

### Production Systemd Integration
Van Vugt's enterprise systemd service configuration:
```bash
# Generate production-ready systemd units
podman create --name production-web \
  --restart=always \
  -p 80:8080 \
  -v web-data:/var/www/html:Z \
  httpd

# Generate systemd service
podman generate systemd --new --files --name production-web

# Install as system service (requires root)
cp container-production-web.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable container-production-web
systemctl start container-production-web

# Monitor service
systemctl status container-production-web
journalctl -u container-production-web -f
```

### Advanced Networking Configuration
```bash
# Create custom bridge network with specific subnet
podman network create --driver bridge --subnet 172.20.0.0/16 --gateway 172.20.0.1 prod-network

# Deploy containers with static IPs
podman run -d --name web1 --network prod-network --ip 172.20.0.10 httpd
podman run -d --name web2 --network prod-network --ip 172.20.0.11 httpd

# Load balancer configuration
podman run -d --name lb \
  --network prod-network \
  --ip 172.20.0.5 \
  -p 80:80 \
  nginx

# Network troubleshooting
podman network inspect prod-network
podman exec web1 ping 172.20.0.11
```

## 6. Command Examples and Scenarios

### Scenario 1: Web Application Deployment
```bash
# Deploy complete web application stack
# 1. Create application network
podman network create webapp-net

# 2. Deploy database
podman run -d --name webapp-db \
  --network webapp-net \
  -e POSTGRES_DB=webapp \
  -e POSTGRES_USER=appuser \
  -e POSTGRES_PASSWORD=secret \
  -v db-data:/var/lib/postgresql/data \
  postgres:13

# 3. Deploy application
podman run -d --name webapp-api \
  --network webapp-net \
  -e DATABASE_URL=postgresql://appuser:secret@webapp-db:5432/webapp \
  -p 8080:8080 \
  webapp-api:latest

# 4. Deploy frontend
podman run -d --name webapp-frontend \
  --network webapp-net \
  -e API_URL=http://webapp-api:8080 \
  -p 80:80 \
  webapp-frontend:latest
```

### Scenario 2: Development Environment
```bash
# Create development container with volume mounts
podman run -it --name dev-env \
  -v $(pwd):/workspace:Z \
  -v dev-cache:/root/.cache \
  -w /workspace \
  -p 3000:3000 \
  -p 8080:8080 \
  node:16

# Inside container: npm install && npm start

# Attach to running development container
podman exec -it dev-env /bin/bash
```

### Scenario 3: Batch Processing Container
```bash
# Run one-time batch processing container
podman run --rm \
  -v /data/input:/input:ro \
  -v /data/output:/output:Z \
  -e BATCH_SIZE=1000 \
  -e OUTPUT_FORMAT=json \
  batch-processor:latest

# Scheduled batch processing with systemd timer
podman create --name nightly-batch \
  -v batch-input:/input:ro \
  -v batch-output:/output:Z \
  batch-processor:latest

podman generate systemd --new --files --name nightly-batch
```

## 7. Lab Exercises

### Lab 14A: Basic Container Operations (Ghori-focused)
**Time Limit**: 25 minutes
**Objective**: Master fundamental Podman operations and rootless container deployment

**Prerequisites**:
- RHEL 9 system with container-tools package installed
- Regular user account configured with subuid/subgid

**Tasks**:
1. Configure rootless container environment for regular user
2. Deploy HTTP server container with persistent volume
3. Create custom image with application modifications
4. Implement container networking with port mapping
5. Generate and test systemd service for container

**Verification Commands**:
```bash
podman ps -a                                        # List all containers
podman images                                       # Show local images
podman volume ls                                    # List volumes
curl http://localhost:8080                          # Test web service
systemctl --user status container-*                # Check systemd services
```

### Lab 14B: Advanced Container Management (van Vugt-focused)
**Time Limit**: 30 minutes
**Objective**: Implement production-ready container infrastructure with pods and networking

**Prerequisites**:
- RHEL 9 system with full container tools suite
- Understanding of systemd service management

**Tasks**:
1. Create multi-container pod with shared networking
2. Implement custom bridge network with static IP assignments
3. Deploy database and web application containers with proper data persistence
4. Configure container auto-restart and health monitoring
5. Set up centralized logging for container applications

**Verification Commands**:
```bash
podman pod ps                                       # List pods
podman network ls                                   # Show networks
podman volume inspect data-volume                   # Check volume details
systemctl status container-*                       # Service status
podman logs --tail=20 webapp                       # Application logs
```

### Lab 14C: Synthesis Challenge - Enterprise Container Platform
**Time Limit**: 40 minutes
**Objective**: Build complete containerized application platform combining all methodologies

**Prerequisites**:
- Multiple RHEL 9 systems for distributed deployment
- Container registry access for image distribution

**Tasks**:
1. Design multi-tier containerized application architecture
2. Implement container image build pipeline with Buildah
3. Deploy distributed application using pods and custom networking
4. Configure container monitoring and log aggregation
5. Implement container backup and disaster recovery procedures
6. Set up automated container updates and rollback mechanisms

**Advanced Requirements**:
- Combine Ghori's systematic deployment with van Vugt's advanced configuration
- Implement container security hardening and SELinux integration
- Create comprehensive operational documentation

**Verification Commands**:
```bash
podman system info                                  # System configuration
podman pod ps && podman ps                          # All containers and pods
ss -tulnp | grep -E ":80|:8080|:443"               # Network services
find /var/lib/containers -name "*.json" | head -5  # Container metadata
systemctl --user list-units --type=service | grep container  # User services
```

## 8. Troubleshooting Common Issues

### Container Won't Start
```bash
# Symptoms: Container fails to start or exits immediately
# Check container logs
podman logs container_name

# Check container configuration
podman inspect container_name | grep -A5 -B5 Error

# Common causes:
# 1. Image not found
podman images | grep image_name

# 2. Port conflicts
ss -tulnp | grep :8080

# 3. Permission issues with volumes
ls -laZ /host/path
```

### Rootless Container Networking Issues
```bash
# Symptoms: Cannot bind to ports below 1024
# Solution: Use port mapping to higher ports
podman run -p 8080:80 httpd                        # Map host 8080 to container 80

# Enable unprivileged port binding (if needed)
echo 'net.ipv4.ip_unprivileged_port_start=80' >> /etc/sysctl.conf
sysctl -p

# Check user namespace configuration
podman unshare cat /proc/self/uid_map
podman unshare cat /proc/self/gid_map
```

### Volume Mount Permission Errors
```bash
# Symptoms: Permission denied errors when accessing mounted volumes
# Check SELinux context
ls -laZ /host/directory

# Fix SELinux context for container volumes
# Method 1: Use :Z suffix for automatic labeling
podman run -v /host/path:/container/path:Z image

# Method 2: Manually set SELinux context
semanage fcontext -a -t container_file_t "/host/path(/.*)?"
restorecon -Rv /host/path

# Check volume ownership
podman unshare ls -la /host/path
```

### Image Pull Failures
```bash
# Symptoms: Cannot pull images from registry
# Check registry configuration
cat /etc/containers/registries.conf

# Test registry connectivity
curl -I https://registry.redhat.io/v2/

# Check authentication
podman login registry.redhat.io

# Use fully qualified image names
podman pull registry.redhat.io/ubi8/ubi:latest
```

### Systemd Service Integration Problems
```bash
# Symptoms: Container service fails to start properly
# Regenerate systemd service files
podman generate systemd --new --files --name container_name

# Check service file syntax
systemctl --user cat container-name
systemctl --user daemon-reload

# Enable linger for user services
loginctl enable-linger username
loginctl show-user username | grep Linger

# Check service logs
systemctl --user status container-name
journalctl --user -u container-name
```

## 9. Best Practices

### Security Hardening
- Run containers as rootless whenever possible
- Use minimal base images (UBI, Alpine, scratch)
- Implement proper SELinux labeling for volumes
- Avoid running containers with --privileged flag
- Use secrets management for sensitive data
- Regular security scanning of container images

### Resource Management
- Set memory and CPU limits for containers
- Use appropriate restart policies
- Monitor container resource usage
- Implement health checks for applications
- Use multi-stage builds to reduce image size
- Clean up unused images and containers regularly

### Data Persistence Strategy
- Use named volumes for persistent data
- Implement proper backup strategies for volume data
- Separate application data from container lifecycle
- Use bind mounts sparingly and with proper permissions
- Document volume dependencies and relationships

### Networking Design
- Use custom networks for application isolation
- Implement proper port management strategies
- Document network dependencies between containers
- Use pod networking for tightly coupled applications
- Implement proper DNS resolution for service discovery

## 10. Integration with Other RHCSA Topics

### Service Management Integration
- Generate systemd services for containers
- Integrate container services with system boot process
- Monitor container services through systemd
- Implement service dependencies and ordering

### Storage Integration
- Use LVM volumes for container storage
- Implement container data backup strategies
- Integrate with existing storage infrastructure
- Monitor container storage usage and growth

### Security Integration
- Implement SELinux policies for containers
- Use firewall rules for container networking
- Integrate with system authentication mechanisms
- Implement audit logging for container operations

### Network Integration
- Configure container networking with host network infrastructure
- Implement load balancing for containerized services
- Use existing DNS infrastructure for container name resolution
- Monitor network performance for containerized applications

---

**Module 14 Summary**: Container management with Podman is an essential skill for modern system administrators. This module provides comprehensive coverage of container operations, from basic deployment to advanced enterprise configurations. Understanding both rootless container management and production deployment strategies is crucial for RHCSA certification and modern infrastructure management. The synthesis approach ensures proficiency in both fundamental operations and advanced containerization concepts.