interface fsm_if(input logic clk);

    logic rst;
    logic start;
    logic done;

    logic [1:0] state;

endinterface