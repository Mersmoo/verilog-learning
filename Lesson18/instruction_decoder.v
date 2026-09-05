module instruction_decoder (
    input  wire [15:0] instruction,

    output reg  [3:0]  opcode,
    output reg  [2:0]  rd,
    output reg  [2:0]  rs1,
    output reg  [2:0]  rs2,
    output reg  [7:0]  immediate,

    output reg         reg_write,
    output reg         mem_read,
    output reg         mem_write,
    output reg         alu_src,
    output reg         branch,
    output reg         jump
);

    // Opcode definitions
    localparam OP_NOP   = 4'b0000;
    localparam OP_ADD   = 4'b0001;
    localparam OP_SUB   = 4'b0010;
    localparam OP_AND   = 4'b0011;
    localparam OP_OR    = 4'b0100;
    localparam OP_LDI   = 4'b0101;
    localparam OP_LOAD  = 4'b0110;
    localparam OP_STORE = 4'b0111;
    localparam OP_BEQ   = 4'b1000;
    localparam OP_JMP   = 4'b1001;

    always @(*) begin

        // Extract instruction fields
        opcode    = instruction[15:12];
        rd        = instruction[11:9];
        rs1       = instruction[8:6];
        rs2       = instruction[5:3];
        immediate = instruction[7:0];

        // Default control signals
        reg_write = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        alu_src   = 1'b0;
        branch    = 1'b0;
        jump      = 1'b0;

        case (opcode)

            OP_NOP: begin
                // No operation
            end

            OP_ADD: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
            end

            OP_SUB: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
            end

            OP_AND: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
            end

            OP_OR: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
            end

            OP_LDI: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
            end

            OP_LOAD: begin
                reg_write = 1'b1;
                mem_read  = 1'b1;
                alu_src   = 1'b1;
            end

            OP_STORE: begin
                mem_write = 1'b1;
                alu_src   = 1'b1;
                rs1       = instruction[11:9];
            end

            OP_BEQ: begin
                branch = 1'b1;
            end

            OP_JMP: begin
                jump = 1'b1;
            end

            default: begin
                // Invalid opcode
            end

        endcase
    end

endmodule