module full_adder_Nbit_cia
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
wire [width:0] pij;

//cin前
assign pij[0] = p[0];
assign gij[0] = 0;
for (i = 0;i<width;i = i+1) begin
    assign p[i] = a_n[i] ^b_n[i];
    assign g[i] = a_n[i] *b_n[i];
    assign pij[i+1] = p[i] *pij[i];
    assign gij[i+1] = g[i] + p[i]* gij[i];
end

//cin后
assign cout = gij[width]+pij[width]*cin;
genvar k;
for( k=0; k<width; k=k+1) begin
    assign s_n[k] = p[k] ^ (gij[k]+pij[k+1]*cin);
end
endmodule