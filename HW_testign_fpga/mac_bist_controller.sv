//------------------------------------------------------------------------------
// File    : mac_bist.sv
// Project : INT8 Dot-Product Accelerator
// Purpose : On-board built-in self-test (BIST) for mac_top.
//           Reads test jobs + expected results from a ROM (vectors.mem),
//           sends each job's 4 pairs to the accelerator with the valid/ready
//           handshake, takes the result, compares it, and reports PASS/FAIL.
//
//           fault = 1 : corrupts the expected value of job FAULT_JOB, so the
//                       test MUST report FAIL (proves the test can fail).
//           stall = 1 : holds out_ready low this cycle (random backpressure).
//------------------------------------------------------------------------------

module mac_bist_controller
    import mac_pkg::*;
#(
    parameter int N_JOBS,
    parameter int WORD_W,
    parameter string MEM_FILE
)
(
    input  logic                        clk,
    input  logic                        rst,
    input  logic                        start,
    input  logic                        fault,      // inject a wrong expected value
    input  logic                        stall,      // withhold out_ready this cycle
                       
    // ---- source side: BIST -> mac_top ----
    output logic                        in_valid,
    input  logic                        in_ready,
    output logic signed [OP_WIDTH-1:0]  in_a,
    output logic signed [OP_WIDTH-1:0]  in_b,

    // ---- receiver side: mac_top -> BIST ----
    input  logic                        out_valid,
    output logic                        out_ready,
    input  logic signed [OUT_WIDTH-1:0] out_data,

    // ---- status for the LEDs ----
    output logic                        busy,    //need some delay to indicate the busy status, because the bist is too fast to see the led change
    output logic                        pass,
    output logic                        fail
);
// FSM
// IDLE ──start──▶ SEND ──4th pair accepted──▶
// WAIT ──result taken──▶ CHECK ──more jobs──▶ SEND
//                          └──last job──▶ DONE (pass/fail)

logic [$clog2(N_JOBS)-1:0] job_cnt;  // number of jobs completed (0..N_JOBS-1)
logic [1:0] pair_cnt;                // number of pairs sent for the current job (0..3)
logic signed [OUT_WIDTH-1:0] expected;  // expected result for the current job
logic signed [OUT_WIDTH-1:0] result;    // result from the DUT for the current job
logic [WORD_W-1:0] job_data;  // 4 pairs + expected result for the current job 
logic in_fire, out_fire;
logic error;  // set if any job fails

//=========ROM instantiation=========
mac_rom #(
    .N_JOBS(N_JOBS),
    .WORD_W(WORD_W),
    .MEM_FILE(MEM_FILE)
    
) u_mac_rom (
    .addr(job_cnt),
    .data(job_data)
);

typedef enum logic[2:0] { IDLE, SEND, WAIT, CHECK, DONE } bist_state_t;
bist_state_t state;


    // ---------------- handshake (from the state only) ----------------
assign in_valid  = (state == SEND);
assign out_ready = (state == WAIT) && !stall;
assign in_fire   = in_valid  && in_ready;
assign out_fire  = out_valid && out_ready;
assign busy      = (state != IDLE);       // includes DONE: pass/fail are written when leaving DONE


// ---------------- current pair: chosen by pair_cnt ----------------
// word layout: a0 b0 a1 b1 a2 b2 a3 b3 expected  (pair p starts at bit WORD_W-1-16p)
assign in_a = job_data[WORD_W-1            - 2*OP_WIDTH*pair_cnt -: OP_WIDTH];
assign in_b = job_data[WORD_W-1 - OP_WIDTH - 2*OP_WIDTH*pair_cnt -: OP_WIDTH];


//==============expected value deduct from rom, and inject fault in fault cycle===============
localparam int FAULT_cycle = 10; // cycle to inject fault

assign expected = (fault && job_cnt == FAULT_cycle)
                ? job_data[OUT_WIDTH-1:0] + 1
                : job_data[OUT_WIDTH-1:0];

always_ff@(posedge clk) begin 
    if(rst) begin
        state <= IDLE;
        pair_cnt <= '0;
        job_cnt <= '0;
        error <= 1'b0;
        result <= 0;
        pass <= 1'b0;
        fail <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                if(start) begin
                    error <= 0;
                    job_cnt <= 0;
                    pair_cnt <= 0;
                    pass     <= 1'b0;      // clear the old outcome
                    fail     <= 1'b0;
                    state <= SEND;
                end
            end 
            SEND: begin
                if (in_fire) begin
                    if (pair_cnt == 2'd3) begin      // the 4th pair was just accepted
                        pair_cnt <= '0;
                        state    <= WAIT;
                    end else begin
                        pair_cnt <= pair_cnt + 1'b1;
                    end
                end
            end
                
            WAIT: begin
                if(out_fire) begin
                    state <= CHECK;
                    result <= out_data;
                end

            end
            CHECK: begin
                if(result != expected) begin
                    error <= 1'b1;
                end
                if(job_cnt < N_JOBS-1) begin
                    job_cnt <= job_cnt + 1'b1;
                    state <= SEND;
                end else begin
                    state <= DONE;
                end
                end
            DONE: begin
                pass  <= !error;
                fail  <=  error;
                state <= IDLE;                 // outcome stays in pass/fail until next start
            end
            default : state <= IDLE;
        endcase
    end
end

endmodule