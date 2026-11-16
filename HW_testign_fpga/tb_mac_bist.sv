//------------------------------------------------------------------------------
// File    : tb_bist.sv
// Purpose : Simulates mac_bist + mac_top: normal run (PASS), fault injected (FAIL),
//           random stalls (PASS), fault + stalls (FAIL). mac_checker stays bound.
//------------------------------------------------------------------------------
`timescale 1ns/1ps
module tb_mac_bist;
    import mac_pkg::*;
    logic clk = 0, rst, start, fault, stall_en, stall;
    logic in_valid, in_ready, out_valid, out_ready, busy, pass, fail;
    logic signed [OP_WIDTH-1:0] in_a, in_b;
    logic signed [OUT_WIDTH-1:0] out_data;
    logic [7:0] lfsr = 8'hA5;
    int errors = 0;

    always #5 clk = ~clk;
    always @(posedge clk) lfsr <= {lfsr[6:0], lfsr[7]^lfsr[5]^lfsr[4]^lfsr[3]};
    assign stall = stall_en && lfsr[0];

    mac_bist_controller #(.MEM_FILE("vectors.mem")) u_bist (.*);   // vectors.mem must be in the simulation folder
    mac_top  dut (.*);

    task automatic run(input logic f, input logic s, input logic expect_pass, input string name);
        fault = f; stall_en = s;
        @(negedge clk) start = 1; @(negedge clk) start = 0;
        wait (!busy); @(negedge clk);
        if (pass === expect_pass && fail === !expect_pass) $display("%s: OK (pass=%b fail=%b)", name, pass, fail);
        else begin errors++; $display("%s: WRONG (pass=%b fail=%b)", name, pass, fail); end
    endtask

    initial begin
        rst = 1; start = 0; fault = 0; stall_en = 0;
        repeat (3) @(negedge clk); rst = 0;
        run(0, 0, 1, "normal run       ");
        run(1, 0, 0, "fault injected   ");
        run(0, 1, 1, "random stalls    ");
        run(1, 1, 0, "fault + stalls   ");
        if (errors == 0) $display("=== BIST OK ==="); else $display("=== BIST PROBLEM ===");
        $finish;
    end
endmodule