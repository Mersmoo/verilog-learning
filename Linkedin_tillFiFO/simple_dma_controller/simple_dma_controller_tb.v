`timescale 1ns/1ps

module simple_dma_controller_tb;

    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 8;
    parameter MEM_SIZE   = 256;

    reg clk;
    reg rst;

    reg start;

    reg [ADDR_WIDTH-1:0] src_addr;
    reg [ADDR_WIDTH-1:0] length;

    wire [ADDR_WIDTH-1:0] mem_addr;
    reg  [DATA_WIDTH-1:0] mem_data;

    wire [DATA_WIDTH-1:0] data_out;
    wire data_valid;

    wire busy;
    wire done;


    reg [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];

    integer i;


    simple_dma_controller #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),

        .start(start),
        .src_addr(src_addr),
        .length(length),

        .mem_addr(mem_addr),
        .mem_data(mem_data),

        .data_out(data_out),
        .data_valid(data_valid),

        .busy(busy),
        .done(done)
    );


    always #5 clk = ~clk;


    always @(*) begin
        mem_data = memory[mem_addr];
    end


    initial begin

        $dumpfile("simple_dma_controller.vcd");
        $dumpvars(0, simple_dma_controller_tb);


        // Initialize memory

        for (i = 0; i < MEM_SIZE; i = i + 1)
            memory[i] = 8'h00;


        memory[8'h10] = 8'hA1;
        memory[8'h11] = 8'hB2;
        memory[8'h12] = 8'hC3;
        memory[8'h13] = 8'hD4;

        memory[8'h20] = 8'h55;
        memory[8'h21] = 8'h66;
        memory[8'h22] = 8'h77;


        clk = 1'b0;
        rst = 1'b1;

        start    = 1'b0;
        src_addr = 8'h00;
        length   = 8'h00;


        #20;

        rst = 1'b0;


        // Start DMA transfer

        @(negedge clk);

        src_addr = 8'h10;
        length   = 8'd4;
        start    = 1'b1;


        @(negedge clk);

        start = 1'b0;


        wait(done);


        #20;


        // Second DMA transfer

        @(negedge clk);

        src_addr = 8'h20;
        length   = 8'd3;
        start    = 1'b1;


        @(negedge clk);

        start = 1'b0;


        wait(done);


        #20;


        $display("");
        $display("==============================");
        $display("SIMULATION FINISHED");
        $display("==============================");


        $finish;

    end


    always @(posedge clk) begin

        if (data_valid) begin

            $display(
                "Time=%0t | DMA ADDR=%h | DATA=%h",
                $time,
                mem_addr,
                data_out
            );

        end


        if (done) begin

            $display(
                "Time=%0t | DMA TRANSFER DONE",
                $time
            );

        end

    end

endmodule