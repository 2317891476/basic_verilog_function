module testtime(
    input clk,
    input [64-1:0] a,b,
    output [64-1:0] c,
    output cout
);

wire [63:0] a_1,b_1,c_1;


pipelineregister #(64+64) uut0 (.in({a,b}),.clk(clk),.out({a_1,b_1}));
multiplier_wrapper dut(clk, a_1, b_1, c_1);
pipelineregister #(64) uut2 (.in({c_1}),.clk(clk),.out({c}));
endmodule