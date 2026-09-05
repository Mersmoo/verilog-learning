`timescale 1ns/1ps

module riscv_control_unit_tb;

    reg [6:0] opcode;

    wire reg_write;
    wire alu_src;
    wire mem_write;
    wire mem_read;
    wire branch;
    wire jump;
    wire [2:0] imm_src;
    wire [1:0] alu_op;

    riscv_control_unit uut (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .branch(branch),
        .jump(jump),
        .imm_src(imm_src),
        .alu_op(alu_op)
    );

    initial begin

        $dumpfile("riscv_control_unit.vcd");
        $dumpvars(0, riscv_control_unit_tb);

        // R-Type
        opcode = 7'b0110011;
        #10;
        $display("R-Type: RegWrite=%b ALUSrc=%b MemRead=%b MemWrite=%b",
                 reg_write, alu_src, mem_read, mem_write);

        // I-Type
        opcode = 7'b0010011;
        #10;
        $display("I-Type: RegWrite=%b ALUSrc=%b ImmSrc=%b",
                 reg_write, alu_src, imm_src);

        // LW
        opcode = 7'b0000011;
        #10;
        $display("LW: RegWrite=%b MemRead=%b ALUSrc=%b",
                 reg_write, mem_read, alu_src);

        // SW
        opcode = 7'b0100011;
        #10;
        $display("SW: MemWrite=%b ALUSrc=%b ImmSrc=%b",
                 mem_write, alu_src, imm_src);

        // Branch
        opcode = 7'b1100011;
        #10;
        $display("Branch: Branch=%b ImmSrc=%b ALUOp=%b",
                 branch, imm_src, alu_op);

        // JAL
        opcode = 7'b1101111;
        #10;
        $display("JAL: Jump=%b RegWrite=%b ImmSrc=%b",
                 jump, reg_write, imm_src);

        // JALR
        opcode = 7'b1100111;
        #10;
        $display("JALR: Jump=%b RegWrite=%b",
                 jump, reg_write);

        // LUI
        opcode = 7'b0110111;
        #10;
        $display("LUI: RegWrite=%b ImmSrc=%b",
                 reg_write, imm_src);

        // AUIPC
        opcode = 7'b0010111;
        #10;
        $display("AUIPC: RegWrite=%b ImmSrc=%b",
                 reg_write, imm_src);

        #10;

        $finish;
    end

endmodule