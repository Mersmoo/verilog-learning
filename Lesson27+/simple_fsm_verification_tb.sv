module simple_fsm_verification_tb;

    // -----------------------------------------------------------------
    // NOTE ON SIMULATOR COMPATIBILITY
    // -----------------------------------------------------------------
    // The original version of this testbench used a class-based
    // generator/driver/monitor/scoreboard architecture with mailboxes
    // and virtual interfaces, which is a common SystemVerilog
    // verification style. Icarus Verilog (12.0 stable) was tested
    // directly and does not support several constructs that style
    // depends on:
    //   - the built-in `mailbox` class (parameterized OR plain)
    //   - `event` as a class member
    //   - queues / dynamic arrays of class-handle type
    //   - `virtual <interface>` as a class member
    // Any one of these breaks the class-based approach on this
    // toolchain. This version keeps the exact same functional
    // structure (generate stimulus -> drive DUT -> monitor DUT ->
    // predict expected state -> compare) but implemented with plain
    // tasks and module-scope signals/queues instead of classes, which
    // iverilog fully supports.
    // -----------------------------------------------------------------

    localparam int NUM_TRANSACTIONS = 20;

    // Reference-model states (mirrors simple_fsm's encoding)
    localparam bit [1:0] IDLE = 2'b00;
    localparam bit [1:0] RUN  = 2'b01;
    localparam bit [1:0] DONE = 2'b10;

    logic clk;
    logic rst;
    logic start;
    logic done;
    logic [1:0] state;

    simple_fsm dut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .done  (done),
        .state (state)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // -----------------------------------------------------------------
    // Stimulus queue: generator pushes {start,done} pairs, driver pops
    // them. Plain bit queues (not class-handle queues) are supported.
    // -----------------------------------------------------------------
    bit gen_start_q[$];
    bit gen_done_q[$];

    // Sampled queue: monitor pushes what it saw, scoreboard pops it.
    bit mon_start_q[$];
    bit mon_done_q[$];

    int pass_count = 0;
    int fail_count = 0;

    // -----------------------------------------------------------------
    // Generator: produces NUM_TRANSACTIONS random {start,done} pairs
    // -----------------------------------------------------------------
    task automatic gen_run(int count);
        bit r_start, r_done;
        repeat (count) begin
            r_start = $urandom_range(0, 1);
            r_done  = $urandom_range(0, 1);

            gen_start_q.push_back(r_start);
            gen_done_q.push_back(r_done);

            $display(
                "[GENERATOR] start=%0b done=%0b",
                r_start,
                r_done
            );
        end
    endtask

    // -----------------------------------------------------------------
    // Driver: pops one stimulus item per negedge and drives the DUT
    // -----------------------------------------------------------------
    task automatic drv_run();
        bit d_start, d_done;
        forever begin
            while (gen_start_q.size() == 0)
                #1;

            d_start = gen_start_q.pop_front();
            d_done  = gen_done_q.pop_front();

            @(negedge clk);

            start <= d_start;
            done  <= d_done;

            $display(
                "[DRIVER] start=%0b done=%0b",
                d_start,
                d_done
            );
        end
    endtask

    // -----------------------------------------------------------------
    // Monitor: samples the DUT inputs/outputs one step after posedge
    // -----------------------------------------------------------------
    task automatic mon_run();
        forever begin
            @(posedge clk);
            #1;

            mon_start_q.push_back(start);
            mon_done_q.push_back(done);

            $display(
                "[MONITOR] start=%0b done=%0b state=%0d",
                start,
                done,
                state
            );
        end
    endtask

    // -----------------------------------------------------------------
    // Reference model + scoreboard: predicts expected state from the
    // sampled {start,done} pair and compares against the DUT's actual
    // state.
    // -----------------------------------------------------------------
    bit [1:0] expected_state = IDLE;

    function automatic void ref_predict(bit p_rst, bit p_start, bit p_done);
        if (p_rst) begin
            expected_state = IDLE;
        end
        else begin
            case (expected_state)
                IDLE: if (p_start) expected_state = RUN;
                RUN:  if (p_done)  expected_state = DONE;
                DONE: if (!p_start) expected_state = IDLE;
                default: expected_state = IDLE;
            endcase
        end
    endfunction

    task automatic scb_run();
        bit s_start, s_done;
        bit [1:0] expected;

        forever begin
            while (mon_start_q.size() == 0)
                #1;

            s_start = mon_start_q.pop_front();
            s_done  = mon_done_q.pop_front();

            ref_predict(rst, s_start, s_done);
            expected = expected_state;

            if (state === expected) begin
                pass_count++;
                $display(
                    "[SCOREBOARD] PASS | start=%0b done=%0b actual=%0d expected=%0d",
                    s_start,
                    s_done,
                    state,
                    expected
                );
            end
            else begin
                fail_count++;
                $display(
                    "[SCOREBOARD] FAIL | start=%0b done=%0b actual=%0d expected=%0d",
                    s_start,
                    s_done,
                    state,
                    expected
                );
            end
        end
    endtask

    // -----------------------------------------------------------------
    // Top-level sequencing
    // -----------------------------------------------------------------
    initial begin

        start = 0;
        done  = 0;
        rst   = 1;

        repeat (2)
            @(posedge clk);

        // Deassert reset on a negedge, not coincident with the posedge
        // the DUT's always_ff is sensitive to, to avoid a race on the
        // simulation time step where both events would otherwise fire.
        @(negedge clk);
        rst = 0;
        expected_state = IDLE;

        fork
            drv_run();
            mon_run();
            scb_run();
        join_none

        gen_run(NUM_TRANSACTIONS);

        // Wait for the scoreboard to actually finish checking every
        // transaction instead of guessing a fixed delay - avoids
        // ending the sim before the later transactions are scored.
        wait ((pass_count + fail_count) == NUM_TRANSACTIONS);

        #10;

        $display("");
        $display("========================================");
        $display("        VERIFICATION SUMMARY");
        $display("========================================");
        $display("PASS = %0d", pass_count);
        $display("FAIL = %0d", fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $display("========================================");

        $finish;

    end

    initial begin
        $dumpfile("simple_fsm_verification.vcd");
        $dumpvars(0, simple_fsm_verification_tb);
    end

endmodule