module ABC (
    clock, reset_, eoc1, eoc2, eoc3, x1, x2, x3, rfd,
    soc, dav_, min
);
    input clock, reset_, eoc1, eoc2, eoc3, rfd;
    input [7:0] x1, x2, x3;
    output soc, dav_;
    output [7:0] min;

    reg SOC;
    assign soc = SOC;
    reg DAV_;
    assign dav_ = DAV_;
    reg [7:0] MIN;
    assign min = MIN;

    reg [1:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3;

    wire [7:0] minimo;
    MINIMO_3 min3(
        .a(x1), .b(x2), .c(x3),
        .min(minimo)
    );

    always @(reset_ == 0) #1 begin
        STAR <= S0;
        SOC <= 0;
        DAV_ <= 1;        
    end

    always @(posedge clock) #3 begin
        casex(STAR)
            S0: begin
                SOC <= 1;
                STAR <= ({eoc1, eoc2, eoc3} == 3'b000) ? S1 : S0;
            end
            S1: begin
                SOC <= 0;
                MIN <= minimo;
                STAR <= ({eoc1, eoc2, eoc3} == 3'b111) ? S2 : S1;
            end
            S2: begin
                DAV_ <= 0;
                STAR <= (rfd == 0) ? S3 : S2;
            end
            S3: begin
                DAV_ <= 1;
                STAR <= (rfd == 1) ? S0 : S3;
            end
        endcase
    end

endmodule

module MINIMO_3 (
    a, b, c,
    min
);
    input [7:0] a, b, c;
    output [7:0] min;

    wire b_out_0;
    sottrattore #( .N(8) ) s0(
        .x(a), .y(b), .b_in(1'b0),
        .b_out(b_out_0)
    );

    wire [7:0] min_0;
    assign min_0 = (b_out_0 == 1) ? a : b;

    wire b_out_1;
    sottrattore #( .N(8) ) s1(
        .x(c), .y(min_0), .b_in(1'b0),
        .b_out(b_out_1)
    );

    assign min = (b_out_1 == 1) ? c : min_0;

endmodule