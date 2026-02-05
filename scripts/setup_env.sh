#!/bin/bash
set -e

# Create keys directory if it doesn't exist
mkdir -p keys

# Generate SSH key pair if not exists
if [ ! -f keys/ansible_id_rsa ]; then
    echo "Generating SSH keys for Ansible..."
    ssh-keygen -t rsa -b 4096 -f keys/ansible_id_rsa -N "" -C "ansible-demo"
    chmod 600 keys/ansible_id_rsa
    echo "Keys generated in ./keys/"
else
    echo "SSH keys already exist in ./keys/"
fi

# Fix permissions for directory
chmod 700 keys
