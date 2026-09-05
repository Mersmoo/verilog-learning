`timescale 1ns/1ps

module single_cycle_alu_tb;

    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] ALUControl;

    wire [7:0] Result;
    wire       Zero;
    wire       Carry;

    single_cycle_alu uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero),
        .Carry(Carry)
    );

    initial begin

        $dumpfile("single_cycle_alu.vcd");
        $dumpvars(0, single_cycle_alu_tb);

        $monitor(
            "Time=%0t A=%d B=%d Control=%b Result=%d Zero=%b Carry=%b",
            $time, A, B, ALUControl, Result, Zero, Carry
        );

        // ADD
        A = 8'd10;
        B = 8'd5;
        ALUControl = 3'b000;
        #10;

        // ADD with carry
        A = 8'd255;
        B = 8'd1;
        ALUControl = 3'b000;
        #10;

        // SUB
        A = 8'd10;
        B = 8'd5;
        ALUControl = 3'b001;
        #10;

        // SUB resulting in zero
        A = 8'd10;
        B = 8'd10;
        ALUControl = 3'b001;
        #10;

        // AND
        A = 8'b11001100;
        B = 8'b10101010;
        ALUControl = 3'b010;
        #10;

        // OR
        A = 8'b11001100;
        B = 8'b10101010;
        ALUControl = 3'b011;
        #10;

        // XOR
        A = 8'b11001100;
        B = 8'b10101010;
        ALUControl = 3'b100;
        #10;

        // SLT
        A = 8'd5;
        B = 8'd10;
        ALUControl = 3'b101;
        #10;

        // SLT false
        A = 8'd20;
        B = 8'd10;
        ALUControl = 3'b101;
        #10;

        $finish;

    end

endmodule