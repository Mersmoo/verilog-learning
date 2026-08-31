module alu_zero_carry (
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] ALU_Control,

    output reg [3:0] Result,
    output reg       Zero,
    output reg       Carry
);

reg [4:0] temp;

always @(*) begin

    // Default values
    Result = 4'b0000;
    Carry  = 1'b0;
    temp   = 5'b00000;

    case (ALU_Control)

        // ADD
        3'b000: begin
            temp   = A + B;
            Result = temp[3:0];
            Carry  = temp[4];
        end

        // SUB
        3'b001: begin
            Result = A - B;
            Carry  = 1'b0;
        end

        // AND
        3'b010: begin
            Result = A & B;
            Carry  = 1'b0;
        end

        // OR
        3'b011: begin
            Result = A | B;
            Carry  = 1'b0;
        end

        // XOR
        3'b100: begin
            Result = A ^ B;
            Carry  = 1'b0;
        end

        // NOT A
        3'b101: begin
            Result = ~A;
            Carry  = 1'b0;
        end

        default: begin
            Result = 4'b0000;
            Carry  = 1'b0;
        end

    endcase

    // Zero flag
    if (Result == 4'b0000)
        Zero = 1'b1;
    else
        Zero = 1'b0;

end

endmodule