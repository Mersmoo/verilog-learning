module single_cycle_alu (
    input  [7:0] A,
    input  [7:0] B,
    input  [2:0] ALUControl,

    output reg [7:0] Result,
    output reg       Zero,
    output reg       Carry
);

    reg [8:0] temp;

    always @(*) begin

        Result = 8'b0;
        Carry  = 1'b0;
        temp   = 9'b0;

        case (ALUControl)

            3'b000: begin
                temp   = {1'b0, A} + {1'b0, B};
                Result = temp[7:0];
                Carry  = temp[8];
            end

            3'b001: begin
                temp   = {1'b0, A} - {1'b0, B};
                Result = temp[7:0];
            end

            3'b010: begin
                Result = A & B;
            end

            3'b011: begin
                Result = A | B;
            end

            3'b100: begin
                Result = A ^ B;
            end

            3'b101: begin
                if (A < B)
                    Result = 8'b00000001;
                else
                    Result = 8'b00000000;
            end

            default: begin
                Result = 8'b0;
                Carry  = 1'b0;
            end

        endcase

        if (Result == 8'b0)
            Zero = 1'b1;
        else
            Zero = 1'b0;

    end

endmodule