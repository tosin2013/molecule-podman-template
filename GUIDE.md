# Guide: Creating a New Ansible Role Using the Molecule-Podman-Template

This guide will walk you through the process of creating a new Ansible role using the molecule-podman-template.

## Prerequisites

- RHEL 9.5 system
- Python 3.8+
- Podman installed and configured for rootless mode
- SELinux in enforcing mode
- Basic understanding of Ansible roles

## Step 1: Create Your New Role

1. Navigate to your working directory and copy the template:
   ```bash
   cp -r molecule-podman-template my-new-role-name
   cd my-new-role-name
   ```

2. Clean up template artifacts:
   ```bash
   rm -f .git
   git init
   ```

## Step 2: Configure Your Role

1. Update `meta/main.yml` with your role's metadata:
   ```yaml
   galaxy_info:
     author: Your Name
     description: Description of your role
     company: Your Company (optional)
     license: license (GPL-2.0-or-later, MIT, etc)
     min_ansible_version: 2.9
     platforms:
       - name: EL
         versions:
           - 9
   ```

2. Define your role's default variables in `defaults/main.yml`:
   ```yaml
   ---
   # Add your role's default variables here
   ```

3. Add your role's tasks in `tasks/main.yml`:
   ```yaml
   ---
   # Add your role's tasks here
   ```

## Step 3: Configure Molecule Testing

1. The `molecule/default/molecule.yml` is pre-configured with:
   - Podman driver
   - RHEL 9.5 UBI container image
   - Proper container configuration for systemd

2. Customize `molecule/default/converge.yml` to apply your role:
   ```yaml
   ---
   - name: Converge
     hosts: all
     tasks:
       - name: Include your role
         include_role:
           name: your_role_name
   ```

3. Add tests in `molecule/default/verify.yml`:
   ```yaml
   ---
   - name: Verify
     hosts: all
     tasks:
       - name: Add your verification tasks here
         # Example:
         command: your-command
         register: result
         failed_when: result.rc != 0
   ```

## Step 4: Development Workflow

1. Create test instance:
   ```bash
   molecule create
   ```

2. Apply your role (you can run this repeatedly as you develop):
   ```bash
   molecule converge
   ```

3. Access the container for debugging:
   ```bash
   molecule login
   ```

4. Run verification tests:
   ```bash
   molecule verify
   ```

5. Run the complete test sequence:
   ```bash
   molecule test
   ```

6. Destroy test instance:
   ```bash
   molecule destroy
   ```

## Best Practices

1. **Incremental Development**:
   - Start with small, focused tasks
   - Test frequently using `molecule converge`
   - Add verification tests as you add features

2. **Testing**:
   - Test both success and failure scenarios
   - Verify idempotency (role can be run multiple times)
   - Test with SELinux enforcing

3. **Documentation**:
   - Document all variables in `defaults/main.yml`
   - Keep README.md updated with role usage
   - Include examples for common use cases

## Troubleshooting

1. If container fails to start:
   - Check SELinux context: `sudo setenforce 1`
   - Verify container_manage_cgroup: `sudo setsebool -P container_manage_cgroup 1`

2. If Podman permissions fail:
   - Verify user namespace mapping:
     ```bash
     grep $USER /etc/subuid
     grep $USER /etc/subgid
     ```
   - Check Podman rootless setup:
     ```bash
     ls -l /usr/bin/newuidmap /usr/bin/newgidmap
     ```

## Next Steps

1. Add your role to source control
2. Consider publishing to Ansible Galaxy
3. Set up CI/CD pipeline for automated testing
4. Create comprehensive documentation

Remember to always test your role thoroughly before deploying to production environments.
