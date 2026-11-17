

// Board wrapper for Nexys A7-100T: on-board BIST of the MAC accelerator.
// BTNC = start, SW0 = fault injection, SW1 = random stalls,
// LED16 green = PASS, LED16 red = FAIL, CPU_RESETN = reset.
module fpga_top (
    input  logic clk,        // 100 MHz, pin E3
    input  logic rst_n,      // CPU_RESETN, active-low
    input  logic btn_start,  // BTNC
    input  logic sw_fault,   // SW0
    input  logic sw_stall,   // SW1
    output logic led_pass,   // LED16_G
    output logic led_fail,   // LED16_R
    output logic led_busy  

);
    import mac_pkg::*;

    // ------------------------------------------------------------
    // 1. Reset synchronizer: active-low pin -> clean active-high rst
    // ------------------------------------------------------------
    logic rst_ff1, rst;

    always_ff @(posedge clk) begin
        rst_ff1 <= !rst_n;
        rst     <= rst_ff1;
    end

    // ------------------------------------------------------------
    // 2. Input synchronizers (button + switches) and start edge detect
    // ------------------------------------------------------------
    logic btn_ff1, btn_ff2, btn_ff3;
    logic fault_ff1, fault;
    logic stall_ff1, stall_en;
    logic start;

    always_ff @(posedge clk) begin
        //double FF for button and switches to avoid metastability
        btn_ff1   <= btn_start;
        btn_ff2   <= btn_ff1;
        btn_ff3   <= btn_ff2;      // previous value, for edge detect

        fault_ff1 <= sw_fault;
        fault     <= fault_ff1;

        stall_ff1 <= sw_stall;
        stall_en  <= stall_ff1;
    end

    assign start = btn_ff2 && !btn_ff3;   // one-cycle pulse on press

    // ------------------------------------------------------------
    // 3. LFSR for random output stalls (x^16 + x^14 + x^13 + x^11 + 1)
    // ------------------------------------------------------------
    logic [15:0] lfsr;
    logic        stall;

    always_ff @(posedge clk) begin
        if (rst)
            lfsr <= 16'hACE1;              // any non-zero seed
        else
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
    end

    assign stall = stall_en && lfsr[0];

    // ------------------------------------------------------------
    // 4. BIST controller <-> DUT (named signals: easy to add a mux later)
    // ------------------------------------------------------------
    logic                          dut_in_valid, dut_in_ready;
    logic signed [OP_WIDTH-1:0]    dut_in_a, dut_in_b;
    logic                          dut_out_valid, dut_out_ready;
    logic signed [OUT_WIDTH-1:0]   dut_out_data;
    logic                          busy, pass, fail;

    mac_bist_controller #(
        .N_JOBS   (64),
        .WORD_W   (84),
        .MEM_FILE ("vectors.mem")
    ) u_bist (
        .clk       (clk),
        .rst       (rst),
        .start     (start),
        .fault     (fault),
        .stall     (stall),
        .in_valid  (dut_in_valid),
        .in_ready  (dut_in_ready),
        .in_a      (dut_in_a),
        .in_b      (dut_in_b),
        .out_valid (dut_out_valid),
        .out_ready (dut_out_ready),
        .out_data  (dut_out_data),
        .busy      (busy),
        .pass      (pass),
        .fail      (fail)
    );

    mac_top u_mac_top (
        .clk       (clk),
        .rst       (rst),
        .in_valid  (dut_in_valid),
        .in_ready  (dut_in_ready),
        .in_a      (dut_in_a),
        .in_b      (dut_in_b),
        .out_valid (dut_out_valid),
        .out_ready (dut_out_ready),
        .out_data  (dut_out_data)
    );

    // ------------------------------------------------------------
    // 5. LEDs
    // ------------------------------------------------------------
    assign led_pass = pass;
    assign led_fail = fail;
    assign led_busy = busy;

endmodule

`default_nettype wire