module riscv_control_unit (
    input  wire [6:0] opcode,

    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_write,
    output reg        mem_read,
    output reg        branch,
    output reg        jump,
    output reg [2:0]  imm_src,
    output reg [1:0]  alu_op
);

    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001;
    localparam IMM_B = 3'b010;
    localparam IMM_U = 3'b011;
    localparam IMM_J = 3'b100;

    localparam ALU_RTYPE = 2'b10;
    localparam ALU_ITYPE = 2'b11;
    localparam ALU_ADD    = 2'b00;
    localparam ALU_BRANCH = 2'b01;

    always @(*) begin

        reg_write = 1'b0;
        alu_src   = 1'b0;
        mem_write = 1'b0;
        mem_read  = 1'b0;
        branch    = 1'b0;
        jump      = 1'b0;
        imm_src   = IMM_I;
        alu_op    = ALU_ADD;

        case (opcode)

            // R-Type instructions
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                alu_op    = ALU_RTYPE;
            end

            // I-Type ALU instructions
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                imm_src   = IMM_I;
                alu_op    = ALU_ITYPE;
            end

            // Load instructions
            7'b0000011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                mem_read  = 1'b1;
                imm_src   = IMM_I;
                alu_op    = ALU_ADD;
            end

            // Store instructions
            7'b0100011: begin
                alu_src   = 1'b1;
                mem_write = 1'b1;
                imm_src   = IMM_S;
                alu_op    = ALU_ADD;
            end

            // Branch instructions
            7'b1100011: begin
                branch  = 1'b1;
                alu_src = 1'b0;
                imm_src = IMM_B;
                alu_op  = ALU_BRANCH;
            end

            // JAL
            7'b1101111: begin
                reg_write = 1'b1;
                jump      = 1'b1;
                imm_src   = IMM_J;
            end

            // JALR
            7'b1100111: begin
                reg_write = 1'b1;
                jump      = 1'b1;
                alu_src   = 1'b1;
                imm_src   = IMM_I;
                alu_op    = ALU_ADD;
            end

            // LUI
            7'b0110111: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                imm_src   = IMM_U;
            end

            // AUIPC
            7'b0010111: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                imm_src   = IMM_U;
                alu_op    = ALU_ADD;
            end

            default: begin
                reg_write = 1'b0;
                alu_src   = 1'b0;
                mem_write = 1'b0;
                mem_read  = 1'b0;
                branch    = 1'b0;
                jump      = 1'b0;
                imm_src   = IMM_I;
                alu_op    = ALU_ADD;
            end

        endcase
    end

endmodule