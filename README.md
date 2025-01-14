# Ansible Role Template for RHEL 9.5 with Podman Testing

[![License](https://img.shields.io/badge/License-GPL-blue.svg)](LICENSE)

This template provides a foundation for creating Ansible roles specifically designed for Red Hat Enterprise Linux (RHEL) 9.5 environments. It includes the basic structure and testing capabilities using Molecule with Podman as the container engine.

## Table of Contents
- [Documentation](#documentation)
- [Architecture Overview](#architecture-overview)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Role Variables](#role-variables)
- [Dependencies](#dependencies)
- [Example Playbook](#example-playbook)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Author Information](#author-information)

## Documentation

Comprehensive documentation is available in the [docs](docs/) directory:

- [Overview](docs/overview.md) - Project architecture and design
- [Usage](docs/usage.md) - Installation and usage instructions
- [Testing](docs/testing.md) - Detailed testing procedures
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions
- [Contributing](docs/contributing.md) - Contribution guidelines
- [API Reference](docs/api.md) - Role parameters and interfaces
- [Changelog](docs/changelog.md) - Version history and release notes

## Architecture Overview

The template follows standard Ansible role structure with additional Molecule testing configuration:

```
molecule-podman-template/
├── defaults/          # Default variables
│   └── main.yml
├── tasks/             # Main role tasks
│   └── main.yml
├── meta/              # Role metadata
│   └── main.yml
├── molecule/          # Molecule testing configuration
│   └── default/
│       ├── molecule.yml  # Test environment config
│       ├── converge.yml  # Test playbook
│       ├── verify.yml    # Test cases
│       ├── prepare.yml   # Test environment setup
│       └── Dockerfile    # Test container image
└── tests/             # Integration tests
    └── test.yml
```

The testing infrastructure uses:
- Podman as the container engine
- UBI 9 (Universal Base Image) as the base container
- Molecule for test orchestration
- Ansible for role execution and verification

## Requirements

* Ansible 2.9 or higher
* Python 3.9 or higher
* Access to a RHEL 9.5 target system
* Molecule
* Podman (preferred container engine for RHEL)
* UBI 9 container images access

## Converting the Template

1. Create your new role from this template:
   ```bash
   cp -r molecule-podman-template your-role-name
   cd your-role-name
   ```

2. Update the role metadata in `meta/main.yml`:
   * Set the proper role name
   * Update platform information to include RHEL 9.5
   * Add relevant tags and dependencies

3. The molecule configuration in `molecule/default/molecule.yml` is already set up for RHEL 9.5 with Podman:
   * Uses `registry.access.redhat.com/ubi9/ubi-init:latest`
   * Configured with proper systemd support
   * Includes necessary volume mounts and capabilities

4. Implement your role logic:
   * Add tasks in `tasks/main.yml`
   * Define variables in `defaults/main.yml`
   * Create handlers in `handlers/main.yml` if needed
   * Add templates in `templates/` if needed

5. Update testing:
   * Modify `molecule/default/converge.yml` with your role
   * Add tests to `molecule/default/verify.yml`

## Role Variables

Define your variables in `defaults/main.yml`. Document each variable here:

### Common Variables

```yaml
# Target RHEL version
rhel_version: "9.5"

# System package configuration
system_packages:
  - vim-enhanced
  - git
  - curl

# Service configuration
services:
  - name: sshd
    state: started
    enabled: true

# Firewall configuration
firewall:
  ports:
    - 22
    - 80
    - 443
  services:
    - ssh
    - http
    - https

# User management
users:
  - name: admin
    groups: wheel
    ssh_key: "ssh-rsa AAAAB3NzaC1yc2E..."
```

### Variable Usage Examples

1. Override default packages:
```yaml
system_packages:
  - vim-enhanced
  - git
  - curl
  - htop
  - tmux
```

2. Configure additional services:
```yaml
services:
  - name: sshd
    state: started
    enabled: true
  - name: httpd
    state: started
    enabled: true
```

3. Add firewall rules:
```yaml
firewall:
  ports:
    - 22
    - 80
    - 443
    - 8080
  services:
    - ssh
    - http
    - https
    - cockpit
```

### Best Practices

- Use descriptive variable names
- Group related variables together
- Provide default values that work for most cases
- Document each variable with comments in defaults/main.yml
- Use YAML anchors and aliases for repeated structures

## Dependencies

List any role dependencies here. For example:

```yaml
dependencies: []
```

## Example Playbook

Here's how to use this role in your playbook:

```yaml
- hosts: rhel_servers
  become: true
  roles:
    - role: your-role-name
      vars:
        rhel_version: "9.5"
```

## Testing

This template uses Molecule with Podman for testing. The configuration is already set up for RHEL 9.5 compatibility. For detailed testing procedures and examples, see the [Testing Documentation](docs/testing.md).

### Key Testing Features
- Podman-based test environments
- UBI 9 container images
- Systemd support in containers
- Comprehensive test verification

### Quick Start
```bash
# Run complete test sequence
molecule test
```

For more commands and detailed testing workflow, refer to the [Testing Documentation](docs/testing.md).

## Troubleshooting

For common issues and solutions, refer to the [Troubleshooting Documentation](docs/troubleshooting.md). This includes:

- Podman installation and configuration
- UBI image access
- SELinux context issues
- Systemd in containers
- Network configuration
- Molecule debugging

### Quick Diagnostics
```bash
# Check container status
podman ps -a

# View container logs
podman logs <container>

# Inspect container configuration
podman inspect <container>
```

## Contributing

We welcome contributions! Please read our [Contribution Guidelines](docs/contributing.md) for details on how to:

- Submit issues
- Create pull requests
- Follow coding standards
- Write documentation

## License

GNU General Public License v3.0

## Author Information

Tosin Akinosho
