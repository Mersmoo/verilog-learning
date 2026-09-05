`timescale 1ns/1ps

module simple_8bit_cpu_tb;

    reg clk;
    reg reset;

    // Instantiate CPU
    simple_8bit_cpu cpu (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Generate VCD file
        $dumpfile("simple_8bit_cpu.vcd");
        $dumpvars(0, simple_8bit_cpu_tb);

        // Initialize clock and reset
        clk = 1'b0;
        reset = 1'b1;

        // Program
        // Format: OPCODE RR SS

        // LDI R1, 3
        cpu.instruction_memory[0] = 8'b0001_01_11;

        // LDI R2, 2
        cpu.instruction_memory[1] = 8'b0001_10_10;

        // ADD R1, R2
        cpu.instruction_memory[2] = 8'b0010_01_10;

        // MOV R3, R1
        cpu.instruction_memory[3] = 8'b0110_11_01;

        // ST R3, address 2
        cpu.instruction_memory[4] = 8'b1000_11_10;

        // LD R0, address 2
        cpu.instruction_memory[5] = 8'b0111_00_10;

        // NOP
        cpu.instruction_memory[6] = 8'b0000_00_00;

        // Release reset
        #12;
        reset = 1'b0;

        // Run CPU
        #70;

        // Display results
        $display("");
        $display("====================================");
        $display("Simple 8-bit CPU Results");
        $display("====================================");

        $display("R0       = %d", cpu.registers[0]);
        $display("R1       = %d", cpu.registers[1]);
        $display("R2       = %d", cpu.registers[2]);
        $display("R3       = %d", cpu.registers[3]);
        $display("Memory[2] = %d", cpu.data_memory[2]);
        $display("PC       = %d", cpu.pc);

        $display("====================================");

        // Check results
        if (cpu.registers[1] == 8'd5)
            $display("PASS: R1 = 5");
        else
            $display("FAIL: R1 expected 5");

        if (cpu.registers[3] == 8'd5)
            $display("PASS: R3 = 5");
        else
            $display("FAIL: R3 expected 5");

        if (cpu.data_memory[2] == 8'd5)
            $display("PASS: Memory[2] = 5");
        else
            $display("FAIL: Memory[2] expected 5");

        if (cpu.registers[0] == 8'd5)
            $display("PASS: R0 = 5");
        else
            $display("FAIL: R0 expected 5");

        $display("====================================");

        $finish;

    end

endmodule