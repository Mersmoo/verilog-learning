`timescale 1ns/1ps

module alu_zero_carry_tb;

    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] ALU_Control;

    wire [3:0] Result;
    wire Zero;
    wire Carry;

    alu_zero_carry uut (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .Result(Result),
        .Zero(Zero),
        .Carry(Carry)
    );

    initial begin
        $dumpfile("alu_zero_carry.vcd");
        $dumpvars(0, alu_zero_carry_tb);
        $monitor("Time=%0t | A=%d | B=%d | Control=%b | Result=%d | Zero=%b | Carry=%b",
                 $time, A, B, ALU_Control, Result, Zero, Carry);

        // ADD: 5 + 3 = 8
        A = 4'd5;
        B = 4'd3;
        ALU_Control = 3'b000;
        #10;

        // ADD with Carry: 15 + 3 = 18
        A = 4'd15;
        B = 4'd3;
        ALU_Control = 3'b000;
        #10;

        // ADD producing Zero + Carry: 15 + 1 = 16
        A = 4'd15;
        B = 4'd1;
        ALU_Control = 3'b000;
        #10;

        // SUB: 5 - 5 = 0
        A = 4'd5;
        B = 4'd5;
        ALU_Control = 3'b001;
        #10;

        // AND
        A = 4'b0101;
        B = 4'b0011;
        ALU_Control = 3'b010;
        #10;

        // OR
        A = 4'b0101;
        B = 4'b0011;
        ALU_Control = 3'b011;
        #10;

        // XOR
        A = 4'b0101;
        B = 4'b0011;
        ALU_Control = 3'b100;
        #10;

        // NOT
        A = 4'b0101;
        B = 4'b0000;
        ALU_Control = 3'b101;
        #10;

        $finish;

    end

endmodule