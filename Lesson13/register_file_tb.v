`timescale 1ns/1ps

module register_file_tb;

    reg clk;
    reg we;

    reg [2:0] write_addr;
    reg [7:0] write_data;

    reg [2:0] read_addr1;
    reg [2:0] read_addr2;

    wire [7:0] read_data1;
    wire [7:0] read_data2;

    register_file uut (
        .clk(clk),
        .we(we),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("register_file.vcd");
        $dumpvars(0, register_file_tb);

        clk = 0;
        we = 0;

        write_addr = 0;
        write_data = 0;

        read_addr1 = 0;
        read_addr2 = 0;

        #10;

        // Write 25 into R1
        we = 1;
        write_addr = 3'd1;
        write_data = 8'd25;

        #10;

        // Write 40 into R2
        write_addr = 3'd2;
        write_data = 8'd40;

        #10;

        we = 0;

        // Read R1 and R2
        read_addr1 = 3'd1;
        read_addr2 = 3'd2;

        #10;

        $display("R1 = %d", read_data1);
        $display("R2 = %d", read_data2);

        #10;

        // Write 100 into R3
        we = 1;
        write_addr = 3'd3;
        write_data = 8'd100;

        #10;

        we = 0;

        // Read R3
        read_addr1 = 3'd3;

        #10;

        $display("R3 = %d", read_data1);

        #10;

        $finish;

    end

    initial begin
        $monitor(
            "time=%0t clk=%b we=%b WAddr=%d WData=%d RAddr1=%d RData1=%d RAddr2=%d RData2=%d",
            $time,
            clk,
            we,
            write_addr,
            write_data,
            read_addr1,
            read_data1,
            read_addr2,
            read_data2
        );
    end

endmodule