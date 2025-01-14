# Molecule Podman Template

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A template for creating Ansible roles with Molecule testing using Podman containers.

## Table of Contents
- [Overview](#overview)
- [Requirements](#requirements)
- [Usage](#usage)
- [Directory Structure](#directory-structure)
- [Testing](#testing)
- [License](#license)
- [Author Information](#author-information)

## Overview

This template provides a starting point for developing Ansible roles with:
- Molecule for testing
- Podman as the container runtime
- Pre-configured test scenarios
- Example tasks and defaults

## Requirements

- Podman 3.0+
- Ansible 2.9+
- Molecule 3.0+
- Python 3.6+

## Usage

1. Clone this repository
2. Rename the directory to your role name
3. Update metadata in `meta/main.yml`
4. Add your role tasks in `tasks/main.yml`
5. Configure role variables in `defaults/main.yml`

## Directory Structure

```
molecule-podman-template/
├── defaults/         # Role default variables
├── meta/             # Role metadata
├── molecule/         # Molecule test scenarios
│   └── default/      # Default test scenario
├── tasks/            # Role tasks
└── vars/             # Role variables
```

## Testing

To run Molecule tests:

```bash
molecule test
```

This will:
1. Create the test environment
2. Converge the role
3. Verify the results
4. Destroy the environment

## License

MIT

## Author Information

This template was created by [Tosin Akinosho](https://github.com/tosin-akinosho).
