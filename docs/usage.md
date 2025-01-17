# Using the Libvirt Role and Molecule Podman Template

This document provides comprehensive guidance on using the Ansible Libvirt Role and the Molecule Podman Template.

## Using the Ansible Libvirt Role

This section provides instructions for using the Ansible Libvirt Role to manage your virtualized infrastructure.

## Using the Scripts

This repository includes several scripts to help with setting up and managing the environment. This section describes how to use each of them.

### fix_permissions.sh

This script fixes file permissions.

**Usage:**

```bash
./fix_permissions.sh
```

### setup_environment.sh

This script sets up the development environment.

**Usage:**

```bash
./setup_environment.sh
```

### validate_environment.sh

This script validates the development environment.

**Usage:**

```bash
./validate_environment.sh
```

### libvirt_validate_environment.sh

This script validates the environment for the Ansible role.

**Usage:**

```bash
./ansible-role-libvirt/libvirt_validate_environment.sh
```

### setup_env.sh

This script sets up the environment for the Ansible role.

**Usage:**

```bash
./ansible-role-libvirt/scripts/setup_env.sh
```

### setup_remote_libvirt.sh

This script sets up a remote libvirt environment.

**Usage:**

```bash
./ansible-role-libvirt/scripts/setup_remote_libvirt.sh
```

## Using the Molecule Podman Template

The `molecule-podman-template` directory contains a template for testing Ansible roles using Molecule and Podman.

### Prerequisites

-   Molecule
-   Podman

### Usage

1. Navigate to the `molecule-podman-template` directory:

    ```bash
    cd molecule-podman-template
    ```

2. Run the default Molecule scenario:

    ```bash
    molecule test
    ```

    This will run the `converge.yml` playbook to set up the environment, and then run the `verify.yml` playbook to verify the role.

3. You can also run specific Molecule commands, such as:

    ```bash
    molecule converge
    molecule verify
    molecule destroy
    ```

## Installation

### Requirements

-   Ansible 2.9+
-   Python 3.6+
-   libvirt 6.0+
-   qemu-kvm

### Installation Methods

1. From Ansible Galaxy:

    ```bash
    ansible-galaxy install ansible-role-libvirt
    ```

2. From source:

    ```bash
    git clone https://github.com/your-repo/ansible-role-libvirt.git
    cd ansible-role-libvirt
    ```

3. Using requirements.yml:

    ```yaml
    - src: ansible-role-libvirt
      version: main
    ```

## Configuration

### Role Variables

#### Required Variables
- `libvirt_pools`: List of storage pools
- `libvirt_networks`: List of virtual networks

#### Optional Variables
- `libvirt_users`: List of users to add to libvirt group
- `libvirt_service_state`: Service state (started/stopped)
- `libvirt_service_enabled`: Service enabled on boot

### Example Configuration

```yaml
libvirt_pools:
  - name: default
    type: dir
    target: /var/lib/libvirt/images

libvirt_networks:
  - name: default
    bridge: virbr0
    ip: 192.168.122.1
    netmask: 255.255.255.0
    dhcp:
      start: 192.168.122.2
      end: 192.168.122.254
```

## Role Execution

### Basic Usage
```bash
ansible-playbook -i inventory playbook.yml
```

### Targeting Specific Hosts
```bash
ansible-playbook -i inventory -l libvirt_hosts playbook.yml
```

### Running with Tags
```bash
ansible-playbook -i inventory playbook.yml --tags "network,storage"
```

## Common Workflows

### Creating Virtual Machines
1. Define VM configuration
2. Create storage volumes
3. Configure networking
4. Install operating system

### Managing Storage
1. Create storage pools
2. Define storage volumes
3. Attach volumes to VMs
4. Monitor storage usage

### Network Configuration
1. Define virtual networks
2. Configure network bridges
3. Set up DHCP
4. Configure firewall rules

## Integration with Other Tools

### Molecule Testing
1. Create test scenarios
2. Define test infrastructure
3. Run integration tests
4. Verify role functionality

### CI/CD Pipelines
1. Add role to requirements
2. Configure test environments
3. Run automated tests
4. Deploy to production

## Advanced Usage

### Custom Modules
1. Create custom modules
2. Add module utilities
3. Extend role functionality
4. Maintain module documentation

### Role Dependencies
1. Define dependencies
2. Manage role versions
3. Handle conflicts
4. Test integration

## Best Practices

### Configuration Management
1. Use version control
2. Maintain separate environments
3. Document all changes
4. Review configurations regularly

### Security Considerations
1. Use secure connections
2. Manage user permissions
3. Monitor access logs
4. Apply security updates

### Performance Optimization
1. Tune resource allocation
2. Optimize storage
3. Configure networking
4. Monitor system metrics

## Troubleshooting

### Common Issues
1. Permission errors
2. Network connectivity
3. Storage allocation
4. Resource constraints

### Diagnostic Tools
1. `virsh` commands
2. System logs
3. Network tools
4. Storage utilities

## Maintenance

### Regular Tasks
1. Backup configurations
2. Update packages
3. Review logs
4. Test recovery procedures

### Upgrade Procedures
1. Check compatibility
2. Backup current setup
3. Test new version
4. Update documentation

## Examples

### Full Playbook Example
```yaml
- hosts: libvirt_hosts
  roles:
    - role: ansible-role-libvirt
      vars:
        libvirt_pools:
          - name: default
            type: dir
            target: /var/lib/libvirt/images
        libvirt_networks:
          - name: default
            bridge: virbr0
            ip: 192.168.122.1
            netmask: 255.255.255.0
            dhcp:
              start: 192.168.122.2
              end: 192.168.122.254
```

### Minimal Configuration
```yaml
- hosts: libvirt_hosts
  roles:
    - role: ansible-role-libvirt
      vars:
        libvirt_pools:
          - name: default
            type: dir
            target: /var/lib/libvirt/images
```

## API Reference

### Available Modules
1. `libvirt_pool`
2. `libvirt_network`
3. `libvirt_domain`
4. `libvirt_volume`

### Module Parameters
- `name`: Resource name
- `state`: Desired state
- `autostart`: Start on boot
- `persistent`: Persistent configuration

## Version Compatibility

### Supported Versions
| Ansible | Libvirt | Python |
|---------|---------|--------|
| 2.9+    | 6.0+    | 3.6+   |

### Deprecated Features
1. Legacy network configuration
2. Old storage formats
3. Outdated authentication methods

## Migration Guide

### From Previous Versions
1. Review breaking changes
2. Update configurations
3. Test new features
4. Update documentation

### To Newer Versions
1. Check release notes
2. Backup configurations
3. Test upgrade process
4. Verify functionality
