#!/bin/bash
set -e  # Exit on any error

# Use HOST_IP if set, otherwise default to host.docker.internal
export DISPLAY="${HOST_IP:-host.docker.internal}:0.0"

echo "Using DISPLAY=$DISPLAY"

# Execute the container’s main command
exec "$@"
