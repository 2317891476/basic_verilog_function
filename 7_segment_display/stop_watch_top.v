module stop_watch_top(
    input wire clk,
    input wire reset,
    input wire start,
    output [3:0] an,
    output [7:0] sseg
);
wire [3:0] d3,d2,d1,d0;

stop_watch uut0(.clk(clk),.start(start),.reset(reset),.d2(d2),.d1(d1),.d0(d0),.d3(d3));
scan_led_disp uut1(.clk(clk),.reset(reset),.dp_in(4'b1011),.hex2(d2),.hex1(d1),.hex0(d0),.an(an),.sseg(sseg),.hex3(d3));
endmodule