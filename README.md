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
![M1](https://img.shields.io/badge/M1_RTL-in_done-brightgreen)
![M2](https://img.shields.io/badge/M2_formal-in_progress-yellow)
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


## Verification (M1: simulation)

Self-checking testbench (Vivado xsim 2024.1) with an independent reference model
and a protocol checker (SVA, bound to `mac_top`).

| Test | Jobs | Result |
|---|---|---|
| Directed arithmetic (edge values, ±max) | 5 | ✅ |
| Reset mid-job / reset while holding | 2 | ✅ |
| Random jobs (operands, input gaps, output stalls) | 100 | ✅ |
| Back-to-back jobs | 20 | ✅ |
| Protocol assertions (reset, stall stability, 4-beat rule, latency) | all cycles | ✅ 0 violations |

Evidence: `verification/results/results.csv`, `verification/results/checker_report.txt`


## Formal Verification (M2)

Properties are written in SVA (`verification/formal_verification/fv_MAC.sv`), bound to `mac_top`,
and proven with OneSpin. Result summary is also saved in same directory


| Property | What it checks |
|---|---|
| `a_check_reset` | During reset, no handshake is possible; `out_data` is cleared one cycle later |
| `a_system_after_reset` | After reset, the design is idle and ready (`in_ready = 1`, `out_valid = 0`) |
| `a_out_valid_after_4_inputs` | `out_valid` rises exactly one cycle after the 4th accepted pair |
| `a_out_valid_stable_until_out_ready` | While the receiver stalls, the result stays valid and unchanged |
| `a_no_input_while_out_valid` | `in_ready` is always the opposite of `out_valid`: inputs are accepted only while collecting, never while a result is waiting |
| `a_in_ready_after_out_fire` | After the result is taken, a new job starts in the next cycle |
| `a_out_data_correctness` | `out_data` equals a₀·b₀ + a₁·b₁ + a₂·b₂ + a₃·b₃ of the job's accepted pairs |

**Covers** (non-vacuity): output stall, a fast job (4 pairs in a row then the result), input gaps
mid-job, and reset during a job. All reached.

**Assumption:** to get prof hold faster, can assume the source sends a new pair at least every n cycles.

**Summary of Formal Verificaiton**
Property Summary:
<img width="820" height="333" alt="onespin_run_result" src="https://github.com/user-attachments/assets/026162c8-b5f6-4203-a37d-514d933ac575" />
Coverage check Summary:
<img width="734" height="327" alt="onespin_coverage_check" src="https://github.com/user-attachments/assets/4bcee10a-0660-4da0-a32c-ab89bc04491b" />




