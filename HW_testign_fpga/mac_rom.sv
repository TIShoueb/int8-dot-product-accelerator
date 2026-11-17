
module mac_rom #(
    parameter int N_JOBS = 64,
    parameter int WORD_W = 84,
    parameter string MEM_FILE = "vectors.mem"
)(
    input logic [$clog2(N_JOBS)-1:0] addr,     //address of the job to read
    output logic [WORD_W-1:0] data      // 84 bits data to send, 4 pairs of 8-bit inputs and 20 bits expected output
);


    logic [WORD_W-1:0] mem [0:N_JOBS-1]; // memory array to store the data

    initial begin
        $readmemh(MEM_FILE, mem); // read the memory file and store it in the memory array
    end

    assign data = mem[addr]; // assign the data output to the memory at the given address

endmodule