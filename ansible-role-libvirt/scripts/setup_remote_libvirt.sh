#!/bin/bash

# Exit on any error
set -e

if [ $# -ne 2 ]; then
  echo "Usage: $0 <user_name> <ip_address>"
  echo "Sets up remote libvirt access for a given user and host"
  exit 1
fi

USER_NAME=$1
IP_ADDRESS=$2

# Function to check if command succeeded
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

echo "Setting up remote libvirt access for ${USER_NAME}@${IP_ADDRESS}..."

# Step 1: Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/cluster-key ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/cluster-key -N ''
    check_status "Failed to generate SSH key"
fi

# Step 2: Add host key to known_hosts if not already present
echo "Checking SSH host key..."
if ! ssh-keygen -F "$IP_ADDRESS" > /dev/null; then
    ssh-keyscan -H "$IP_ADDRESS" >> ~/.ssh/known_hosts 2>/dev/null
fi

# Step 3: Test SSH connection first
echo "Testing SSH connection..."
if ! ssh -o PasswordAuthentication=no "${USER_NAME}@${IP_ADDRESS}" exit 2>/dev/null; then
    echo "Password authentication required."
    echo "Please enter the password for ${USER_NAME}@${IP_ADDRESS} when prompted."
    ssh-copy-id -i ~/.ssh/cluster-key.pub "${USER_NAME}@${IP_ADDRESS}"
    check_status "Failed to copy SSH key"
fi

# Step 4: Create the libvirt group if it doesn't exist
if ! getent group libvirt > /dev/null; then
    echo "Creating libvirt group..."
    sudo groupadd libvirt
    check_status "Failed to create libvirt group"
fi

# Step 5: Update the libvirt configuration
echo "Updating libvirt configuration..."
sudo cp /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.backup
sudo sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/g' /etc/libvirt/libvirtd.conf
sudo sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/g' /etc/libvirt/libvirtd.conf
check_status "Failed to update libvirt configuration"

# Step 6: Restart libvirtd service
echo "Restarting libvirtd service..."
if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl restart libvirtd
else
    sudo service libvirtd restart
fi
check_status "Failed to restart libvirtd service"

# Step 7: Add user to libvirt group
echo "Adding user to libvirt group..."
sudo usermod -a -G libvirt "$USER_NAME"
check_status "Failed to add user to libvirt group"

# Step 8: Test connection
echo "Testing connection to remote libvirt..."
virsh -c "qemu+ssh://${USER_NAME}@${IP_ADDRESS}/system" list
check_status "Failed to connect to remote libvirt"

echo "Setup completed successfully!"
echo "Note: You may need to log out and back in for group changes to take effect"
