# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 15)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Test case 1: Reset state
    dut.ui_in.value = 0b00000000  # All sensors off
    await ClockCycles(dut.clk, 10)

    # Test case 2: Enable ui_in[0] (sensor1)
    dut.ui_in.value = 0b00000001  # Sensor 1 on
    await ClockCycles(dut.clk, 10)
    dut.ui_in.value = 0b00000000  # Sensor 1 off
    await ClockCycles(dut.clk, 10)
    cocotb.log.info(f"uo_out value: {dut.uo_out.value}")
    assert dut.uo_out == 0b00000001
    # Test case 3: Enable ui_in[1] (sensor2)
    dut.ui_in.value = 0b00000010  # Sensor 2 on
    await ClockCycles(dut.clk, 10)
    dut.ui_in.value = 0b00000000  # Sensor 2 off
    await ClockCycles(dut.clk, 10)
    cocotb.log.info(f"uo_out value: {dut.uo_out.value}")
    assert dut.uo_out == 0b00000010

    # Test case 4: Enable ui_in[2] (sensor3)
    dut.ui_in.value = 0b00000100  # Sensor 3 on
    await ClockCycles(dut.clk, 10)
    dut.ui_in.value = 0b00000000  # Sensor 3 off
    await ClockCycles(dut.clk, 10)
    cocotb.log.info(f"uo_out value: {dut.uo_out.value}")
    assert dut.uo_out == 0b00000100

    # Test case 5: Combination of ui_in[1] and ui_in[2]
    dut.ui_in.value = 0b00000110  # Sensor 2 and 3 on
    await ClockCycles(dut.clk, 10)
    dut.ui_in.value = 0b00000000  # All sensors off
    await ClockCycles(dut.clk, 10)
    cocotb.log.info(f"uo_out value: {dut.uo_out.value}")
    assert dut.uo_out == 0b00000010

    # Test case 6: All sensors enabled
    dut.ui_in.value = 0b11111111  # All sensors on
    await ClockCycles(dut.clk, 10)
    dut.ui_in.value = 0b00000000  # All sensors off
    await ClockCycles(dut.clk, 10)
    cocotb.log.info(f"uo_out value: {dut.uo_out.value}")
    assert dut.uo_out == 0b00000001

    dut._log.info("End of test")
