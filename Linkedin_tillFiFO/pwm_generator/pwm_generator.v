module pwm_generator #(
    parameter COUNTER_WIDTH = 8
)(
    input  wire                     clk,
    input  wire                     rst,
    input  wire [COUNTER_WIDTH-1:0] duty_cycle,

    output reg                      pwm
);

    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            counter <= 0;
            pwm     <= 0;
        end

        else begin

            counter <= counter + 1'b1;

            if (counter < duty_cycle)
                pwm <= 1'b1;
            else
                pwm <= 1'b0;
        end
    end

endmodule