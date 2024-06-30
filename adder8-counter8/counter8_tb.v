module counter8_tb();
reg clk;
reg reset;
wire [7:0] count;

counter8 uut (.clk(clk),.reset(reset),.count(count));

initial begin
    clk =0;
    reset= 1;
end

always #5 clk=~clk;

always begin
    #20
    reset = 0;
end

endmodule