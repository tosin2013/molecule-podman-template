# Ansible Role Testing Environment Setup Notes

## Environment Requirements
- User: lab-user (non-root)
- OS: RHEL 9.5
- SELinux: Enforcing mode
- Container Runtime: Podman (rootless)
- Python: 3.8+
- Testing Framework: Molecule with Podman driver

## Current Status

### Working Components
1. User Context
   - Running as lab-user (non-root)
2. Operating System
   - RHEL 9.5 confirmed
3. SELinux Status
   - Running in enforcing mode
4. Python Environment
   - Python 3.9.19 installed
   - Molecule and dependencies installed via pip
5. Podman Configuration
   - Rootless mode working
   - Container test successful
   - Proper UID/GID mapping configured

### Next Steps
1. Initialize Test Role
   ```bash
   # Create a new role with Molecule
   molecule init role my-test-role --driver-name=podman
   cd my-test-role
   
   # Verify Molecule configuration
   cat molecule/default/molecule.yml
   ```

2. Configure Molecule for RHEL 9.5
   ```yaml
   # molecule/default/molecule.yml
   ---
   dependency:
     name: galaxy
   driver:
     name: podman
   platforms:
     - name: rhel95
       image: registry.access.redhat.com/ubi9/ubi-init:latest
       tmpfs:
         - /run
         - /tmp
       volumes:
         - /sys/fs/cgroup:/sys/fs/cgroup:ro
       capabilities:
         - SYS_ADMIN
       command: "/usr/sbin/init"
       pre_build_image: true
   provisioner:
     name: ansible
   verifier:
     name: ansible
   ```

3. Create Basic Role Tasks
   ```yaml
   # tasks/main.yml
   ---
   - name: Ensure required packages are installed
     ansible.builtin.package:
       name: "{{ item }}"
       state: present
     loop:
       - httpd
       - firewalld
   
   - name: Ensure services are running
     ansible.builtin.service:
       name: "{{ item }}"
       state: started
       enabled: yes
     loop:
       - httpd
       - firewalld
   ```

4. Add Verification Tests
   ```yaml
   # molecule/default/verify.yml
   ---
   - name: Verify
     hosts: all
     gather_facts: false
     tasks:
       - name: Check if httpd is installed
         ansible.builtin.package:
           name: httpd
           state: present
         check_mode: true
         register: pkg_check
         failed_when: pkg_check.changed
   
       - name: Check if services are running
         ansible.builtin.service:
           name: "{{ item }}"
           state: started
         check_mode: true
         register: svc_check
         failed_when: svc_check.changed
         loop:
           - httpd
           - firewalld
   ```

## System Configuration Reference

### Current Permissions
```bash
# Verified working configuration
$ ls -l /usr/bin/newuidmap /usr/bin/newgidmap
-rwsr-sr-x. 1 root root 43144 Jul  3  2024 /usr/bin/newgidmap
-rwsr-xr-x. 1 root root 39024 Jul  3  2024 /usr/bin/newuidmap
```

### User Namespace Mapping
```bash
# /etc/subuid and /etc/subgid configuration
lab-user:100000:65536
```

## Testing Workflow
1. Create new role:
   ```bash
   molecule init role my-test-role --driver-name=podman
   ```

2. Run full test sequence:
   ```bash
   molecule create    # Create test container
   molecule converge  # Run playbook
   molecule verify    # Run tests
   molecule test      # Full test sequence
   ```

3. Development cycle:
   ```bash
   molecule destroy   # Clean up
   molecule converge  # Apply changes
   molecule verify    # Run tests
   ```

## References
- [Podman Rootless Setup Guide](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md)
- [Molecule Documentation](https://molecule.readthedocs.io/)
- [RHEL 9 Container Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/building_running_and_managing_containers/index)