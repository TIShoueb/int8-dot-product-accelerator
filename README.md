# INT8 Dot-Product Accelerator on FPGA

A clocked, synthesizable SystemVerilog accelerator that computes the exact signed
dot product of four pairs of 8-bit integers, `R = a0*b0 + a1*b1 + a2*b2 + a3*b3`,
implemented and tested on a Digilent Nexys A7-100T (Artix-7) board.

The focus is a professional RTL workflow: specification, RTL design, self-checking
simulation, SVA/formal verification, and on-board validation.

> **Note:** This project follows a simulated client brief, written with AI assistance
> as a self-directed training exercise. It is not paid client work.

## Status

![M0](https://img.shields.io/badge/M0_spec-in_progress-yellow)
![M1](https://img.shields.io/badge/M1_RTL-pending-lightgrey)
![M2](https://img.shields.io/badge/M2_formal-pending-lightgrey)
![M3](https://img.shields.io/badge/M3_FPGA-pending-lightgrey)
