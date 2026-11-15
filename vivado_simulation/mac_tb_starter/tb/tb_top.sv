`timescale 1ns/1ps

module tb_top;
    import mac_pkg::*;

    logic clk = 0;
    logic rst = 1;
    logic in_valid, in_ready, out_valid, out_ready;
    logic signed [OP_WIDTH-1:0] in_a, in_b;
    logic signed [OUT_WIDTH-1:0] out_data;
    int jobs;

    always #5 clk = ~clk; // 100 MHz

    mac_top        dut (.*);
    mac_driver     drv (.*);
    mac_scoreboard sb  (.*);
    mac_checker    chk (.*);

    task automatic run_job(input int a[4], input int b[4],
                           input int stalls);
        for (int i = 0; i < 4; i++)
            drv.send_pair(a[i], b[i]);
        drv.receive_result(stalls);
    endtask

    initial begin
        repeat (3) @(negedge clk);
        rst = 0;

        // T1: signed arithmetic + five cycles of output backpressure
        run_job('{3,-2,7,-128}, '{4,5,-1,-128}, 5); // expected 16379

        // T2: maximum positive sum
        run_job('{-128,-128,-128,-128},
                '{-128,-128,-128,-128}, 0);         // expected 65536

        // T3: input gaps; result must not appear after only 3 beats
        drv.send_pair(2, 3);
        drv.send_pair(4, 5);
        drv.send_pair(-2, 6);
        repeat (10) @(negedge clk);
        drv.send_pair(3, 7);
        drv.receive_result(0);                     // expected 35

        // T4: reset after 2 beats; old partial job is discarded
        drv.send_pair(9, 9);
        drv.send_pair(8, 8);
        @(negedge clk);
        rst = 1;
        repeat (2) @(negedge clk);
        rst = 0;
        run_job('{1,1,1,1}, '{2,2,2,2}, 0);        // expected 8

        // T5: 10 randomized jobs (repeatable with a simulator seed)
        repeat (10) begin
            for (int i = 0; i < 4; i++) begin
                repeat ($urandom_range(0, 3)) @(negedge clk);
                drv.send_pair($urandom_range(0,255) - 128,
                              $urandom_range(0,255) - 128);
            end
            drv.receive_result($urandom_range(0, 5));
        end

        repeat (3) @(negedge clk);
        if (jobs != 14)
            $fatal(1, "Expected 14 completed jobs, got %0d", jobs);
        $display("ALL %0d JOBS PASSED", jobs);
        $finish;
    end

    initial begin
        #100000;
        $fatal(1, "Global simulation timeout");
    end
endmodule
