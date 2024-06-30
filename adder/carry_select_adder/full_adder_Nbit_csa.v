module full_adder(
    input a,b,cin,
    output s,cout
);
assign cout = (a*b) + (a^b)*cin;
assign s = a^b^cin;
endmodule

module full_adder_Nbit_csa
#(parameter width = 4)
(
    input [width-1 :0] a_n,
    input [width-1:0] b_n,
    input cin,
    output [width-1:0] s_n,
    output cout
);
genvar i;
wire [width:0] temp0;
wire [width:0] temp1;
wire [width-1:0] s_n0;
wire [width-1:0] s_n1;
assign temp1[0] = 1;
assign temp0[0] = 0;

//不需等待cin到就能开始运算
generate
    for (i = 0;i< width;i = i+1) begin :BLOCK1
        full_adder full_adder0(.a(a_n[i]),.b(b_n[i]),.cin(temp0[i]),.s(s_n0[i]),.cout(temp0[i+1]));
        full_adder full_adder1(.a(a_n[i]),.b(b_n[i]),.cin(temp1[i]),.s(s_n1[i]),.cout(temp1[i+1]));
    end
endgenerate
//等待cin到能开始运算
assign s_n = cin ?s_n1:s_n0;
assign cout =cin ?temp1[width]:temp0[width];
endmodule