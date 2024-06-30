module key_filter_tb();
reg clk,reset,key_in;
wire key_out;

key_filter #(.N(10)) uut (.clk(clk),.reset(reset),.key_in(key_in),.key_out(key_out));

initial begin
    clk = 0;
    reset = 1;
    key_in = 0;
    #100
    reset = 0;
    key_in = 1;
    #5
    key_in = 0;
    #5
    key_in = 1;
    #15
    key_in = 0;
    #5
    key_in = 1;
    #40
    key_in = 0;

end

always begin
    #1
    clk = ~clk;
end
endmodule