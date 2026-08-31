module universal_shift_register (
    input        clk,
    input        reset,
    input  [1:0]  mode,
    input        serial_in_left,
    input        serial_in_right,
    input  [3:0]  parallel_in,
    output reg [3:0] q
);

always @(posedge clk or posedge reset) begin

    if (reset)
        q <= 4'b0000;

    else begin

        case (mode)

            2'b00: begin
                // Hold
                q <= q;
            end

            2'b01: begin
                // Shift Right
                q <= {serial_in_left, q[3:1]};
            end

            2'b10: begin
                // Shift Left
                q <= {q[2:0], serial_in_right};
            end

            2'b11: begin
                // Parallel Load
                q <= parallel_in;
            end

        endcase

    end
end

endmodule