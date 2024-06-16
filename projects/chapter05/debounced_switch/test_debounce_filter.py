import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import logging

@cocotb.test()
async def debounce_filter_tb(dut):
    """
    Test for Debounce Filter
    """
    
    # Create a 4ns period clock on the 'i_Clk' signal
    cocotb.start_soon(Clock(dut.i_Clk, 4, units="ns").start())

    # Required for waveform viewing
    dut._log.setLevel(logging.DEBUG)
    cocotb.log.setLevel(logging.DEBUG)
    
    # Start with initial values
    dut.i_Bouncy.value = 0

    await RisingEdge(dut.i_Clk)
    await RisingEdge(dut.i_Clk)
    await RisingEdge(dut.i_Clk)

    # Apply test stimulus
    dut.i_Bouncy.value = 1  # toggle state of input pin
    await RisingEdge(dut.i_Clk)

    dut.i_Bouncy.value = 0  # simulate a glitch/bounce of switch
    await RisingEdge(dut.i_Clk)

    dut.i_Bouncy.value = 1  # bounce goes away
    await RisingEdge(dut.i_Clk)
    await RisingEdge(dut.i_Clk)
    await RisingEdge(dut.i_Clk)
    await RisingEdge(dut.i_Clk)
    await RisingEdge(dut.i_Clk)
    await RisingEdge(dut.i_Clk)

    dut._log.info("Test Complete")
