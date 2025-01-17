# Troubleshooting Guide

This document provides guidance for identifying and resolving common issues with the Ansible Libvirt Role and Molecule Podman Template.

## Environment Setup Issues

### Missing Dependencies

#### Problem
Required packages or Python modules are not installed.

#### Solution
1. Install required packages:
```bash
# For Red Hat-based systems
sudo dnf install -y libvirt qemu-kvm virt-install virt-viewer python3-libvirt

# For Debian-based systems
sudo apt-get install -y libvirt-daemon-system qemu-kvm virtinst virt-viewer python3-libvirt
```

2. Install Python dependencies:
```bash
python3 -m pip install ansible molecule molecule-plugins[podman] ansible-lint yamllint
```

### Permission Issues

#### Problem
Insufficient permissions to access libvirt resources or run containers.

#### Solution
1. Add user to required groups:
```bash
sudo usermod -aG libvirt,kvm $USER
```

2. Fix file permissions:
```bash
./fix_permissions.sh
```

3. Verify group membership:
```bash
groups
```

### Configuration Conflicts

#### Problem
Conflicting libvirt configurations or network settings.

#### Solution
1. Check existing configurations:
```bash
virsh net-list --all
virsh pool-list --all
```

2. Remove conflicting resources:
```bash
virsh net-destroy default
virsh net-undefine default
```

3. Validate environment:
```bash
./validate_environment.sh
```

## Ansible Role Issues

### Role Execution Failures

#### Problem
The Ansible role fails to execute properly.

#### Solution
1. Check role syntax:
```bash
ansible-playbook --syntax-check playbook.yml
```

2. Run role in verbose mode:
```bash
ansible-playbook -vvv playbook.yml
```

3. Verify role variables:
```yaml
# Example of correct variables
libvirt_pools:
  - name: default
    type: dir
    target: /var/lib/libvirt/images

libvirt_networks:
  - name: default
    bridge: virbr0
    ip: 192.168.122.1
```

### Network Configuration Issues

#### Problem
Virtual networks fail to start or have connectivity issues.

#### Solution
1. Check network status:
```bash
virsh net-list --all
```

2. Verify network configuration:
```bash
virsh net-dumpxml default
```

3. Debug network issues:
```bash
# Check network interfaces
ip addr show

# Check network bridges
brctl show

# Check firewall rules
sudo iptables -L -n -v
```

## Molecule Testing Issues

### Container Runtime Issues

#### Problem
Podman containers fail to start or run properly.

#### Solution
1. Check Podman status:
```bash
podman info
```

2. Verify container networking:
```bash
podman network ls
```

3. Clean up stale containers:
```bash
podman rm -f $(podman ps -aq)
```

### Test Failures

#### Problem
Molecule tests fail during execution.

#### Solution
1. Run tests with increased verbosity:
```bash
ANSIBLE_VERBOSITY=2 molecule test
```

2. Debug specific test phases:
```bash
molecule create
molecule converge
molecule login  # Inspect the container
```

3. Check test logs:
```bash
molecule --debug test
```

## Environment Validation

### Validation Scripts

1. `validate_environment.sh`:
   - Checks basic environment setup
   - Verifies required packages
   - Tests system configuration

2. `libvirt_validate_environment.sh`:
   - Validates libvirt installation
   - Checks service status
   - Tests network configuration

3. `setup_environment.sh`:
   - Sets up development environment
   - Configures required services
   - Installs dependencies

## Common Error Messages

### "Failed to connect to libvirt"
```
error: Failed to connect to the hypervisor
error: No valid connection
error: Failed to connect socket to '/var/run/libvirt/libvirt-sock': Permission denied
```

#### Solution
1. Check libvirtd service:
```bash
sudo systemctl status libvirtd
```

2. Verify socket permissions:
```bash
ls -l /var/run/libvirt/libvirt-sock
```

3. Add user to libvirt group:
```bash
sudo usermod -aG libvirt $USER
newgrp libvirt
```

### "Could not find a required package"
```
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Could not find required package"}
```

#### Solution
1. Update package cache:
```bash
# For Red Hat-based systems
sudo dnf clean all && sudo dnf makecache

# For Debian-based systems
sudo apt-get update
```

2. Install missing package:
```bash
# Example for libvirt package
sudo dnf install -y libvirt
```

## Best Practices

### Debugging Tips

1. Use verbose mode:
   - Ansible: `-vvv`
   - Molecule: `--debug`
   - Podman: `--log-level=debug`

2. Check logs:
   - System logs: `/var/log/messages` or `/var/log/syslog`
   - Libvirt logs: `/var/log/libvirt/`
   - Ansible logs: Set `log_path` in ansible.cfg

3. Validate configurations:
   - Use provided validation scripts
   - Check syntax before running
   - Test in isolation

### Prevention

1. Regular maintenance:
   - Keep packages updated
   - Monitor system resources
   - Review logs periodically

2. Testing:
   - Run tests before changes
   - Use staging environments
   - Validate configurations

3. Documentation:
   - Keep notes of changes
   - Document custom configurations
   - Update troubleshooting guides

## Getting Help

If you encounter issues not covered in this guide:

1. Check the [GitHub Issues](https://github.com/your-org/ansible-role-libvirt/issues)
2. Review the [Documentation](docs/)
3. Join the community discussion
4. Submit a new issue with:
   - Detailed description
   - Error messages
   - System information
   - Steps to reproduce
