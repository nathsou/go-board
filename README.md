# NandLand Go / Alchitry Cu Dev Container

[Dev container](https://containers.dev/) set up for development, synthesis & place and route, and simulation of the [NandLand Go](https://nandland.com/the-go-board/) and [Alchitry Cu](https://alchitry.com/boards/cu) FPGA development boards.

## Tools
- [Yosys](https://github.com/YosysHQ/yosys) for synthesis
- [NextPNR](https://github.com/YosysHQ/nextpnr) for place and route
- [Icestorm](https://github.com/YosysHQ/icestorm) for programming the FPGA
- [Icarus Verilog](https://github.com/steveicarus/iverilog) for simulation
- [Cocotb](https://github.com/cocotb/cocotb) for testbenches

## Usage

Open the project in VSCode, open the command palette and select `Dev Containers: Reopen in Container`. This will open the project in a container with all the necessary tools installed and example projects.

### Generate a bitstream file

NandLand Go Board:

```bash
cd projects/chapter02/go
gen_bitstream go . switchtes_to_leds.v
iceprog artifacts/switches_to_leds.bin
```

For the Alchitry Cu:

```bash
cd projects/chapter02/cu
gen_bitstream cu . rst_to_leds.v
iceprog artifacts/rst_to_leds.bin
```

 ### Run a simulation

Testbenches can be run using cocotb and Icarus Verilog which are already installed in the container.

```bash
cd projects/chapter05/and_gate
make
```
