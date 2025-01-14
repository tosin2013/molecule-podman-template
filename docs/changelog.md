# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project structure
- Basic Molecule testing configuration
- Podman integration
- Documentation framework

### Changed
- N/A

### Fixed
- N/A

### Removed
- N/A

## [1.0.0] - YYYY-MM-DD

### Added
- Initial release of molecule-podman-template
- Core Ansible role structure
- Basic test scenarios
- Documentation framework

### Changed
- N/A

### Fixed
- N/A

### Removed
- N/A

## Versioning Guidelines

### Version Format
```markdown
MAJOR.MINOR.PATCH
```

### Version Increment Rules
- MAJOR: Incompatible API changes
- MINOR: Backwards-compatible functionality additions
- PATCH: Backwards-compatible bug fixes

### Pre-release Versions
```markdown
1.0.0-alpha.1
1.0.0-beta.1
1.0.0-rc.1
```

### Release Process
1. Update version in meta/main.yml
2. Update changelog with release notes
3. Create git tag
4. Push changes and tag
5. Create GitHub release

## Deprecation Policy

### Deprecation Notice
- Features marked for removal will be deprecated for at least one major version
- Deprecated features will be clearly marked in documentation
- Removal will occur in the next major version

### Migration Paths
- Deprecated features will include migration instructions
- Alternative approaches will be documented
- Examples will be provided for common use cases

## Security Fixes

### Security Policy
- Critical security fixes will be released as patch versions
- Security advisories will be published in the changelog
- CVEs will be referenced when applicable

### Reporting Security Issues
- Use the security issue template
- Provide detailed reproduction steps
- Include affected versions
- Describe potential impact

## Maintenance Policy

### Supported Versions
- Current major version
- Previous major version (for 6 months)
- LTS versions (if applicable)

### End of Life
- EOL versions will be clearly marked
- Migration guides will be provided
- Security fixes will not be backported
