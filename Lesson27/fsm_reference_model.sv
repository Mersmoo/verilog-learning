class fsm_reference_model;

    bit [1:0] expected_state;

    localparam IDLE = 2'b00;
    localparam RUN  = 2'b01;
    localparam DONE = 2'b10;

    function new();

        expected_state = IDLE;

    endfunction

    function void reset();

        expected_state = IDLE;

    endfunction

    function void predict(
        bit rst,
        bit start,
        bit done
    );

        if (rst) begin

            expected_state = IDLE;

        end
        else begin

            case (expected_state)

                IDLE: begin
                    if (start)
                        expected_state = RUN;
                end

                RUN: begin
                    if (done)
                        expected_state = DONE;
                end

                DONE: begin
                    if (!start)
                        expected_state = IDLE;
                end

                default:
                    expected_state = IDLE;

            endcase

        end

    endfunction

endclass