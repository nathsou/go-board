#!/bin/bash

# check that there are 2 arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: gen_bistream <verilog-project-path> <top-module>"
    exit 1
fi

FOLDER_PATH=$1
TOP_MODULE=$2
OUTPUT_BASENAME=$TOP_MODULE
PIN_CONSTRAINT_FILE="/keep/Go_Board_Pin_Constraints.pcf"
ARTIFACTS_DIR="$FOLDER_PATH/artifacts"

# Create the artifacts directory if it doesn't exist
mkdir -p $ARTIFACTS_DIR

JSON_FILE=$ARTIFACTS_DIR/${OUTPUT_BASENAME}.json
ASC_FILE=$ARTIFACTS_DIR/${OUTPUT_BASENAME}.asc
BIN_FILE=$ARTIFACTS_DIR/${OUTPUT_BASENAME}.bin

# Run yosys to compile the Verilog file to an intermediate format
yosys -p "read_verilog $FOLDER_PATH/*.v; synth_ice40 -json $JSON_FILE"

# Place and route the design
nextpnr-ice40 --hx1k --json $JSON_FILE --pcf $PIN_CONSTRAINT_FILE --asc $ASC_FILE --package vq100 --freq 25

# Convert the ASCII bitstream to a binary file
icepack $ASC_FILE $BIN_FILE

echo "Compilation finished! Bitstream file: $BIN_FILE"
