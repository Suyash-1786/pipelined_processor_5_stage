# pipelined_processor_5_stage

# 5-Stage Pipelined Processor in Verilog

## Overview

This project implements a 5-stage pipelined processor using Verilog HDL. The objective is to understand processor datapath design, instruction execution, pipelining, and functional verification through simulation.

The design is developed and compiled using **Intel Quartus Prime**, with RTL simulation and waveform analysis planned using **ModelSim**.

## Architecture

The processor follows a five-stage pipeline:

1. **Instruction Fetch (IF):** Fetches the instruction from instruction memory.
2. **Instruction Decode (ID):** Decodes the instruction and reads the required operands.
3. **Execute (EX):** Performs arithmetic and logical operations or evaluates branch conditions.
4. **Memory Access (MEM):** Performs memory operations for load and store instructions.
5. **Write Back (WB):** Writes the result back to the register file.

## Tools Used

* Verilog HDL
* Intel Quartus Prime
* ModelSim
* Visual Studio Code

## Functional Verification Plan

The processor will be verified through dedicated Verilog testbenches designed to execute programs and check their expected results.

### 1. Addition of Three Numbers

**Objective:** Verify arithmetic instruction execution and register write-back.

The test program will add three numbers and store the final result in a destination register.

Expected outcome: The destination register contains the correct sum.

### 2. Load, Add, and Store

**Objective:** Verify arithmetic operations alongside data-memory access.

The test program will:

* Load data from memory into a register.
* Perform an addition using the loaded value and another operand.
* Store the result back into memory.

Expected outcome: The final memory location contains the expected result.

### 3. Factorial Using a Loop

**Objective:** Evaluate iterative computation and control-flow behavior.

The test program will calculate the factorial of an input number using repeated multiplication or the instruction sequence supported by the processor, together with loop-control instructions.

Expected outcome: The final result matches the expected factorial value for the selected input.

This test depends on the processor supporting the required multiplication or arithmetic operations, branch instructions, and loop execution.

## Simulation and Verification

The planned verification workflow is:

1. Compile the RTL design in Quartus Prime.
2. Create a Verilog testbench to generate the required clock signals.
3. Initialize instruction and data memory with the test program.
4. Run RTL simulation in ModelSim.
5. Inspect waveforms and verify register and memory values against expected results.
6. Debug functional errors and rerun the tests.

## Synthesis and Timing Analysis

Quartus Prime is used to synthesize the RTL design and inspect compilation results, resource utilization, and timing reports.

Synthesis and timing analysis complement functional simulation; successful compilation alone does not establish that the processor executes instructions correctly.

## Project Goals

* Understand five-stage pipeline organization.
* Explore instruction execution and datapath behavior.
* Verify arithmetic, memory, and control-flow operations.
* Develop practical experience with RTL simulation and waveform debugging.
* Establish a foundation for more advanced processor designs, including RISC-V.

## Future Improvements

* Expand instruction-level test coverage.
* Add automated testbench checks and pass/fail reporting.
* Investigate pipeline data hazards and control hazards.
* Perform post-synthesis functional simulation.
* Improve timing constraints and analyze critical paths.

## Project Status

**RTL synthesis:** Compiled successfully in Quartus Prime.

**Functional verification:** Planned — the three program-level testbenches will be implemented and simulated.

**Post-synthesis simulation:** Planned.

Further results will be documented as verification progresses.
