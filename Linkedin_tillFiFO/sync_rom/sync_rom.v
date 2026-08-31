module sync_rom #(
    parameter integer DATA_WIDTH = 8,
    parameter integer ADDR_WIDTH = 4
)(
    input wire                  clk,
    input wire [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] data
);

    localparam integer DEPTH = 2 ** ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    initial begin
        memory[0] = 8'h10;
        memory[1] = 8'h25;
        memory[2] = 8'h37;
        memory[3] = 8'h42;
        memory[4] = 8'h55;
        memory[5] = 8'h66;
        memory[6] = 8'h77;
        memory[7] = 8'h88;
    end


    always @(posedge clk) begin
        data <= memory[addr];
    end

endmodule