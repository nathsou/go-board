#!/bin/bash

# check that there are 3 arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: gen_bitstream <board> <verilog-project-path> <top-module>"
    exit 1
fi

BOARD=$1
FOLDER_PATH=$2
TOP_MODULE=$3
OUTPUT_BASENAME=$TOP_MODULE
ARTIFACTS_DIR="$FOLDER_PATH/artifacts"

# Create the artifacts directory if it doesn't exist
mkdir -p $ARTIFACTS_DIR

JSON_FILE=$ARTIFACTS_DIR/${OUTPUT_BASENAME}.json
ASC_FILE=$ARTIFACTS_DIR/${OUTPUT_BASENAME}.asc
BIN_FILE=$ARTIFACTS_DIR/${OUTPUT_BASENAME}.bin

if [ "$BOARD" == "go" ]; then
    PIN_CONSTRAINT_FILE="/keep/go.pcf"
    PACKAGE="vq100"
    CHIP="hx1k"
    FREQ=25
elif [ "$BOARD" == "cu" ]; then
    PIN_CONSTRAINT_FILE="/keep/cu.pcf"
    PACKAGE="cb132"
    CHIP="hx8k"
    FREQ=10
else
    echo "Unknown board type: $BOARD, valid options are "go" (nandland.com Go Board) and "cu" (Alchitry Cu Board)"
    exit 1
fi

# Run yosys to compile the Verilog file to an intermediate format
yosys -p "read_verilog $FOLDER_PATH/*.v; synth_ice40 -json $JSON_FILE"

# Place and route the design
nextpnr-ice40 --$CHIP --json $JSON_FILE --pcf $PIN_CONSTRAINT_FILE --asc $ASC_FILE --package $PACKAGE --freq $FREQ

# Convert the ASCII bitstream to a binary file
icepack $ASC_FILE $BIN_FILE

echo "Compilation finished! Bitstream file: $BIN_FILE"
