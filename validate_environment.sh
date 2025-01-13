#!/bin/bash

# Set strict error handling
set -euo pipefail

LOG_FILE="environment.log"
echo "Environment Validation Started: $(date)" > "$LOG_FILE"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages
log_message() {
    local level=$1
    local message=$2
    local color=$NC
    
    case $level in
        "ERROR")   color=$RED ;;
        "WARNING") color=$YELLOW ;;
        "SUCCESS") color=$GREEN ;;
    esac
    
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message${NC}" | tee -a "$LOG_FILE"
}

log_message "INFO" "Starting environment validation..."

# Check current user
current_user=$(whoami)
log_message "INFO" "Current user: $current_user"
if [ "$current_user" != "lab-user" ]; then
    log_message "ERROR" "Must be running as lab-user"
    exit 1
else
    log_message "SUCCESS" "User check passed"
fi

# Check RHEL version
if [ -f "/etc/redhat-release" ]; then
    rhel_version=$(cat /etc/redhat-release)
    log_message "INFO" "OS Version: $rhel_version"
    if ! grep -q "9.5" /etc/redhat-release; then
        log_message "WARNING" "Expected RHEL 9.5"
    else
        log_message "SUCCESS" "RHEL version check passed"
    fi
else
    log_message "ERROR" "Not a RHEL system"
    exit 1
fi

# Check SELinux status
selinux_status=$(sestatus)
log_message "INFO" "Checking SELinux status..."
if echo "$selinux_status" | grep -q "enforcing"; then
    log_message "SUCCESS" "SELinux is in enforcing mode"
else
    log_message "WARNING" "SELinux is not in enforcing mode"
    echo "$selinux_status" >> "$LOG_FILE"
fi

# Check Podman
if command -v podman >/dev/null 2>&1; then
    podman_version=$(podman --version)
    log_message "INFO" "Podman version: $podman_version"
    
    # Check rootless setup
    podman_info=$(podman info)
    if echo "$podman_info" | grep -q "rootless"; then
        log_message "SUCCESS" "Podman rootless mode is enabled"
    else
        log_message "WARNING" "Podman rootless mode may not be properly configured"
    fi
    
    # Test container creation
    log_message "INFO" "Testing rootless container creation..."
    if podman run --rm hello-world >/dev/null 2>&1; then
        log_message "SUCCESS" "Container test passed"
    else
        log_message "WARNING" "Container test failed"
    fi
else
    log_message "ERROR" "Podman is not installed"
fi

# Check Python version
if command -v python3 >/dev/null 2>&1; then
    python_version=$(python3 --version)
    log_message "INFO" "Python version: $python_version"
    # Check if Python version is 3.8+
    if python3 -c "import sys; exit(0 if sys.version_info >= (3, 8) else 1)" >/dev/null 2>&1; then
        log_message "SUCCESS" "Python version check passed"
    else
        log_message "WARNING" "Python version should be 3.8 or higher"
    fi
else
    log_message "ERROR" "Python 3 is not installed"
fi

# Check Molecule
if command -v molecule >/dev/null 2>&1; then
    molecule_version=$(molecule --version)
    log_message "INFO" "Molecule version: $molecule_version"
    
    # Check Podman driver
    if pip list 2>/dev/null | grep -q "molecule-podman"; then
        log_message "SUCCESS" "Molecule Podman driver is installed"
    else
        log_message "WARNING" "Molecule Podman driver is not installed"
    fi
else
    log_message "WARNING" "Molecule is not installed"
fi

# Check SELinux boolean for container management
if command -v getsebool >/dev/null 2>&1; then
    if getsebool container_manage_cgroup | grep -q "on"; then
        log_message "SUCCESS" "SELinux container_manage_cgroup is enabled"
    else
        log_message "WARNING" "SELinux container_manage_cgroup is not enabled"
    fi
fi

# Check if PODMAN_SYSTEM_DEBUG is set
if [ -n "${PODMAN_SYSTEM_DEBUG:-}" ]; then
    log_message "SUCCESS" "Podman debug logging is enabled"
else
    log_message "WARNING" "Podman debug logging is not enabled (PODMAN_SYSTEM_DEBUG not set)"
fi

log_message "INFO" "Environment Validation Completed"
