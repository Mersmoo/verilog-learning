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