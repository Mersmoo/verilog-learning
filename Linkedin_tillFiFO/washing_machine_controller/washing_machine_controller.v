module washing_machine_controller (
    input  wire clk,
    input  wire reset,

    input  wire start,
    input  wire water_full,
    input  wire wash_done,
    input  wire drain_done,
    input  wire spin_done,

    output reg water_valve,
    output reg wash_motor,
    output reg drain_pump,
    output reg spin_motor,
    output reg done
);

    // State definitions
    localparam IDLE  = 3'b000;
    localparam FILL  = 3'b001;
    localparam WASH  = 3'b010;
    localparam DRAIN = 3'b011;
    localparam SPIN  = 3'b100;
    localparam DONE  = 3'b101;

    reg [2:0] state;
    reg [2:0] next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin

        next_state = state;

        case (state)

            IDLE: begin
                if (start)
                    next_state = FILL;
            end

            FILL: begin
                if (water_full)
                    next_state = WASH;
            end

            WASH: begin
                if (wash_done)
                    next_state = DRAIN;
            end

            DRAIN: begin
                if (drain_done)
                    next_state = SPIN;
            end

            SPIN: begin
                if (spin_done)
                    next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase
    end

    // Output logic
    always @(*) begin

        water_valve = 1'b0;
        wash_motor  = 1'b0;
        drain_pump  = 1'b0;
        spin_motor   = 1'b0;
        done         = 1'b0;

        case (state)

            IDLE: begin
            end

            FILL: begin
                water_valve = 1'b1;
            end

            WASH: begin
                wash_motor = 1'b1;
            end

            DRAIN: begin
                drain_pump = 1'b1;
            end

            SPIN: begin
                spin_motor = 1'b1;
            end

            DONE: begin
                done = 1'b1;
            end

        endcase
    end

endmodule