// Black-box reference model: watches accepted transfers, not driver calls.
module mac_scoreboard (
    input  logic clk, rst,
    input  logic in_valid, in_ready,
    input  logic out_valid, out_ready,
    input  logic signed [mac_pkg::OP_WIDTH-1:0] in_a, in_b,
    input  logic signed [mac_pkg::OUT_WIDTH-1:0] out_data,
    output int jobs
);
    import mac_pkg::*;
    int beats = 0;
    int expected = 0;
    initial jobs = 0;

    always @(posedge clk) begin
        if (rst) begin
            beats    = 0;
            expected = 0;
        end else begin
            // Immediate assertions: check observable behavior.
            if (out_valid === 1'b1) begin
                assert (beats == 4)
                    else $fatal(1, "Early/duplicate result: beats=%0d", beats);
                assert (out_data === expected[OUT_WIDTH-1:0])
                    else $fatal(1, "Wrong result: expected=%0d, actual=%0d",
                                expected, $signed(out_data));
            end

            // Output must arrive at next sampled edge after beat 4.
            if (beats == 4)
                assert (out_valid === 1'b1)
                    else $fatal(1, "Missing/late result");

            if (in_valid === 1'b1 && in_ready === 1'b1) begin
                assert (beats < 4)
                    else $fatal(1, "Unexpected fifth input beat");
                expected += $signed(in_a) * $signed(in_b);
                beats++;
            end

            if (out_valid === 1'b1 && out_ready === 1'b1) begin
                jobs++;
                $display("PASS job=%0d result=%0d", jobs, $signed(out_data));
                beats    = 0;
                expected = 0;
            end
        end
    end
endmodule
