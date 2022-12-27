module master_bridge (
    input [31:0] apb_writeAddr, apb_readAddr,
    input [31:0] apb_writeData, PRDATA,
    input PRESETn, PCLK, READ_WRITE, transfer, PREADY,
    output PSEL1, PSEL2,
    output reg PENABLE,
    output reg [31:0] PADDR,
    output reg PWRITE,
    output reg [31:0] PWDATA, apb_readData_out
);
    reg [1:0] state, nextState;
    localparam IDLE = 2'b01, SETUP = 2'b10, ACCESS = 2'b11; //State Values
    state <= IDLE; //Base state

    /*reg [31:0] slave1Addr, slave2Addr;
    initial begin
        slave1Addr = PADDR;
    end*/

    always (@posedge PCLK)
    begin
        if (!PRESETn)
            state <= IDLE; //In case of reset return to IDLE state (RESET ACTIVE LOW)
        else 
            state <= nextState; // No reset ->> Go to Next state
    end

    always @(state, transfer, PREADY) // FSM
    begin
        if (!PRESETn)
            nextState <= IDLE;
        else  
            begin
                PWRITE = READ_WRITE;
                //READ_WRITE = 1 -> Write data/ READ_WRITE = 0 -> READ DATA
                case (state) 
                    IDLE: 
                    begin
                        PENABLE = 0;
                        if (transfer)
                            nextState =SETUP;
                        else
                            nextState = IDLE;
                    end 
                    SETUP:
                    begin
                        PENABLE = 0;
                        if (READ_WRITE) // READ_WRITE = 1 -> WRITE -- 0 -> READ
                        begin 
                            PADDR = apb_writeAddr; //output address of slave
                            PWDATA = apb_writeData; //output data that will be written
                        end
                        else 
                            PADDR = apb_readAddr; 
                        if (transfer)
                            nextState = ACCESS;
                        else
                            nextState = IDLE;
                    end
                    ACCESS:
                    begin
                        if (PSEL1 || PSEL2)
                            PENABLE = 1;
                        if (transfer)
                        begin
                            /*if (PADDR == slave1Addr) {
                                PSEL1 = 1'b1;
                                PSEL2 = 1'b0;
                            }
                            else {
                                slave2Addr = PADDR;
                                PSEL2 = 1'b1;
                                PSEL1 = 1'b0;
                            }*/
                            if (PREADY) 
                            begin
                                if (READ_WRITE)
                                    nextState = SETUP;
                                else
                                begin
                                    nextState = SETUP;
                                    apb_readData_out = PRDATA;
                                end
                            end
                            else nextState = ACCESS;
                        end
                        else
                            nextState = IDLE;
                    end
                    default: nextState = IDLE;
                endcase
            end
    end

    assign {PSEL1,PSEL2} = ((state != IDLE) ? (PADDR[0] ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'd0);
endmodule