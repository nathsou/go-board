#!/bin/bash

# Check if a Verilog file path is provided
if [ -z "$1" ]; then
    echo "Error: No Verilog file path provided."
    echo "Usage: docker run --rm -v ./:/workspace hdl-env <verilog-file-path>"
    exit 1
fi

VERILOG_FILE=$1
OUTPUT_BASENAME=$(basename "$VERILOG_FILE" .v)
CONSTRAINT_FILE="/keep/Go_Board_Pin_Constraints.pcf"
ARTIFACTS_DIR="artifacts"

# Create the artifacts directory if it doesn't exist
mkdir -p $ARTIFACTS_DIR

# Run yosys to compile the Verilog file to an intermediate format
yosys -p "read_verilog $VERILOG_FILE; synth_ice40 -blif $ARTIFACTS_DIR/${OUTPUT_BASENAME}.blif"

# Place and route the design
arachne-pnr -d 1k -o $ARTIFACTS_DIR/${OUTPUT_BASENAME}.txt -p ${CONSTRAINT_FILE} -P vq100 $ARTIFACTS_DIR/${OUTPUT_BASENAME}.blif

# Convert the ASCII bitstream to a binary file
icepack $ARTIFACTS_DIR/${OUTPUT_BASENAME}.txt $ARTIFACTS_DIR/${OUTPUT_BASENAME}.bin

echo "Compilation finished! Bitstream file: $ARTIFACTS_DIR/${OUTPUT_BASENAME}.bin"
