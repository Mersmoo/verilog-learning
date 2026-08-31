`timescale 1ns/1ps

module pwm_generator_tb;

    reg clk;
    reg rst;

    reg [7:0] duty_cycle;

    wire pwm;


    // PWM Generator instance

    pwm_generator #(
        .COUNTER_WIDTH(8)
    ) uut (

        .clk(clk),
        .rst(rst),
        .duty_cycle(duty_cycle),
        .pwm(pwm)

    );


    // 100 MHz clock

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // Test sequence

    initial begin

        rst = 1'b1;
        duty_cycle = 8'd0;

        #20;

        rst = 1'b0;


        // 25% duty cycle

        duty_cycle = 8'd64;

        #2560;


        // 50% duty cycle

        duty_cycle = 8'd128;

        #2560;


        // 75% duty cycle

        duty_cycle = 8'd192;

        #2560;


        // 100% duty cycle

        duty_cycle = 8'd255;

        #2560;


        // 0% duty cycle

        duty_cycle = 8'd0;

        #2560;


        $finish;

    end


    // VCD waveform

    initial begin

        $dumpfile("pwm_generator.vcd");
        $dumpvars(0, pwm_generator_tb);
    end

endmodule