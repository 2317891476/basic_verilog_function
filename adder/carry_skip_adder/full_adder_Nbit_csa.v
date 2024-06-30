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
wire [width-1:0] g;
wire [width-1:0] p;
wire [width:0] gij;//gij
wire [width:0] c;
wire pij;

//不需等待cin到就能开始运算
assign gij[0] = 0;
for (i = 0;i<width;i = i+1) begin
    assign p[i] = a_n[i] ^b_n[i];
    assign g[i] = a_n[i] *b_n[i];
    assign gij[i+1] = g[i] + p[i]* gij[i];
end
assign pij = &p;

//需等待cin到才能开始运算
assign c[0] =cin;
assign cout = pij?cin:gij[width];
genvar k;
for( k=0; k<width; k=k+1) begin
    assign c[k+1] = g[k] + p[k] * c[k];
    assign s_n[k] = p[k] ^ c[k];
end
endmodule