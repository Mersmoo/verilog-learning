module small_memory_design #(
    parameter integer ADDR_WIDTH = 4,
    parameter integer DATA_WIDTH = 8
)(
    input  wire [ADDR_WIDTH-1:0] input_data,
    output reg  [DATA_WIDTH-1:0] output_data
);

    localparam integer DEPTH = 2 ** ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];


    initial begin

        memory[0]  = 8'd0;
        memory[1]  = 8'd1;
        memory[2]  = 8'd4;
        memory[3]  = 8'd9;
        memory[4]  = 8'd16;
        memory[5]  = 8'd25;
        memory[6]  = 8'd36;
        memory[7]  = 8'd49;
        memory[8]  = 8'd64;
        memory[9]  = 8'd81;
        memory[10] = 8'd100;
        memory[11] = 8'd121;
        memory[12] = 8'd144;
        memory[13] = 8'd169;
        memory[14] = 8'd196;
        memory[15] = 8'd225;

    end


    always @(*) begin
        output_data = memory[input_data];
    end

endmodule