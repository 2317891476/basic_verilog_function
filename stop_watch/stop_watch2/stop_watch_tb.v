module stop_watch_tb();
reg clk,reset,set,pause,up;
wire [3:0] d3,d2,d1,d0;
wire minus_flag;

stop_watch  uut (.clk(clk),.reset(reset),.set(set),.pause(pause),.up(up),.d3(d3),.d2(d2),.d1(d1),.d0(d0),.minus_flag(minus_flag));

initial begin
    clk = 0;
    reset = 1;
    set = 0;
    pause = 0;
    up = 1;
    #50
    reset = 0;
    #100
    pause = 1;
    #100
    pause = 0;
    #100
    up = 0;
    #100
    up = 1;
    #100
    set = 1;
    #10
    set = 0;
    #100
    up = 0;
    #100
    up = 1;
end

always begin
    #5
    clk = ~clk;
end
endmodule