# Ansible Role: libvirt

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

An Ansible role to configure and manage libvirt virtualization environment on RHEL 9.5 systems.

## Table of Contents
- [Requirements](#requirements)
- [Role Variables](#role-variables)
- [Dependencies](#dependencies)
- [Example Playbook](#example-playbook)
- [License](#license)
- [Author Information](#author-information)

## Requirements

- RHEL 9.5 or compatible system
- Ansible 2.9 or higher
- Python 3.6 or higher
- Root privileges

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# User to add to libvirt group for management access
libvirt_user: ""
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

## License

MIT

## Author Information

This role was created by [Tosin Akinosho](https://github.com/tosin-akinosho).

## Testing

This role includes Molecule tests for verification. To run tests:

```bash
molecule test
```

## Contribution Guidelines

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

Please ensure your code follows the existing style and includes appropriate tests.
