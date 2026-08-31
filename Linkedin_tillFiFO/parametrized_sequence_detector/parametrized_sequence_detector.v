module parametrized_sequence_detector #(
    parameter integer SEQ_WIDTH = 4,
    parameter [SEQ_WIDTH-1:0] SEQUENCE = 4'b1011
)(
    input  wire clk,
    input  wire reset,
    input  wire din,

    output reg detected
);

    localparam integer STATE_WIDTH =
        $clog2(SEQ_WIDTH + 1);

    reg [STATE_WIDTH-1:0] state;

    integer i;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            state    <= 0;
            detected <= 1'b0;
        end

        else begin

            detected <= 1'b0;

            if (din == SEQUENCE[SEQ_WIDTH-1-state]) begin

                if (state == SEQ_WIDTH - 1) begin
                    state    <= 0;
                    detected <= 1'b1;
                end

                else begin
                    state <= state + 1;
                end

            end

            else begin
                state <= 0;
            end

        end

    end

endmodule