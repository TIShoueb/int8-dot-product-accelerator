//------------------------------------------------------------------------------
// File    : tb_top.sv
// Purpose : Simulates fpga_top like the real board: drive the pins
//           (rst_n, btn_start, sw_fault, sw_stall), check the LEDs.
//           4 runs: normal (green), fault (red), stalls (green), fault+stalls (red).
//------------------------------------------------------------------------------
`timescale 1ns/1ps
module tb_top;
    logic clk = 0;
    logic rst_n, btn_start, sw_fault, sw_stall;
    logic led_pass, led_fail, led_busy;
    int   errors = 0;

    always #5 clk = ~clk;                 // 100 MHz

    fpga_top dut (.*);                    // vectors.mem must be in the simulation folder

    // Press the button like a person: switches set first, button held, then released.
    task automatic run(input logic f, input logic s, input logic expect_pass, input string name);
        sw_fault = f;
        sw_stall = s;
        repeat (5)  @(negedge clk);       // let the switch synchronizers settle
        btn_start = 1;
        repeat (20) @(negedge clk);       // button held for a while
        btn_start = 0;
        wait (led_pass || led_fail);      // BIST finished
        @(negedge clk);
        if (led_pass === expect_pass && led_fail === !expect_pass)
            $display("%s: OK    (green=%b red=%b)", name, led_pass, led_fail);
        else begin
            errors++;
            $display("%s: WRONG (green=%b red=%b)", name, led_pass, led_fail);
        end
    endtask

    initial begin
        rst_n = 0; btn_start = 0; sw_fault = 0; sw_stall = 0;   // reset button pressed
        repeat (5) @(negedge clk);
        rst_n = 1;                                              // released
        repeat (5) @(negedge clk);

        if (led_pass || led_fail) begin errors++; $display("LEDs not off after reset"); end

        run(0, 0, 1, "normal run    ");
        run(1, 0, 0, "fault injected");
        run(0, 1, 1, "random stalls ");
        run(1, 1, 0, "fault + stalls");

        if (errors == 0) $display("=== TOP OK ===");
        else             $display("=== TOP PROBLEM (%0d) ===", errors);
        $finish;
    end
endmodule