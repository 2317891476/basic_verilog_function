module Brent_kung_adder
#(parameter width = 64)
(
    input [width-1:0] a,b,
    input cin,
    output [width-1:0] sum,
    output cout
);

wire [width>>4:0] temp;
genvar i;

generate
    for (i = 0;i<width>>4;i = i+1)begin:BLOCK2
        BKadder_16 uut0(
            .a_n(a[i*16+15:i*16]),
            .b_n(b[i*16+15:i*16]),
            .cin(temp[i]),
            .s_n(sum[i*16+15:i*16]),
            .cout(temp[i+1])
        );
    end
endgenerate

assign temp[0] =cin;
assign cout = temp[width>>4];
endmodule