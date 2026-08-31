module simple_fsm (
    input  wire clk,
    input  wire reset,
    input  wire unlock,
    output reg  door_open
);

    localparam LOCKED   = 1'b0;
    localparam UNLOCKED = 1'b1;

    // State registers
    reg state;
    reg next_state;

    // State Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= LOCKED;
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (state)

            LOCKED: begin
                if (unlock)
                    next_state = UNLOCKED;
                else
                    next_state = LOCKED;
            end

            UNLOCKED: begin
                if (unlock)
                    next_state = LOCKED;
                else
                    next_state = UNLOCKED;
            end

            default:
                next_state = LOCKED;

        endcase
    end

    // Output Logic
    always @(*) begin
        if (state == UNLOCKED)
            door_open = 1'b1;
        else
            door_open = 1'b0;
    end

endmodule