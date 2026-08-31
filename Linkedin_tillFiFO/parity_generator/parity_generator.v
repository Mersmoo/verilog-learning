module parity_generator (
    input  [3:0] data,
    output       even_parity,
    output       odd_parity
);

    assign even_parity = data[3] ^
                         data[2] ^
                         data[1] ^
                         data[0];

    assign odd_parity = ~even_parity;

endmodule