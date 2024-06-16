#!/bin/bash

# Check if a Verilog file path is provided
if [ -z "$1" ]; then
    echo "Error: No Verilog file path provided."
    echo "Usage: gen_bistream <verilog-file-path>"
    exit 1
fi

VERILOG_FILE=$1
OUTPUT_BASENAME=$(basename "$VERILOG_FILE" .v)
PIN_CONSTRAINT_FILE="/keep/Go_Board_Pin_Constraints.pcf"
CLOCK_CONSTRAINT_FILE=$2
ARTIFACTS_DIR="artifacts"

# Create the artifacts directory if it doesn't exist
mkdir -p $ARTIFACTS_DIR

JSON_FILE=$ARTIFACTS_DIR/${OUTPUT_BASENAME}.json
ASC_FILE=$ARTIFACTS_DIR/${OUTPUT_BASENAME}.asc
BIN_FILE=$ARTIFACTS_DIR/${OUTPUT_BASENAME}.bin

# Run yosys to compile the Verilog file to an intermediate format
yosys -p "synth_ice40 -json $JSON_FILE" $VERILOG_FILE

# Place and route the design
nextpnr-ice40 --hx1k --json $JSON_FILE --pcf $PIN_CONSTRAINT_FILE --asc $ASC_FILE --package vq100 --freq 25

# Convert the ASCII bitstream to a binary file
icepack $ASC_FILE $BIN_FILE

echo "Compilation finished! Bitstream file: $BIN_FILE"
