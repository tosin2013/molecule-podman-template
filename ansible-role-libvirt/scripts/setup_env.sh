#!/bin/bash

# Step 1: Enable required repositories for RHEL 9
echo "Setting up repositories..."
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms || {
    echo "Warning: Could not enable CodeReady Builder repository. Some packages might not be available."
}

# Step 2: Install required system packages
echo "Installing required system packages..."
sudo dnf install -y \
    python3-pip \
    python3-devel \
    libvirt \
    libvirt-daemon-driver-qemu \
    libvirt-client \
    qemu-kvm \
    virt-install \
    python3-libvirt \
    podman \
    git \
    platform-python-devel \
    openssh-clients \
    gcc \
    pkgconfig \
    libvirt-devel \
    make

# Step 3: Install Python packages
echo "Installing Python packages..."
# Upgrade pip
python3 -m pip install --user --upgrade pip setuptools wheel molecule molecule-podman podman-compose

# Install packages with pip
python3 -m pip install --user \
    ansible \
    molecule \
    molecule-podman \
    podman-compose \
    libvirt-python

# Step 4: Install and configure libvirt
echo "Installing and configuring libvirt..."
sudo dnf install -y libvirt libvirt-daemon-driver-qemu

# Create libvirt group if it doesn't exist
if ! getent group libvirt > /dev/null; then
    sudo groupadd libvirt
fi

# Create qemu group if it doesn't exist
if ! getent group qemu > /dev/null; then
    sudo groupadd qemu
fi

# Configure libvirt
sudo mkdir -p /etc/libvirt
cat << EOF | sudo tee /etc/libvirt/libvirtd.conf
unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"
auth_unix_rw = "none"
EOF

# Step 5: Enable and start libvirt services
echo "Starting libvirt services..."
sudo systemctl enable --now libvirtd || true
sudo systemctl start libvirtd || true

# Step 6: Add user to necessary groups
echo "Adding user to groups..."
sudo usermod -a -G libvirt $(whoami)
sudo usermod -a -G kvm $(whoami)
[[ $(getent group qemu) ]] && sudo usermod -a -G qemu $(whoami)

# Step 7: Create necessary directories and set permissions
sudo mkdir -p /var/run/libvirt/common /var/run/libvirt/qemu /var/lib/libvirt/qemu /var/lib/libvirt/images /run/libvirt
sudo chown -R root:libvirt /var/run/libvirt /var/lib/libvirt /run/libvirt
sudo chmod -R g+rwx /var/run/libvirt /var/lib/libvirt /run/libvirt

# Step 8: Configure Ansible temporary directory
sudo mkdir -p /var/tmp/ansible-tmp
sudo chmod -R 777 /var/tmp/ansible-tmp

# Step 9: Test local libvirt connection
if command -v virsh &> /dev/null; then
    echo "Testing local libvirt connection..."
    virsh list --all || echo "Note: Local libvirt connection test failed. Please check libvirt service status."
else
    echo "Note: virsh command not available. Please ensure libvirt-client is properly installed."
fi

# Set up environment for molecule tests
echo "export LIBVIRT_DEFAULT_URI=\"qemu:///system\"" >> ~/.bashrc

echo "Setup complete! Please:"
echo "1. Log out and log back in for group changes to take effect"
echo "2. Run: source ~/.bashrc"
echo "3. Verify installation with: molecule test -s default"
