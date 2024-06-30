module multiplier_wrapper(
input clk,
input [63:0] a,
input [63:0] b,
input [63:0] c);

double_multiplier uut0(.input_a(a),.input_b(b),.output_z(c),.clk(clk));

endmodule