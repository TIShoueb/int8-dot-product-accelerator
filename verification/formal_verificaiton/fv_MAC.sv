`default_nettype none

module fv_MAC 
    import mac_pkg::*; 
(
    input logic             clk,        // Input
    input logic             rst,        // Input
    input logic             in_valid,   // Input
    input logic            in_ready,   // Output
    input logic             out_ready,  // Input
    input logic            out_valid,  // Output
    input logic signed [OP_WIDTH-1:0]  in_a,   // Input
    input logic signed [OP_WIDTH-1:0]  in_b,   // Input
    input logic signed [OUT_WIDTH-1:0] out_data,  //Output 
    input state_t          state
);

    // Define the default clock for every property
    default clocking default_clk @(posedge clk); endclocking

    //auxilary logic for calculation refference model 
    logic [2:0] cnt;                          // accepted pairs in the current job
    logic       in_fire, out_fire;
    int         exp_sum;                      // reference sum (32-bit, independent of RTL width)
 
    assign in_fire  = in_valid  && in_ready;
    assign out_fire = out_valid && out_ready;
 
    always_ff @(posedge clk) begin
        if (rst || out_fire) begin
            cnt     <= '0;
            exp_sum <= 0;
        end else if (in_fire) begin
            cnt     <= cnt + 1'b1;
            exp_sum <= exp_sum + int'(in_a) * int'(in_b);
        end
    end


    //assumptions
    assume property (!in_valid |-> ##[1:4] in_valid);

    //sequences
    sequence seq_in_fire;
        ##0 in_valid && in_ready
    ;endsequence

    sequence seq_out_fire;
        ##0 out_valid && out_ready
    ;endsequence

    property check_reset;
        ##0 rst
    |->
        ##0 !in_ready 
        ##0 !out_valid
        ##1 out_data == '0      // check that output is cleared 1 cycle after reset(design choice, not spcificed in specificcaiton)
    ;endproperty
    a_check_reset: assert property(check_reset);

    property system_after_reset;
        ##0 $fell(rst)
    |->
        ##0 in_ready
        ##0 !out_valid
    ;endproperty
    a_system_after_reset: assert property(system_after_reset);

    property in_ready_after_out_fire;
        disable iff(rst)
        ##0 seq_out_fire
    |->
        ##1 in_ready
        ##0 !out_valid
        ##0 out_data == '0
    ;endproperty
    a_in_ready_after_out_fire: assert property(in_ready_after_out_fire);


    property out_valid_after_4_inputs;
        disable iff(rst)
        ##0 $fell(rst) || $fell(out_fire)
    |-> 
    	##0 in_fire[-> 4]
        ##1 out_valid
        ##0 !in_ready
    ;endproperty
    a_out_valid_after_4_inputs: assert property(out_valid_after_4_inputs);

    property out_valid_stable_until_out_ready;
        logic  [OUT_WIDTH-1:0] out_data_prev;

        disable iff(rst)
        ##0 out_valid
         && !out_ready
        ##0 (1'b1, out_data_prev = out_data)
    |-> 
        ##1 out_valid
        ##0 state == HOLD      // for covering the HOLD statement in coverage
        ##0 !in_ready
         && (out_data == out_data_prev)
    ;endproperty
    a_out_valid_stable_until_out_ready: assert property(out_valid_stable_until_out_ready);
 
    property no_input_while_out_valid;
    	disable iff(rst)
        (out_valid == !in_ready)
    ;endproperty
    a_no_input_while_out_valid: assert property(no_input_while_out_valid);

    property out_data_correctness;

        disable iff(rst)
        ##0 out_valid
    |->
        ##0 out_data == $signed(exp_sum)
    ;endproperty
    a_out_data_correctness: assert property(out_data_correctness);
    

    //======================================
    //========== cover properties ==========
    c_stall: cover property (disable iff(rst)
        (out_valid && !out_ready));
    c_back_to_back: cover property (disable iff(rst)
        (in_fire[*4] ##1 out_fire));
    c_input_gaps: cover property (disable iff(rst)
        in_ready && !in_valid && cnt inside {[1:3]});
    sc_reset_mid_job:  cover property (rst && cnt== 3'd4);
   
   // hold_Cover: cover property (state == HOLD);



endmodule


bind mac_top fv_MAC u_fv_MAC (
    .clk(clk),
    .rst(rst),
    .in_valid(in_valid),
    .in_ready(in_ready),
    .out_ready(out_ready),
    .out_valid(out_valid),
    .in_a(in_a),
    .in_b(in_b),
    .out_data(out_data),
    .state(u_mac_controlpath.state)
    
);