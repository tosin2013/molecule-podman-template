# Role Usage Guide

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

## Example Playbook

### Basic Usage

```yaml
- hosts: rhel_servers
  become: true
  roles:
    - role: your-role-name
      vars:
        rhel_version: "9.5"
```

### Advanced Configuration

1. **Custom Package Installation**
```yaml
- hosts: rhel_servers
  become: true
  roles:
    - role: your-role-name
      vars:
        system_packages:
          - vim-enhanced
          - git
          - curl
          - htop
          - tmux
```

2. **Service Management**
```yaml
- hosts: rhel_servers
  become: true
  roles:
    - role: your-role-name
      vars:
        services:
          - name: sshd
            state: started
            enabled: true
          - name: httpd
            state: started
            enabled: true
```

3. **Firewall Configuration**
```yaml
- hosts: rhel_servers
  become: true
  roles:
    - role: your-role-name
      vars:
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

4. **User Management**
```yaml
- hosts: rhel_servers
  become: true
  roles:
    - role: your-role-name
      vars:
        users:
          - name: admin
            groups: wheel
            ssh_key: "ssh-rsa AAAAB3NzaC1yc2E..."
          - name: deploy
            groups: users
            ssh_key: "ssh-rsa AAAAB3NzaC1yc2E..."
```

### Integration with Other Roles

```yaml
- hosts: rhel_servers
  become: true
  roles:
    - role: your-role-name
      vars:
        rhel_version: "9.5"
    - role: timezone
      vars:
        timezone: "America/New_York"
    - role: ntp
      vars:
        ntp_servers:
          - 0.pool.ntp.org
          - 1.pool.ntp.org
```

### Conditional Execution

```yaml
- hosts: rhel_servers
  become: true
  tasks:
    - name: Include role conditionally
      include_role:
        name: your-role-name
      when: ansible_os_family == "RedHat" and ansible_distribution_major_version == "9"
      vars:
        rhel_version: "9.5"
```

### Tagged Execution

```yaml
- hosts: rhel_servers
  become: true
  roles:
    - role: your-role-name
      tags:
        - base
        - security
      vars:
        rhel_version: "9.5"
