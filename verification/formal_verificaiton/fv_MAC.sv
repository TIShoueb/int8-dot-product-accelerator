`default_nettype none

module fv_fifo 
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
    input logic signed [OUT_WIDTH-1:0] out_data  //Output 
)

    // Define the default clock for every property
    default clocking default_clk @(posedge clk); endclocking

    //auxilary logic for calculation refference model 
    int exp_sum;

    always_ff @(posedge clk) begin
        if (rst || out_fire) exp_sum <= 0;                          // new job
        else if (in_fire)    exp_sum <= exp_sum + int'(in_a) * int'(in_b);
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
        ##0 out_data == '0    
    ;endproperty
    a_check_reset: assert property(check_reset);

    property in_ready_after_reset;
        ##0 $fall(rst)
    |->
        ##0 in_ready
        ##0 !out_valid
        ##0 out_data == '0
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



    property out_valid_after_4_inputs;
        disable iff(rst)
        ##0 seq_in_fire [-> 4]
    |-> 
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
        ##0 !in_ready
         && (out_data == out_data_prev)
    ;endproperty
    a_out_valid_stable_until_out_ready: assert property(out_valid_stable_until_out_ready);
 
    property no_input_while_out_valid;
        !(out_valid && in_ready)
    ;endproperty
    a_no_input_while_out_valid: assert property(no_input_while_out_valid);

    property out_data_correctness;

        disable iff(rst)
        ##0 out_valid
    |->
        ##0 out_data == $signed(exp_sum)
    ;endproperty
    a_out_data_correctness: assert property(out_data_correctness);

endmodule


bind mac_top fv_fifo u_fv_fifo (
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





         
