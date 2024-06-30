module stop_watch_top_tb();
reg clk,reset,start;
wire [3:0] an;
wire [7:0] sseg;

stop_watch_top uut (.clk(clk),.reset(reset),.start(start),.an(an),.sseg(sseg));

initial begin
    clk = 0;
    reset = 1;
    start = 0;
    #100
    reset = 0;
    start = 1;
end

always  begin
    #15 clk = ~clk;
end
endmodule