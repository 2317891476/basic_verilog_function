module top_tb();
reg clk;
reg a,b;
wire [5:0] z;

top uut(.clk(clk),.a(a),.b(b),.z(z));

initial begin 
clk=0;
end

always begin
    #5
    clk = ~clk;
end

always begin
    a=0;
    b=0;
    #20
    a=0;
    b=1;
    #20
    a=1;
    b=0;
    #20
    a=1;
    b=1;
end

endmodule