`timescale 1ns/1ps

module riscv_imm_gen_tb;

    reg  [31:0] instruction;
    reg  [2:0]  imm_src;
    wire [31:0] immediate;

    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001;
    localparam IMM_B = 3'b010;
    localparam IMM_U = 3'b011;
    localparam IMM_J = 3'b100;

    riscv_imm_gen uut (
        .instruction(instruction),
        .imm_src(imm_src),
        .immediate(immediate)
    );

    initial begin
        $dumpfile("riscv_imm_gen.vcd");
        $dumpvars(0, riscv_imm_gen_tb);

        // I-Type: ADDI x1, x2, 10
        instruction = 32'h00A10093;
        imm_src = IMM_I;
        #10;

        $display("I-Type Immediate = %h", immediate);

        // S-Type
        instruction = 32'h00512223;
        imm_src = IMM_S;
        #10;

        $display("S-Type Immediate = %h", immediate);

        // U-Type: LUI
        instruction = 32'h123450B7;
        imm_src = IMM_U;
        #10;

        $display("U-Type Immediate = %h", immediate);

        // B-Type
        instruction = 32'h00000063;
        imm_src = IMM_B;
        #10;

        $display("B-Type Immediate = %h", immediate);

        // J-Type
        instruction = 32'h0000006F;
        imm_src = IMM_J;
        #10;

        $display("J-Type Immediate = %h", immediate);

        $finish;
    end

endmodule