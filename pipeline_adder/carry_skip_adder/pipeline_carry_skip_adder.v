module pipeline_carry_skip_adder
#(parameter width = 64)
(
    input [width-1:0] a,b,
    input cin,
    output [width-1:0] sum,
    output cout,
    input clk
);
wire [63:0] sum0,sum1;
wire [width>>2:0] temp [2:0];
genvar i;
wire [63:0] a1,a2,b1,b2;

//第一级流水
generate
    for (i = 0;i<6;i = i+1)begin:BLOCK2
        full_adder_Nbit_csa uut0(
            .a_n(a[i*4+3:i*4]),
            .b_n(b[i*4+3:i*4]),
            .cin(temp[0][i]),
            .s_n(sum0[i*4+3:i*4]),
            .cout(temp[0][i+1])
        );
    end
endgenerate

pipelineregister #(64+64+7+24) uut0 (.in({a,b,temp[0][6:0],sum0[23:0]}),.clk(clk),.out({a1,b1,temp[1][6:0],sum1[23:0]}));
//第二级流水
generate
    for (i = 6;i<12;i = i+1)begin:BLOCK3
        full_adder_Nbit_csa uut0(
            .a_n(a1[i*4+3:i*4]),
            .b_n(b1[i*4+3:i*4]),
            .cin(temp[1][i]),
            .s_n(sum1[i*4+3:i*4]),
            .cout(temp[1][i+1])
        );
    end
endgenerate

pipelineregister #(64+64+13+48) uut1 (.in({a1,b1,temp[1][12:0],sum1[47:0]}),.clk(clk),.out({a2,b2,temp[2][12:0],sum[47:0]}));

//第三级流水
generate
    for (i = 12;i<16;i = i+1)begin:BLOCK4
        full_adder_Nbit_csa uut0(
            .a_n(a2[i*4+3:i*4]),
            .b_n(b2[i*4+3:i*4]),
            .cin(temp[2][i]),
            .s_n(sum[i*4+3:i*4]),
            .cout(temp[2][i+1])
        );
    end
endgenerate
assign temp[0][0] =cin;
assign cout = temp[2][width>>2];
endmodule