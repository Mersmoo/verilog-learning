module digital_timer #(
    parameter CLK_FREQ = 100_000_000
)(
    input  wire clk,
    input  wire rst,

    input  wire start,
    input  wire stop,

    output reg [5:0] seconds,
    output reg [5:0] minutes,

    output reg running
);

    reg [31:0] clk_counter;

    wire one_second_tick;

    assign one_second_tick = (clk_counter == CLK_FREQ - 1);


    always @(posedge clk or posedge rst) begin

        if (rst) begin

            clk_counter <= 32'd0;

            seconds <= 6'd0;
            minutes <= 6'd0;

            running <= 1'b0;

        end

        else begin

            // Start timer

            if (start)
                running <= 1'b1;

            // Stop timer

            if (stop)
                running <= 1'b0;


            // Generate one-second tick

            if (one_second_tick) begin

                clk_counter <= 32'd0;

            end

            else begin

                clk_counter <= clk_counter + 1'b1;

            end


            // Timer counting

            if (running && one_second_tick) begin

                if (seconds == 6'd59) begin

                    seconds <= 6'd0;

                    if (minutes == 6'd59)
                        minutes <= 6'd0;

                    else
                        minutes <= minutes + 1'b1;

                end

                else begin

                    seconds <= seconds + 1'b1;

                end

            end

        end
    end

endmodule