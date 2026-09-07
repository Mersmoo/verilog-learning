module axis_consumer (
    input  wire        clk,
    input  wire        rst,

    input  wire [31:0] data,
    input  wire        valid,
    output reg         ready
);

    reg [3:0] cycle_count;

    always @(posedge clk) begin
        if (rst) begin
            ready       <= 1'b0;
            cycle_count <= 4'd0;
        end
        else begin
            cycle_count <= cycle_count + 1'b1;

            if ((cycle_count == 2) ||
                (cycle_count == 3) ||
                (cycle_count == 7)) begin
                ready <= 1'b0;
            end
            else begin
                ready <= 1'b1;
            end

            if (valid && ready) begin
                $display(
                    "TRANSFER: time=%0t DATA=%0d",
                    $time,
                    data
                );
            end
        end
    end

endmodule