# Go Board Dev Container

[Dev container](https://containers.dev/) set up for development, synthesis & place and route, and simulation of the [Go Board](https://nandland.com/the-go-board/) (development board with a Lattice iCE40HX1K FPGA).

## Tools
- [Yosys](https://github.com/YosysHQ/yosys) for synthesis
- [NextPNR](https://github.com/YosysHQ/nextpnr) for place and route
- [Icestorm](https://github.com/YosysHQ/icestorm) for programming the FPGA
- [Icarus Verilog](https://github.com/steveicarus/iverilog) for simulation
- [Cocotb](https://github.com/cocotb/cocotb) for testbenches

## Usage

Open the project in VSCode, open the command palette and select `Dev Containers: Reopen in Container`. This will open the project in a container with all the necessary tools installed and example projects.

### Generate a bitstream file

To generate a bitstream file for the Go Board, run the following command:

```bash
./gen_bitstream <verilog_file> # e.g. projects/chapter02/switchtes_to_leds.v
```

The .bin file (located in the `artifacts/` directory) can then be programmed to the Go Board using `iceprog`:

```bash
iceprog <bin_file>
```

 ### Run a simulation

Testbenches can be run using cocotb and Icarus Verilog which are already installed in the container.
An example testbench is provided in the `projects/simple_dff` directory:

```bash
cd projects/simple_dff
make
```
