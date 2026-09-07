`timescale 1ns/1ps

module power_gating_controller_tb;

    reg clk;
    reg reset;
    reg sleep_req;
    reg wake_req;

    wire power_switch;
    wire isolation_enable;

    power_gating_controller dut (
        .clk(clk),
        .reset(reset),
        .sleep_req(sleep_req),
        .wake_req(wake_req),
        .power_switch(power_switch),
        .isolation_enable(isolation_enable)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("power_gating.vcd");
        $dumpvars(0, power_gating_controller_tb);

        clk = 0;
        reset = 1;
        sleep_req = 0;
        wake_req = 0;

        #20;
        reset = 0;

        // Normal operation
        #20;

        // Request power down
        sleep_req = 1;

        #10;
        sleep_req = 0;

        // Wait in power-down state
        #30;

        // Request wake-up
        wake_req = 1;

        #10;
        wake_req = 0;

        #30;

        $finish;

    end

    initial begin

        $monitor(
            "Time=%0t | Reset=%b Sleep=%b Wake=%b | Power=%b Isolation=%b",
            $time,
            reset,
            sleep_req,
            wake_req,
            power_switch,
            isolation_enable
        );

    end

endmodule