`timescale 1ns/1ps

module async_fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 3;

    reg wr_clk;
    reg rd_clk;

    reg wr_reset;
    reg rd_reset;

    reg wr_en;
    reg rd_en;

    reg [DATA_WIDTH-1:0] wr_data;

    wire [DATA_WIDTH-1:0] rd_data;

    wire full;
    wire empty;


    // ---------------------------------------------
    // DUT
    // ---------------------------------------------

    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (

        .wr_clk(wr_clk),
        .wr_reset(wr_reset),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .full(full),

        .rd_clk(rd_clk),
        .rd_reset(rd_reset),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .empty(empty)

    );


    // ---------------------------------------------
    // WRITE CLOCK = 100 MHz
    // ---------------------------------------------

    always #5 wr_clk = ~wr_clk;


    // ---------------------------------------------
    // READ CLOCK ≈ 71.4 MHz
    // ---------------------------------------------

    always #7 rd_clk = ~rd_clk;


    // ---------------------------------------------
    // WRITE TASK
    // ---------------------------------------------

    task write_data;
        input [7:0] data;

        begin

            @(negedge wr_clk);

            if (!full) begin

                wr_en   = 1;
                wr_data = data;

                @(negedge wr_clk);

                wr_en = 0;

            end

        end

    endtask


    // ---------------------------------------------
    // READ TASK
    // ---------------------------------------------

    task read_data;

        begin

            @(negedge rd_clk);

            if (!empty) begin

                rd_en = 1;

                @(negedge rd_clk);

                rd_en = 0;

            end

        end

    endtask


    // ---------------------------------------------
    // TEST
    // ---------------------------------------------

    initial begin

        $dumpfile("async_fifo.vcd");
        $dumpvars(0, async_fifo_tb);


        wr_clk = 0;
        rd_clk = 0;

        wr_reset = 1;
        rd_reset = 1;

        wr_en = 0;
        rd_en = 0;

        wr_data = 0;


        // -----------------------------------------
        // RESET
        // -----------------------------------------

        #20;

        wr_reset = 0;
        rd_reset = 0;


        // -----------------------------------------
        // WRITE
        // -----------------------------------------

        write_data(8'd10);
        write_data(8'd20);
        write_data(8'd30);
        write_data(8'd40);
        write_data(8'd50);
        write_data(8'd60);
        write_data(8'd70);


        // -----------------------------------------
        // WAIT
        // Give Gray pointer time to synchronize
        // -----------------------------------------

        #50;


        // -----------------------------------------
        // READ
        // -----------------------------------------

        read_data();
        read_data();
        read_data();
        read_data();
        read_data();
        read_data();
        read_data();


        #50;

        $finish;

    end


    // ---------------------------------------------
    // WRITE MONITOR
    // ---------------------------------------------

    always @(posedge wr_clk) begin

        $display(
            "WRITE | t=%0t | en=%b | data=%d | full=%b | wr_bin=%b | wr_gray=%b",
            $time,
            wr_en,
            wr_data,
            full,
            uut.wr_ptr_bin,
            uut.wr_ptr_gray
        );

    end


    // ---------------------------------------------
    // READ MONITOR
    // ---------------------------------------------

    always @(posedge rd_clk) begin

        $display(
            "READ  | t=%0t | en=%b | data=%d | empty=%b | rd_bin=%b | rd_gray=%b",
            $time,
            rd_en,
            rd_data,
            empty,
            uut.rd_ptr_bin,
            uut.rd_ptr_gray
        );

    end

endmodule