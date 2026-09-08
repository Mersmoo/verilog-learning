module simple_fsm_verification_tb;

    interface fsm_if(input logic clk);

        logic rst;
        logic start;
        logic done;

        logic [1:0] state;

    endinterface

    class fsm_transaction;

        rand bit start;
        rand bit done;

        function void display(string name);
            $display(
                "[%s] start=%0b done=%0b",
                name,
                start,
                done
            );
        endfunction

    endclass

    class fsm_generator;

        mailbox #(fsm_transaction) gen2drv;

        function new(mailbox #(fsm_transaction) gen2drv);
            this.gen2drv = gen2drv;
        endfunction

        task run(int count);

            fsm_transaction tr;

            repeat (count) begin

                tr = new();

                assert(tr.randomize());

                tr.display("GENERATOR");

                gen2drv.put(tr);

            end

        endtask

    endclass

    class fsm_driver;

        virtual fsm_if vif;

        mailbox #(fsm_transaction) gen2drv;

        function new(
            virtual fsm_if vif,
            mailbox #(fsm_transaction) gen2drv
        );

            this.vif = vif;
            this.gen2drv = gen2drv;

        endfunction

        task run();

            fsm_transaction tr;

            forever begin

                gen2drv.get(tr);

                @(negedge vif.clk);

                vif.start <= tr.start;
                vif.done  <= tr.done;

                tr.display("DRIVER");

            end

        endtask

    endclass

    class fsm_monitor;

        virtual fsm_if vif;

        mailbox #(fsm_transaction) mon2scb;

        function new(
            virtual fsm_if vif,
            mailbox #(fsm_transaction) mon2scb
        );

            this.vif = vif;
            this.mon2scb = mon2scb;

        endfunction

        task run();

            fsm_transaction tr;

            forever begin

                @(posedge vif.clk);
                #1
                tr = new();

                tr.start = vif.start;
                tr.done  = vif.done;

                mon2scb.put(tr);

                $display(
                    "[MONITOR] start=%0b done=%0b state=%0d",
                    vif.start,
                    vif.done,
                    vif.state
                );

            end

        endtask

    endclass

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

    class fsm_scoreboard;

        virtual fsm_if vif;

        mailbox #(fsm_transaction) mon2scb;

        fsm_reference_model ref_model;

        int pass_count;
        int fail_count;

        function new(
            virtual fsm_if vif,
            mailbox #(fsm_transaction) mon2scb,
            fsm_reference_model ref_model
        );

            this.vif = vif;
            this.mon2scb = mon2scb;
            this.ref_model = ref_model;

            pass_count = 0;
            fail_count = 0;

        endfunction

        task run();

            fsm_transaction tr;
            bit [1:0] expected;

            forever begin

                mon2scb.get(tr);

                ref_model.predict(
                    vif.rst,
                    tr.start,
                    tr.done
                );

                expected = ref_model.expected_state;

                if (vif.state === expected) begin

                    pass_count++;

                    $display(
                        "[SCOREBOARD] PASS | start=%0b done=%0b actual=%0d expected=%0d",
                        tr.start,
                        tr.done,
                        vif.state,
                        expected
                    );

                end
                else begin

                    fail_count++;

                    $display(
                        "[SCOREBOARD] FAIL | start=%0b done=%0b actual=%0d expected=%0d",
                        tr.start,
                        tr.done,
                        vif.state,
                        expected
                    );

                end

            end

        endtask

    endclass

    logic clk;
    fsm_if vif(clk);

    mailbox #(fsm_transaction) gen2drv;
    mailbox #(fsm_transaction) mon2scb;

    fsm_generator        generator;
    fsm_driver           driver;
    fsm_monitor          monitor;
    fsm_reference_model  ref_model;
    fsm_scoreboard       scoreboard;

    // Total transactions the generator will produce; used both to drive
    // the generator and to know when the scoreboard has actually finished
    // checking all of them (fixes the old fixed-delay #100 timing bug).
    localparam int NUM_TRANSACTIONS = 20;

    simple_fsm dut (
        .clk   (clk),
        .rst   (vif.rst),
        .start (vif.start),
        .done  (vif.done),
        .state (vif.state)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        gen2drv = new();
        mon2scb = new();

        ref_model = new();

        generator = new(gen2drv);

        driver = new(
            vif,
            gen2drv
        );

        monitor = new(
            vif,
            mon2scb
        );

        scoreboard = new(
            vif,
            mon2scb,
            ref_model
        );

        vif.start = 0;
        vif.done  = 0;
        vif.rst   = 1;

        repeat (2)
            @(posedge clk);

        // Deassert reset on a negedge, not coincident with the posedge
        // the DUT's always_ff is sensitive to. This removes the race
        // that existed when rst was cleared with a blocking assign at
        // the same time step as a posedge clk event.
        @(negedge clk);
        vif.rst = 0;
        ref_model.reset();

        fork

            driver.run();

            monitor.run();

            scoreboard.run();

        join_none

        generator.run(NUM_TRANSACTIONS);

        // Wait for the scoreboard to actually finish checking every
        // transaction instead of a fixed #100 delay. With the old fixed
        // delay, only ~10 of 20 transactions were ever driven/scored
        // before $finish fired, silently passing regardless of bugs in
        // the untested back half of the stimulus.
        wait (
            (scoreboard.pass_count + scoreboard.fail_count)
            == NUM_TRANSACTIONS
        );

        #10;

        $display("");
        $display("========================================");
        $display("        VERIFICATION SUMMARY");
        $display("========================================");
        $display("PASS = %0d", scoreboard.pass_count);
        $display("FAIL = %0d", scoreboard.fail_count);
        $display("========================================");

        if (scoreboard.fail_count == 0)
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