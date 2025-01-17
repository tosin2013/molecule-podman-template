# Ansible Role: libvirt

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

An Ansible role to configure and manage libvirt virtualization environment on RHEL 9.5 systems. This role sets up libvirt, creates a CentOS 9 VM, and verifies SSH connectivity.

## Table of Contents
- [Requirements](#requirements)
- [Role Variables](#role-variables)
- [Dependencies](#dependencies)
- [Example Playbook](#example-playbook)
- [Testing](#testing)
  - [Manual Testing](#manual-testing)
  - [Automated Testing](#automated-testing)
- [License](#license)
- [Author Information](#author-information)

## Requirements

- RHEL 9.5 or compatible system
- Ansible 2.14 or higher
- Python 3.6 or higher
- Root privileges
- Required packages:
  - libvirt
  - libvirt-client
  - qemu-kvm
  - virt-manager
  - virt-install
  - python3-libvirt
  - genisoimage (for cloud-init ISO creation)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# User to add to libvirt group for management access
libvirt_user: ""

# VM Configuration
vm_name: "centos9-test"  # Name of the test VM
vm_memory: "2048"        # Memory in MB
vm_vcpus: "2"           # Number of vCPUs
```

## Dependencies

None

## Example Playbook

```yaml
- hosts: virtualization_servers
  become: yes
  roles:
    - role: tosin-akinosho.libvirt
      vars:
        libvirt_user: "admin"
```

## Testing

### Manual Testing

You can test the role manually using the included test playbook:

```bash
# Clone the repository
git clone https://github.com/tosin-akinosho/ansible-role-libvirt.git
cd ansible-role-libvirt

# Run the test playbook
ansible-playbook test.yml
```

The test playbook will:
1. Install and configure libvirt
2. Create a CentOS 9 VM using cloud-init
3. Configure SSH access
4. Create a test file in the VM
5. Verify connectivity

### Automated Testing with Molecule

This role includes comprehensive Molecule tests that verify:
1. Libvirt installation and configuration
2. Service status and socket permissions
3. VM creation and management
4. SSH connectivity
5. File operations within the VM

To run the molecule tests:

```bash
# Install molecule and dependencies
pip install molecule molecule-plugins[podman] ansible-core

# Run the full test suite (VM will be cleaned up after tests)
molecule test

# Run tests without cleaning up the VM for inspection
MOLECULE_CLEANUP_VM=false molecule test

# For development, you can run tests individually
molecule create    # Create test instance
molecule converge  # Run the role
molecule verify    # Run verify playbook
molecule destroy   # Clean up
```

The verify stage will:
1. Check libvirt service and package installation
2. Create a test VM using cloud-init
3. Verify SSH connectivity
4. Create and verify a test file in the VM's home directory
5. Clean up the test VM and associated resources (unless MOLECULE_CLEANUP_VM=false)

## License

MIT

## Author Information

This role was created by [Tosin Akinosho](https://github.com/tosin-akinosho).

## Contribution Guidelines

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

Please ensure your code follows the existing style and includes appropriate tests.
