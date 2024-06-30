module SKadder_64
#(parameter width = 64)
(
    input [width-1:0] a,b,
    input cin,
    output reg [width-1:0] sum,
    output cout
);


reg [width-1:0] p,g;
wire [width-1:0] c;
wire [width-1:0] gij [7:0];
wire [width-1:0] pij [7:0];

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

//第3层
generate
    for (i = 7;i<width;i = i+8)begin: BLOCK3
        if (i==7) begin
            pg uut01 (.p2(p[4]),.g1(c[3]),.g2(g[4]),.gout(c[4]));
            pg uut02 (.p2(pij[1][5]),.g1(c[3]),.g2(gij[1][5]),.gout(c[5]));
            pg uut03 (.p2(pij[1][6]),.g1(c[3]),.g2(gij[1][6]),.gout(c[6]));
            pg uut04 (.p2(pij[1][7]),.g1(c[3]),.g2(gij[1][7]),.gout(c[7]));
        end
        else begin
            pg uut1(.p1(pij[1][i-4]),.g1(gij[1][i-4]),.p2(p[i-3]),.g2(g[i-3]),.gout(gij[2][i-3]),.pout(pij[2][i-3]));
            pg uut2(.p1(pij[1][i-4]),.g1(gij[1][i-4]),.p2(pij[1][i-2]),.g2(gij[1][i-2]),.gout(gij[2][i-2]),.pout(pij[2][i-2]));
            pg uut3(.p1(pij[1][i-4]),.g1(gij[1][i-4]),.p2(pij[1][i-1]),.g2(gij[1][i-1]),.gout(gij[2][i-1]),.pout(pij[2][i-1]));
            pg uut4(.p1(pij[1][i-4]),.g1(gij[1][i-4]),.p2(pij[1][i]),.g2(gij[1][i]),.gout(gij[2][i]),.pout(pij[2][i]));

            assign pij[2][i-4] =pij[1][i-4];
            assign gij[2][i-4] =gij[1][i-4];
            assign pij[2][i-5] =pij[1][i-5];
            assign gij[2][i-5] =gij[1][i-5];
            assign pij[2][i-6] =pij[1][i-6];
            assign gij[2][i-6] =gij[1][i-6];
        end
    end
endgenerate


//第4层
generate
    for (i = 15;i<width;i = i+16)begin: BLOCK4
        if (i==15) begin
            pg uut01 (.p2(p[8]),.g1(c[7]),.g2(g[8]),.gout(c[8]));
            pg uut02 (.p2(pij[2][9]),.g1(c[7]),.g2(gij[2][9]),.gout(c[9]));
            pg uut03 (.p2(pij[2][10]),.g1(c[7]),.g2(gij[2][10]),.gout(c[10]));
            pg uut04 (.p2(pij[2][11]),.g1(c[7]),.g2(gij[2][11]),.gout(c[11]));
            pg uut05 (.p2(pij[2][12]),.g1(c[7]),.g2(gij[2][12]),.gout(c[12]));
            pg uut06 (.p2(pij[2][13]),.g1(c[7]),.g2(gij[2][13]),.gout(c[13]));
            pg uut07 (.p2(pij[2][14]),.g1(c[7]),.g2(gij[2][14]),.gout(c[14]));
            pg uut08 (.p2(pij[2][15]),.g1(c[7]),.g2(gij[2][15]),.gout(c[15]));
        end
        else begin
            pg uut1(.p1(pij[2][i-8]),.g1(gij[2][i-8]),.p2(p[i-7]),.g2(g[i-7]),.gout(gij[3][i-7]),.pout(pij[3][i-7]));
            pg uut2(.p1(pij[2][i-8]),.g1(gij[2][i-8]),.p2(pij[2][i-6]),.g2(gij[2][i-6]),.gout(gij[3][i-6]),.pout(pij[3][i-6]));
            pg uut3(.p1(pij[2][i-8]),.g1(gij[2][i-8]),.p2(pij[2][i-5]),.g2(gij[2][i-5]),.gout(gij[3][i-5]),.pout(pij[3][i-5]));
            pg uut4(.p1(pij[2][i-8]),.g1(gij[2][i-8]),.p2(pij[2][i-4]),.g2(gij[2][i-4]),.gout(gij[3][i-4]),.pout(pij[3][i-4]));
            pg uut5(.p1(pij[2][i-8]),.g1(gij[2][i-8]),.p2(pij[2][i-3]),.g2(gij[2][i-3]),.gout(gij[3][i-3]),.pout(pij[3][i-3]));
            pg uut6(.p1(pij[2][i-8]),.g1(gij[2][i-8]),.p2(pij[2][i-2]),.g2(gij[2][i-2]),.gout(gij[3][i-2]),.pout(pij[3][i-2]));
            pg uut7(.p1(pij[2][i-8]),.g1(gij[2][i-8]),.p2(pij[2][i-1]),.g2(gij[2][i-1]),.gout(gij[3][i-1]),.pout(pij[3][i-1]));
            pg uut8(.p1(pij[2][i-8]),.g1(gij[2][i-8]),.p2(pij[2][i-0]),.g2(gij[2][i-0]),.gout(gij[3][i-0]),.pout(pij[3][i-0]));

            assign pij[3][i-8] = pij[2][i-8];
            assign gij[3][i-8] = gij[2][i-8];
            assign pij[3][i-9] = pij[2][i-9];
            assign gij[3][i-9] = gij[2][i-9];
            assign pij[3][i-10] = pij[2][i-10];
            assign gij[3][i-10] = gij[2][i-10];
            assign pij[3][i-11] = pij[2][i-11];
            assign gij[3][i-11] = gij[2][i-11];
            assign pij[3][i-12] = pij[2][i-12];
            assign gij[3][i-12] = gij[2][i-12];
            assign pij[3][i-13] = pij[2][i-13];
            assign gij[3][i-13] = gij[2][i-13];
            assign pij[3][i-14] = pij[2][i-14];
            assign gij[3][i-14] = gij[2][i-14];
           
        end
    end
endgenerate


//第5层
generate
    for (i = 16;i<32;i = i+1)begin: BLOCK5
        if (i ==16) begin
            pg uut01 (.p2(p[16]),.g1(c[15]),.g2(g[16]),.gout(c[16]));
        end
        else begin
            pg uut02 (.p2(pij[3][i]),.g1(c[15]),.g2(gij[3][i]),.gout(c[i]));
        end
    end
endgenerate

generate
    for (i = 33;i<64;i = i+1)begin: BLOCK6
        if (i<48) begin
            assign pij[4][i] =pij[3][i];
            assign gij[4][i] =gij[3][i];
        end
        else if (i ==48) begin
            pg uut1(.p1(pij[3][47]),.g1(gij[3][47]),.p2(p[48]),.g2(g[48]),.gout(gij[4][48]),.pout(pij[4][48]));
        end
        else begin
            pg uut2(.p1(pij[3][47]),.g1(gij[3][47]),.p2(pij[3][i]),.g2(gij[3][i]),.gout(gij[4][i]),.pout(pij[4][i]));
        end
    end
endgenerate

//第6层
generate
    for (i = 32;i<width;i = i+1)begin: BLOCK7
        if (i ==32) begin
            pg uut01 (.p2(p[32]),.g1(c[31]),.g2(g[32]),.gout(c[32]));
        end
        else begin
            pg uut02 (.p2(pij[4][i]),.g1(c[31]),.g2(gij[4][i]),.gout(c[i]));
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