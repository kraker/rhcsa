#!/bin/bash
# RHCSA Lab Startup Script
# Automatically sources credentials and starts Vagrant VMs

set -e  # Exit on any error

echo "🔧 RHCSA Lab Startup"
echo "===================="

# Check if credentials file exists
if [ ! -f ".rhel-credentials" ]; then
    echo "❌ Error: .rhel-credentials file not found"
    echo "   Please create it first with your Red Hat Developer credentials"
    echo ""
    echo "   You can copy the template:"
    echo "   cp .rhel-credentials.template .rhel-credentials"
    echo "   Then edit .rhel-credentials with your actual credentials"
    exit 1
fi

# Source the credentials
echo "🔑 Loading Red Hat Developer credentials..."
source .rhel-credentials

# Verify credentials were loaded
if [ -z "$SUB_USERNAME" ] || [ -z "$SUB_PASSWORD" ]; then
    echo "❌ Error: Credentials not properly loaded"
    echo "   Please check your .rhel-credentials file"
    exit 1
fi

# Start the VMs
echo ""
echo "🚀 Starting RHEL 9 VMs..."
echo "   This may take several minutes on first run..."
vagrant up

echo ""
echo "✅ Lab environment ready!"
echo ""
echo "💡 Useful commands:"
echo "   vagrant ssh rhel9a    # SSH to rhel9a VM"
echo "   vagrant ssh rhel9b    # SSH to rhel9b VM"
echo "   vagrant halt          # Stop all VMs"
echo "   vagrant destroy       # Remove all VMs"