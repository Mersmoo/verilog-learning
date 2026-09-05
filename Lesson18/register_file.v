`timescale 1ns/1ps

module register_file #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
)(
    input  wire                     clk,
    input  wire                     we,

    input  wire [ADDR_WIDTH-1:0]    write_addr,
    input  wire [DATA_WIDTH-1:0]    write_data,

    input  wire [ADDR_WIDTH-1:0]    read_addr1,
    input  wire [ADDR_WIDTH-1:0]    read_addr2,

    output wire [DATA_WIDTH-1:0]    read_data1,
    output wire [DATA_WIDTH-1:0]    read_data2
);

    localparam REG_COUNT = 1 << ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] registers [0:REG_COUNT-1];

    integer i;

    initial begin
        for (i = 0; i < REG_COUNT; i = i + 1)
            registers[i] = {DATA_WIDTH{1'b0}};
    end

    // Register write
    always @(posedge clk) begin
        if (we)
            registers[write_addr] <= write_data;
    end

    // Asynchronous register reads
    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];

endmodule