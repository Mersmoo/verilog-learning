`timescale 1ns/1ps

module alu_tb;

    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] ALU_Control;

    wire [3:0] Result;

    // Instantiate ALU
    alu uut (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .Result(Result)
    );

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);
        $monitor("Time=%0t | A=%d | B=%d | Control=%b | Result=%d",
                 $time, A, B, ALU_Control, Result);

        // ADD
        A = 4'd5;
        B = 4'd3;
        ALU_Control = 3'b000;
        #10;

        // SUB
        A = 4'd5;
        B = 4'd3;
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

        // NOT A
        A = 4'b0101;
        B = 4'b0000;
        ALU_Control = 3'b101;
        #10;

        $finish;

    end

endmodule