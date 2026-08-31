module sequence_detector (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  detected
);

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // State Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin

        case (state)

            S0: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S2;
            end

            S2: begin
                if (data)
                    next_state = S3;
                else
                    next_state = S0;
            end

            S3: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S2;
            end

            default:
                next_state = S0;

        endcase
    end

    // Moore Output
    always @(*) begin

        case (state)

            S3:
                detected = 1'b1;

            default:
                detected = 1'b0;

        endcase

    end

endmodule