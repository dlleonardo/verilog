module ABC(
    ref, rxd, clock, reset_,
    led
);
    input clock, reset_;
    input rxd;
    input [4:0] ref;
    output [2:0] led;

    reg [2:0] LED;
    assign led = LED;

    reg [2:0] COUNT_BYTE;
    reg [3:0] COUNT_SPACE;
    reg [2:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5;

    localparam mark = 1, space = 0;

    reg [7:0] BUFFER;

    always @(reset_ == 0) #1 begin
        STAR <= S0;
        LED <= 0;
        COUNT_SPACE <= 0;
        COUNT_BYTE <= 0;
        BUFFER <= 0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (STAR)
            S0: begin
                STAR <= (rxd == mark) ? S0 : S1;
            end
            // Conto i bit di space (0)
            S1: begin
                COUNT_SPACE <= COUNT_SPACE+1;
                STAR <= (rxd == space) ? S1 : S2;
            end
            // Controllo se si tratta di bit 0 o 1
            S2: begin
                BUFFER <= (COUNT_SPACE[3]==1'b0) ? {mark,BUFFER[7:1]} : BUFFER;
                STAR <= (COUNT_SPACE[3]==1'b1) ? S3 : S4;       
            end
            // bit 0
            S3: begin
                BUFFER <= {space,BUFFER[7:1]};
                STAR <= S4;
            end
            S4: begin
                COUNT_SPACE <= 0;
                COUNT_BYTE <= COUNT_BYTE + 1;
                STAR <= (COUNT_BYTE == 7) ? S5 : S0;
            end
            // Trasmissione di led
            S5: begin
                LED <= (BUFFER[7:3] == ref) ? BUFFER[2:0] : LED;
                COUNT_BYTE <= 0;
                COUNT_SPACE <= 0;
                BUFFER <= 0;
                STAR <= S0;
            end
        endcase
    end


endmodule