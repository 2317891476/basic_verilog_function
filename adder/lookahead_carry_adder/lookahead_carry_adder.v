module lookahead_carry_adder
#(parameter width = 64)
(
    input [width-1:0] a,b,
    input cin,
    output [width-1:0] sum,
    output cout
);

wire [width>>2:0] temp;
genvar i;

generate
    for (i = 0;i<width>>2;i = i+1)begin:BLOCK2
        full_adder_Nbit_lca uut0(
            .a_n(a[i*4+3:i*4]),
            .b_n(b[i*4+3:i*4]),
            .cin(temp[i]),
            .s_n(sum[i*4+3:i*4]),
            .cout(temp[i+1])
        );
    end
endgenerate

assign temp[0] =cin;
assign cout = temp[width>>2];
endmodule