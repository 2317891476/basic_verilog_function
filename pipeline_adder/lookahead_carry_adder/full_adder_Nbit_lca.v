module full_adder_Nbit_lca
#(parameter width = 4)
(
    input [width-1 :0] a_n,
    input [width-1:0] b_n,
    input cin,
    output [width-1:0] s_n,
    output cout
);
genvar i;
wire [width-1:0] g;
wire [width-1:0] p;
wire [width:0] c;
wire gij4;
wire pij4;
//cin来前
for (i = 0;i<width;i = i+1) begin
    assign p[i] = a_n[i] ^b_n[i];
    assign g[i] = a_n[i] *b_n[i];
end
assign pij4 = &p;
assign gij4 = g[3]+p[3]*(g[2] + p[2]*(g[1]+p[1]*g[0]));

//cin来后
//发现即使这么写代码，vivado依旧会优化成为c[i] = g[i-1] +p[i-1]*c[i-1]
// assign c[0] = cin;
// assign c[1] = g[0] + ( c[0] & p[0] );
// assign c[2] = g[1] + ( (g[0] + ( c[0] & p[0]) ) & p[1] );
// assign c[3] = g[2] + ( (g[1] + ( (g[0] + (c[0] & p[0]) ) & p[1])) & p[2] );
//assign c[4] = g[3] + ( (g[2] + ( (g[1] + ( (g[0] + (c[0] & p[0]) ) & p[1])) & p[2] )) & p[3]);
assign cout = gij4 + pij4*cin;
genvar k;
//即使把c[0]改成cin，vivado还是会优化掉！
assign c[0] = cin;
assign c[1] = g[0] + ( cin & p[0] );
assign c[2] = g[1] + ( (g[0] + ( cin & p[0]) ) & p[1] );
assign c[3] = g[2] + ( (g[1] + ( (g[0] + (cin & p[0]) ) & p[1])) & p[2] );

for( k=0; k<width; k=k+1) begin
    assign s_n[k] = p[k] ^ c[k];
end
endmodule