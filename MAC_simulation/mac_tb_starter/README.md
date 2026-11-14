# MAC accelerator: M1 non-UVM simulation starter

## Files
- `tb/tb_top.sv`: DUT and verification module instances; directed and randomized tests
- `tb/mac_driver.sv`: send_pair and receive_result stimulus tasks
- `tb/mac_scoreboard.sv`: independent transaction-based reference model and immediate assertions
- `tb/mac_checker.sv`: concurrent SVA for stall, HOLD, and reset

## Assumed external RTL (not included)
- `rtl/mac_pkg.sv` defines `OP_WIDTH` = 8 and `OUT_WIDTH` = 20.
- `rtl/mac_top.sv` has ports `clk`, `rst`, `in_valid`, `in_ready`, `in_a`, `in_b`, `out_valid`, `out_ready`, `out_data`.
- The MAC accepts exactly four input pairs, then asserts registered `out_valid` after the fourth accepted edge, holding it until an output handshake.
- Synchronous active-high reset discards partial and pending results.
- A result is not accepted concurrently with a new input pair.

## Vivado setup
Add your RTL as **Design Sources** and the four `tb/*.sv` files as **Simulation Sources**. Ensure package `mac_pkg.sv` is compiled before consumers. Set `tb_top` as simulation top and run Behavioral Simulation.

## Status
Template only. The actual DUT was not supplied, so it has not been simulated against the user's RTL. If your simulator does not support hierarchical calls to module tasks or concurrent assertions, adapt the driver to an interface and/or check tool settings. This is intentionally not a complete verification closure environment.
