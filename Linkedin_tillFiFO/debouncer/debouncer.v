module debouncer #(
    parameter COUNTER_WIDTH = 20
)(
    input  wire clk,
    input  wire rst,
    input  wire button,

    output reg  button_clean
);

    reg button_sync_1;
    reg button_sync_2;

    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            button_sync_1 <= 1'b0;
            button_sync_2 <= 1'b0;

            button_clean <= 1'b0;

            counter <= 0;

        end

        else begin

            // Two-stage synchronizer

            button_sync_1 <= button;
            button_sync_2 <= button_sync_1;


            // Button is stable

            if (button_sync_2 == button_clean) begin

                counter <= 0;

            end

            else begin

                if (&counter) begin

                    button_clean <= button_sync_2;
                    counter <= 0;

                end

                else begin

                    counter <= counter + 1'b1;

                end

            end
        end
    end

endmodule