module SKadder_64
#(parameter width = 64)
(
    input [width-1:0] a,b,
    input cin,
    input clk,
    output reg [width-1:0] sum,
    output cout
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
genvar k;
integer  j;
always @(*) begin
    for (j=0;j<width;j=j+1) begin
        p[j] = a[j] ^ b[j];
        g[j] = a[j] & b[j];
    end
end

pg uut1 (.p2(p[0]),.g1(cin),.g2(g[0]),.gout(c[0]));

//第一级流水线
//第一层
generate
    for (i = 1;i<width;i = i+2)begin: BLOCK1
        if (i==1) begin
            pg uut2 (.p2(p[1]),.g1(c[0]),.g2(g[1]),.gout(c[1]));
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
    for (i = 3;i<width;i = i+4)begin: BLOCK2
        if (i==3) begin
            pg uut2 (.p2(p[2]),.g1(c[1]),.g2(g[2]),.gout(c[2]));
            pg uut1 (.p2(pij[0][3]),.g1(c[1]),.g2(gij[0][3]),.gout(c[3]));
        end
        else begin
            pg uut3(.p1(pij[0][i-2]),.g1(gij[0][i-2]),.p2(p[i-1]),.g2(g[i-1]),.gout(gij[1][i-1]),.pout(pij[1][i-1]));
            pg uut4(.p1(pij[0][i-2]),.g1(gij[0][i-2]),.p2(pij[0][i]),.g2(gij[0][i]),.gout(gij[1][i]),.pout(pij[1][i]));

            assign pij[1][i-2] =pij[0][i-2];
            assign gij[1][i-2] =gij[0][i-2];
        end
    end
endgenerate
pipelineregister #(64+64+4+64+64+1) pipereg0 (.in({p,g,c[3:0],gij[1],pij[1],cin}),.clk(clk),.out({p1,g1,c1[3:0],gij1[1],pij1[1],cin1}));
//第二级流水线
//第3层
generate
    for (i = 7;i<width;i = i+8)begin: BLOCK3
        if (i==7) begin
            pg uut01 (.p2(p1[4]),.g1(c1[3]),.g2(g1[4]),.gout(c1[4]));
            pg uut02 (.p2(pij1[1][5]),.g1(c1[3]),.g2(gij1[1][5]),.gout(c1[5]));
            pg uut03 (.p2(pij1[1][6]),.g1(c1[3]),.g2(gij1[1][6]),.gout(c1[6]));
            pg uut04 (.p2(pij1[1][7]),.g1(c1[3]),.g2(gij1[1][7]),.gout(c1[7]));
        end
        else begin
            pg uut1(.p1(pij1[1][i-4]),.g1(gij1[1][i-4]),.p2(p1[i-3]),.g2(g1[i-3]),.gout(gij1[2][i-3]),.pout(pij1[2][i-3]));
            pg uut2(.p1(pij1[1][i-4]),.g1(gij1[1][i-4]),.p2(pij1[1][i-2]),.g2(gij1[1][i-2]),.gout(gij1[2][i-2]),.pout(pij1[2][i-2]));
            pg uut3(.p1(pij1[1][i-4]),.g1(gij1[1][i-4]),.p2(pij1[1][i-1]),.g2(gij1[1][i-1]),.gout(gij1[2][i-1]),.pout(pij1[2][i-1]));
            pg uut4(.p1(pij1[1][i-4]),.g1(gij1[1][i-4]),.p2(pij1[1][i]),.g2(gij1[1][i]),.gout(gij1[2][i]),.pout(pij1[2][i]));

            assign pij1[2][i-4] =pij1[1][i-4];
            assign gij1[2][i-4] =gij1[1][i-4];
            assign pij1[2][i-5] =pij1[1][i-5];
            assign gij1[2][i-5] =gij1[1][i-5];
            assign pij1[2][i-6] =pij1[1][i-6];
            assign gij1[2][i-6] =gij1[1][i-6];
        end
    end
endgenerate


//第4层
generate
    for (i = 15;i<width;i = i+16)begin: BLOCK4
        if (i==15) begin
            pg uut01 (.p2(p1[8]),.g1(c1[7]),.g2(g1[8]),.gout(c1[8]));
            pg uut02 (.p2(pij1[2][9]),  .g1(c1[7]),.g2(gij1[2][9]),.gout(c1[9]));
            pg uut03 (.p2(pij1[2][10]),.g1(c1[7]),.g2(gij1[2][10]),.gout(c1[10]));
            pg uut04 (.p2(pij1[2][11]),.g1(c1[7]),.g2(gij1[2][11]),.gout(c1[11]));
            pg uut05 (.p2(pij1[2][12]),.g1(c1[7]),.g2(gij1[2][12]),.gout(c1[12]));
            pg uut06 (.p2(pij1[2][13]),.g1(c1[7]),.g2(gij1[2][13]),.gout(c1[13]));
            pg uut07 (.p2(pij1[2][14]),.g1(c1[7]),.g2(gij1[2][14]),.gout(c1[14]));
            pg uut08 (.p2(pij1[2][15]),.g1(c1[7]),.g2(gij1[2][15]),.gout(c1[15]));
        end
        else begin
            pg uut1(.p1(pij1[2][i-8]),.g1(gij1[2][i-8]),.p2(p1[i-7]),.g2(g1[i-7]),.gout(gij1[3][i-7]),.pout(pij1[3][i-7]));
            pg uut2(.p1(pij1[2][i-8]),.g1(gij1[2][i-8]),.p2(pij1[2][i-6]),.g2(gij1[2][i-6]),.gout(gij1[3][i-6]),.pout(pij1[3][i-6]));
            pg uut3(.p1(pij1[2][i-8]),.g1(gij1[2][i-8]),.p2(pij1[2][i-5]),.g2(gij1[2][i-5]),.gout(gij1[3][i-5]),.pout(pij1[3][i-5]));
            pg uut4(.p1(pij1[2][i-8]),.g1(gij1[2][i-8]),.p2(pij1[2][i-4]),.g2(gij1[2][i-4]),.gout(gij1[3][i-4]),.pout(pij1[3][i-4]));
            pg uut5(.p1(pij1[2][i-8]),.g1(gij1[2][i-8]),.p2(pij1[2][i-3]),.g2(gij1[2][i-3]),.gout(gij1[3][i-3]),.pout(pij1[3][i-3]));
            pg uut6(.p1(pij1[2][i-8]),.g1(gij1[2][i-8]),.p2(pij1[2][i-2]),.g2(gij1[2][i-2]),.gout(gij1[3][i-2]),.pout(pij1[3][i-2]));
            pg uut7(.p1(pij1[2][i-8]),.g1(gij1[2][i-8]),.p2(pij1[2][i-1]),.g2(gij1[2][i-1]),.gout(gij1[3][i-1]),.pout(pij1[3][i-1]));
            pg uut8(.p1(pij1[2][i-8]),.g1(gij1[2][i-8]),.p2(pij1[2][i-0]),.g2(gij1[2][i-0]),.gout(gij1[3][i-0]),.pout(pij1[3][i-0]));

            assign pij1[3][i-8]   = pij1[2][i-8];
            assign gij1[3][i-8]   = gij1[2][i-8];
            assign pij1[3][i-9]   = pij1[2][i-9];
            assign gij1[3][i-9]   = gij1[2][i-9];
            assign pij1[3][i-10] = pij1[2][i-10];
            assign gij1[3][i-10] = gij1[2][i-10];
            assign pij1[3][i-11] = pij1[2][i-11];
            assign gij1[3][i-11] = gij1[2][i-11];
            assign pij1[3][i-12] = pij1[2][i-12];
            assign gij1[3][i-12] = gij1[2][i-12];
            assign pij1[3][i-13] = pij1[2][i-13];
            assign gij1[3][i-13] = gij1[2][i-13];
            assign pij1[3][i-14] = pij1[2][i-14];
            assign gij1[3][i-14] = gij1[2][i-14];
           
        end
    end
endgenerate
pipelineregister #(64+64+16+64+64+1) pipereg1 (.in({p1,g1,c1[15:0],gij1[3],pij1[3],cin1}),.clk(clk),.out({p2,g2,c2[15:0],gij2[3],pij2[3],cin2}));
//第三级流水线
//第5层
generate
    for (i = 16;i<32;i = i+1)begin: BLOCK5
        if (i ==16) begin
            pg uut01 (.p2(p2[16]),.g1(c2[15]),.g2(g2[16]),.gout(c2[16]));
        end
        else begin
            pg uut02 (.p2(pij2[3][i]),.g1(c2[15]),.g2(gij2[3][i]),.gout(c2[i]));
        end
    end
endgenerate

generate
    for (i = 33;i<64;i = i+1)begin: BLOCK6
        if (i<48) begin
            assign pij2[4][i] =pij2[3][i];
            assign gij2[4][i] =gij2[3][i];
        end
        else if (i ==48) begin
            pg uut1(.p1(pij2[3][47]),.g1(gij2[3][47]),.p2(p2[48]),.g2(g2[48]),.gout(gij2[4][48]),.pout(pij2[4][48]));
        end
        else begin
            pg uut2(.p1(pij2[3][47]),.g1(gij2[3][47]),.p2(pij2[3][i]),.g2(gij2[3][i]),.gout(gij2[4][i]),.pout(pij2[4][i]));
        end
    end
endgenerate

//第6层
generate
    for (i = 32;i<width;i = i+1)begin: BLOCK7
        if (i ==32) begin
            pg uut01 (.p2(p2[32]),.g1(c2[31]),.g2(g2[32]),.gout(c2[32]));
        end
        else begin
            pg uut02 (.p2(pij2[4][i]),.g1(c2[31]),.g2(gij2[4][i]),.gout(c2[i]));
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