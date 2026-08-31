`timescale 1ns/1ps

module dual_port_ram_tb;

    reg        clk;

    // Write port
    reg        we;
    reg [3:0]  write_addr;
    reg [7:0]  write_data;

    // Read port
    reg [3:0]  read_addr;
    wire [7:0] read_data;


    dual_port_ram #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(4)
    ) uut (
        .clk(clk),

        .we(we),
        .write_addr(write_addr),
        .write_data(write_data),

        .read_addr(read_addr),
        .read_data(read_data)
    );


    // 100 MHz clock
    always #5 clk = ~clk;


    initial begin

        $dumpfile("dual_port_ram.vcd");
        $dumpvars(0, dual_port_ram_tb);

        clk        = 1'b0;
        we         = 1'b0;
        write_addr = 4'd0;
        write_data = 8'h00;
        read_addr  = 4'd0;


        // --------------------------------
        // Write data into RAM
        // --------------------------------

        // Write AA to address 0
        #10;
        we         = 1'b1;
        write_addr = 4'd0;
        write_data = 8'hAA;

        #10;


        // Write BB to address 1
        write_addr = 4'd1;
        write_data = 8'hBB;

        #10;


        // Write CC to address 2
        write_addr = 4'd2;
        write_data = 8'hCC;

        #10;


        // Write DD to address 3
        write_addr = 4'd3;
        write_data = 8'hDD;

        #10;


        // Disable write
        we = 1'b0;

        #10;


        // --------------------------------
        // Read data using Port B
        // --------------------------------

        // Read address 0
        read_addr = 4'd0;
        #10;

        $display(
            "READ: Address=%0d Data=0x%02h",
            read_addr,
            read_data
        );


        // Read address 1
        read_addr = 4'd1;
        #10;

        $display(
            "READ: Address=%0d Data=0x%02h",
            read_addr,
            read_data
        );


        // Read address 2
        read_addr = 4'd2;
        #10;

        $display(
            "READ: Address=%0d Data=0x%02h",
            read_addr,
            read_data
        );


        // Read address 3
        read_addr = 4'd3;
        #10;

        $display(
            "READ: Address=%0d Data=0x%02h",
            read_addr,
            read_data
        );


        // --------------------------------
        // Simultaneous Write and Read
        // --------------------------------

        #10;

        we         = 1'b1;
        write_addr = 4'd4;
        write_data = 8'hEE;

        read_addr  = 4'd2;

        #10;

        $display(
            "SIMULTANEOUS: Write Addr=%0d Data=0x%02h | Read Addr=%0d Data=0x%02h",
            write_addr,
            write_data,
            read_addr,
            read_data
        );


        // --------------------------------
        // Read newly written address
        // --------------------------------

        we = 1'b0;

        read_addr = 4'd4;

        #10;

        $display(
            "READ NEW DATA: Address=%0d Data=0x%02h",
            read_addr,
            read_data
        );


        #20;

        $finish;

    end


    // Display signals at every positive clock edge
    always @(posedge clk) begin

        $display(
            "Time=%0t | WE=%b | W_ADDR=%0d | W_DATA=0x%02h | R_ADDR=%0d | R_DATA=0x%02h",
            $time,
            we,
            write_addr,
            write_data,
            read_addr,
            read_data
        );

    end

endmodule