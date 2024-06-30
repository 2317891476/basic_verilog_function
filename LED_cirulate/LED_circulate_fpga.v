module LED_circulate_fpga(
    input clk,
    input reset,
    input key,
    input rotate,
    input up,
    input key_enable,
    output [3:0] an,
    output [7:0] sseg
);
wire [3:0] d3,d2,d1,d0;
wire clk_out;
wire key_out;


clk_div uut0 (.clk_in(clk),.clk_out(clk_out),.rst(reset));
key_filter uut1 (.clk(clk),.reset(reset),.key_in(key),.key_out(key_out));
LED_circulate uut2(.clk(clk_out),.reset(reset),.key(key_out),.key_enable(key_enable),.up(up),.rotate(rotate),.d3(d3),.d2(d2),.d1(d1),.d0(d0));
scan_led_disp uut3 (.clk(clk),.reset(reset),.hex3(d3),.hex2(d2),.hex1(d1),.hex0(d0),.dp_in(4'b0101),.an(an),.sseg(sseg));
endmodule