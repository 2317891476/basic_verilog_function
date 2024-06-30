module BCD_adder_fpga(
    input clk,
    input trig,
    input [11:0] sw,
    output [11:0] led,
    output [3:0] an,
    output [7:0] sseg
);


BCD_adder uut0(.trig(trig),.cin(sw),.cout(led));
scan_led_disp uut1 (.clk(clk),.reset(0),.hex3(led[11:8]),.hex2(led[7:4]),.hex1(led[3:0]),.hex0(0),.dp_in(4'b1111),.an(an),.sseg(sseg));
endmodule