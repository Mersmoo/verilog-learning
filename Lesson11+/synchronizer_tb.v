`timescale 1ns/1ps

module synchronizer_tb;

    reg clk;
    reg reset;
    reg async_signal;

    wire sync_signal;

    synchronizer uut (
        .clk(clk),
        .reset(reset),
        .async_signal(async_signal),
        .sync_signal(sync_signal)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("synchronizer.vcd");
        $dumpvars(0, synchronizer_tb);

        clk = 0;
        reset = 1;
        async_signal = 0;

        #12;

        reset = 0;

        // Change asynchronous signal
        #7;
        async_signal = 1;

        #20;

        async_signal = 0;

        #20;

        async_signal = 1;

        #20;

        $finish;

    end

    always @(posedge clk) begin

        $display(
            "TIME=%0t | async=%b | ff1=%b | sync=%b",
            $time,
            async_signal,
            uut.sync_ff1,
            sync_signal
        );

    end

endmodule