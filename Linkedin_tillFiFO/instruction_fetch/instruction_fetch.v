module instruction_fetch (
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] pc,
    output wire [31:0] instruction
);

    reg [31:0] instruction_memory [0:255];

    assign instruction = instruction_memory[pc[9:2]];

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else
            pc <= pc + 32'd4;
    end

endmodule