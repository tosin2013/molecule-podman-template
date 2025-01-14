# API Documentation

## Role Interface

### Input Variables

#### Required Variables
```yaml
# Example required variables
required_variable: value
```

#### Optional Variables
```yaml
# Example optional variables with defaults
optional_variable: default_value
```

### Output Variables

#### Registered Variables
```yaml
# Example registered variables
result_variable: value
```

#### Facts
```yaml
# Example facts
ansible_facts:
  custom_fact: value
```

### Task Documentation

#### Main Tasks
```yaml
- name: Example task
  ansible.builtin.command:
    cmd: echo "Hello World"
  register: result
```

#### Handler Tasks
```yaml
- name: Restart service
  ansible.builtin.service:
    name: example
    state: restarted
```

### Role Dependencies

#### Required Roles
```yaml
dependencies:
  - role: common
```

#### Optional Roles
```yaml
dependencies:
  - role: optional
    when: use_optional_feature
```

## Role Parameters

### Configuration Options

#### Example Section
```yaml
example_section:
  option1: value1
  option2: value2
```

### Variable Precedence
1. Role defaults
2. Inventory variables
3. Playbook variables
4. Extra vars

## Role Outputs

### Return Values

#### Success
```yaml
changed: true
failed: false
msg: "Operation completed successfully"
```

#### Failure
```yaml
changed: false
failed: true
msg: "Operation failed"
```

### Debug Output

#### Verbose Output
```bash
ansible-playbook playbook.yml -vvv
```

#### Debug Module
```yaml
- name: Debug output
  ansible.builtin.debug:
    msg: "{{ result_variable }}"
```

## Role Examples

### Basic Usage
```yaml
- hosts: all
  roles:
    - role: molecule-podman-template
      vars:
        required_variable: value
```

### Advanced Usage
```yaml
- hosts: all
  roles:
    - role: molecule-podman-template
      vars:
        required_variable: value
        optional_variable: custom_value
```

## Role Testing

### Molecule Tests
```yaml
- name: Verify role execution
  hosts: all
  tasks:
    - name: Check result
      ansible.builtin.assert:
        that:
          - result_variable == expected_value
```

### Integration Tests
```yaml
- name: Verify integration
  hosts: all
  tasks:
    - name: Check service status
      ansible.builtin.service:
        name: example
        state: started
```

## Role Metadata

### Meta Information
```yaml
galaxy_info:
  author: your_name
  description: Molecule Podman Template Role
  license: MIT
  min_ansible_version: 2.9
  platforms:
    - name: EL
      versions:
        - 7
        - 8
        - 9
```

### Dependencies
```yaml
dependencies:
  - name: community.general
    version: ">=1.0.0"
```

## Role Versioning

### Version History
```markdown
- 1.0.0: Initial release
- 1.1.0: Added new feature
```

### Compatibility
```markdown
- Ansible: 2.9+
- Python: 3.8+
- Podman: 3.0+
```

## Role Security

### Security Considerations
```markdown
- Use secure defaults
- Validate input variables
- Follow least privilege principle
```

### Security Best Practices
```markdown
- Use vault for sensitive data
- Validate input parameters
- Follow secure coding guidelines
