# Ansible Role: libvirt

This Ansible role installs and configures libvirt on RHEL 9.5 systems, providing access to virtualization capabilities.

## Requirements

* RHEL 9.5 or compatible distribution
* Ansible 2.9 or higher
* Python 3.9 or higher
* Sufficient privileges to manage system services and install packages

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# User to be added to libvirt group (optional)
# libvirt_user: "username"

# Default libvirt URI
libvirt_uri: "qemu:///system"

# Default network settings
libvirt_network:
  name: "default"
  autostart: true

# Default pool settings
libvirt_pool:
  name: "default"
  path: "/var/lib/libvirt/images"
  autostart: true
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: virtualization_hosts
  become: true
  vars:
    libvirt_user: "myuser"
  roles:
    - ansible-role-libvirt
```

## Role Actions

This role will:

1. Install required libvirt packages
2. Configure and start the libvirtd service
3. Set up proper permissions for libvirt access
4. Add specified user to the libvirt group (if libvirt_user is defined)
5. Configure libvirt socket permissions

## Testing

This role includes Molecule tests using Podman as the driver. To run the tests:

```bash
molecule test
```

The tests will verify:
- Package installation
- Service status
- Socket permissions
- Basic virsh functionality

## License

MIT

## Author Information

Your Name
Your Contact Information
