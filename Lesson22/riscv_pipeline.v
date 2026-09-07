`timescale 1ns/1ps

module riscv_pipeline (
    input  wire clk,
    input  wire reset
);

    // ============================================================
    // Program Counter
    // ============================================================

    reg [31:0] pc;

    // ============================================================
    // Instruction Memory
    // ============================================================

    reg [31:0] instr_mem [0:255];

    wire [31:0] instruction;

    assign instruction = instr_mem[pc[9:2]];

    // ============================================================
    // Data Memory
    // ============================================================

    reg [31:0] data_mem [0:255];

    // ============================================================
    // Register File
    // ============================================================

    reg [31:0] registers [0:31];

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];

    // ============================================================
    // IF/ID Pipeline Register
    // ============================================================

    reg [31:0] if_id_pc;
    reg [31:0] if_id_instr;
    reg        if_id_valid;

    // ============================================================
    // ID Stage - Decode
    // ============================================================

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = if_id_instr[6:0];
    assign funct3 = if_id_instr[14:12];
    assign funct7 = if_id_instr[31:25];

    wire [4:0] id_rs1;
    wire [4:0] id_rs2;
    wire [4:0] id_rd;

    assign id_rs1 = if_id_instr[19:15];
    assign id_rs2 = if_id_instr[24:20];
    assign id_rd  = if_id_instr[11:7];

    // ============================================================
    // Immediate Generator
    // ============================================================

    reg [31:0] id_immediate;

    always @(*) begin

        case (opcode)

            // I-Type
            7'b0010011,
            7'b0000011: begin
                id_immediate = {{20{if_id_instr[31]}},
                                if_id_instr[31:20]};
            end

            // S-Type
            7'b0100011: begin
                id_immediate = {{20{if_id_instr[31]}},
                                if_id_instr[31:25],
                                if_id_instr[11:7]};
            end

            // B-Type
            7'b1100011: begin
                id_immediate = {{19{if_id_instr[31]}},
                                if_id_instr[31],
                                if_id_instr[7],
                                if_id_instr[30:25],
                                if_id_instr[11:8],
                                1'b0};
            end

            default: begin
                id_immediate = 32'd0;
            end

        endcase

    end

    // ============================================================
    // Control Unit
    // ============================================================

    reg id_reg_write;
    reg id_mem_read;
    reg id_mem_write;
    reg id_mem_to_reg;
    reg id_alu_src;
    reg id_branch;
    reg [3:0] id_alu_control;

    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;

    always @(*) begin

        id_reg_write   = 1'b0;
        id_mem_read    = 1'b0;
        id_mem_write   = 1'b0;
        id_mem_to_reg  = 1'b0;
        id_alu_src     = 1'b0;
        id_branch      = 1'b0;
        id_alu_control = ALU_ADD;

        case (opcode)

            // ADD / SUB / AND / OR
            7'b0110011: begin

                id_reg_write = 1'b1;
                id_alu_src   = 1'b0;

                case (funct3)

                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            id_alu_control = ALU_SUB;
                        else
                            id_alu_control = ALU_ADD;
                    end

                    3'b111:
                        id_alu_control = ALU_AND;

                    3'b110:
                        id_alu_control = ALU_OR;

                    default:
                        id_alu_control = ALU_ADD;

                endcase

            end

            // ADDI
            7'b0010011: begin

                id_reg_write   = 1'b1;
                id_alu_src     = 1'b1;
                id_alu_control = ALU_ADD;

            end

            // LW
            7'b0000011: begin

                id_reg_write   = 1'b1;
                id_mem_read    = 1'b1;
                id_mem_to_reg  = 1'b1;
                id_alu_src     = 1'b1;
                id_alu_control = ALU_ADD;

            end

            // SW
            7'b0100011: begin

                id_mem_write   = 1'b1;
                id_alu_src     = 1'b1;
                id_alu_control = ALU_ADD;

            end

            // BEQ
            7'b1100011: begin

                id_branch      = 1'b1;
                id_alu_control = ALU_SUB;
                id_alu_src     = 1'b0;

            end

            default: begin

                id_reg_write   = 1'b0;
                id_mem_read    = 1'b0;
                id_mem_write   = 1'b0;
                id_branch      = 1'b0;
                id_alu_control = ALU_ADD;

            end

        endcase

    end

    // ============================================================
    // ID/EX Pipeline Register
    // ============================================================

    reg [31:0] id_ex_pc;
    reg [31:0] id_ex_rs1_data;
    reg [31:0] id_ex_rs2_data;
    reg [31:0] id_ex_immediate;

    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;
    reg [4:0] id_ex_rd;

    reg       id_ex_reg_write;
    reg       id_ex_mem_read;
    reg       id_ex_mem_write;
    reg       id_ex_mem_to_reg;
    reg       id_ex_alu_src;
    reg       id_ex_branch;

    reg [3:0] id_ex_alu_control;

    // ============================================================
    // EX/MEM Pipeline Register
    // ============================================================

    reg [31:0] ex_mem_alu_result;
    reg [31:0] ex_mem_store_data;

    reg [4:0] ex_mem_rd;

    reg       ex_mem_reg_write;
    reg       ex_mem_mem_read;
    reg       ex_mem_mem_write;
    reg       ex_mem_mem_to_reg;

    // ============================================================
    // MEM/WB Pipeline Register
    // ============================================================

    reg [31:0] mem_wb_alu_result;
    reg [31:0] mem_wb_mem_data;

    reg [4:0] mem_wb_rd;

    reg       mem_wb_reg_write;
    reg       mem_wb_mem_to_reg;
    wire [31:0] wb_forward_data;

    assign wb_forward_data =
        mem_wb_mem_to_reg ?
        mem_wb_mem_data :
        mem_wb_alu_result;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    assign rs1_data =
        (id_rs1 == 5'd0) ?
        32'd0 :
        (mem_wb_reg_write &&
        (mem_wb_rd != 5'd0) &&
        (mem_wb_rd == id_rs1)) ?
        wb_forward_data :
        registers[id_rs1];

    assign rs2_data =
        (id_rs2 == 5'd0) ?
        32'd0 :
        (mem_wb_reg_write &&
        (mem_wb_rd != 5'd0) &&
        (mem_wb_rd == id_rs2)) ?
        wb_forward_data :
        registers[id_rs2];    
    // ============================================================
    // Forwarding Unit
    // ============================================================

    reg [1:0] forward_a;
    reg [1:0] forward_b;

    always @(*) begin

        forward_a = 2'b00;
        forward_b = 2'b00;

        // EX/MEM forwarding
        if (ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rs1)) begin

            forward_a = 2'b10;

        end

        if (ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rs2)) begin

            forward_b = 2'b10;

        end

        // MEM/WB forwarding
        if (mem_wb_reg_write &&
            (mem_wb_rd != 5'd0) &&
            !(ex_mem_reg_write &&
              (ex_mem_rd != 5'd0) &&
              (ex_mem_rd == id_ex_rs1)) &&
            (mem_wb_rd == id_ex_rs1)) begin

            forward_a = 2'b01;

        end

        if (mem_wb_reg_write &&
            (mem_wb_rd != 5'd0) &&
            !(ex_mem_reg_write &&
              (ex_mem_rd != 5'd0) &&
              (ex_mem_rd == id_ex_rs2)) &&
            (mem_wb_rd == id_ex_rs2)) begin

            forward_b = 2'b01;

        end

    end

    // ============================================================
    // Forwarded EX Operands
    // ============================================================

    reg [31:0] ex_operand_a;
    reg [31:0] ex_operand_b_reg;

    always @(*) begin

        case (forward_a)

            2'b00:
                ex_operand_a = id_ex_rs1_data;

            2'b10:
                ex_operand_a = ex_mem_alu_result;

            2'b01:
                ex_operand_a = mem_wb_mem_to_reg ?
                               mem_wb_mem_data :
                               mem_wb_alu_result;

            default:
                ex_operand_a = id_ex_rs1_data;

        endcase


        case (forward_b)

            2'b00:
                ex_operand_b_reg = id_ex_rs2_data;

            2'b10:
                ex_operand_b_reg = ex_mem_alu_result;

            2'b01:
                ex_operand_b_reg = mem_wb_mem_to_reg ?
                                   mem_wb_mem_data :
                                   mem_wb_alu_result;

            default:
                ex_operand_b_reg = id_ex_rs2_data;

        endcase

    end

    // ============================================================
    // ALU
    // ============================================================

    reg [31:0] alu_operand_b;
    reg [31:0] alu_result;

    always @(*) begin

        if (id_ex_alu_src)
            alu_operand_b = id_ex_immediate;
        else
            alu_operand_b = ex_operand_b_reg;

        case (id_ex_alu_control)

            ALU_ADD:
                alu_result = ex_operand_a + alu_operand_b;

            ALU_SUB:
                alu_result = ex_operand_a - alu_operand_b;

            ALU_AND:
                alu_result = ex_operand_a & alu_operand_b;

            ALU_OR:
                alu_result = ex_operand_a | alu_operand_b;

            default:
                alu_result = 32'd0;

        endcase

    end

    // ============================================================
    // Branch Logic
    // ============================================================

    wire branch_taken;

    assign branch_taken =
        id_ex_branch &&
        (ex_operand_a == ex_operand_b_reg);

    wire [31:0] branch_target;

    assign branch_target =
        id_ex_pc + id_ex_immediate;

    // ============================================================
    // Hazard Detection
    // ============================================================

    wire load_use_hazard;

    assign load_use_hazard =
        id_ex_mem_read &&
        (id_ex_rd != 5'd0) &&
        ((id_ex_rd == id_rs1) ||
         (id_ex_rd == id_rs2));

    // ============================================================
    // Next PC
    // ============================================================

    wire [31:0] pc_plus_4;

    assign pc_plus_4 = pc + 32'd4;

    // ============================================================
    // Memory Read
    // ============================================================

    wire [31:0] mem_read_data;

    assign mem_read_data =
        data_mem[ex_mem_alu_result[9:2]];

    // ============================================================
    // Write Back Data
    // ============================================================

    wire [31:0] wb_data;

    assign wb_data =
        mem_wb_mem_to_reg ?
        mem_wb_mem_data :
        mem_wb_alu_result;

    // ============================================================
    // Sequential Pipeline
    // ============================================================

    integer i;

    always @(posedge clk) begin

        if (reset) begin

            pc <= 32'd0;

            if_id_pc    <= 32'd0;
            if_id_instr <= 32'd0;
            if_id_valid <= 1'b0;

            id_ex_pc          <= 32'd0;
            id_ex_rs1_data    <= 32'd0;
            id_ex_rs2_data    <= 32'd0;
            id_ex_immediate   <= 32'd0;

            id_ex_rs1 <= 5'd0;
            id_ex_rs2 <= 5'd0;
            id_ex_rd  <= 5'd0;

            id_ex_reg_write  <= 1'b0;
            id_ex_mem_read   <= 1'b0;
            id_ex_mem_write  <= 1'b0;
            id_ex_mem_to_reg <= 1'b0;
            id_ex_alu_src    <= 1'b0;
            id_ex_branch     <= 1'b0;

            id_ex_alu_control <= ALU_ADD;

            ex_mem_alu_result <= 32'd0;
            ex_mem_store_data <= 32'd0;
            ex_mem_rd         <= 5'd0;

            ex_mem_reg_write  <= 1'b0;
            ex_mem_mem_read   <= 1'b0;
            ex_mem_mem_write  <= 1'b0;
            ex_mem_mem_to_reg <= 1'b0;

            mem_wb_alu_result <= 32'd0;
            mem_wb_mem_data   <= 32'd0;
            mem_wb_rd         <= 5'd0;

            mem_wb_reg_write  <= 1'b0;
            mem_wb_mem_to_reg <= 1'b0;

            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;

            for (i = 0; i < 256; i = i + 1)
                data_mem[i] <= 32'd0;

        end

        else begin

            // ====================================================
            // WB Stage
            // ====================================================

            if (mem_wb_reg_write &&
                (mem_wb_rd != 5'd0)) begin

                registers[mem_wb_rd] <= wb_data;

            end

            registers[0] <= 32'd0;

            // ====================================================
            // MEM Stage
            // ====================================================

            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_rd         <= ex_mem_rd;

            mem_wb_reg_write  <= ex_mem_reg_write;
            mem_wb_mem_to_reg <= ex_mem_mem_to_reg;

            if (ex_mem_mem_read) begin

                mem_wb_mem_data <=
                    data_mem[ex_mem_alu_result[9:2]];

            end
            else begin

                mem_wb_mem_data <= 32'd0;

            end

            if (ex_mem_mem_write) begin

                data_mem[ex_mem_alu_result[9:2]]
                    <= ex_mem_store_data;

            end

            // ====================================================
            // EX/MEM Register
            // ====================================================

            ex_mem_alu_result <= alu_result;

            ex_mem_store_data <= ex_operand_b_reg;

            ex_mem_rd <= id_ex_rd;

            ex_mem_reg_write  <= id_ex_reg_write;
            ex_mem_mem_read   <= id_ex_mem_read;
            ex_mem_mem_write  <= id_ex_mem_write;
            ex_mem_mem_to_reg <= id_ex_mem_to_reg;

            // ====================================================
            // PC and Pipeline Control
            // ====================================================

            if (branch_taken) begin

                pc <= branch_target;

                // Flush IF/ID
                if_id_pc    <= 32'd0;
                if_id_instr <= 32'd0;
                if_id_valid <= 1'b0;

                // Flush ID/EX
                id_ex_pc        <= 32'd0;
                id_ex_rs1_data  <= 32'd0;
                id_ex_rs2_data  <= 32'd0;
                id_ex_immediate <= 32'd0;

                id_ex_rs1 <= 5'd0;
                id_ex_rs2 <= 5'd0;
                id_ex_rd  <= 5'd0;

                id_ex_reg_write  <= 1'b0;
                id_ex_mem_read   <= 1'b0;
                id_ex_mem_write  <= 1'b0;
                id_ex_mem_to_reg <= 1'b0;
                id_ex_alu_src    <= 1'b0;
                id_ex_branch     <= 1'b0;

                id_ex_alu_control <= ALU_ADD;

            end

            else if (load_use_hazard) begin

                // Stall PC
                pc <= pc;

                // Stall IF/ID
                if_id_pc    <= if_id_pc;
                if_id_instr <= if_id_instr;
                if_id_valid <= if_id_valid;

                // Insert bubble into ID/EX
                id_ex_pc        <= 32'd0;
                id_ex_rs1_data  <= 32'd0;
                id_ex_rs2_data  <= 32'd0;
                id_ex_immediate <= 32'd0;

                id_ex_rs1 <= 5'd0;
                id_ex_rs2 <= 5'd0;
                id_ex_rd  <= 5'd0;

                id_ex_reg_write  <= 1'b0;
                id_ex_mem_read   <= 1'b0;
                id_ex_mem_write  <= 1'b0;
                id_ex_mem_to_reg <= 1'b0;
                id_ex_alu_src    <= 1'b0;
                id_ex_branch     <= 1'b0;

                id_ex_alu_control <= ALU_ADD;

            end

            else begin

                // =================================================
                // IF Stage
                // =================================================

                pc <= pc_plus_4;

                // =================================================
                // IF/ID Register
                // =================================================

                if_id_pc    <= pc;
                if_id_instr <= instruction;
                if_id_valid <= 1'b1;

                // =================================================
                // ID/EX Register
                // =================================================

                id_ex_pc        <= if_id_pc;
                id_ex_rs1_data  <= rs1_data;
                id_ex_rs2_data  <= rs2_data;
                id_ex_immediate <= id_immediate;

                id_ex_rs1 <= id_rs1;
                id_ex_rs2 <= id_rs2;
                id_ex_rd  <= id_rd;

                id_ex_reg_write  <= id_reg_write;
                id_ex_mem_read   <= id_mem_read;
                id_ex_mem_write  <= id_mem_write;
                id_ex_mem_to_reg <= id_mem_to_reg;
                id_ex_alu_src    <= id_alu_src;
                id_ex_branch     <= id_branch;

                id_ex_alu_control <= id_alu_control;

            end

        end

    end

endmodule