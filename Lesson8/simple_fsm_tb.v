`timescale 1ns/1ps

module simple_fsm_tb;

    reg clk;
    reg reset;
    reg unlock;

    wire door_open;

    simple_fsm uut (
        .clk(clk),
        .reset(reset),
        .unlock(unlock),
        .door_open(door_open)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
    $dumpfile("simple_FSM.vcd");
    $dumpvars(0, simple_fsm_tb);
        $monitor(
            "Time=%0t | reset=%b | unlock=%b | state=%b | door_open=%b",
            $time,
            reset,
            unlock,
            uut.state,
            door_open
        );

        clk = 0;
        reset = 1;
        unlock = 0;

        #10;

        reset = 0;

        #10;
        unlock = 1;

        #10;
        unlock = 0;

        #20;
        unlock = 1;

        #10;
        unlock = 0;

        #20;

        $finish;

    end

endmodule