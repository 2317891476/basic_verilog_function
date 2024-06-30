module gray_tran_top(
    input clk,
    input [3:0] cin,
    output [3:0] an,
    output [7:0] sseg
);

wire [3:0] cout;
gray_tran uut0(.cin(cin),.cout(cout));
scan_led_disp uut1 (.clk(clk),.reset(0),.hex3(cout[3]),.hex2(cout[2]),.hex1(cout[1]),.hex0(cout[0]),.dp_in(4'b1111),.an(an),.sseg(sseg));

endmodule