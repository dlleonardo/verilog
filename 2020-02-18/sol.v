module ABC (
    clock, reset_, eoc, numero,
    soc, out
);
    input clock, reset_, eoc;
    input [7:0] numero;
    output soc, out;
    reg SOC;
    assign soc = SOC;
    reg OUT;
    assign out = OUT;
    reg [7:0] NUMERO;
    reg [7:0] COUNT;
    reg [2:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4;

    always @(reset_ == 0) #1 begin
        STAR <= S0;
        SOC <= 0;
        COUNT <= 6;
        NUMERO <= 6;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: begin
                OUT <= 0;
                NUMERO <= COUNT;
                COUNT <= COUNT - 1;
                STAR <= S1;
            end
            S1: begin
                OUT <= 0;
                COUNT <= COUNT - 1;
                STAR <= (COUNT == 1) ? S2 : S1; 
            end
            S2: begin
                OUT <= 1;
                SOC <= 1;
                NUMERO <= NUMERO - 1;
                STAR <= (eoc == 0) ? S2 : S3;
            end
            S3: begin
                OUT <= 1;
                SOC <= 0;
                NUMERO <= NUMERO - 1;
                COUNT <= numero;
                STAR <= (eoc == 1) ? S4 : S3;
            end
            S4: begin
                OUT <= 1;
                NUMERO <= NUMERO - 1;
                STAR <= (NUMERO == 1) ? S0 : S4;
            end
        endcase
    end 

endmodule