# Ansible Role Template Overview

## Architecture

This template provides a foundation for creating Ansible roles specifically designed for Red Hat Enterprise Linux (RHEL) 9.5 environments. It includes the basic structure and testing capabilities using Molecule with Podman as the container engine.

### Directory Structure

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
