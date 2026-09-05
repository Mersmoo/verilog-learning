`timescale 1ns/1ps

module simple_8bit_cpu (
    input wire clk,
    input wire reset
);

    // Program Counter
    reg [7:0] pc;

    // Four 8-bit general-purpose registers
    reg [7:0] registers [0:3];

    // Instruction memory
    reg [7:0] instruction_memory [0:255];

    // Data memory
    reg [7:0] data_memory [0:255];

    // Current instruction
    reg [7:0] instruction;

    // Decoded instruction fields
    reg [3:0] opcode;
    reg [1:0] reg_a;
    reg [1:0] reg_b;
    reg [3:0] address;

    integer i;

    // Opcodes
    localparam OP_NOP = 4'b0000;
    localparam OP_LDI = 4'b0001;
    localparam OP_ADD = 4'b0010;
    localparam OP_SUB = 4'b0011;
    localparam OP_AND = 4'b0100;
    localparam OP_OR  = 4'b0101;
    localparam OP_MOV = 4'b0110;
    localparam OP_LD  = 4'b0111;
    localparam OP_ST  = 4'b1000;
    localparam OP_JMP = 4'b1001;

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            // Reset Program Counter
            pc <= 8'd0;

            // Clear registers
            for (i = 0; i < 4; i = i + 1)
                registers[i] <= 8'd0;

            // Clear data memory
            for (i = 0; i < 256; i = i + 1)
                data_memory[i] <= 8'd0;

            instruction <= 8'd0;
            opcode <= OP_NOP;
            reg_a <= 2'd0;
            reg_b <= 2'd0;
            address <= 4'd0;

        end

        else begin

            // Fetch instruction
            instruction = instruction_memory[pc];

            // Decode instruction
            opcode = instruction[7:4];
            reg_a = instruction[3:2];
            reg_b = instruction[1:0];
            address = instruction[3:0];

            case (opcode)

                // NOP
                OP_NOP: begin
                    pc <= pc + 8'd1;
                end

                // Load immediate
                // Format: 0001 RR II
                // Loads a 2-bit immediate value into a register
                OP_LDI: begin
                    registers[reg_a] <= {6'd0, reg_b};
                    pc <= pc + 8'd1;
                end

                // ADD
                // Format: 0010 RR SS
                // R[RR] = R[RR] + R[SS]
                OP_ADD: begin
                    registers[reg_a] <= registers[reg_a] + registers[reg_b];
                    pc <= pc + 8'd1;
                end

                // SUB
                // Format: 0011 RR SS
                // R[RR] = R[RR] - R[SS]
                OP_SUB: begin
                    registers[reg_a] <= registers[reg_a] - registers[reg_b];
                    pc <= pc + 8'd1;
                end

                // AND
                // Format: 0100 RR SS
                // R[RR] = R[RR] & R[SS]
                OP_AND: begin
                    registers[reg_a] <= registers[reg_a] & registers[reg_b];
                    pc <= pc + 8'd1;
                end

                // OR
                // Format: 0101 RR SS
                // R[RR] = R[RR] | R[SS]
                OP_OR: begin
                    registers[reg_a] <= registers[reg_a] | registers[reg_b];
                    pc <= pc + 8'd1;
                end

                // MOV
                // Format: 0110 RR SS
                // R[RR] = R[SS]
                OP_MOV: begin
                    registers[reg_a] <= registers[reg_b];
                    pc <= pc + 8'd1;
                end

                // Load from data memory
                // Format: 0111 RR AA
                // R[RR] = data_memory[AA]
                OP_LD: begin
                    registers[reg_a] <= data_memory[reg_b];
                    pc <= pc + 8'd1;
                end

                // Store to data memory
                // Format: 1000 RR AA
                // data_memory[AA] = R[RR]
                OP_ST: begin
                    data_memory[reg_b] <= registers[reg_a];
                    pc <= pc + 8'd1;
                end

                // Jump
                // Format: 1001 AAAA
                // PC = address
                OP_JMP: begin
                    pc <= {4'd0, address};
                end

                // Unknown instruction
                default: begin
                    pc <= pc + 8'd1;
                end

            endcase

        end
    end

endmodule