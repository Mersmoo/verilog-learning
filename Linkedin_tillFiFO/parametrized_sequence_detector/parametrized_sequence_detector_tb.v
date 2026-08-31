`timescale 1ns/1ps

module parametrized_sequence_detector_tb;

    reg clk;
    reg reset;
    reg din;

    wire detected;


    parametrized_sequence_detector #(
        .SEQ_WIDTH(4),
        .SEQUENCE(4'b1011)
    ) uut (
        .clk(clk),
        .reset(reset),
        .din(din),
        .detected(detected)
    );


    // 100 MHz clock
    always #5 clk = ~clk;


    // Send one bit
    task send_bit;

        input bit_value;

        begin
            din = bit_value;
            #10;
        end

    endtask


    initial begin

        $dumpfile("parametrized_sequence_detector.vcd");
        $dumpvars(0, parametrized_sequence_detector_tb);

        clk   = 1'b0;
        reset = 1'b1;
        din   = 1'b0;

        #20;

        reset = 1'b0;

        #10;


        // Test sequence: 1011
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);

        #20;


        // Test sequence: 1111
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);

        #20;


        // Test sequence: 1011
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);

        #20;


        $finish;

    end


    always @(posedge clk) begin

        $display(
            "Time=%0t | din=%b | state=%0d | detected=%b",
            $time,
            din,
            uut.state,
            detected
        );

    end

endmodule