module program_counter_jump (
    input  wire        clk,
    input  wire        reset,
    input  wire        jump,
    input  wire [31:0] jump_address,
    output reg  [31:0] pc
);

wire [31:0] next_pc;

assign next_pc = jump ? jump_address : pc + 32'd4;

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 32'h00000000;
    else
        pc <= next_pc;
end

endmodule