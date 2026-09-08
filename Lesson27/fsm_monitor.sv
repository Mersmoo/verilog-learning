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