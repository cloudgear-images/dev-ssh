#!/bin/sh

# Set SSH public key for root
mkdir -p /root/.ssh
chmod 700 /root/.ssh
echo $SSH_PUBKEY > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

exec "$@"