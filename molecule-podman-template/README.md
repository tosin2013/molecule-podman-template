# Ansible Role Template for RHEL 9.5 with Podman Testing

This template provides a foundation for creating Ansible roles specifically designed for Red Hat Enterprise Linux (RHEL) 9.5 environments. It includes the basic structure and testing capabilities using Molecule with Podman as the container engine.

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

```yaml
# Example variable
rhel_version: "9.5"
```

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

This template uses Molecule with Podman for testing. The configuration is already set up for RHEL 9.5 compatibility.

To test the role:

```bash
# Create the test container
molecule create

# Run the role
molecule converge

# Run the tests
molecule verify

# Clean up
molecule destroy

# Run the complete test sequence
molecule test
```

## Troubleshooting

1. Ensure Podman is installed and running:
   ```bash
   podman info
   ```

2. Verify access to UBI images:
   ```bash
   podman pull registry.access.redhat.com/ubi9/ubi-init:latest
   ```

3. Check SELinux contexts if running on RHEL:
   ```bash
   sudo setenforce Permissive # if needed for testing
   ```

## License

MIT

## Author Information

Your Name
Your Contact Information
