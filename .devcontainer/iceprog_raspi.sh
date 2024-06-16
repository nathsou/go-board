#!/bin/bash

# This script is specific to my setup, where the Go Board is connected to a raspberry pi
# Transfer a bitstream file to a raspberry pi and program a connected FPGA using iceprog

# Configuration
REMOTE_SERVER="192.168.1.24"  # Replace with your remote server address
REMOTE_USER="nathan"                # Replace with your SSH username
SSH_KEY_PATH="~/.ssh/id_ed25519"   # Path to your private SSH key
REMOTE_DIR="/tmp"                     # Directory on the remote server to store the file
ICEPROG_PATH="/home/nathan/Documents/code/fpga/icestorm/iceprog/iceprog"

# Check if a file was provided
if [ $# -eq 0 ]; then
    echo "No file provided. Usage: $0 <path_to_file>"
    exit 1
fi

# Generate a unique filename using UUID
FILE_PATH=$1
FILE_NAME=$(basename "$FILE_PATH")
REMOTE_FILE_PATH="$REMOTE_DIR/$(uuidgen).bin"

# Copy the file to the remote server
scp -i "$SSH_KEY_PATH" "$FILE_PATH" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_FILE_PATH"
if [ $? -ne 0 ]; then
    echo "Error: File transfer failed"
    exit 1
fi

# Run iceprog on the remote server
ssh -i "$SSH_KEY_PATH" "$REMOTE_USER@$REMOTE_SERVER" "$ICEPROG_PATH $REMOTE_FILE_PATH"
if [ $? -ne 0 ]; then
    echo "Error: iceprog failed"
    # Clean up the file on the remote server
    ssh -i "$SSH_KEY_PATH" "$REMOTE_USER@$REMOTE_SERVER" "rm $REMOTE_FILE_PATH"
    exit 1
fi

# Clean up the file on the remote server
ssh -i "$SSH_KEY_PATH" "$REMOTE_USER@$REMOTE_SERVER" "rm $REMOTE_FILE_PATH"
if [ $? -ne 0 ]; then
    echo "Warning: Cleanup of the remote file failed"
fi

echo "iceprog completed successfully"
exit 0
