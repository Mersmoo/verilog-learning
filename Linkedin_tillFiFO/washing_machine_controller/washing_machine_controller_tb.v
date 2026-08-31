`timescale 1ns/1ps

module washing_machine_controller_tb;

    reg clk;
    reg reset;

    reg start;
    reg water_full;
    reg wash_done;
    reg drain_done;
    reg spin_done;

    wire water_valve;
    wire wash_motor;
    wire drain_pump;
    wire spin_motor;
    wire done;

    washing_machine_controller uut (
        .clk(clk),
        .reset(reset),

        .start(start),
        .water_full(water_full),
        .wash_done(wash_done),
        .drain_done(drain_done),
        .spin_done(spin_done),

        .water_valve(water_valve),
        .wash_motor(wash_motor),
        .drain_pump(drain_pump),
        .spin_motor(spin_motor),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    // VCD generation
    initial begin
        $dumpfile("washing_machine_controller.vcd");
        $dumpvars(0, washing_machine_controller_tb);
    end

    // Test sequence
    initial begin

        clk = 0;
        reset = 1;

        start      = 0;
        water_full = 0;
        wash_done  = 0;
        drain_done = 0;
        spin_done  = 0;

        #12;

        reset = 0;

        // Start washing machine
        start = 1;
        #10;
        start = 0;

        // Fill state
        #20;
        water_full = 1;
        #10;
        water_full = 0;

        // Wash state
        #20;
        wash_done = 1;
        #10;
        wash_done = 0;

        // Drain state
        #20;
        drain_done = 1;
        #10;
        drain_done = 0;

        // Spin state
        #20;
        spin_done = 1;
        #10;
        spin_done = 0;

        // Done state
        #20;

        $finish;

    end

    // Monitor signals
    initial begin
        $monitor(
            "Time=%0t | CLK=%b | RESET=%b | START=%b | WATER_FULL=%b | WASH_DONE=%b | DRAIN_DONE=%b | SPIN_DONE=%b | VALVE=%b | WASH_MOTOR=%b | PUMP=%b | SPIN_MOTOR=%b | DONE=%b",
            $time,
            clk,
            reset,
            start,
            water_full,
            wash_done,
            drain_done,
            spin_done,
            water_valve,
            wash_motor,
            drain_pump,
            spin_motor,
            done
        );
    end

endmodule