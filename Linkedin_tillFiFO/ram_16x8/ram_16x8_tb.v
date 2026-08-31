`timescale 1ns/1ps

module ram_16x8_tb;

    reg        clk;
    reg        we;
    reg [3:0]  addr;
    reg [7:0]  write_data;

    wire [7:0] read_data;


    ram_16x8 uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );


    // 100 MHz clock
    always #5 clk = ~clk;


    initial begin

        $dumpfile("ram_16x8.vcd");
        $dumpvars(0, ram_16x8_tb);

        clk        = 1'b0;
        we         = 1'b0;
        addr       = 4'd0;
        write_data = 8'h00;


        // -------------------------
        // Write data to RAM
        // -------------------------

        // Address 0 = AA
        #10;
        addr       = 4'd0;
        write_data = 8'hAA;
        we         = 1'b1;

        #10;


        // Address 1 = BB
        addr       = 4'd1;
        write_data = 8'hBB;

        #10;


        // Address 2 = CC
        addr       = 4'd2;
        write_data = 8'hCC;

        #10;


        // Address 3 = DD
        addr       = 4'd3;
        write_data = 8'hDD;

        #10;


        // Disable write
        we = 1'b0;

        #10;


        // -------------------------
        // Read data from RAM
        // -------------------------

        // Read address 0
        addr = 4'd0;
        #10;

        $display(
            "READ: Address=%0d Data=0x%02h",
            addr,
            read_data
        );


        // Read address 1
        addr = 4'd1;
        #10;

        $display(
            "READ: Address=%0d Data=0x%02h",
            addr,
            read_data
        );


        // Read address 2
        addr = 4'd2;
        #10;

        $display(
            "READ: Address=%0d Data=0x%02h",
            addr,
            read_data
        );


        // Read address 3
        addr = 4'd3;
        #10;

        $display(
            "READ: Address=%0d Data=0x%02h",
            addr,
            read_data
        );


        #20;

        $finish;

    end


    always @(posedge clk) begin

        $display(
            "Time=%0t | WE=%b | ADDR=%0d | WRITE_DATA=0x%02h | READ_DATA=0x%02h",
            $time,
            we,
            addr,
            write_data,
            read_data
        );

    end

endmodule