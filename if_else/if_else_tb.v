module if_tb();
    reg [3:0] r;
    wire [2:0] y;
    prio_encoder_if uut(.r(r),.y(y));
    
    initial r =0;
    always begin
        #10
        r=r+1;
    if (r==4'b1111)
    r =0;
    end

    // always @*
    // if (r==4'b1111)
    // r =0;

endmodule