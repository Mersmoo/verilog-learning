module apb_register_bank (
    input  wire        PCLK,
    input  wire        PRESETn,

    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [7:0]  PADDR,
    input  wire [31:0] PWDATA,

    output reg  [31:0] PRDATA,
    output wire        PREADY,
    output wire        PSLVERR
);

    reg [31:0] ctrl_reg;
    reg [31:0] status_reg;
    reg [31:0] data_reg;
    reg [31:0] config_reg;

    wire apb_access;

    assign apb_access = PSEL && PENABLE;

    assign PREADY = 1'b1;

    assign PSLVERR = 1'b0;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            ctrl_reg   <= 32'h00000000;
            status_reg <= 32'h00000000;
            data_reg   <= 32'h00000000;
            config_reg <= 32'h00000000;
        end
        else begin

            if (apb_access && PWRITE) begin

                case (PADDR)

                    8'h00: begin
                        ctrl_reg <= PWDATA;
                    end

                    8'h08: begin
                        data_reg <= PWDATA;
                    end

                    8'h0C: begin
                        config_reg <= PWDATA;
                    end

                    default: begin
                    end

                endcase

            end

        end
    end

    always @(*) begin

        PRDATA = 32'h00000000;

        if (apb_access && !PWRITE) begin

            case (PADDR)

                8'h00: begin
                    PRDATA = ctrl_reg;
                end

                8'h04: begin
                    PRDATA = status_reg;
                end

                8'h08: begin
                    PRDATA = data_reg;
                end

                8'h0C: begin
                    PRDATA = config_reg;
                end

                default: begin
                    PRDATA = 32'h00000000;
                end

            endcase

        end

    end

endmodule