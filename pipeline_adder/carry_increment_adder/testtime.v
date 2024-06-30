module testtime(
    input clk,
    input [64-1:0] a,b,
    input cin,
    output [64-1:0] sum,
    output cout
);

wire [63:0] a_1,b_1,sum_1;
wire cin_1,cout_1;

pipelineregister #(64+64+1) uut0 (.in({a,b,cin}),.clk(clk),.out({a_1,b_1,cin_1}));
pipeline_cia_adder uut1 (.a(a_1),.b(b_1),.cin(cin_1),.sum(sum_1),.cout(cout_1),.clk(clk));
pipelineregister #(64+1) uut2 (.in({sum_1,cout_1}),.clk(clk),.out({sum,cout}));
endmodule