module priority_encoder16to4 (
    input  [15:0] in,
    output reg [3:0] out
);

    always @(*) begin

        if (in[15])
            out = 4'b1111;

        else if (in[14])
            out = 4'b1110;

        else if (in[13])
            out = 4'b1101;

        else if (in[12])
            out = 4'b1100;

        else if (in[11])
            out = 4'b1011;

        else if (in[10])
            out = 4'b1010;

        else if (in[9])
            out = 4'b1001;

        else if (in[8])
            out = 4'b1000;

        else if (in[7])
            out = 4'b0111;

        else if (in[6])
            out = 4'b0110;

        else if (in[5])
            out = 4'b0101;

        else if (in[4])
            out = 4'b0100;

        else if (in[3])
            out = 4'b0011;

        else if (in[2])
            out = 4'b0010;

        else if (in[1])
            out = 4'b0001;

        else if (in[0])
            out = 4'b0000;

        else
            out = 4'b0000;

    end

endmodule