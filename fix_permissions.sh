#!/bin/bash

# Script to fix permissions for rootless Podman
echo "Current permissions:"
ls -l /usr/bin/newuidmap /usr/bin/newgidmap

echo -e "\nRequired changes (need sudo):"
echo "sudo chmod u+s /usr/bin/newuidmap"
echo "sudo chmod u+s /usr/bin/newgidmap"
echo "sudo restorecon -v /usr/bin/newuidmap /usr/bin/newgidmap"

echo -e "\nAfter making changes, verify with:"
echo "ls -l /usr/bin/newuidmap /usr/bin/newgidmap"
echo "podman run --rm hello-world"
