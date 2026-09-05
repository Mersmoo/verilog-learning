`timescale 1ns/1ps

module simple_risc_cpu_tb;

    reg clk;
    reg reset;

    simple_risc_cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        $dumpfile("simple_risc_cpu.vcd");
        $dumpvars(0, simple_risc_cpu_tb);

        clk = 1'b0;
        reset = 1'b1;

        #12;

        reset = 1'b0;

        // Run the CPU
        #100;

        $display("--------------------------------");
        $display("CPU TEST RESULT");
        $display("--------------------------------");

        $display("PC  = %h", uut.pc);

        $display("R0  = %d", uut.u_register_file.registers[0]);
        $display("R1  = %d", uut.u_register_file.registers[1]);
        $display("R2  = %d", uut.u_register_file.registers[2]);
        $display("R3  = %d", uut.u_register_file.registers[3]);
        $display("R4  = %d", uut.u_register_file.registers[4]);
        $display("R5  = %d", uut.u_register_file.registers[5]);
        $display("R6  = %d", uut.u_register_file.registers[6]);
        $display("R7  = %d", uut.u_register_file.registers[7]);

        $display("MEM[5] = %d",
                 uut.u_data_memory.memory[5 >> 0]);

        $display("--------------------------------");

        $finish;

    end

    // Monitor CPU operation
    always @(posedge clk) begin

        $display(
            "TIME=%0t PC=%h INSTR=%h OPCODE=%b R1=%d R2=%d R3=%d R4=%d",
            $time,
            uut.pc,
            uut.instruction_word,
            uut.opcode,
            uut.u_register_file.registers[1],
            uut.u_register_file.registers[2],
            uut.u_register_file.registers[3],
            uut.u_register_file.registers[4]
        );

    end

endmodule