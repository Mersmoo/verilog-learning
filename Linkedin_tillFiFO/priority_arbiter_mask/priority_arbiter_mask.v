module priority_arbiter_mask #(
    parameter NUM_REQUESTERS = 4
)(
    input  wire [NUM_REQUESTERS-1:0] req,
    input  wire [NUM_REQUESTERS-1:0] mask,

    output reg  [NUM_REQUESTERS-1:0] grant
);

    wire [NUM_REQUESTERS-1:0] masked_req;

    integer i;
    reg grant_found;

    assign masked_req = req & mask;

    always @(*) begin

        grant = {NUM_REQUESTERS{1'b0}};
        grant_found = 1'b0;

        for (i = 0; i < NUM_REQUESTERS; i = i + 1) begin

            if (masked_req[i] && !grant_found) begin
                grant[i] = 1'b1;
                grant_found = 1'b1;
            end

        end

    end

endmodule