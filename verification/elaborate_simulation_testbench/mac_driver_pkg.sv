package mac_pkg_tb;

    localparam int BEATS = 4;
    //reference model: plain integer math 
    function automatic int ref_model ( input int a[BEATS], input int b[BEATS] );
        int sum = 0;
        for(int i=0; i<4; i++) begin
            sum += a[i] * b[i];
        end
        return sum;
    endfunction

    class randomize_input;
        rand int a [BEATS];
        rand int b [BEATS];
        rand int gap[BEATS];
        rand int stall;

        //legal signed 8 bits range

        constraint input_range {
            foreach(a[i]) a[i] inside {[ -128 : 127 ]};
            foreach(b[i]) b[i] inside {[ -128 : 127 ]};
        }

        //conrner cases
        constraint c_edges{
            foreach (a[i]) a[i] dist { -128 := 10, 127 := 10, 0 := 5, -1 := 5, [-127:126] :/ 70 };
            foreach (b[i]) b[i] dist { -128 := 10, 127 := 10, 0 := 5, -1 := 5, [-127:126] :/ 70 };
        }

        // random timing
        constraint c_timing {
            foreach (gap[i]) gap[i] inside {[0:3]};
            stall inside {[0:5]};
        }        
    endclass
endpackage