`timescale 1ns/1ps
module simulation_tb;
    import mac_pkg_tb::*;
    import mac_pkg::*;
    // ------------------------------------------------------------
    // Configuration
    // ------------------------------------------------------------
    localparam time clk_period     = 10;    // 100 MHz
    localparam int  N_RANDOM       = 100;   // random jobs
    localparam int  N_BACK_TO_BACK = 20;    // back-to-back jobs
    localparam time SETTLE         = 1;     // let combinational outputs settle
    
    parameter string RESULTS_FILE =
    "C:/Users/toush/Desktop/emecs/self_project/int8-dot-product-accelerator/verification/elaborate_simulation_testbench/results/results.csv";
    
    logic clk = 0;
    logic rst;
    //signal declaration
    logic in_valid, in_ready, out_ready, out_valid;
    logic signed [OP_WIDTH-1:0] in_a, in_b;
    logic signed [OUT_WIDTH-1:0] out_data;

    int errors = 0;
    int jobs = 0;
    int fd;    

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


    task automatic apply_reset();
        rst = 1'b1;
        in_valid = 1'b0;
        out_ready = 1'b0;
        repeat (2) @(negedge clk);
        rst = 1'b0;
    endtask

    task automatic input_data_to_design(input int a, input int b);
        in_a <= a;
        in_b <= b;
        in_valid <= 1'b1;
        #1
        while (!in_ready)            // check BEFORE the edge
            @(negedge clk) #1;
        @(negedge clk); 
        in_valid <= 1'b0;
    endtask
    task automatic output_data_from_design(output int data);
        out_ready <= 1'b1;
        #1
        while (!out_valid)             // check BEFORE the edge
            @(negedge clk) #1;
        
        data = out_data;               
        @(negedge clk);
        out_ready <= 1'b0;
    endtask

    function void compare_results(input int expected, input int actual);
        jobs++;
        $fdisplay(fd, "%0d,%0d,%0d,%s", jobs, expected, actual,
                (expected === actual) ? "PASS" : "FAIL");
        if (expected !== actual) begin
            $display("ERROR: Expected %0d, got %0d", expected, actual);
            errors++;
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
    // one random job: random gap before each pair, random stall before taking the result
    task automatic run_random_test(randomize_input random_job);
        int actual;
        for(int i=0; i<4; i++) begin
            repeat (random_job.gap[i]) @(negedge clk);     // input gap   (in_valid = 0)
            input_data_to_design(random_job.a[i], random_job.b[i]);
        end
        repeat (random_job.stall) @(negedge clk);          // backpressure (out_ready = 0)
        output_data_from_design(actual);
        compare_results(ref_model(random_job.a, random_job.b), actual);
    endtask
    // back-to-back: sender and receiver run at the same time (fork),
    // expected results wait in a queue until the matching result arrives
    task automatic run_back_to_back(input int n);
        int expected_q[$];
        randomize_input random_job=new();
        fork
            begin
                repeat(n) begin
                    random_job.randomize();
                    expected_q.push_back(ref_model(random_job.a, random_job.b));
                    for(int i=0; i<4; i++) begin
                        input_data_to_design(random_job.a[i], random_job.b[i]);
                    end
                end
            end
            begin 
                int recieved = 0;
                out_ready <= 1'b1;
                while(recieved < n) begin
                    #1
                    if (out_valid) begin
                        compare_results(expected_q.pop_front(), out_data);
                        recieved++;
                    end
                    @(negedge clk);
                end
                out_ready <= 1'b0;
            end

        join
    endtask


    //================= TEST SEQUENCE =================

    initial begin

        randomize_input random_job = new();
        fd = $fopen(RESULTS_FILE, "w");                       // ← new
        if (fd == 0) $fatal(1, "Cannot open %s", RESULTS_FILE);
        $fdisplay(fd, "job,expected,actual,status"); 


        apply_reset();
        
        // T1: directed arithmetic
        $display("T1: directed arithmetic");
        run_test('{3, -2, 7, -128},         '{4, 5, -1, -128});          // mixed signs
        run_test('{0, 0, 0, 0},             '{0, 0, 0, 0});  
        run_test('{-128, -128, -128, -128}, '{-128, -128, -128, -128});  // max  +65536
        run_test('{-128, -128, -128, -128}, '{127, 127, 127, 127});      // min  -65024            // zero
        run_test('{-1, -1, -1, -1},         '{-1, -1, -1, -1});          // neg x neg



        // T2: reset in the middle of a job -> old pairs must be discarded
        $display("T2: reset mid-job");
        input_data_to_design(100, 100);
        input_data_to_design(100, 100);
        apply_reset();
        run_test('{1, 2, 3, 4}, '{1, 1, 1, 1});                          // expect 10


        
        // T3: reset while a result is waiting -> old result must disappear
        $display("T3: reset while a result is waiting");
        for(int i=0; i<4; i++) input_data_to_design(50, 50);
        #1;
        apply_reset();
        repeat (3) @(negedge clk);
        #1;
        if (out_valid)  begin errors++; $display("ERROR: T7 old result survived reset"); end
        @(negedge clk);
        run_test('{2, 2, 2, 2}, '{3, 3, 3, 3});                          // expect 24

        
        
        
        // T4: Randomized test
        $display("T4: 200 random jobs");
        repeat (100) begin
            random_job.randomize();
            run_random_test(random_job);
        end

        
        
        // T5: Back-to-back test
        $display("T8: 20 back-to-back jobs");
        run_back_to_back(N_BACK_TO_BACK);
        
        
        
        
        #100
        // 3. Summary
        if (errors == 0) begin
            $display("All %0d jobs passed", jobs);
        end else begin
            $display("%0d jobs failed", errors);
        end
        $fclose(fd);     
        $finish;
    end


endmodule