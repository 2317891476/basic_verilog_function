module pipeline_rc_adder
#(parameter width = 64)
(
    input [width-1:0] a,b,
    input cin,
    input clk,
    output reg [width-1:0] sum,
    output cout
);
reg [width-1:0] p;
reg [width-1:0] g;

wire [width-1:0] p0[2:0];
wire [width-1:0] g0[2:0];
wire [width-1:0] c [2:0];
wire cin1,cin2;

genvar i;
integer  j;
always @(*) begin
    for (j=0;j<width;j=j+1) begin
        p[j] = a[j] ^ b[j];
        g[j] = a[j] & b[j];
    end
end

//第一级流水线
generate
    for (i = 0;i<23;i = i+1)begin: BLOCK2
        if (i == 0) begin
            pg uut1 (.p2(p[0]),.g1(cin),.g2(g[0]),.gout(c[0][0]));
        end
        else begin
            pg uut0(
            .g1(c[0][i-1]),
            .p2(p[i]),
            .g2(g[i]),
            .gout(c[0][i]));
        end
    end
endgenerate

generate
    for (i = 0;i<width; i = i+1) begin: pipe1
        if (i <23) begin
            pipelineregister #(2) uut0 (.in({c[0][i],p[i]}),.clk(clk),.out({c[1][i],p0[1][i]}));
        end
        else begin
            pipelineregister #(2) uut1 (.in({g[i],p[i]}),.clk(clk),.out({g0[1][i],p0[1][i]}));
        end
    end
endgenerate
pipelineregister #(1) uut0 (.in({cin}),.clk(clk),.out({cin1}));
//pipelineregister #(64+64+1) uut0 (.in({a,b,cin}),.clk(clk),.out({a_1,b_1,cin_1}));

//第二级流水线
generate
    for (i = 23;i<46;i = i+1)begin: BLOCK3
        begin
            pg uut0(
            .g1(c[1][i-1]),
            .p2(p0[1][i]),
            .g2(g0[1][i]),
            .gout(c[1][i]));
        end
    end
endgenerate

generate
    for (i = 0;i<width; i = i+1) begin: pipe2
        if (i <46) begin
            pipelineregister #(2) uut0 (.in({c[1][i],p0[1][i]}),.clk(clk),.out({c[2][i],p0[2][i]}));
        end
        else begin
            pipelineregister #(2) uut1 (.in({g0[1][i],p0[1][i]}),.clk(clk),.out({g0[2][i],p0[2][i]}));
        end
    end
endgenerate
pipelineregister #(1) uut1w (.in({cin1}),.clk(clk),.out({cin2}));

//第三级流水线
generate
    for (i = 46;i<width;i = i+1)begin: BLOCK4
        begin
            pg uut0(
            .g1(c[2][i-1]),
            .p2(p0[2][i]),
            .g2(g0[2][i]),
            .gout(c[2][i]));
        end
    end
endgenerate


always @(*) begin
    for (j = 0;j<width;j= j+1) begin
        if (j==0) begin
            sum[j] = p0[2][j] ^ cin2;
        end
        else 
            sum[j] = p0[2][j] ^ c[2][j-1];
    end
end

assign cout = c[2][width-1];
endmodule