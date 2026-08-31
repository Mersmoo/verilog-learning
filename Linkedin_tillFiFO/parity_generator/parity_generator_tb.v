`timescale 1ns/1ps

module parity_generator_tb;

    reg  [3:0] data;
    wire       even_parity;
    wire       odd_parity;

    parity_generator uut (
        .data(data),
        .even_parity(even_parity),
        .odd_parity(odd_parity)
    );

    initial begin
        $dumpfile("parity_generator.vcd");
        $dumpvars(0, parity_generator_tb);
        $monitor("Time=%0t | Data=%b | Even=%b | Odd=%b",
                 $time, data, even_parity, odd_parity);

        data = 4'b0000;
        #10;

        data = 4'b0001;
        #10;

        data = 4'b0011;
        #10;

        data = 4'b0101;
        #10;

        data = 4'b0111;
        #10;

        data = 4'b1011;
        #10;

        data = 4'b1111;
        #10;

        $finish;

    end

endmodule