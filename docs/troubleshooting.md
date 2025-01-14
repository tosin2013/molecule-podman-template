# Troubleshooting Guide

## Common Issues and Solutions

### 1. Molecule Test Failures

**Symptoms:**
- Tests fail during `molecule converge`
- Container fails to start
- Systemd services not running

**Solutions:**
1. Verify Podman is installed and running:
```bash
podman --version
systemctl status podman
```

2. Check container privileges:
```bash
# Ensure container has proper capabilities
podman inspect <container_name> | grep -i cap
```

3. Verify systemd support:
```bash
molecule login --exec "systemctl status"
```

4. Check SELinux configuration:
```bash
getenforce
# If enforcing, try:
sudo setenforce 0
```

### 2. Package Installation Failures

**Symptoms:**
- Yum/DNF errors during package installation
- Missing repositories
- Subscription manager issues

**Solutions:**
1. Verify network connectivity:
```bash
molecule login --exec "curl -I https://access.redhat.com"
```

2. Check repository configuration:
```bash
molecule login --exec "yum repolist"
```

3. Register system if needed:
```bash
molecule login --exec "subscription-manager register"
```

4. Attach subscription:
```bash
molecule login --exec "subscription-manager attach --auto"
```

### 3. Ansible Module Failures

**Symptoms:**
- Module-specific errors
- Python interpreter issues
- Permission denied errors

**Solutions:**
1. Verify Python interpreter:
```bash
ansible localhost -m ping
```

2. Check module dependencies:
```bash
molecule login --exec "rpm -q python3-<module>"
```

3. Increase verbosity:
```bash
molecule converge -- -vvv
```

4. Check SELinux context:
```bash
ls -Z /path/to/resource
```

### 4. Firewall Configuration Issues

**Symptoms:**
- Services not accessible
- Firewall rules not applied
- SELinux blocking access

**Solutions:**
1. Verify firewall rules:
```bash
molecule login --exec "firewall-cmd --list-all"
```

2. Check service definitions:
```bash
molecule login --exec "firewall-cmd --get-services"
```

3. Verify SELinux ports:
```bash
molecule login --exec "semanage port -l"
```

4. Check service status:
```bash
molecule login --exec "systemctl status firewalld"
```

### 5. User Management Problems

**Symptoms:**
- Users not created
- SSH access denied
- Permission issues

**Solutions:**
1. Verify user creation:
```bash
molecule login --exec "id <username>"
```

2. Check SSH configuration:
```bash
molecule login --exec "cat /etc/ssh/sshd_config"
```

3. Verify home directory:
```bash
molecule login --exec "ls -ld /home/<username>"
```

4. Check SELinux context:
```bash
molecule login --exec "ls -Z /home/<username>/.ssh"
```

## Debugging Techniques

### 1. Verbose Output

Add `-vvv` to any Ansible command:
```bash
molecule converge -- -vvv
```

### 2. Container Inspection

View container logs:
```bash
podman logs <container_name>
```

Inspect container configuration:
```bash
podman inspect <container_name>
```

### 3. System Logs

View system logs:
```bash
molecule login --exec "journalctl -xe"
```

Check specific service logs:
```bash
molecule login --exec "journalctl -u <service>"
```

### 4. Network Diagnostics

Check network configuration:
```bash
molecule login --exec "ip a"
```

Test connectivity:
```bash
molecule login --exec "curl -I https://example.com"
```

### 5. SELinux Troubleshooting

Check SELinux status:
```bash
molecule login --exec "sestatus"
```

View SELinux alerts:
```bash
molecule login --exec "ausearch -m avc -ts recent"
```

## Common Error Messages

### 1. "Permission Denied"
- Verify user permissions
- Check SELinux context
- Ensure proper file ownership

### 2. "Module Failed"
- Verify module dependencies
- Check Python interpreter
- Review module documentation

### 3. "Package Not Found"
- Verify repository configuration
- Check network connectivity
- Ensure proper subscription

### 4. "Service Failed to Start"
- Check service logs
- Verify dependencies
- Review systemd configuration

### 5. "Firewall Rule Not Applied"
- Verify firewalld service status
- Check SELinux port configuration
- Ensure proper zone assignment
