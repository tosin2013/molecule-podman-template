# Testing with Molecule

## Test Environment Setup

The template includes a pre-configured Molecule environment using Podman as the container engine. The test environment is configured in `molecule/default/molecule.yml`.

### Key Configuration

```yaml
dependency:
  name: galaxy
driver:
  name: podman
platforms:
  - name: rhel9
    image: registry.access.redhat.com/ubi9/ubi-init:latest
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    capabilities:
      - SYS_ADMIN
    command: /usr/sbin/init
provisioner:
  name: ansible
  inventory:
    group_vars:
      all:
        ansible_python_interpreter: /usr/bin/python3
verifier:
  name: ansible
```

### Test Container Features

- Systemd support enabled
- Proper SELinux configuration
- Network access to Red Hat repositories
- Python 3.9+ installed
- Ansible pre-installed

## Running Tests

### Basic Commands

1. **Create Test Environment**
```bash
molecule create
```

2. **Run Playbook**
```bash
molecule converge
```

3. **Verify Tests**
```bash
molecule verify
```

4. **Destroy Environment**
```bash
molecule destroy
```

5. **Full Test Cycle**
```bash
molecule test
```

### Test Development Workflow

1. Start test environment:
```bash
molecule create
```

2. Login to container:
```bash
molecule login
```

3. Make changes to role and test:
```bash
molecule converge
```

4. Verify changes:
```bash
molecule verify
```

5. When finished:
```bash
molecule destroy
```

## Writing Tests

Tests are defined in `molecule/default/verify.yml`. Example test structure:

```yaml
- name: Verify system configuration
  hosts: all
  tasks:
    - name: Check RHEL version
      ansible.builtin.shell: cat /etc/redhat-release
      register: rhel_version
      changed_when: false

    - name: Assert RHEL version
      ansible.builtin.assert:
        that:
          - "'9.5' in rhel_version.stdout"

    - name: Check installed packages
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      loop: "{{ system_packages }}"
      changed_when: false

    - name: Verify services
      ansible.builtin.service:
        name: "{{ item.name }}"
        state: started
        enabled: true
      loop: "{{ services }}"
      changed_when: false
```

### Test Best Practices

- Test both success and failure cases
- Verify idempotency (run converge twice)
- Check for proper error handling
- Test edge cases and boundary conditions
- Verify role variables work as expected
- Test role integration with other roles

## Debugging Tests

### Common Issues

1. **Systemd not working**
   - Ensure container is running with proper privileges
   - Verify /sys/fs/cgroup is mounted
   - Check SELinux configuration

2. **Package installation failures**
   - Verify network access
   - Check repository configuration
   - Ensure proper subscription management

3. **Ansible module failures**
   - Verify Python interpreter path
   - Check required dependencies
   - Test with verbose output (-vvv)

### Debugging Commands

1. View container logs:
```bash
podman logs <container_name>
```

2. Inspect container configuration:
```bash
podman inspect <container_name>
```

3. Run ad-hoc commands:
```bash
molecule login --exec "journalctl -xe"
```

4. Increase verbosity:
```bash
molecule --debug converge
```

## Continuous Integration

Example GitHub Actions configuration:

```yaml
name: Molecule Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.9'
          
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install molecule molecule-podman ansible
          
      - name: Run Molecule tests
        run: molecule test
```

### CI Best Practices

- Run tests on multiple Python versions
- Test against different RHEL versions
- Include linting and syntax checking
- Cache dependencies between runs
- Fail fast on critical errors
- Generate test reports
