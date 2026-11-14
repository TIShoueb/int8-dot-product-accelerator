`default_nettype none

module mac_checker
    import mac_pkg::*;
#(
    parameter string REPORT_FILE =
    "C:/Users/toush/Desktop/emecs/self_project/int8-dot-product-accelerator/verification/elaborate_simulation_testbench/results/checker_report.txt"
    )
(
    input  logic                        clk,
    input  logic                        rst,
    input  logic                        in_valid,
    input logic                        in_ready,
    input logic                        out_valid,
    input logic                        out_ready,
    input logic signed [OUT_WIDTH-1:0] out_data
);

    default clocking chk_cb @(posedge clk); endclocking

    //count accepted beats

    logic in_fire, out_fire;
    logic [2:0] cnt;

    assign in_fire = in_valid && in_ready;
    assign out_fire = out_valid && out_ready;


    //count number of accepted input pairs
    always_ff @(posedge clk) begin
        if(rst || out_fire) cnt <= 0;
        else if(in_fire) cnt <= cnt + 1;
    end

    //failure counting signal 
    int f_p1a, f_p1b, f_p2a, f_p2b, f_p3a, f_p3b, f_p4a, f_p4b; 


    // --------------------------------------------------------------
    // P1: reset behaviour
    // --------------------------------------------------------------
    // while reset is high, no handshake is possible
    a_rst_no_handshake: assert property (rst |-> !in_ready && !out_valid)
    else begin
        f_p1a++;
        $error("P1a: in_ready/out_valid not low during reset");
    end
    // first cycle after reset: idle (ready for a new job, no result)
    a_rst_idle: assert property ($fell(rst) |-> in_ready && !out_valid)
    else begin
        f_p1b++;
        $error("P1b: design not idle after reset");
    end
    // P2: output stable and no input accepted while stalled 
    a_out_data_stable: assert property (disable iff(rst)
        out_valid && !out_ready |-> ##1 out_valid && $stable(out_data))
        else begin
            f_p2a++; 
            $error("P2a: output changed while stalled");
        end
    a_no_input_while_stalled: assert property (disable iff(rst)
        out_valid && !out_ready |-> ##1 !in_fire)
        else begin
            f_p2b++; 
            $error("P2b: input accepted while stalled");
        end
    // p3: result only after 4 accepted pairs 
    a_result_after_4: assert property (disable iff(rst)
        out_valid |-> cnt == 4)
        else begin
            f_p3a++; 
            $error("P3a: result produced before 4 accepted pairs");
        end
    a_no_5th_beat: assert property (disable iff(rst)
        in_fire |-> cnt < 3'd4)
        else begin
            f_p3b++; 
            $error("P3b: more than 4 pairs were accepted before result was produced");
        end
    // p4: latency check
    a_out_valid_after_4pairs: assert property (disable iff(rst)
        in_fire && cnt == 3'd3|-> !out_valid ##1 out_valid)
        else begin
            f_p4a++; 
            $error("P4a: output not valid 1 cycles after 4th input pair");
        end
    a_restart_next_cycle: assert property (disable iff(rst)
        out_fire |-> ##1 in_ready)
        else begin
            f_p4b++; 
            $error("P4b: input not accepted next cycle after output accepted");
        end
    //======================================
    //========== cover properties ==========
    // vivado ignores cover properties, we use them to count scenarios exercised manually
        c_stall: cover property (disable iff(rst)
            (out_valid && !out_ready));
        c_back_to_back: cover property (disable iff(rst)
            (in_fire[*4] ##1 out_fire));
        c_input_gaps: cover property (disable iff(rst)
            in_ready && !in_valid && cnt inside {[1:3]});
        sc_reset_mid_job:  cover property (rst && cnt== 3'd4);

    //withness counter ===== manual cover properties 
    int n_results, n_stall_cycles, n_back_to_back, n_reset_mid_job, n_reset_in_hold, n_input_gap;
    logic out_fire_d;                   // out_fire, one cycle delayed,,, substitute for ##1 sequence or $past 

    always_ff @(posedge clk) begin
        out_fire_d <= out_fire;
        if (!rst && out_fire)                                   n_results++;
        if (!rst && out_valid && !out_ready)                    n_stall_cycles++;
        if (!rst && out_fire_d && in_fire)                      n_back_to_back++;
        if (!rst && in_ready && !in_valid && cnt inside {[1:3]}) n_input_gap++;
        if (rst && cnt inside {[1:3]})                          n_reset_mid_job++;
        if (rst && cnt == 3'd4)                                 n_reset_in_hold++;
    end



    //summary 
    final begin
        int fd = $fopen(REPORT_FILE, "w");
        $fdisplay(fd, "=== mac_checker report ===");
        $fdisplay(fd, "-- assertion failures (must all be 0) --");
        $fdisplay(fd, "P1a reset: no handshake      : %0d", f_p1a);
        $fdisplay(fd, "P1b idle after reset         : %0d", f_p1b);
        $fdisplay(fd, "P2a  output stable in stall   : %0d", f_p2a);
        $fdisplay(fd, "P3a result after 4 pairs     : %0d", f_p3a);
        $fdisplay(fd, "P3b no 5th pair              : %0d", f_p3b);
        $fdisplay(fd, "P2b  no input while waiting   : %0d", f_p2b);
        $fdisplay(fd, "LAT latency = 1 cycle        : %0d", f_p4a);
        $fdisplay(fd, "LAT restart next cycle       : %0d", f_p4b);
        $fdisplay(fd, "-- scenarios exercised (must be > 0) --");
        $fdisplay(fd, "results taken                : %0d", n_results);
        $fdisplay(fd, "stall cycles                 : %0d", n_stall_cycles);
        $fdisplay(fd, "back-to-back restarts        : %0d", n_back_to_back);
        $fdisplay(fd, "reset during a job (cycles)  : %0d", n_reset_mid_job);
        $fdisplay(fd, "reset while holding (cycles) : %0d", n_reset_in_hold);
        $fdisplay(fd, "gap within 4 consequitive inputs : %0d", n_input_gap);
        $fclose(fd);
    end



endmodule


// attach the checker to every instance of mac_top
bind mac_top mac_checker u_checker (.*);