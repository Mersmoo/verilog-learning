module dual_port_ram #(
    parameter integer DATA_WIDTH = 8,
    parameter integer ADDR_WIDTH = 4
)(
    input wire                   clk,

    // Write port
    input wire                   we,
    input wire [ADDR_WIDTH-1:0]  write_addr,
    input wire [DATA_WIDTH-1:0]  write_data,

    // Read port
    input wire [ADDR_WIDTH-1:0]  read_addr,
    output reg [DATA_WIDTH-1:0]  read_data
);

    localparam integer DEPTH = 2 ** ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];


    // Write operation
    always @(posedge clk) begin

        if (we) begin
            memory[write_addr] <= write_data;
        end

    end


    // Read operation
    always @(*) begin

        read_data = memory[read_addr];

    end

endmodule