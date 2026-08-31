`timescale 1ns/1ps

module round_robin_arbiter_tb;

    parameter NUM_REQUESTERS = 4;

    reg clk;
    reg reset;

    reg [NUM_REQUESTERS-1:0] req;
    wire [NUM_REQUESTERS-1:0] grant;

    round_robin_arbiter #(
        .NUM_REQUESTERS(NUM_REQUESTERS)
    ) dut (
        .clk(clk),
        .reset(reset),
        .req(req),
        .grant(grant)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("round_robin_arbiter.vcd");
        $dumpvars(0, round_robin_arbiter_tb);

        clk = 0;
        reset = 1;
        req = 4'b0000;

        #20;

        reset = 0;

        // All requesters request access
        #10;
        req = 4'b1111;

        #10;
        req = 4'b1111;

        #10;
        req = 4'b1111;

        #10;
        req = 4'b1111;

        #10;
        req = 4'b1111;

        // Only requesters 0 and 2 request access
        #10;
        req = 4'b0101;

        #10;
        req = 4'b0101;

        #10;
        req = 4'b0101;

        // No requests
        #10;
        req = 4'b0000;

        #20;

        $finish;

    end

    initial begin

        $monitor(
            "Time=%0t | req=%b | grant=%b | priority=%d",
            $time,
            req,
            grant,
            dut.priority
        );

    end

endmodule