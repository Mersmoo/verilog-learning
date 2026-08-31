module round_robin_arbiter #(
    parameter NUM_REQUESTERS = 4
)(
    input  wire                     clk,
    input  wire                     reset,

    input  wire [NUM_REQUESTERS-1:0] req,

    output reg  [NUM_REQUESTERS-1:0] grant
);

    integer i;
    integer index;

    reg [1:0] priority;
    reg       grant_found;

    always @(*) begin

        grant = 4'b0000;
        grant_found = 1'b0;

        for (i = 0; i < NUM_REQUESTERS; i = i + 1) begin

            index = priority + i;

            if (index >= NUM_REQUESTERS)
                index = index - NUM_REQUESTERS;

            if (req[index] && !grant_found) begin
                grant[index] = 1'b1;
                grant_found = 1'b1;
            end

        end

    end

    always @(posedge clk) begin

        if (reset) begin
            priority <= 2'd0;
        end

        else begin

            if (grant != 4'b0000) begin

                if (grant[0])
                    priority <= 2'd1;

                else if (grant[1])
                    priority <= 2'd2;

                else if (grant[2])
                    priority <= 2'd3;

                else if (grant[3])
                    priority <= 2'd0;

            end

        end

    end

endmodule