`timescale 1ns/1ps

module stream_data_processor_tb;

    parameter DATA_WIDTH = 8;

    reg clk;
    reg rst;

    reg [DATA_WIDTH-1:0] data_in;
    reg                  valid_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire                  valid_out;


    stream_data_processor #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),

        .data_in(data_in),
        .valid_in(valid_in),

        .data_out(data_out),
        .valid_out(valid_out)
    );


    always #5 clk = ~clk;


    task send_data;
        input [7:0] data;
        begin

            @(negedge clk);

            data_in  = data;
            valid_in = 1'b1;

            @(negedge clk);

            valid_in = 1'b0;
            data_in  = 8'h00;

        end
    endtask


    initial begin

        $dumpfile("stream_data_processor.vcd");
        $dumpvars(0, stream_data_processor_tb);

        clk = 1'b0;
        rst = 1'b1;

        data_in  = 8'h00;
        valid_in = 1'b0;

        #20;

        rst = 1'b0;


        // Send stream data

        send_data(8'h10);
        send_data(8'h20);
        send_data(8'h30);
        send_data(8'h40);
        send_data(8'h7F);
        send_data(8'hFF);


        #20;

        $display("");
        $display("==============================");
        $display("SIMULATION FINISHED");
        $display("==============================");

        $finish;

    end


    always @(posedge clk) begin

        if (valid_out) begin

            $display(
                "Time=%0t | INPUT=%h | OUTPUT=%h",
                $time,
                data_in,
                data_out
            );

        end

    end

endmodule