`default_nettype none

package mac_pkg;
    //widths
    localparam int OP_WIDTH = 8;
    localparam int ACC_WIDTH = 18;
    localparam int OUT_WIDTH = 20;

    //FSM states
    typedef enum logic { ACCUMULATE, HOLD } state_t;

endpackage
