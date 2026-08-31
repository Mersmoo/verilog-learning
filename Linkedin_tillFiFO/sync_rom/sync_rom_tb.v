`timescale 1ns/1ps

module sync_rom_tb;

    reg clk;
    reg [3:0] addr;

    wire [7:0] data;


    sync_rom #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(4)
    ) uut (
        .clk(clk),
        .addr(addr),
        .data(data)
    );


    // 100 MHz clock
    always #5 clk = ~clk;


    initial begin

        $dumpfile("sync_rom.vcd");
        $dumpvars(0, sync_rom_tb);

        clk  = 1'b0;
        addr = 4'd0;


        // Read address 0
        #10;
        addr = 4'd0;

        #10;


        // Read address 1
        addr = 4'd1;

        #10;


        // Read address 2
        addr = 4'd2;

        #10;


        // Read address 3
        addr = 4'd3;

        #10;


        // Read address 4
        addr = 4'd4;

        #10;


        // Read address 5
        addr = 4'd5;

        #10;


        // Read address 6
        addr = 4'd6;

        #10;


        // Read address 7
        addr = 4'd7;

        #10;


        $finish;

    end


    always @(posedge clk) begin

        $display(
            "Time=%0t | Address=%0d | Data=0x%02h",
            $time,
            addr,
            data
        );

    end

endmodule