module stop_watch_fpga(
    input clk,
    input reset,
    input set,
    input pause,
    input up,
    output [3:0] an,
    output [7:0] sseg,
    output minus_flag
);
wire [3:0] d3,d2,d1,d0;
wire clk_out;

clk_div uut0 (.clk_in(clk),.clk_out(clk_out),.rst(reset));
stop_watch  uut (.clk(clk_out),.reset(reset),.set(set),.pause(pause),.up(up),.d3(d3),.d2(d2),.d1(d1),.d0(d0),.minus_flag(minus_flag));
scan_led_disp uut1 (.clk(clk),.reset(reset),.hex3(d3),.hex2(d2),.hex1(d1),.hex0(d0),.dp_in(4'b0101),.an(an),.sseg(sseg));
endmodule