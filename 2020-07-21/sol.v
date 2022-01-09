module XXX(
    clock, reset_, 
    d7_d0, a3_a0, ior_, iow_
);
    input clock, reset_;
    inout d7_d0;
    output ior_, iow_;
    output [1:0] a1_a0;

    reg [1:0] A1_A0;
    assign a1_a0 = A1_A0;

    reg IOR_, IOW_;
    assign ior_ = IOR_;
    assign iow_ = IOW_;

    reg [7:0] BUFFER;
    reg DIR;
    assign d7_d0 = (DIR == 1) ? BUFFER : 'HZZ;

    reg [4:0] COUNT;

    reg [2:0] STAR;
        localparam 
            S0 = 0,
            S1 = 1,
            S2 = 2,
            S3 = 3,
            S4 = 4;

    always @(reset_==0) #1 begin
        STAR <= S0;
        COUNT <= 0;
        DIR <= 0;
        IOR_ <= 1;
        IOW_ <= 1;
        BUFFER <= 0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: begin
                COUNT <= COUNT + 1;
                IOR_ <= 0;
                STAR <= S1;
            end
            S1: begin
                COUNT <= COUNT + 1;
                BUFFER <= d7_d0;
                IOR_ <= 1;
                STAR <= S2;
            end
            S2: begin
                COUNT <= COUNT + 1;
                DIR <= 1;
                STAR <= S3;
            end
            S3: begin  
                COUNT <= COUNT + 1;
                IOW_ <= 0;
                STAR <= S4;
            end
            S4: begin
                COUNT <= COUNT + 1;
                IOW_ <= 1;
                STAR <= S5;
            end
            S5: begin
                DIR <= 0;
                COUNT <= (COUNT == 19) ? 0 : (COUNT+1);
                STAR <= (COUNT == 19) ? S0 : S5;
            end
        endcase 
    end

endmodule
