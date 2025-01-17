# Testing Guide

This document provides comprehensive guidance on testing the Ansible Libvirt Role using Molecule and Podman.

## Overview

Testing is performed using Molecule, a testing framework for Ansible roles, with Podman as the container runtime. The testing framework is configured to validate both the Ansible role functionality and the infrastructure it creates.

## Prerequisites

### Required Software
- Molecule
- Podman
- Python 3.6+
- Ansible 2.9+

### Installation

1. Install Podman:
```bash
# For Red Hat-based systems
sudo dnf install -y podman

# For Debian-based systems
sudo apt-get install -y podman
```

2. Install Molecule and dependencies:
```bash
python3 -m pip install molecule molecule-plugins[podman] ansible-lint yamllint
```

## Test Structure

The test suite is organized into several key components:

### Molecule Configuration (`molecule.yml`)
```yaml
# molecule/default/molecule.yml
---
dependency:
  name: galaxy
driver:
  name: podman
platforms:
  - name: instance
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
```

### Test Scenarios

1. **Prepare Playbook** (`prepare.yml`):
   - Sets up the test environment
   - Installs prerequisites
   - Configures system settings

2. **Converge Playbook** (`converge.yml`):
   - Applies the role configuration
   - Sets up libvirt environment
   - Configures networks and storage

3. **Verify Playbook** (`verify.yml`):
   - Validates role functionality
   - Checks service status
   - Verifies configurations

## Running Tests

### Full Test Suite
```bash
molecule test
```
This runs the complete test sequence:
1. Destroy any existing instances
2. Create test instances
3. Prepare the environment
4. Converge the role
5. Verify the results
6. Destroy test instances

### Individual Test Phases

#### Create Test Environment
```bash
molecule create
```

#### Prepare Environment
```bash
molecule prepare
```

#### Apply Role
```bash
molecule converge
```

#### Run Verification
```bash
molecule verify
```

#### Clean Up
```bash
molecule destroy
```

### Running Specific Scenarios
```bash
molecule test -s <scenario_name>
```

## Writing Tests

### Verify Tests

Add test cases to `verify.yml`:

```yaml
---
- name: Verify
  hosts: all
  gather_facts: false
  tasks:
    - name: Check if libvirtd service is running
      ansible.builtin.service_facts:

    - name: Assert libvirtd is running
      ansible.builtin.assert:
        that:
          - ansible_facts.services['libvirtd.service'].state == 'running'
        fail_msg: "libvirtd service is not running"
        success_msg: "libvirtd service is running"

    - name: Check if storage pool exists
      command: virsh pool-list --all
      register: pool_list
      changed_when: false

    - name: Assert default storage pool exists
      ansible.builtin.assert:
        that:
          - '"default" in pool_list.stdout'
        fail_msg: "Default storage pool not found"
        success_msg: "Default storage pool exists"
```

### Test Best Practices

1. **Idempotency Tests**
   - Run converge twice to ensure no changes on second run
   - Check for consistent results

2. **Failure Testing**
   - Test error conditions
   - Verify proper error handling
   - Check recovery procedures

3. **Resource Cleanup**
   - Ensure all resources are properly removed
   - Check for leftover artifacts

4. **Configuration Validation**
   - Verify all settings are applied
   - Check for correct file permissions
   - Validate service configurations

## Continuous Integration

### GitHub Actions Example

```yaml
name: Molecule Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.x'
      - name: Install dependencies
        run: |
          python -m pip install molecule molecule-plugins[podman] ansible-lint yamllint
      - name: Run Molecule tests
        run: molecule test
```

## Troubleshooting

### Common Issues

1. **Container Runtime Issues**
   - Ensure Podman is installed and running
   - Check container permissions
   - Verify network connectivity

2. **Molecule Configuration**
   - Validate molecule.yml syntax
   - Check platform configurations
   - Verify driver settings

3. **Test Failures**
   - Check test instance logs
   - Verify role variables
   - Validate dependencies

### Debugging Tips

1. **Interactive Debugging**
```bash
molecule create
molecule converge
molecule login
```

2. **Increase Verbosity**
```bash
molecule --debug test
ANSIBLE_VERBOSITY=2 molecule test
```

3. **Keep Instances Running**
```bash
molecule test --destroy never
```

## Test Coverage

### Areas to Test

1. **Installation**
   - Package installation
   - Service configuration
   - File permissions

2. **Configuration**
   - Network setup
   - Storage configuration
   - Security settings

3. **Operations**
   - Service management
   - Resource creation
   - Error handling

4. **Integration**
   - Network connectivity
   - Storage access
   - User permissions

## Reporting

### Test Reports

Generate test reports using Ansible callback plugins:

```yaml
# ansible.cfg
[defaults]
callback_plugins = junit
callback_whitelist = junit

[junit_xml]
output_dir = ./test-reports
```

### Code Quality

1. **Linting**
```bash
molecule lint
ansible-lint
yamllint .
```

2. **Syntax Check**
```bash
ansible-playbook --syntax-check playbook.yml
```

## Resources

- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Podman Documentation](https://podman.io/docs/)
- [Ansible Testing Strategies](https://docs.ansible.com/ansible/latest/reference_appendices/test_strategies.html)
