`timescale 1ns/1ps

module apb_register_bank_tb;

    reg         PCLK;
    reg         PRESETn;

    reg         PSEL;
    reg         PENABLE;
    reg         PWRITE;
    reg  [7:0]  PADDR;
    reg  [31:0] PWDATA;

    wire [31:0] PRDATA;
    wire        PREADY;
    wire        PSLVERR;

    apb_register_bank dut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),

        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),

        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );

    always #5 PCLK = ~PCLK;

    task apb_write;

        input [7:0]  addr;
        input [31:0] data;

        begin

            @(posedge PCLK);

            PSEL    <= 1'b1;
            PENABLE <= 1'b0;
            PWRITE  <= 1'b1;
            PADDR   <= addr;
            PWDATA  <= data;

            @(posedge PCLK);

            PENABLE <= 1'b1;

            @(posedge PCLK);

            PSEL    <= 1'b0;
            PENABLE <= 1'b0;
            PWRITE  <= 1'b0;
            PADDR   <= 8'h00;
            PWDATA  <= 32'h00000000;

        end

    endtask


    task apb_read;

        input [7:0] addr;
        input [31:0] expected;

        begin

            @(posedge PCLK);

            PSEL    <= 1'b1;
            PENABLE <= 1'b0;
            PWRITE  <= 1'b0;
            PADDR   <= addr;
            PWDATA  <= 32'h00000000;

            @(posedge PCLK);

            PENABLE <= 1'b1;

            @(posedge PCLK);

            if (PRDATA !== expected) begin

                $display(
                    "READ ERROR: ADDR=%h EXPECTED=%h ACTUAL=%h",
                    addr,
                    expected,
                    PRDATA
                );

            end
            else begin

                $display(
                    "READ OK: ADDR=%h DATA=%h",
                    addr,
                    PRDATA
                );

            end

            PSEL    <= 1'b0;
            PENABLE <= 1'b0;

        end

    endtask


    initial begin

        $dumpfile("apb_register_bank.vcd");
        $dumpvars(0, apb_register_bank_tb);

        PCLK   = 1'b0;
        PRESETn = 1'b0;

        PSEL    = 1'b0;
        PENABLE = 1'b0;
        PWRITE  = 1'b0;
        PADDR   = 8'h00;
        PWDATA  = 32'h00000000;

        #20;

        PRESETn = 1'b1;

        // Write CTRL
        apb_write(
            8'h00,
            32'h12345678
        );

        // Read CTRL
        apb_read(
            8'h00,
            32'h12345678
        );

        // Write DATA
        apb_write(
            8'h08,
            32'hAABBCCDD
        );

        // Read DATA
        apb_read(
            8'h08,
            32'hAABBCCDD
        );

        // Write CONFIG
        apb_write(
            8'h0C,
            32'h5555AAAA
        );

        // Read CONFIG
        apb_read(
            8'h0C,
            32'h5555AAAA
        );

        // Read STATUS
        apb_read(
            8'h04,
            32'h00000000
        );

        $display("----------------------------------------");
        $display("APB REGISTER BANK TEST PASSED");
        $display("----------------------------------------");

        #20;

        $finish;

    end

endmodule