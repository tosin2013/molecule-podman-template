# Contributing Guide

Thank you for your interest in contributing to our project! This document provides guidelines and processes for contributing to both the Ansible Libvirt Role and the Molecule Podman Template.

## Table of Contents
1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Workflow](#development-workflow)
4. [Code Style and Standards](#code-style-and-standards)
5. [Pull Request Process](#pull-request-process)
6. [Testing Requirements](#testing-requirements)
7. [Documentation Standards](#documentation-standards)
8. [Code Review Process](#code-review-process)

## Code of Conduct
Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting Started
1. Fork the repository
2. Clone your fork locally
3. Set up development environment:
   ```bash
   # Install dependencies
   python3 -m pip install ansible molecule molecule-plugins[podman] ansible-lint yamllint

   # Set up environment
   ./setup_environment.sh
   ```
4. Create a new branch for your changes

## Development Workflow
1. Create a feature branch from `main`
2. Make your changes
3. Write tests using Molecule
4. Update documentation
5. Commit your changes
6. Push your branch to your fork
7. Create a pull request

## Code Style and Standards

### General Guidelines
1. Follow PEP 8 for Python code
2. Use consistent indentation (4 spaces)
3. Use descriptive variable names
4. Keep functions small and focused
5. Write clear and concise comments

### Ansible Specific Guidelines
1. Use YAML best practices
2. Follow Ansible style guide
3. Use consistent naming conventions
4. Keep tasks focused and modular
5. Use tags appropriately

### Molecule Testing Guidelines
1. Use the provided Molecule Podman template
2. Write comprehensive test scenarios
3. Follow test naming conventions
4. Document test requirements
5. Ensure idempotency

## Pull Request Process
1. Create a new branch for your changes
2. Make your changes and commit them
3. Push your branch to your fork
4. Create a pull request
5. Address any feedback
6. Wait for approval and merge

## Testing Requirements

### Molecule Testing
1. Use the provided Molecule Podman template for testing:
   ```bash
   # Create a new role with the template
   molecule init role new-role --template molecule-podman-template

   # Run tests
   molecule test
   ```

2. Write comprehensive tests:
   - Unit tests for new features
   - Integration tests using Molecule scenarios
   - Idempotency tests to ensure consistent results
   - Edge case tests for error conditions

3. Test Structure:
   - `prepare.yml`: Set up test prerequisites
   - `converge.yml`: Apply role configuration
   - `verify.yml`: Validate results

4. Testing Guidelines:
   - Test all new features and bug fixes
   - Verify role idempotency
   - Test error conditions
   - Document test scenarios

5. Run all tests before submitting:
   ```bash
   # Run full test suite
   molecule test

   # Run specific scenarios
   molecule test -s <scenario_name>
   ```

## Documentation Standards

### General Guidelines
1. Update documentation for new features
2. Follow Markdown style guide
3. Use consistent formatting
4. Keep documentation up to date
5. Write clear and concise documentation

### Documentation Files
1. `README.md`: Project overview and quick start
2. `docs/overview.md`: Detailed architecture and features
3. `docs/usage.md`: Usage instructions and examples
4. `docs/testing.md`: Testing procedures and guidelines
5. `docs/troubleshooting.md`: Common issues and solutions
6. `docs/changelog.md`: Version history and changes

### Documentation Best Practices
1. Keep documentation close to code
2. Use meaningful section headers
3. Include code examples
4. Document configuration options
5. Provide troubleshooting tips

## Code Review Process
1. Reviewers will review your code
2. Address any feedback
3. Make necessary changes
4. Wait for approval
5. Merge your changes

## Commit Message Guidelines
1. Use present tense
2. Use imperative mood
3. Keep messages short and descriptive
4. Use the following format:
```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

### Commit Types
1. feat: A new feature
2. fix: A bug fix
3. docs: Documentation changes
4. style: Code style changes
5. refactor: Code refactoring
6. test: Test changes
7. chore: Maintenance tasks

### Commit Scope
1. ansible: Ansible role related changes
2. template: Molecule template related changes
3. docs: Documentation related changes
4. tests: Test related changes
5. ci: CI/CD related changes
6. chore: Maintenance related changes

### Commit Subject
1. Keep it short and descriptive
2. Use present tense
3. Use imperative mood

### Commit Body
1. Explain what and why
2. Use present tense
3. Use imperative mood

### Commit Footer
1. Reference issues and pull requests
2. Use the following format:
```
Closes #<issue-number>
Fixes #<issue-number>
```

## Issue Reporting
1. Check if the issue already exists
2. Create a new issue
3. Provide a clear and concise description
4. Provide steps to reproduce
5. Provide expected and actual results
6. Provide environment details

## Feature Requests
1. Check if the feature already exists
2. Create a new issue
3. Provide a clear and concise description
4. Provide use cases
5. Provide expected behavior

## Bug Reports
1. Check if the bug already exists
2. Create a new issue
3. Provide a clear and concise description
4. Provide steps to reproduce
5. Provide expected and actual results
6. Provide environment details

## Code of Conduct
Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## License
By contributing to this project, you agree to license your contributions under the [MIT License](LICENSE).

## Contact
If you have any questions, please contact the maintainers.

## Thank You
Thank you for your contributions!
