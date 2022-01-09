module XXX(
    clock, reset_, dav_, numero,
    rfd, out
);
    input clock, reset_, dav_;
    input [1:0] numero;
    output rfd, out;

    reg RFD;
    assign rfd = RFD;
    reg OUT;
    assign out = OUT;

    reg [1:0] NUMERO;
    reg [2:0] COUNT;

    reg STAR;
    localparam 
        S0 = 0,
        S1 = 1;

    always @(reset_ == 0) #1 begin
        STAR <= S0;
        RFD <= 1;
        OUT <= 0;
        COUNT <= 0;
        NUMERO <= 0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: begin
                OUT <= 0;
                RFD <= 1;
                COUNT <= 0;
                NUMERO <= numero;
                STAR <= (dav_ == 0) ? S1 : S0;
            end
            S1: begin
                RFD <= 0;
                STAR <= (dav_ == 1) ? S2 : S1;
            end
            S2: begin
                OUT <= 1;
                COUNT <= COUNT + 1;
                STAR <= ( (NUMERO == 2'b00 && COUNT == 1) ||
                          (NUMERO == 2'b01 && COUNT == 3) ||
                          (NUMERO == 2'b10 && COUNT == 5) ||
                          (NUMERO == 2'b11 && COUNT == 7) ) ? S0 : S1;
            end
        endcase
    end

endmodule