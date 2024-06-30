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

for (i = 0;i<width;i = i+1) begin
    assign p[i] = a_n[i] ^b_n[i];
    assign c[i+1] = g[i] + p[i]* c[i];//这么写无法做到超前进位链
    assign g[i] = a_n[i] *b_n[i];
    assign s_n[i] = p[i] ^ c[i];
end

assign c[0] = cin;
assign cout = c[width];


endmodule