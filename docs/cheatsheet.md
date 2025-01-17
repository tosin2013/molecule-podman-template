# Libvirt Role Cheatsheet

## Quick Commands

### VM Management

```bash
# List all VMs
virsh list --all

# Stop a VM
virsh shutdown <vm-name>

# Force stop a VM (like unplugging power)
virsh destroy <vm-name>

# Delete a VM and its storage
virsh undefine <vm-name> --remove-all-storage

# Start a VM
virsh start <vm-name>

# Get VM info
virsh dominfo <vm-name>

# View VM console
virsh console <vm-name>
```

### Storage Management

```bash
# List storage pools
virsh pool-list --all

# Delete a storage pool
virsh pool-destroy <pool-name>
virsh pool-undefine <pool-name>

# List volumes in a pool
virsh vol-list <pool-name>

# Delete a volume
virsh vol-delete <volume-name> --pool <pool-name>
```

### Network Management

```bash
# List networks
virsh net-list --all

# Stop a network
virsh net-destroy <network-name>

# Delete a network
virsh net-undefine <network-name>

# Start a network
virsh net-start <network-name>
```

## Molecule Testing

### Basic Commands
```bash
# Run full test suite
molecule test

# Run without destroying environment
molecule test --destroy never

# Only run specific stages
molecule create
molecule converge
molecule verify

# Destroy test environment
molecule destroy

# Login to test container
molecule login
```

### Using the Molecule Podman Template
```bash
# Create a new role using the template
molecule init role new-role --template molecule-podman-template

# Run tests with the template
cd new-role
molecule test

# Run specific test scenarios
molecule test -s default
molecule test -s custom_scenario

# Debug template issues
molecule --debug test
ANSIBLE_VERBOSITY=2 molecule test
```

### Podman Container Management
```bash
# List running containers
podman ps

# List all containers (including stopped)
podman ps -a

# Remove all containers
podman rm -f $(podman ps -aq)

# View container logs
podman logs <container-id>

# Inspect container details
podman inspect <container-id>

# Execute command in container
podman exec <container-id> <command>

# View container resource usage
podman stats <container-id>
```

## Troubleshooting Steps

### When VMs Won't Delete

1. Force stop the VM:
```bash
virsh destroy <vm-name>
```

2. Remove VM definition and storage:
```bash
virsh undefine <vm-name> --remove-all-storage
```

3. Manually check and remove storage:
```bash
ls -l /var/lib/libvirt/images/
rm -f /var/lib/libvirt/images/<vm-name>.qcow2
```

### When Networks Are Stuck

1. Stop all VMs using the network:
```bash
for vm in $(virsh list --name); do
  virsh shutdown $vm
done
```

2. Force destroy network:
```bash
virsh net-destroy <network-name>
```

3. Clean up network interfaces:
```bash
ip link delete <interface-name>
```

### When Storage Won't Delete

1. Stop VMs using the storage:
```bash
virsh list --all
virsh shutdown <vm-name>
```

2. Force cleanup storage:
```bash
virsh pool-destroy <pool-name>
virsh pool-undefine <pool-name>
rm -rf /var/lib/libvirt/images/<pool-name>
```

### SELinux Issues

```bash
# Check SELinux status
getenforce

# View SELinux denials
ausearch -m AVC -ts recent

# Set correct context
restorecon -Rv /var/lib/libvirt/images/
```

### Permission Issues

```bash
# Fix ownership
chown -R root:root /var/lib/libvirt/images/

# Fix permissions
chmod 600 /var/lib/libvirt/images/*.qcow2
```

## Common Issues and Solutions

### VM Creation Fails

1. Check libvirt service:
```bash
systemctl status libvirtd
```

2. Verify storage pool:
```bash
virsh pool-list --all
virsh pool-info default
```

3. Check available space:
```bash
df -h /var/lib/libvirt/images/
```

### Network Issues

1. Verify bridge interface:
```bash
ip a show virbr0
```

2. Check network definition:
```bash
virsh net-dumpxml default
```

3. Restart network:
```bash
virsh net-destroy default
virsh net-start default
```

### Storage Pool Issues

1. Check pool status:
```bash
virsh pool-info default
```

2. Refresh pool:
```bash
virsh pool-refresh default
```

3. Recreate pool:
```bash
virsh pool-destroy default
virsh pool-create-as default dir --target /var/lib/libvirt/images
```

## Development Tips

### Quick Testing Cycle
```bash
# Create and converge without running full test
molecule create
molecule converge

# Make changes to role
vim tasks/main.yml

# Test changes
molecule converge

# Run verify step
molecule verify

# Clean up when done
molecule destroy
```

### Debugging Tips
```bash
# Run molecule with debug logging
molecule --debug test

# View container logs
podman logs <container-id>

# Run specific tests
molecule verify -- -k "test_name"

# Keep containers for debugging
molecule test --destroy never
```

### Template Development
```bash
# Validate template syntax
molecule lint

# Test template with different scenarios
molecule test -s default
molecule test -s custom_scenario

# Debug template issues
MOLECULE_DEBUG=1 molecule test
ANSIBLE_VERBOSITY=2 molecule test

# Validate template files
yamllint molecule/default/*.yml
ansible-lint molecule/default/*.yml
```

### Container Troubleshooting
```bash
# Check container health
podman healthcheck run <container-id>

# View container processes
podman top <container-id>

# Monitor container events
podman events

# Check container network
podman network inspect <network-name>

# View container mounts
podman mount <container-id>
```
