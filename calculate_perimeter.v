module CALCULATE_PERIMETER(
    clock, _reset, _dav, a, b,
    rfd, p
);
    input clock, _reset;
    input _dav;
    input [3:0] a, b;

    output rfd;
    output [5:0] p;

    reg RFD;
    assign rfd = RFD;
    reg [5:0] P;
    assign p = P;
    reg [1:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3;

    wire [5:0] perimeter;
    PERIMETER rc(
        .l1(a), .l2(b),
        .per(perimeter)
    );

    always @(_reset == 0) #1 begin
        STAR <= S0;
        P <= 0;
        RFD <= 1;
    end

    always @(posedge clock) if(_reset == 1) #3 begin
        casex(STAR)
            S0: begin
                STAR <= (_dav == 0) ? S1 : S0;
            end
            S1: begin
                RFD <= 0;
                P <= perimeter;
                STAR <= S2;
            end
            S2: begin
                STAR <= (_dav == 1) ? S3 : S2;
            end
            S3: begin
                RFD <= 1;
                STAR <= S0;
            end
        endcase
    end
endmodule

module PERIMETER(
    l1, l2,
    per
);
    input [3:0] l1, l2;
    output [5:0] per;

    wire [4:0] sum;
    add #( .N(4) ) sum(
        .x(l1), .y(l2), .c_in(1'b0),
        .s(sum[3:0]), .c_out(sum[4])
    );

    assign per = {sum, 1'b0};

endmodule