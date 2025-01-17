# Ansible Role Testing Environment Setup Notes

## Environment Requirements
- User: lab-user (non-root)
- OS: RHEL 9.5
- SELinux: Enforcing mode
- Container Runtime: Podman (rootless)
- Python: 3.8+
- Testing Framework: Molecule with Podman driver

## Current Status

### Working Components
1. User Context
   - Running as lab-user (non-root)
2. Operating System
   - RHEL 9.5 confirmed
3. SELinux Status
   - Running in enforcing mode
4. Python Environment
   - Python 3.9.19 installed
   - Molecule and dependencies installed via pip
5. Podman Configuration
   - Rootless mode working
   - Container test successful
   - Proper UID/GID mapping configured

### Next Steps
1. Initialize Test Role
   ```bash
   # Create a new role with Molecule
   molecule init role my-test-role --driver-name=podman
   cd my-test-role
   
   # Verify Molecule configuration
   cat molecule/default/molecule.yml
   ```

2. Configure Molecule for RHEL 9.5
   ```yaml
   # molecule/default/molecule.yml
   ---
   dependency:
     name: galaxy
   driver:
     name: podman
   platforms:
     - name: rhel95
       image: registry.access.redhat.com/ubi9/ubi-init:latest
       tmpfs:
         - /run
         - /tmp
       volumes:
         - /sys/fs/cgroup:/sys/fs/cgroup:ro
       capabilities:
         - SYS_ADMIN
       command: "/usr/sbin/init"
       pre_build_image: true
   provisioner:
     name: ansible
   verifier:
     name: ansible
   ```

3. Create Basic Role Tasks
   ```yaml
   # tasks/main.yml
   ---
   - name: Ensure required packages are installed
     ansible.builtin.package:
       name: "{{ item }}"
       state: present
     loop:
       - httpd
       - firewalld
   
   - name: Ensure services are running
     ansible.builtin.service:
       name: "{{ item }}"
       state: started
       enabled: yes
     loop:
       - httpd
       - firewalld
   ```

4. Add Verification Tests
   ```yaml
   # molecule/default/verify.yml
   ---
   - name: Verify
     hosts: all
     gather_facts: false
     tasks:
       - name: Check if httpd is installed
         ansible.builtin.package:
           name: httpd
           state: present
         check_mode: true
         register: pkg_check
         failed_when: pkg_check.changed
   
       - name: Check if services are running
         ansible.builtin.service:
           name: "{{ item }}"
           state: started
         check_mode: true
         register: svc_check
         failed_when: svc_check.changed
         loop:
           - httpd
           - firewalld
   ```

## System Configuration Reference

### Current Permissions
```bash
# Verified working configuration
$ ls -l /usr/bin/newuidmap /usr/bin/newgidmap
-rwsr-sr-x. 1 root root 43144 Jul  3  2024 /usr/bin/newgidmap
-rwsr-xr-x. 1 root root 39024 Jul  3  2024 /usr/bin/newuidmap
```

### User Namespace Mapping
```bash
# /etc/subuid and /etc/subgid configuration
lab-user:100000:65536
```

## Testing Workflow
1. Create new role:
   ```bash
   molecule init role my-test-role --driver-name=podman
   ```

2. Run full test sequence:
   ```bash
   molecule create    # Create test container
   molecule converge  # Run playbook
   molecule verify    # Run tests
   molecule test      # Full test sequence
   ```

3. Development cycle:
   ```bash
   molecule destroy   # Clean up
   molecule converge  # Apply changes
   molecule verify    # Run tests
   ```

## References
- [Podman Rootless Setup Guide](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md)
- [Molecule Documentation](https://molecule.readthedocs.io/)
- [RHEL 9 Container Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/building_running_and_managing_containers/index)

## Ansible Role: libvirt Configuration Steps

## Overview
This document details the step-by-step process of configuring and testing the libvirt Ansible role for managing virtual machines on RHEL 9.5 systems.

## Role Configuration Steps

### 1. Package Installation
- Installed core libvirt packages:
  - libvirt
  - libvirt-client
  - qemu-kvm
  - virt-manager
  - virt-install
  - python3-libvirt
- Used `dnf` module for idempotent package management

### 2. Service Configuration
- Enabled and started libvirtd service
- Added user to libvirt group for management access
- Configured libvirtd socket permissions:
  - Set unix_sock_group to "libvirt"
  - Set unix_sock_rw_perms to "0770"
- Added service restart trigger when socket configuration changes

### 3. Network Configuration
- Created default network XML configuration
  - Network name: default
  - NAT forwarding mode
  - Bridge: virbr0
  - DHCP range: 192.168.122.2-254
- Implemented idempotent network setup:
  - Added checks for existing network
  - Properly handled "already exists" conditions
  - Configured network autostart

### 4. VM Management
- Implemented VM lifecycle management:
  - Added existence checks before operations
  - Added state checks for running VMs
  - Implemented proper cleanup procedures
- Created SSH key management:
  - Generated 2048-bit RSA key if not exists
  - Set proper permissions (0600)
  - Created in user's .ssh directory

### 5. Cloud-Init Configuration
- Created cloud-init configuration:
  - user-data: cloud-user creation with sudo access
  - meta-data: instance ID and hostname
- Generated cloud-init ISO for VM initialization
- Added existence checks for ISO creation

### 6. VM Creation and Testing
- Downloaded CentOS 9 cloud image
- Created VM with:
  - 2GB RAM
  - 2 vCPUs
  - Cloud image as primary disk
  - Cloud-init ISO as secondary disk
- Added comprehensive VM readiness checks:
  - Wait for VM to be running
  - Wait for IP address assignment
  - Wait for SSH availability
  - Test SSH connectivity with file creation

## Idempotency Improvements

### 1. Command Execution
- Added proper `changed_when` conditions for all commands
- Implemented proper error handling with `failed_when`
- Added status checks before operations

### 2. Resource Management
- Added existence checks for:
  - Cloud-init ISO
  - CentOS cloud image
  - VM instance
  - SSH keys
  - Test files
- Skip resource creation if already exists

### 3. State Management
- Added VM state detection
- Only stop running VMs
- Only remove existing VMs
- Added force=false for downloads

### 4. Wait Operations
- Set `changed_when: false` for all wait tasks
- Added 120-second pause after VM creation
- Implemented proper retry mechanisms with delays

## Testing Procedures

### 1. Molecule Testing
- Test matrix includes:
  - dependency
  - cleanup
  - destroy
  - syntax
  - create
  - prepare
  - converge
  - idempotence
  - side_effect
  - verify
- Added cleanup control with environment variable
- Implemented proper wait times for service stability

### 2. Verification Steps
- Verify VM creation
- Verify network configuration
- Test SSH connectivity
- Verify file creation
- Test idempotency
- Verify proper cleanup

## Environment Variables
- `MOLECULE_CLEANUP_VM`: Controls VM cleanup after tests
  - true: Remove VM after testing (default)
  - false: Keep VM for inspection

## Notes
- The role is designed for RHEL 9.5 systems
- All operations are made idempotent
- Proper error handling is implemented
- Resource cleanup is controlled
- Added appropriate wait times for service stability