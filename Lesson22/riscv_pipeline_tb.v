`timescale 1ns/1ps

module riscv_pipeline_tb;

    reg clk;
    reg reset;

    riscv_pipeline dut (
        .clk   (clk),
        .reset (reset)
    );

    // ============================================================
    // Clock
    // ============================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end

    // ============================================================
    // Instruction Encoding Functions
    // ============================================================

    function [31:0] encode_r;
        input [6:0] funct7;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;
        input [4:0] rd;
        input [6:0] opcode;

        begin

            encode_r = {
                funct7,
                rs2,
                rs1,
                funct3,
                rd,
                opcode
            };

        end

    endfunction


    function [31:0] encode_i;
        input [11:0] imm;
        input [4:0] rs1;
        input [2:0] funct3;
        input [4:0] rd;
        input [6:0] opcode;

        begin

            encode_i = {
                imm,
                rs1,
                funct3,
                rd,
                opcode
            };

        end

    endfunction


    function [31:0] encode_s;
        input [11:0] imm;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;
        input [6:0] opcode;

        begin

            encode_s = {
                imm[11:5],
                rs2,
                rs1,
                funct3,
                imm[4:0],
                opcode
            };

        end

    endfunction


    // ============================================================
    // Test Program
    // ============================================================

    initial begin

        reset = 1'b1;

        #10;

        // ADDI x1, x0, 10
        dut.instr_mem[0] =
            encode_i(
                12'd10,
                5'd0,
                3'b000,
                5'd1,
                7'b0010011
            );

        // ADDI x2, x0, 20
        dut.instr_mem[1] =
            encode_i(
                12'd20,
                5'd0,
                3'b000,
                5'd2,
                7'b0010011
            );

        // ADD x3, x1, x2
        dut.instr_mem[2] =
            encode_r(
                7'b0000000,
                5'd2,
                5'd1,
                3'b000,
                5'd3,
                7'b0110011
            );

        // SUB x4, x3, x1
        dut.instr_mem[3] =
            encode_r(
                7'b0100000,
                5'd1,
                5'd3,
                3'b000,
                5'd4,
                7'b0110011
            );

        // AND x5, x3, x4
        dut.instr_mem[4] =
            encode_r(
                7'b0000000,
                5'd4,
                5'd3,
                3'b111,
                5'd5,
                7'b0110011
            );

        // OR x6, x3, x4
        dut.instr_mem[5] =
            encode_r(
                7'b0000000,
                5'd4,
                5'd3,
                3'b110,
                5'd6,
                7'b0110011
            );

        // SW x6, 0(x0)
        dut.instr_mem[6] =
            encode_s(
                12'd0,
                5'd6,
                5'd0,
                3'b010,
                7'b0100011
            );

        // LW x7, 0(x0)
        dut.instr_mem[7] =
            encode_i(
                12'd0,
                5'd0,
                3'b010,
                5'd7,
                7'b0000011
            );

        // ADD x8, x7, x1
        dut.instr_mem[8] =
            encode_r(
                7'b0000000,
                5'd1,
                5'd7,
                3'b000,
                5'd8,
                7'b0110011
            );

        // Finish
        #10;

        reset = 1'b0;

        // Run pipeline
        #250;

        // ========================================================
        // Results
        // ========================================================

        $display("----------------------------------------");
        $display("RISC-V Pipeline Test");
        $display("----------------------------------------");

        $display("x1 = %0d", dut.registers[1]);
        $display("x2 = %0d", dut.registers[2]);
        $display("x3 = %0d", dut.registers[3]);
        $display("x4 = %0d", dut.registers[4]);
        $display("x5 = %0d", dut.registers[5]);
        $display("x6 = %0d", dut.registers[6]);
        $display("x7 = %0d", dut.registers[7]);
        $display("x8 = %0d", dut.registers[8]);

        $display("MEM[0] = %0d", dut.data_mem[0]);

        $display("----------------------------------------");

        if (dut.registers[1] == 10 &&
            dut.registers[2] == 20 &&
            dut.registers[3] == 30 &&
            dut.registers[4] == 20 &&
            dut.registers[5] == 20 &&
            dut.registers[6] == 30 &&
            dut.registers[7] == 30 &&
            dut.registers[8] == 40 &&
            dut.data_mem[0] == 30) begin

            $display("TEST PASSED");

        end
        else begin

            $display("TEST FAILED");

        end

        $display("----------------------------------------");

        $finish;

    end

    // ============================================================
    // Waveform
    // ============================================================

    initial begin

        $dumpfile("riscv_pipeline.vcd");
        $dumpvars(0, riscv_pipeline_tb);

    end

endmodule