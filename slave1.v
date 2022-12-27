module slave1 (
    input PSEL,PCLK,PRESET,PENABLE,READ_WRITE,
    // READ_WRITE = 0 => READ
    // READ_WRITE = 1 => WRITE
    input [31:0] PADDR,PWDATA,
    output [31:0] PRDATA,
    output reg PREADY,
);
 

 reg [31:0] mem[63:0];


 always@(*)
    begin
       if(!PRESET)
          PREADY = 0;
        else if(PSEL && !PENABLE )
        PREADY = 0;
        else if(PSEL && PENABLE && READ_WRITE)
        begin
            PREADY = 1;
            mem[PADDR] = PWDATA;
        end
        else if(PSEL && PENABLE && !READ_WRITE)
        begin
            PREADY = 1;
            PRDATA = mem[PADDR];
        end
        else 
        PREADY =0;
    end
         
endmodule