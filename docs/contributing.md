# Contributing Guide

## Getting Started

### Prerequisites
- Ansible 2.9+
- Molecule 3.0+
- Podman 3.0+
- Python 3.8+

### Development Environment Setup

1. Clone the repository:
```bash
git clone https://github.com/your-org/molecule-podman-template.git
cd molecule-podman-template
```

2. Install dependencies:
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

3. Verify setup:
```bash
molecule test
```

## Contribution Workflow

### 1. Create a Feature Branch
```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes
- Follow coding standards
- Write tests for new functionality
- Update documentation

### 3. Run Tests
```bash
molecule test
```

### 4. Commit Changes
```bash
git add .
git commit -m "Description of changes"
```

### 5. Push Changes
```bash
git push origin feature/your-feature-name
```

### 6. Create Pull Request
- Open a PR against the main branch
- Include detailed description of changes
- Reference any related issues

## Coding Standards

### Ansible Best Practices
- Use FQCN (Fully Qualified Collection Names)
- Maintain idempotency
- Use handlers appropriately
- Follow variable naming conventions
- Use tags judiciously

### YAML Formatting
- 2 space indentation
- Consistent quoting style
- Alphabetical ordering of keys
- Proper spacing between sections

### Documentation
- Include inline comments for complex logic
- Update README.md for significant changes
- Add new documentation files as needed

## Testing Guidelines

### Molecule Tests
- Cover all role scenarios
- Test idempotency
- Include negative tests
- Verify edge cases

### Test Structure
```yaml
- name: Verify feature
  hosts: all
  tasks:
    - name: Check configuration
      ansible.builtin.shell: command
      register: result
      changed_when: false

    - name: Assert expected result
      ansible.builtin.assert:
        that:
          - "'expected' in result.stdout"
```

### Linting
Run ansible-lint before committing:
```bash
ansible-lint
```

## Code Review Process

### Review Checklist
- [ ] Code follows style guidelines
- [ ] Tests are comprehensive
- [ ] Documentation is updated
- [ ] Changes are backwards compatible
- [ ] Security considerations addressed

### Review Expectations
- Be respectful and constructive
- Provide clear feedback
- Suggest improvements
- Acknowledge good practices

## Issue Reporting

### Creating Issues
- Use provided templates
- Include reproduction steps
- Specify environment details
- Attach relevant logs

### Issue Labels
- bug: Unexpected behavior
- enhancement: Feature request
- documentation: Documentation improvements
- question: General inquiries
- help wanted: Requests for assistance

## Release Process

### Versioning
- Follow semantic versioning (MAJOR.MINOR.PATCH)
- Update CHANGELOG.md
- Tag releases appropriately

### Release Checklist
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Version bumped
- [ ] Changelog updated
- [ ] Release notes prepared

## Communication

### Code of Conduct
- Be respectful and inclusive
- Maintain professional tone
- Focus on technical merit
- Welcome diverse perspectives

### Getting Help
- Check documentation first
- Search existing issues
- Ask in community channels
- Be specific in questions
