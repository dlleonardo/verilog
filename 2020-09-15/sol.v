module U(
    clock, reset_, ok, d7_d0,
    stop, Umr_, Ua23_a0, out
);
    input clock, reset_, ok;
    input [7:0] d7_d0;
    output stop, Umr_;
    output [23:0] Ua23_a0;
    output [7:0] out;

    reg STOP;               assign stop = STOP;
    reg UMR_;               assign Umr_ = UMR_;
    reg [23:0] A23_A0;      assign Ua23_a0 = A23_A0;
    reg [7:0] OUT, D7_D0;   assign out = OUT;

    reg [6:0] COUNT;

    reg [2:0] STAR;
        localparam 
            S0 = 0,
            S1 = 1,
            S2 = 2,
            S3 = 3,
            S4 = 4;

    always @(reset_ == 0) #1 begin
        STAR <= S0;
        COUNT <= 0;
        STOP <= 0;
        A23_A0 <= 0;
    end 

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: begin
                COUNT <= COUNT + 1;
                STOP <= 1;
                STAR <= (ok == 1) ? S1 : S0;
            end
            S1: begin 
                COUNT <= COUNT + 1;
                UMR_ <= 0;
                STAR <= S2;
            end
            S2: begin
                COUNT <= COUNT + 1;
                D7_D0 <= d7_d0;
                UMR_ <= 1;
                STOP <= 0;
                A23_A0 <= A23_A0 + 1;
                STAR <= S3;
            end
            S3: begin
                COUNT <= COUNT + 1;
                STAR <= (ok == 0) ? S0 : S4;
            end
            S4: begin
                OUT <= D7_D0;
                COUNT <= (COUNT == 99) ? 0 : (COUNT+1);
                STAR <= (COUNT == 99) ? S4 : S3;
            end
        endcase
    end

endmodule