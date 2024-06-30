module dual_prior_encoder_fpga(
    input clk,
    input [15:0] sw,
    output [3:0] an,
    output [7:0] sseg
);

wire [3:0] h_flag,l_flag;

dual_prior_encoder uut0(.cin(sw),.h_flag(h_flag),.l_flag(l_flag));
scan_led_disp uut1 (.clk(clk),.reset(0),.hex3(0),.hex2(h_flag),.hex1(0),.hex0(l_flag),.dp_in(4'b1111),.an(an),.sseg(sseg));
endmodule