module slave2(
    input PCLK, PRESETn, PSEL, PENABLE, PWRITE,
    input [31:0] PADDR, PWDATA,
    output [31:0] PRDATA,
    output reg PREADY
);

reg [31:0] slave2Mem [0:63];

//assign PRDATA = slave2Mem[PADDR];

always @(*)
begin
    if (!PRESETn) 
        PREADY = 0;
    else
    begin
        if (PSEL && !PENABLE) 
            PREADY = 0;
        else if(PSEL && PENABLE && !PWRITE) 
        begin
            PREADY = 1;
            PRDATA = slave2Mem[PADDR];
        end
        else if(PSEL && PENABLE && PWRITE)
        begin
            PREADY = 1;
            slave2Mem[PADDR] = PWDATA;
        end
        else 
            PREADY = 0
    end
end

endmodule