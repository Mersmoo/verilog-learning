`timescale 1ns/1ps

module data_memory_tb;

    reg         clk;
    reg         mem_write;
    reg         mem_read;
    reg  [31:0] address;
    reg  [31:0] write_data;
    wire [31:0] read_data;

    data_memory uut (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("data_memory.vcd");
        $dumpvars(0, data_memory_tb);

        clk = 0;
        mem_write = 0;
        mem_read = 0;
        address = 0;
        write_data = 0;

        #10;

        // Write 100 to address 0
        address = 32'h00000000;
        write_data = 32'd100;
        mem_write = 1;

        #10;

        mem_write = 0;

        // Read address 0
        mem_read = 1;

        #5;

        $display("Read address 0 = %d", read_data);

        #5;

        // Write 200 to address 4
        mem_read = 0;
        address = 32'h00000004;
        write_data = 32'd200;
        mem_write = 1;

        #10;

        mem_write = 0;

        // Read address 4
        mem_read = 1;

        #5;

        $display("Read address 4 = %d", read_data);

        #5;

        // Write 12345 to address 8
        mem_read = 0;
        address = 32'h00000008;
        write_data = 32'd12345;
        mem_write = 1;

        #10;

        mem_write = 0;

        // Read address 8
        mem_read = 1;

        #5;

        $display("Read address 8 = %d", read_data);

        #5;

        $finish;

    end

endmodule