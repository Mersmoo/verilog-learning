module simple_fsm (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic done,
    output logic [1:0] state
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RUN  = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t current_state, next_state;

    assign state = current_state;

    always_comb begin
        next_state = current_state;

        case (current_state)

            IDLE: begin
                if (start)
                    next_state = RUN;
            end

            RUN: begin
                if (done)
                    next_state = DONE;
            end

            DONE: begin
                if (!start)
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase
    end

    always_ff @(posedge clk) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

endmodule