module LED_circulate_tb();
reg clk,reset,key,up,rotate,key_enable;
wire [3:0] d3,d2,d1,d0;

LED_circulate uut(.clk(clk),.reset(reset),.key(key),.up(up),.key_enable(key_enable),.rotate(rotate),.d3(d3),.d2(d2),.d1(d1),.d0(d0));

initial begin
    clk = 0;
    reset = 1;
    key = 0;
    up = 1;
    rotate = 0;
    key_enable = 1;
    #100
    reset = 0;
    #10
    rotate = 1;
    #100
    up = 0;
    #5
    key = 1;
    #5
    key = 0;
    #5
    key = 1;
    #5
    key = 0;
    #5
    key = 1;
    #5
    key = 0;
    #100
    rotate = 0;
end

always begin
    #10;
    clk = ~clk;
end

endmodule