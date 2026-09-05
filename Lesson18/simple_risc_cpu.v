`timescale 1ns/1ps

module simple_risc_cpu (
    input wire clk,
    input wire reset
);

    // ------------------------------------------------------------
    // Program Counter
    // ------------------------------------------------------------

    reg [31:0] pc;
    reg [31:0] pc_next;


    // ------------------------------------------------------------
    // Instruction Memory
    // ------------------------------------------------------------

    wire [31:0] instruction_word;

    instruction_memory u_instruction_memory (
        .address(pc),
        .instruction(instruction_word)
    );


    // Use lower 16 bits for the custom RISC instruction format
    wire [15:0] instruction;

    assign instruction = instruction_word[15:0];


    // ------------------------------------------------------------
    // Instruction Decoder
    // ------------------------------------------------------------

    wire [3:0] opcode;
    wire [2:0] rd;
    wire [2:0] rs1;
    wire [2:0] rs2;
    wire [7:0] immediate;

    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire alu_src;
    wire branch;
    wire jump;

    instruction_decoder u_decoder (
        .instruction(instruction),

        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .immediate(immediate),

        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump)
    );


    // ------------------------------------------------------------
    // Register File
    // ------------------------------------------------------------

    wire [7:0] register_data1;
    wire [7:0] register_data2;

    reg [7:0] writeback_data;

    register_file u_register_file (
        .clk(clk),
        .we(reg_write),

        .write_addr(rd),
        .write_data(writeback_data),

        .read_addr1(rs1),
        .read_addr2(rs2),

        .read_data1(register_data1),
        .read_data2(register_data2)
    );


    // ------------------------------------------------------------
    // ALU Input
    // ------------------------------------------------------------

    reg [7:0] alu_input_b;

    always @(*) begin

        if (alu_src)
            alu_input_b = immediate;
        else
            alu_input_b = register_data2;

    end


    // ------------------------------------------------------------
    // ALU Control
    // ------------------------------------------------------------

    reg [2:0] alu_control;

    always @(*) begin

        case (opcode)

            4'b0001: alu_control = 3'b000; // ADD
            4'b0010: alu_control = 3'b001; // SUB
            4'b0011: alu_control = 3'b010; // AND
            4'b0100: alu_control = 3'b011; // OR

            default: alu_control = 3'b000;

        endcase

    end


    // ------------------------------------------------------------
    // ALU
    // ------------------------------------------------------------

    wire [7:0] alu_result;
    wire alu_zero;
    wire alu_carry;

    single_cycle_alu u_alu (
        .A(register_data1),
        .B(alu_input_b),
        .ALUControl(alu_control),

        .Result(alu_result),
        .Zero(alu_zero),
        .Carry(alu_carry)
    );


    // ------------------------------------------------------------
    // Data Memory
    // ------------------------------------------------------------

    wire [31:0] data_memory_address;
    wire [31:0] data_memory_write_data;
    wire [31:0] data_memory_read_data;

    // Convert word address into byte address
    assign data_memory_address = {22'b0, immediate, 2'b00};

    // Store 8-bit register data in a 32-bit memory word
    assign data_memory_write_data = {24'b0, register_data1};

    data_memory u_data_memory (
        .clk(clk),

        .mem_write(mem_write),
        .mem_read(mem_read),

        .address(data_memory_address),
        .write_data(data_memory_write_data),

        .read_data(data_memory_read_data)
    );


    // ------------------------------------------------------------
    // Writeback Multiplexer
    // ------------------------------------------------------------

    always @(*) begin

        if (mem_read)
            writeback_data = data_memory_read_data[7:0];

        else if (opcode == 4'b0101)
            writeback_data = immediate;

        else
            writeback_data = alu_result;

    end


    // ------------------------------------------------------------
    // Next PC Logic
    // ------------------------------------------------------------

    always @(*) begin

        pc_next = pc + 32'd4;

        // Jump
        if (jump) begin
            pc_next = {24'b0, immediate};
        end

        // Branch if ALU result is zero
        else if (branch && alu_zero) begin
            pc_next = pc + {{26{instruction[5]}}, instruction[5:0]};
        end

    end


    // ------------------------------------------------------------
    // Program Counter Register
    // ------------------------------------------------------------

    always @(posedge clk) begin

        if (reset)
            pc <= 32'd0;
        else
            pc <= pc_next;

    end

endmodule