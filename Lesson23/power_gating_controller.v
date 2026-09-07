module power_gating_controller (
    input  wire clk,
    input  wire reset,
    input  wire sleep_req,
    input  wire wake_req,

    output reg  power_switch,
    output reg  isolation_enable
);

    localparam RUN        = 3'b000;
    localparam ISOLATE   = 3'b001;
    localparam POWER_OFF = 3'b010;
    localparam POWER_ON  = 3'b011;
    localparam DEISOLATE = 3'b100;

    reg [2:0] state;
    reg [2:0] next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= RUN;
        else
            state <= next_state;
    end

    always @(*) begin

        next_state = state;

        case (state)

            RUN: begin
                if (sleep_req)
                    next_state = ISOLATE;
            end

            ISOLATE: begin
                next_state = POWER_OFF;
            end

            POWER_OFF: begin
                if (wake_req)
                    next_state = POWER_ON;
            end

            POWER_ON: begin
                next_state = DEISOLATE;
            end

            DEISOLATE: begin
                next_state = RUN;
            end

            default: begin
                next_state = RUN;
            end

        endcase
    end

    always @(*) begin

        power_switch     = 1'b1;
        isolation_enable = 1'b0;

        case (state)

            RUN: begin
                power_switch     = 1'b1;
                isolation_enable = 1'b0;
            end

            ISOLATE: begin
                power_switch     = 1'b1;
                isolation_enable = 1'b1;
            end

            POWER_OFF: begin
                power_switch     = 1'b0;
                isolation_enable = 1'b1;
            end

            POWER_ON: begin
                power_switch     = 1'b1;
                isolation_enable = 1'b1;
            end

            DEISOLATE: begin
                power_switch     = 1'b1;
                isolation_enable = 1'b0;
            end

            default: begin
                power_switch     = 1'b1;
                isolation_enable = 1'b0;
            end

        endcase
    end

endmodule