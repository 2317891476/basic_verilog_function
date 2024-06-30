module stop_watch_tb();
reg clk;
reg reset;
reg start;
wire [3:0] d3,d2,d1,d0;

stop_watch#(.N(10)) uut0(.clk(clk),.start(start),.reset(reset),.d2(d2),.d1(d1),.d0(d0),.d3(d3));

initial begin
    clk = 0;
    reset = 1;
    start = 0 ;
    #10
    reset = 0;
    start = 1;
    #100
    reset = 1;
    #15
    reset = 0;
    #5
    start = 0;
    #10
    start =1;
end
always  begin
    #5 clk = ~clk;
end
endmodule