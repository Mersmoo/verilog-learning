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