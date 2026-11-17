
module mac_datapath
    import mac_pkg::*;
(
    input  logic            clk,
    input  logic            acc_clr,
    input  logic            acc_en,
    input  logic signed [OP_WIDTH-1:0] in_a,
    input  logic signed [OP_WIDTH-1:0] in_b,
    output logic signed [OUT_WIDTH-1:0] out_data
);

(* use_dsp = "yes" *) logic signed [ACC_WIDTH-1:0] acc;   //to force vivado to use DSP for multiplication and addition,
assign out_data = {{(OUT_WIDTH-ACC_WIDTH){acc[ACC_WIDTH-1]}}, acc};


always_ff @(posedge clk) begin

    if(acc_clr) begin
        acc <= '0;
    end
    else if(acc_en) begin 
        acc <= acc + (in_a * in_b);
    end 
    else begin
        acc <= acc;
    end
end
endmodule

`default_nettype wire
