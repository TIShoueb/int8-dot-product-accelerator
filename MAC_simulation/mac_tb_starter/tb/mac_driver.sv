// Simple non-UVM stimulus driver. Tasks are called from tb_top.
module mac_driver (
    input  logic clk,
    input  logic in_ready,
    input  logic out_valid,
    output logic in_valid,
    output logic out_ready,
    output logic signed [mac_pkg::OP_WIDTH-1:0] in_a,
    output logic signed [mac_pkg::OP_WIDTH-1:0] in_b
);
    initial begin
        in_valid  = 0;
        out_ready = 0;
        in_a      = '0;
        in_b      = '0;
    end

    // Present one pair and hold it until accepted on a rising edge.
    task automatic send_pair(input int a, input int b);
        @(negedge clk);
        in_a     = a;
        in_b     = b;
        in_valid = 1;

        for (int n = 0; n < 30; n++) begin
            @(posedge clk);
            if (in_ready === 1'b1) begin
                @(negedge clk);
                in_valid = 0;
                return;
            end
        end
        $fatal(1, "Input handshake timeout");
    endtask

    // Keep output blocked for stall_cycles, then accept one result.
    task automatic receive_result(input int stall_cycles);
        repeat (stall_cycles) @(negedge clk);
        @(negedge clk);
        out_ready = 1;

        for (int n = 0; n < 30; n++) begin
            @(posedge clk);
            if (out_valid === 1'b1) begin
                @(negedge clk);
                out_ready = 0;
                return;
            end
        end
        $fatal(1, "Output handshake timeout");
    endtask
endmodule
