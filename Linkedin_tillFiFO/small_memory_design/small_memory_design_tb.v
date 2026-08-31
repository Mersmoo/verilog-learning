`timescale 1ns/1ps

module small_memory_design_tb;

    reg  [3:0] input_data;
    wire [7:0] output_data;


    small_memory_design #(
        .ADDR_WIDTH(4),
        .DATA_WIDTH(8)
    ) uut (
        .input_data(input_data),
        .output_data(output_data)
    );


    initial begin

        $dumpfile("small_memory_design.vcd");
        $dumpvars(0, small_memory_design_tb);

        input_data = 4'd0;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd1;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd2;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd3;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd4;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd5;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd6;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd7;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd8;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd9;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd10;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd11;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd12;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd13;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd14;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        input_data = 4'd15;
        #10;

        $display("Input=%0d | Output=%0d", input_data, output_data);


        $finish;

    end

endmodule