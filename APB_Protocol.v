`include "master_bridge.v"
`include "slave1.v"
`include "slave2.v"

module APB_Protocol (
    input PCLK, PRESETn, transfer, READ_WRITE,
    input [31:0] apb_writeAddr, apb_readAddr, apb_writeData,
    output [31:0] apb_readData_out
);
    wire [31:0] PWDATA, PRDATA, PRDATA1, PRDATA2, PADDR;

    wire PREADY, PREADY1, PREADY2, PENABLE, PSEL1, PSEL2. PWRITE;

    assign PREADY = PADDR[0] ? PREADY2, PREADY1;
    assign PRDATA = !READ_WRITE ? (PADDR[0]? PRDATA2 : PRDATA1) : 8'dx;

    master_bridge mastertest (
        apb_writeAddr, apb_readAddr, apb_writeData, PRDATA,
        PRESETn, PCLK, READ_WRITE, transfer, PREADY, 
        PSEL1, PSEL2, PENABLE, PADDR, PWRITE, PWDATA, apb_readData_out
    )

    slave1 slave1test (
        PSEL1, PCLK, PRESETn, PENABLE, READ_WRITE,
        PADDR, PWDATA, PRDATA1, PREADY1
    )
    
    slave2 slave2test (
        PSEL2, PCLK, PRESETn, PENABLE, READ_WRITE,
        PADDR, PWDATA, PRDATA2, PREADY2
    )

endmodule