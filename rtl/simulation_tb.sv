`timescale 1ns/1ps
module simulation_tb;
    import mac_pkg::*;
    parameter time clk_period = 10;
    logic clk = 0;
    logic rst;

    //signal declaration
    logic in_valid, in_ready, out_ready, out_valid;
    logic signed [OP_WIDTH-1:0] in_a, in_b;
    logic signed [OUT_WIDTH-1:0] out_data;

    int errors = 0;
    int jobs = 0;

    // DUT instantiation
    mac_top dut (
        .clk(clk),
        .rst(rst),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .out_ready(out_ready),
        .out_valid(out_valid),
        .in_a(in_a),
        .in_b(in_b),
        .out_data(out_data)
    );

    always # (clk_period/2) clk = ~clk;

    //reference model: plain integer math 
    function automatic int ref_model(input int a[4], input int b[4]);
        int sum = 0;
        for(int i=0; i<4; i++) begin
            sum += a[i] * b[i];
        end
        return sum;
    endfunction

    task automatic input_data_to_design(input int a, input int b);
        in_a <= a;
        in_b <= b;
        in_valid <= 1'b1;
        do @(posedge clk); while (!in_ready);
        in_valid <= 1'b0;
    endtask

    task automatic output_data_from_design(output int data);
        out_ready <= 1'b1;
        do @(posedge clk); while (!out_valid);
        data = out_data;
        out_ready <= 1'b0;
    endtask

    function void compare_results(input int expected, input int actual);
        if (expected !== actual) begin
            $display("ERROR: Expected %0d, got %0d", expected, actual);
            errors++;
        end
        else begin
            $display("PASS: Expected %0d, got %0d", expected, actual);
        end
    endfunction

    task automatic run_test(input int a[4], input int b[4]);
        int expected, actual;
        expected = ref_model(a, b);
        for(int i=0; i<4; i++) begin
            input_data_to_design(a[i], b[i]);
        end
        output_data_from_design(actual);
        compare_results(expected, actual);
        jobs++;
    endtask

    //test sequence
    initial begin
        rst = 1'b1;
        in_valid = 1'b0;
        out_ready = 1'b0;
        in_a = 0;
        in_b = 0;
        #30

        @(negedge clk);
        rst = 1'b0;
        // T1: simple mixed-sign job
        run_test('{3, -2, 7, -128}, '{4, 5, -1, -128});

        // T2: maximum result (all -128) -> +65536, needs all 18 bits
        run_test('{-128, -128, -128, -128}, '{-128, -128, -128, -128});

        // T3: minimum result (-128 * +127) x4 -> -65024
        run_test('{-128, -128, -128, -128}, '{127, 127, 127, 127});

        // T4: all zeros -> 0
        run_test('{0, 0, 0, 0}, '{0, 0, 0, 0});

        // T5: -1 * -1 x4 -> 4
        run_test('{-1, -1, -1, -1}, '{-1, -1, -1, -1});
        

        //summary 
        #50
        if (errors == 0) $display("=== ALL %0d JOBS PASSED ===", jobs);
        else             $display("=== %0d of %0d JOBS FAILED ===", errors, jobs);
        $finish;
    end

endmodule








