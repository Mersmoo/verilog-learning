module mux2_tb;

reg I0;
reg I1;
reg S;

wire Y;

mux2 uut (
    .I0(I0),
    .I1(I1),
    .S(S),
    .Y(Y)
);

initial begin
    $dumpfile("mux2.vcd");
    $dumpvars(0, mux2_tb);
    I0 = 0;
    I1 = 0;
    S  = 0;

    #10;

    I0 = 1;
    I1 = 0;
    S  = 0;

    #10;

    I0 = 0;
    I1 = 1;
    S  = 1;

    #10;

    I0 = 1;
    I1 = 0;
    S  = 1;

    #10;

    $finish;

end

endmodule