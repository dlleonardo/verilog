module XX(
    clock, reset_, eoc, x, rfd, eprom
    soc, dav_, y
);
    input clock, reset_;
    input eoc, rfd;
    input [3:0] d3_d0;
    input [7:0] x;
    output soc, dav_, mr_;
    output [7:0] y, addr;

    reg SOC;
    assign soc = SOC;

    reg DAV_;
    assign dav_ = DAV_;

    reg MR_;
    assign mr_ = MR_;

    reg [7:0] Y, ADDR;
    assign y = Y;

    reg [3:0] STAR;
        localparam 
            S0 = 0,
            S1 = 1,
            S2 = 2,
            S3 = 3,
            S4 = 4,
            S5 = 5;

    always @(reset_ == 0) #1 begin
        STAR <= S0;
        DAV_ <= 1;
        SOC <= 0;
        Y <= 0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: begin
                SOC <= 1;
                STAR <= (eoc == 0) ? S1 : S0; 
            end
            S1: begin
                SOC <= 0;
                STAR <= (eoc == 1) ? S2 : S1;
            end
            S2: begin
                ADDR <= (x[7] == 1'b0) ? x : (~x + 1);
                MR_ <= 0;
                STAR <= S3;
            end
            S3: begin
                Y <= (d3_d0 == 4'b0010 ||
                      d3_d0 == 4'b0011 ||
                      d3_d0 == 4'b0101 ||
                      d3_d0 == 4'b0111 ||
                      d3_d0 == 4'b1011 ||
                      d3_d0 == 4'b1101) ? x : Y;
                STAR <= (d3_d0 == 4'b0010 ||
                         d3_d0 == 4'b0011 ||
                         d3_d0 == 4'b0101 ||
                         d3_d0 == 4'b0111 ||
                         d3_d0 == 4'b1011 ||
                         d3_d0 == 4'b1101) ? S4 : S0;
            end
            // Hs con consumatore
            S4: begin
                DAV_ <= 0;
                STAR <= (rfd == 1) ? S4 : S5;
            end
            S5: begin
                DAV_ <= 1;
                STAR <= (rfd == 0) ? S5 : S0;
            end
            end
        endcase
    end

endmodule
