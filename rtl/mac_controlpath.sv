`default_nettype none 

module mac_controlpath
    import mac_pkg::*;
(
    input  logic            clk,
    input  logic            rst,
    input  logic            in_valid,
    output logic            in_ready,
    input  logic            out_ready,
    output logic            out_valid,
    output logic            acc_en,
    output logic            acc_clr
);
state_t next_state, state;
logic[2:0] cnt, cnt_next;

assign acc_en = in_ready && in_valid; 
assign acc_clr = rst || (out_ready && out_valid) ;

always_comb begin
    out_valid = 1'b0;
    in_ready  = 1'b0;
    cnt_next = cnt;
    next_state = state;

    case(state)
        ACCUMULATE: begin
            if(in_valid && cnt<=3) begin
                in_ready = 1'b1;
                cnt_next = cnt + 1;
            end
            else if(cnt == 4) begin
                out_valid = 1'b1;
                if (out_ready) begin
                    cnt_next = 0;
                    next_state = ACCUMULATE;
                end
                else begin
                    next_state = HOLD;
                end
            end
        end

        HOLD: begin
            out_valid = 1'b1;
            if (out_ready) begin
                cnt_next = 0;
                next_state = ACCUMULATE;
            end
            else begin
                next_state = HOLD;
            end
        end

   endcase

end


always_ff @(posedge clk) begin
    if(rst) begin
        state <= ACCUMULATE;
        cnt <= 0;
    end
    else begin
        state <= next_state;
        cnt <= cnt_next;
    end
end

endmodule

`default_nettype wire