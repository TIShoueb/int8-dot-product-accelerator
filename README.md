# INT8 Dot-Product Accelerator on FPGA

A clocked, synthesizable SystemVerilog accelerator that computes the exact signed
dot product of four pairs of 8-bit integers, `R = a0*b0 + a1*b1 + a2*b2 + a3*b3`,
implemented and tested on a Digilent Nexys A7-100T (Artix-7) board.

The focus is a professional RTL workflow: specification, RTL design, self-checking
simulation, SVA/formal verification, and on-board validation.

> **Note:** This project follows a simulated client brief, written with AI assistance
> as a self-directed training exercise. It is not paid client work.

## Status

![M0](https://img.shields.io/badge/M0_spec-done-brightgreen)
![M1](https://img.shields.io/badge/M1_RTL-in_progress-yellow)
![M2](https://img.shields.io/badge/M2_formal-pending-lightgrey)
![M3](https://img.shields.io/badge/M3_FPGA-pending-lightgrey)


## Specification

The approved specification is in [`docs/spec/m0_spec.pdf`](docs/spec/m0_spec.pdf). Key points:

- Four-beat AXI4-Stream-style ready/valid input: one signed 8-bit (a, b) pair per beat
- One shared multiplier, 18-bit accumulator, 20-bit signed result
- Latency: 1 cycle after the 4th pair; job period: 5 cycles
- Synchronous reset; discards any job in progress


## RTL Structure

| File | Purpose |
|---|---|
| `rtl/mac_pkg.sv` | Shared widths and FSM state type |
| `rtl/mac_controlpath.sv` | Handshakes, beat counter, ACCUMULATE/HOLD FSM |
| `rtl/mac_datapath.sv` | Signed 8×8 multiply, 18-bit accumulator, sign extension to 20 bits |
| `rtl/mac_top.sv` | Connects control path and datapath |
