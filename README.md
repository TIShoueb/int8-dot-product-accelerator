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
![M1](https://img.shields.io/badge/M1_RTL_%2B_sim-done-brightgreen)
![M2](https://img.shields.io/badge/M2_formal-done-brightgreen)
![M3](https://img.shields.io/badge/M3_FPGA-done-brightgreen)
![Timing](https://img.shields.io/badge/100_MHz-met-blue)


## Specification

The approved specification is in [`docs/spec/m0_spec.pdf`](docs/spec/m0_spec.pdf). Key points:

- Four-beat AXI4-Stream-style ready/valid input: one signed 8-bit (a, b) pair per beat
- One shared multiplier, 18-bit accumulator, 20-bit signed result
- Latency: 1 cycle after the 4th pair; job period: 5 cycles
- Synchronous reset; discards any job in progress


## Repository Structure

| Path | Content |
|---|---|
| `docs/` | Client brief and approved specification |
| `rtl/` | Accelerator RTL |
| `verification/elaborate_simulation_testbench/` | Self-checking testbench, reference model, SVA checker, results |
| `verification/formal_verificaiton/` | Formal properties (OneSpin) and result screenshots |
| `coverage_quantify_result/` | OneSpin coverage (quantify) report |
| `HW_testign_fpga/` | On-board BIST, board top level, constraints, test vectors, reports |


## RTL Structure

| File | Purpose |
|---|---|
| `rtl/mac_pkg.sv` | Shared widths and FSM state type |
| `rtl/mac_controlpath.sv` | Handshakes, beat counter, ACCUMULATE/HOLD FSM |
| `rtl/mac_datapath.sv` | Signed 8×8 multiply, 18-bit accumulator, sign extension to 20 bits |
| `rtl/mac_top.sv` | Connects control path and datapath |


## Verification (M1: Simulation)

Self-checking testbench (Vivado xsim 2024.1) with an independent reference model
and a protocol checker (SVA, bound to `mac_top`).

| Test | Jobs | Result |
|---|---|---|
| Directed arithmetic (edge values, ±max) | 5 | ✅ |
| Reset mid-job / reset while holding | 2 | ✅ |
| Random jobs (operands, input gaps, output stalls) | 100 | ✅ |
| Back-to-back jobs | 20 | ✅ |
| Protocol assertions (reset, stall stability, 4-beat rule, latency) | all cycles | ✅ 0 violations |

Evidence: `verification/elaborate_simulation_testbench/results/` (`results.csv`, `checker_report.txt`)


## Formal Verification (M2)

Properties are written in SVA (`verification/formal_verificaiton/fv_MAC.sv`), bound to `mac_top`,
and proven with OneSpin.

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

**Assumption:** to get proofs faster, the source can be assumed to send a new pair at least every n cycles.

**Property summary:**

<img width="1013" height="234" alt="onespin_run_result" src="https://github.com/user-attachments/assets/53f0ce46-4d63-4d6a-858b-3b344cab605f" />

**Coverage check summary:**

<img width="812" height="171" alt="onespin_coverage_check" src="https://github.com/user-attachments/assets/dd39c58e-c9b8-4211-9fd5-a1e8a94073e4" />


## FPGA Implementation (M3)

The accelerator is tested on the board by a **built-in self-test (BIST)**. A ROM holds
64 test jobs with their expected results. The BIST sends each job to `mac_top` through
the same ready/valid handshake, compares every result, and shows PASS or FAIL on an LED.

```
            ┌──────────────── fpga_top ─────────────────┐
 BTNC ──sync+edge──▶ start                               │
 SW0  ──sync──────▶ fault     ┌──────────┐  in_*   ┌─────────┐
 SW1  ──sync──▶ LFSR ▶ stall  │   BIST   │────────▶│ mac_top │
 CPU_RESETN ─sync─▶ rst       │ + ROM    │◀────────│  (DUT)  │
                              └──────────┘  out_*  └─────────┘
                                 │ pass / fail / busy
                                 ▼
                            LED16 (RGB)
```

| File | Purpose |
|---|---|
| `HW_testign_fpga/script/gen_vector.py` | Generates `vectors.mem`: 6 directed edge cases + 58 random jobs, with expected results |
| `HW_testign_fpga/vectors.mem` | ROM contents (84 bits per job: 4 pairs + 20-bit expected result) |
| `HW_testign_fpga/mac_rom.sv` | ROM loaded with `$readmemh` |
| `HW_testign_fpga/mac_bist_controller.sv` | BIST FSM (IDLE → SEND → WAIT → CHECK → DONE), comparator, fault injection |
| `HW_testign_fpga/fpga_top.sv` | Board wrapper: reset/button/switch synchronizers, start edge detect, LFSR, LEDs |
| `HW_testign_fpga/nexys_a7.xdc` | Pin assignment and 100 MHz clock constraint |
| `HW_testign_fpga/tb_mac_bist.sv`, `tb_top.sv` | Simulation of the BIST and of the full board design |

### Board Controls

| Control | Function |
|---|---|
| CPU_RESET | Reset |
| BTNC | Start a BIST run (64 jobs) |
| SW0 | Fault injection: corrupts one expected value, so the BIST must report FAIL |
| SW1 | Random output stalls (LFSR-driven `out_ready` backpressure) |
| LED16 green / red / blue | PASS / FAIL / busy |

### Results

| Check | Result |
|---|---|
| Simulation (`tb_top`): normal, fault, stalls, fault + stalls | ✅ green / red / green / red |
| Timing @ 100 MHz | ✅ WNS +0.479 ns, WHS +0.131 ns, 0 failing endpoints |
| Utilization (incl. BIST) | 245 LUT (0.39%), 79 FF (0.06%), 0 DSP, 0 BRAM, 8 IO |
| Power (vectorless estimate) | 0.101 W total (0.003 W dynamic) |
| On-board test | ✅ green / red / green / red |

Critical path: BIST job counter → ROM → pair mux → multiplier → accumulator (9.48 ns).
Reports: `HW_testign_fpga/reports/`

**DSP usage:** Vivado implemented the small 8×8 signed multiplier in LUTs and carry chains (0 DSP), since its synthesis heuristics found this cheap enough at 100 MHz.
DSP mapping can be forced with the `(* use_dsp = "yes" *)` attribute in `mac_datapath.sv`, which would also be the first step if more timing margin is needed.

### Build

1. Create a Vivado project for `xc7a100tcsg324-1`.
2. Add `rtl/*.sv` and `HW_testign_fpga/*.sv` (except testbenches) plus `vectors.mem` as design sources.
3. Add `nexys_a7.xdc` as a constraint; set `fpga_top` as top.
4. Run synthesis, implementation and bitstream generation, then program the board.

The bitstream is attached to the `m3` release.


## Future Work

- Manual mode: enter operands with switches and show the result on the 7-segment display (muxed into `fpga_top`)
- Register `in_a`/`in_b` to shorten the critical path and add timing margin
