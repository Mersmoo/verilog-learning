`timescale 1ns/1ps

module priority_arbiter_mask_tb;

    parameter NUM_REQUESTERS = 4;

    reg [NUM_REQUESTERS-1:0] req;
    reg [NUM_REQUESTERS-1:0] mask;

    wire [NUM_REQUESTERS-1:0] grant;

    priority_arbiter_mask #(
        .NUM_REQUESTERS(NUM_REQUESTERS)
    ) dut (
        .req(req),
        .mask(mask),
        .grant(grant)
    );

    initial begin

        $dumpfile("priority_arbiter_mask.vcd");
        $dumpvars(0, priority_arbiter_mask_tb);

        // No requests
        req  = 4'b0000;
        mask = 4'b1111;

        #10;

        // All requesters active
        req  = 4'b1111;
        mask = 4'b1111;

        #10;

        // Mask requester 0
        req  = 4'b1111;
        mask = 4'b1110;

        #10;

        // Allow only requester 2 and 3
        req  = 4'b1111;
        mask = 4'b1100;

        #10;

        // Only requester 3 remains after masking
        req  = 4'b1010;
        mask = 4'b1101;

        #10;

        // Requester 0 and 2 active
        req  = 4'b0101;
        mask = 4'b1111;

        #10;

        // Requester 0 is masked
        req  = 4'b0101;
        mask = 4'b1110;

        #10;

        // All requests masked
        req  = 4'b1111;
        mask = 4'b0000;

        #10;

        $finish;

    end

    initial begin

        $monitor(
            "Time=%0t | req=%b | mask=%b | masked_req=%b | grant=%b",
            $time,
            req,
            mask,
            dut.masked_req,
            grant
        );

    end

endmodule