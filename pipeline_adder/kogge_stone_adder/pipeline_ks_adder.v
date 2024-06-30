module ks_adder_64
#(parameter width = 64)
(
    input [width-1:0] a,b,
    input cin,
    output reg [width-1:0] sum,
    output cout,
    input clk
);


reg [width-1:0] p,g;
wire [width-1:0] c;
wire [width-1:0] gij [7:0];
wire [width-1:0] pij [7:0];

wire [width-1:0] p1,g1,p2,g2;
wire [width-1:0] c1,c2;
wire [width-1:0] gij1 [7:0];
wire [width-1:0] gij2 [7:0];
wire [width-1:0] pij1 [7:0];
wire [width-1:0] pij2 [7:0];
wire cin1,cin2;

genvar i;
integer  j;
always @(*) begin
    for (j=0;j<width;j=j+1) begin
        p[j] = a[j] ^ b[j];
        g[j] = a[j] & b[j];
    end
end

//第一层
generate
    for (i = 0;i<width;i = i+1)begin: BLOCK1
        if (i == 0) begin
            pg uut1 (.p2(p[0]),.g1(cin),.g2(g[0]),.gout(c[0]));
        end
        else if (i==1) begin
            pg uut2 (.p1(p[0]),.p2(p[1]),.g1(c[0]),.g2(g[1]),.gout(c[1]));
        end
        else begin
            pg uut0(
                .p1(p[i-1]),
                .g1(g[i-1]),
                .p2(p[i]),
                .g2(g[i]),
                .gout(gij[0][i]),
                .pout(pij[0][i]));
        end
    end
endgenerate

//第二层
generate
    for (i = 2;i<width;i = i+1)begin: BLOCK2
        if (i == 2) begin
            pg uut1 (.p2(pij[0][i]),.g1(c[0]),.g2(gij[0][i]),.gout(c[2]));
        end
        else if (i==3) begin
            pg uut1 (.p2(pij[0][i]),.g1(c[1]),.g2(gij[0][i]),.gout(c[3]));
        end
        else begin
            pg uut0(
                .p1(pij[0][i-2]),
                .g1(gij[0][i-2]),
                .p2(pij[0][i]),
                .g2(gij[0][i]),
                .gout(gij[1][i]),
                .pout(pij[1][i]));
        end
    end
endgenerate

pipelineregister #(64+64+4+64+64+1) pipereg0 (.in({p,g,c[3:0],gij[1],pij[1],cin}),.clk(clk),.out({p1,g1,c1[3:0],gij1[1],pij1[1],cin1}));
//第3层
generate
    for (i = 4;i<width;i = i+1)begin: BLOCK3
        if (i <= 7) begin
            pg uut1 (.p2(pij1[1][i]),.g1(c1[i-4]),.g2(gij1[1][i]),.gout(c1[i]));
        end
        else begin
            pg uut0(
                .p1(pij1[1][i-4]),
                .g1(gij1[1][i-4]),
                .p2(pij1[1][i]),
                .g2(gij1[1][i]),
                .gout(gij1[2][i]),
                .pout(pij1[2][i]));
        end
    end
endgenerate


//第4层
generate
    for (i = 8;i<width;i = i+1)begin: BLOCK4
        if (i <= 15) begin
            pg uut1 (.p2(pij1[2][i]),.g1(c1[i-8]),.g2(gij1[2][i]),.gout(c1[i]));
        end
        else begin
            pg uut0(
                .p1(pij1[2][i-8]),
                .g1(gij1[2][i-8]),
                .p2(pij1[2][i]),
                .g2(gij1[2][i]),
                .gout(gij1[3][i]),
                .pout(pij1[3][i]));
        end
    end
endgenerate

pipelineregister #(64+64+16+64+64+1) pipereg1 (.in({p1,g1,c1[15:0],gij1[3],pij1[3],cin1}),.clk(clk),.out({p2,g2,c2[15:0],gij2[3],pij2[3],cin2}));

//第5层
generate
    for (i = 16;i<width;i = i+1)begin: BLOCK5
        if (i <= 31) begin
            pg uut1 (.p2(pij2[3][i]),.g1(c2[i-16]),.g2(gij2[3][i]),.gout(c2[i]));
        end
        else begin
            pg uut0(
                .p1(pij2[3][i-16]),
                .g1(gij2[3][i-16]),
                .p2(pij2[3][i]),
                .g2(gij2[3][i]),
                .gout(gij2[4][i]),
                .pout(pij2[4][i]));
        end
    end
endgenerate

//第6层
generate
    for (i = 32;i<width;i = i+1)begin: BLOCK6
        if (i <= 63) begin
            pg uut1 (.p2(pij2[4][i]),.g1(c2[i-32]),.g2(gij2[4][i]),.gout(c2[i]));
        end
        else begin
            pg uut0(
                .p1(pij2[4][i-32]),
                .g1(gij2[4][i-32]),
                .p2(pij2[4][i]),
                .g2(gij2[4][i]),
                .gout(gij2[5][i]),
                .pout(pij2[5][i]));
        end
    end
endgenerate


always @(*) begin
    for (j = 0;j<width;j= j+1) begin
        if (j==0) begin
            sum[j] = p2[j] ^ cin2;
        end
        else 
            sum[j] = p2[j] ^ c2[j-1];
    end
end

assign cout = c2[width-1];
endmodule