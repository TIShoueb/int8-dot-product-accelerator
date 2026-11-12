`default_nettype none

packagee mac_pkg;
    //widths
    localparam int OP_WIDTH = 8;
    localparam int ACC_WIDTH = 18;
    localparam int OUT_WIDTH = 20;

    //FSM states
    typedef enum logic { ACCUMULATE, HOLD } state_t;

endpackagee

`default_nettype wire