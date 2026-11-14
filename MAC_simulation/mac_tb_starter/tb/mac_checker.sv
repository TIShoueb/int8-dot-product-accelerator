// Interface-level concurrent SVA, reusable in simulation and formal.
module mac_checker (
    input logic clk, rst,
    input logic out_valid, out_ready, in_ready,
    input logic signed [mac_pkg::OUT_WIDTH-1:0] out_data
);
    // A pending result must remain valid and unchanged until accepted.
    a_stable: assert property (
        @(posedge clk) disable iff (rst)
        (out_valid && !out_ready) |=> (out_valid && $stable(out_data))
    ) else $fatal(1, "Output changed while stalled");

    // This design cannot accept a new pair while holding a result.
    a_hold: assert property (
        @(posedge clk) disable iff (rst)
        out_valid |-> !in_ready
    ) else $fatal(1, "in_ready high during output HOLD");

    // Registered synchronous reset discards a pending result.
    a_reset: assert property (
        @(posedge clk) rst |=> !out_valid
    ) else $fatal(1, "Reset did not clear out_valid");
endmodule
