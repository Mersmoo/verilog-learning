module ram_16x8 (
    input  wire       clk,
    input  wire       we,

    input  wire [3:0] addr,
    input  wire [7:0] write_data,

    output reg  [7:0] read_data
);

    reg [7:0] memory [0:15];


    // Write operation
    always @(posedge clk) begin

        if (we) begin
            memory[addr] <= write_data;
        end

    end


    // Read operation
    always @(*) begin
        read_data = memory[addr];
    end

endmodule