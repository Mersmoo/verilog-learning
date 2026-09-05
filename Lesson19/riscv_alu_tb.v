`timescale 1ns/1ps

module riscv_alu_tb;

    logic [31:0] A, B;
    logic [3:0]  ALUControl;
    logic [31:0] Result;
    logic        Zero;

    integer errors = 0;
    integer tests  = 0;

    riscv_alu uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    task check(
        input [31:0] a_in,
        input [31:0] b_in,
        input [3:0]  ctrl,
        input [31:0] expected,
        input string name
    );
        begin
            A = a_in;
            B = b_in;
            ALUControl = ctrl;
            #1; // let combinational logic settle

            tests = tests + 1;

            if (Result !== expected) begin
                errors = errors + 1;
                $display("FAIL [%0s]: A=%h B=%h ctrl=%b -> Result=%h (expected %h)",
                          name, a_in, b_in, ctrl, Result, expected);
            end
            else begin
                $display("PASS [%0s]: A=%h B=%h ctrl=%b -> Result=%h",
                          name, a_in, b_in, ctrl, Result);
            end

            // Cross-check Zero flag independently
            if (Zero !== (Result == 32'd0)) begin
                errors = errors + 1;
                $display("FAIL [%0s]: Zero flag mismatch (Zero=%b, Result=%h)",
                          name, Zero, Result);
            end
        end
    endtask

    initial begin
        
        $display("--------------------------------------------------");
        $display("RISC-V ALU Testbench");
        $display("--------------------------------------------------");

        // ADD
        check(32'd10, 32'd20, 4'b0000, 32'd30, "ADD basic");
        check(32'hFFFFFFFF, 32'd1, 4'b0000, 32'd0, "ADD overflow wraps, Zero set");

        // SUB
        check(32'd20, 32'd10, 4'b0001, 32'd10, "SUB basic");
        check(32'd5, 32'd5, 4'b0001, 32'd0, "SUB equal -> Zero");
        check(32'd0, 32'd1, 4'b0001, 32'hFFFFFFFF, "SUB underflow wraps");

        // AND / OR / XOR
        check(32'hFF00FF00, 32'h0FF00FF0, 4'b0010, 32'h0F000F00, "AND");
        check(32'hFF00FF00, 32'h00FF00FF, 4'b0011, 32'hFFFFFFFF, "OR");
        check(32'hFFFFFFFF, 32'hFFFFFFFF, 4'b0100, 32'd0, "XOR self -> Zero");

        // SLL
        check(32'h00000001, 32'd4, 4'b0101, 32'h00000010, "SLL by 4");
        check(32'h00000001, 32'd31, 4'b0101, 32'h80000000, "SLL by 31");
        check(32'hFFFFFFFF, 32'd0, 4'b0101, 32'hFFFFFFFF, "SLL by 0 (no-op)");

        // SRL
        check(32'h80000000, 32'd4, 4'b0110, 32'h08000000, "SRL by 4, no sign extend");
        check(32'hFFFFFFFF, 32'd0, 4'b0110, 32'hFFFFFFFF, "SRL by 0 (no-op)");

        // SRA
        check(32'h80000000, 32'd4, 4'b0111, 32'hF8000000, "SRA negative, sign-extends");
        check(32'h7FFFFFFF, 32'd4, 4'b0111, 32'h07FFFFFF, "SRA positive, behaves like SRL");
        check(32'hFFFFFFFF, 32'd31, 4'b0111, 32'hFFFFFFFF, "SRA -1 by 31 stays -1");

        // SLT (signed)
        check(32'hFFFFFFFF, 32'd1, 4'b1000, 32'd1, "SLT: -1 < 1 signed -> true");
        check(32'd1, 32'hFFFFFFFF, 4'b1000, 32'd0, "SLT: 1 < -1 signed -> false");
        check(32'd5, 32'd5, 4'b1000, 32'd0, "SLT equal -> false");

        // SLTU (unsigned)
        check(32'hFFFFFFFF, 32'd1, 4'b1001, 32'd0, "SLTU: 0xFFFFFFFF < 1 unsigned -> false");
        check(32'd1, 32'hFFFFFFFF, 4'b1001, 32'd1, "SLTU: 1 < 0xFFFFFFFF unsigned -> true");
        check(32'd5, 32'd5, 4'b1001, 32'd0, "SLTU equal -> false");

        // Default / undefined opcode
        check(32'd123, 32'd456, 4'b1111, 32'd0, "Undefined ALUControl -> default 0");

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("ALL %0d TESTS PASSED", tests);
        else
            $display("%0d / %0d TESTS FAILED", errors, tests);
        $display("--------------------------------------------------");

        $finish;
    end

endmodule
