module t_flip_flop (
    input  wire clk,
    input  wire reset,
    input  wire t,
    output reg  q
);

    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end

endmodule