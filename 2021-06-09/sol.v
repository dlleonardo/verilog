module ABC(
    clock, reset_, data,
    addr, ior_, iow_,
);
    input clock, reset_;
    inout [7:0] data;
    output ior_, iow_;
    output [15:0] addr;

    reg IOR_;
    assign ior_ = IOR_;

    reg IOW_;
    assign iow_ = IOW_;

    reg [15:0] ADDR;
    assign addr = ADDR;

    reg [7:0] A, B;
    wire [15:0] mul;
    assign #1 mul = A*B;

    reg DIR;
    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'bZZ;

    reg [3:0] COUNT;

    reg [3:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5,
        S6 = 6,
        S7 = 7,
        S8 = 8,
        S9 = 9,
        S10 = 10,
        S11 = 11,
        S12 = 12,
        S13 = 13,
        S14 = 14;

    always @(reset_ == 0) #1 begin
        STAR <= S0;
        COUNT <= 16;
        A <= 0;
        DIR <= 0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: begin
                ADDR <= 16'h0120;
                COUNT <= COUNT - 1;
                STAR <= S1;
            end
            S1: begin
                IOR_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S2;
            end
            S2: begin
                B <= data;
                COUNT <= COUNT - 1;
                STAR <= S3;
            end
            S3: begin
                IOR_ <= 1;
                COUNT <= COUNT - 1;
                STAR <= S4;
            end
            S4: begin
                ADDR <= 16'h0140;
                DIR <= 1;
                DATA <= mul[15:8];
                COUNT <= COUNT - 1;
                STAR <= S5;
            end
            S5: begin
                IOW_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S6;
            end
            S6: begin
                IOW_ <= 1;
                DATA <= mul[7:0];
                COUNT <= COUNT - 1;
                STAR <= S7;
            end
            S7: begin
                IOW_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S8;
            end
            S8: begin
                IOW_ <= 1;
                DIR <= 0;
                COUNT <= COUNT - 1;
                STAR <= S9;
            end
            S9: begin
                ADDR <= 16'h0100;
                COUNT <= COUNT - 1;
                STAR <= S10;
            end
            S10: begin
                IOR_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S11;   
            end
            S11: begin
                IOR_ <= 1;
                ADDR <= 16'h0101; 
                COUNT <= COUNT - 1;
                STAR <= (data[0]) ? S12 : S14;
            end
            S12: begin
                IOR_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S13;
            end
            S13: begin
                IOR_ <= 1;
                A <= data;
                COUNT <= COUNT - 1;
                STAR <= S14;
            end
            S14: begin
                COUNT <= (COUNT == 1) ? 16 : COUNT - 1;
                STAR <= (COUNT == 1) ? S0 : S14;
            end
        endcase
    end 

endmodule