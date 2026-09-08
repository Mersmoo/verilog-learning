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