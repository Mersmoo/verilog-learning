module crossbar_4x4 #(
    parameter DATA_WIDTH = 8
)(
    input  [DATA_WIDTH-1:0] in0,
    input  [DATA_WIDTH-1:0] in1,
    input  [DATA_WIDTH-1:0] in2,
    input  [DATA_WIDTH-1:0] in3,

    input  [1:0] sel0,
    input  [1:0] sel1,
    input  [1:0] sel2,
    input  [1:0] sel3,

    output reg [DATA_WIDTH-1:0] out0,
    output reg [DATA_WIDTH-1:0] out1,
    output reg [DATA_WIDTH-1:0] out2,
    output reg [DATA_WIDTH-1:0] out3
);

always @(*) begin

    // Output 0 selection
    case (sel0)
        2'b00: out0 = in0;
        2'b01: out0 = in1;
        2'b10: out0 = in2;
        2'b11: out0 = in3;
        default: out0 = {DATA_WIDTH{1'b0}};
    endcase

    // Output 1 selection
    case (sel1)
        2'b00: out1 = in0;
        2'b01: out1 = in1;
        2'b10: out1 = in2;
        2'b11: out1 = in3;
        default: out1 = {DATA_WIDTH{1'b0}};
    endcase

    // Output 2 selection
    case (sel2)
        2'b00: out2 = in0;
        2'b01: out2 = in1;
        2'b10: out2 = in2;
        2'b11: out2 = in3;
        default: out2 = {DATA_WIDTH{1'b0}};
    endcase

    // Output 3 selection
    case (sel3)
        2'b00: out3 = in0;
        2'b01: out3 = in1;
        2'b10: out3 = in2;
        2'b11: out3 = in3;
        default: out3 = {DATA_WIDTH{1'b0}};
    endcase

end

endmodule