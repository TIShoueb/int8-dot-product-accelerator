`default_nettype none
module mac_top
    import mac_pkg::*;
(
    input  logic                        clk,
    input  logic                        rst,
    input  logic                        in_valid,
    output logic                        in_ready,
    input  logic                        out_ready,
    output logic                        out_valid,
    input  logic signed [OP_WIDTH-1:0]  in_a,
    input  logic signed [OP_WIDTH-1:0]  in_b,
    output logic signed [OUT_WIDTH-1:0] out_data
);

logic acc_en, acc_clr;

mac_controlpath u_mac_controlpath (
    .clk(clk),
    .rst(rst),
    .in_valid(in_valid),
    .in_ready(in_ready),
    .out_ready(out_ready),
    .out_valid(out_valid),
    .acc_en(acc_en),
    .acc_clr(acc_clr)
);

mac_datapath u_mac_datapath (
    .clk(clk),
    .acc_clr(acc_clr),
    .acc_en(acc_en),
    .in_a(in_a),
    .in_b(in_b),
    .out_data(out_data)
);

endmodule