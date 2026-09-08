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