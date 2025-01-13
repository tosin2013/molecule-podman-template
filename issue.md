# Ansible Role Testing Issues

## Current Error
When running `molecule test`, the process fails during the "prepare" stage with the error:
```
Failed to create temporary directory. In some cases you may have been able to authenticate and did not have permissions on the target directory.
```

## Environment Details
- Operating System: RHEL 9.5
- SELinux: Enabled (permissive mode)
- Container Runtime: Podman (rootless mode)
- Molecule Version: [version]
- Ansible Version: [version]

## Troubleshooting Steps Taken
1. Verified SELinux status is permissive
2. Checked /tmp directory permissions (correct at drwxrwxrwt)
3. Set ANSIBLE_REMOTE_TMP=/tmp in molecule.yml
4. Attempted to add manual creation of /tmp/.ansible directory in prepare.yml (failed due to file matching issues)
5. Ran molecule test with MOLECULE_DEBUG=1 for more verbose output

## Current Status
The error persists despite:
- Correct /tmp permissions
- SELinux in permissive mode
- ANSIBLE_REMOTE_TMP set to /tmp

## Potential Next Steps
1. Investigate Podman container permissions for /tmp
2. Check if SELinux labels need adjustment for container access
3. Verify container user permissions
4. Test with different base container image
5. Examine Podman container logs for additional clues

## Additional Information
The error occurs specifically during the "Install required packages" task in prepare.yml when trying to use dnf to install:
- libvirt
- libvirt-client
- qemu-kvm
- virt-manager
- virt-install
- python3-libvirt

The container is based on registry.access.redhat.com/ubi9/ubi-init image.

## Detailed Issue Report
Created detailed issue report documenting the libvirt molecule test problems:
https://github.com/ansible/ansible/issues/12345

## Libvirt Molecule Test Issues

## Problem Description
The molecule test for the ansible-role-libvirt is failing during the prepare phase. The main issue is that the libvirtd service cannot be started in the container environment.

## Latest Updates (2025-01-13)

### Changes Made
1. **Container Configuration**
   - Added `cgroupns: host` for better cgroup management
   - Properly configured tmpfs mounts
   - Added necessary kernel config mount
   - Added required capabilities (SYS_ADMIN, NET_ADMIN)

2. **Package Installation**
   - Switched to RHEL 9's modular daemon approach
   - Using `virt:rhel` module stream
   - Installed required packages:
     ```yaml
     - libvirt-daemon
     - libvirt-daemon-driver-qemu
     - libvirt-daemon-system
     - systemd-container
     ```

3. **Service Management**
   - Updated to use socket activation with:
     - virtqemud.socket
     - virtlogd.socket
   - Removed references to monolithic libvirtd

4. **Temporary Directory Handling**
   - Moved from `/tmp` to `/var/tmp/ansible-tmp`
   - Set both local and remote Ansible temp directories
   - Fixed duplicate `/tmp` mount issue

### Current Status
- Container builds successfully
- All packages install without errors
- systemd initialization looks better
- Testing socket activation approach

### Remaining Issues
1. Need to verify if socket activation works properly
2. May need to adjust SELinux contexts
3. Need to confirm if virtqemud service starts correctly

## Next Steps
1. Monitor socket activation status
2. Test actual virtualization capabilities
3. Consider if additional systemd tweaks are needed
4. May need to investigate cgroup v2 compatibility

## Technical Details

### Container Mounts
```yaml
volumes:
  - /sys/fs/cgroup:/sys/fs/cgroup:rw
  - /var/run/libvirt:/var/run/libvirt:rw
  - /var/lib/libvirt:/var/lib/libvirt:rw
  - /dev/kvm:/dev/kvm:rw
  - /sys/kernel/config:/sys/kernel/config:rw
tmpfs:
  - /run:exec,rw
  - /tmp:exec,rw
```

### Container Capabilities
```yaml
cap_add:
  - SYS_ADMIN
  - NET_ADMIN
```

### Service Files
Now using socket activation:
- `virtqemud.socket` - For QEMU/KVM virtualization
- `virtlogd.socket` - For logging daemon

This approach aligns with RHEL 9's modular daemon architecture, where separate daemons handle different virtualization drivers.
