module ripple_carry_adder
#(parameter width = 64)
(
    input [width-1:0] a,b,
    input cin,
    output reg [width-1:0] sum,
    output cout
);


reg [width-1:0] p,g;
wire [width-1:0] c;

genvar i;
integer  j;
always @(*) begin
    for (j=0;j<width;j=j+1) begin
        p[j] = a[j] ^ b[j];
        g[j] = a[j] & b[j];
    end
end


generate
    for (i = 0;i<width;i = i+1)begin: BLOCK2
        if (i == 0) begin
            pg uut1 (.p2(p[0]),.g1(cin),.g2(g[0]),.gout(c[0]));
        end
        else begin
            pg uut0(
            .g1(c[i-1]),
            .p2(p[i]),
            .g2(g[i]),
            .gout(c[i]));
        end
    end
endgenerate

always @(*) begin
    for (j = 0;j<width;j= j+1) begin
        if (j==0) begin
            sum[j] = p[j] ^ cin;
        end
        else 
            sum[j] = p[j] ^ c[j-1];
    end
end

assign cout = c[width-1];
endmodule