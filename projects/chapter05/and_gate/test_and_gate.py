import cocotb
from cocotb.triggers import Timer
from cocotb.result import TestFailure

@cocotb.test()
async def test_and_gate(dut):
    """Test for AND gate"""
    
    # List of test vectors (a, b, expected_output)
    test_vectors = [
        (0, 0, 0),
        (0, 1, 0),
        (1, 0, 0),
        (1, 1, 1)
    ]
    
    for a, b, expected_output in test_vectors:
        # Apply inputs
        dut.a.value = a
        dut.b.value = b
        
        # Wait for some time to allow the output to settle
        await Timer(1, units='us')
        
        # Check output
        if dut.q.value != expected_output:
            raise TestFailure(f"Test failed with: a={a}, b={b}, expected_output={expected_output}, got={int(dut.q.value)}")
        else:
            dut._log.info(f"Test passed with: a={a}, b={b}, got={int(dut.q.value)}")

