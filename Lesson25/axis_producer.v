module axis_producer (
    input  wire        clk,
    input  wire        rst,

    output reg [31:0]  data,
    output reg         valid,
    input  wire        ready
);

    reg [2:0] index;

    always @(posedge clk) begin
        if (rst) begin
            data  <= 32'd0;
            valid <= 1'b0;
            index <= 3'd0;
        end
        else begin
            if (!valid) begin
                if (index < 5) begin
                    data  <= (index + 1) * 32'd10;
                    valid <= 1'b1;
                end
            end
            else if (ready) begin
                if (index == 4) begin
                    valid <= 1'b0;
                    index <= index + 1'b1;
                end
                else begin
                    index <= index + 1'b1;
                    data  <= (index + 2) * 32'd10;
                end
            end
        end
    end

endmodule