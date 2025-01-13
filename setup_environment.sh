#!/bin/bash

# Set strict error handling
set -euo pipefail

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
    
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    log_message "ERROR" "This script should not be run as root"
    exit 1
fi

log_message "INFO" "Starting environment setup..."

# Install Python pip if not present
if ! command -v pip3 &> /dev/null; then
    log_message "INFO" "Installing pip3..."
    python3 -m ensurepip --user
fi

# Install Molecule and its dependencies
log_message "INFO" "Installing Molecule and dependencies..."
pip3 install --user "molecule[podman]" ansible-lint yamllint

# Set up Podman debug logging
echo "export PODMAN_SYSTEM_DEBUG=1" >> ~/.bashrc
export PODMAN_SYSTEM_DEBUG=1

log_message "SUCCESS" "Environment setup completed"
log_message "INFO" "Please run 'source ~/.bashrc' to apply environment changes"
log_message "WARNING" "Some actions require root privileges. Please contact your system administrator to:"
log_message "WARNING" "1. Install Podman: sudo dnf install -y podman"
log_message "WARNING" "2. Enable SELinux enforcing mode: sudo setenforce 1"
log_message "WARNING" "3. Enable container_manage_cgroup: sudo setsebool -P container_manage_cgroup 1"
