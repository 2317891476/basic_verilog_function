module pipeline_carry_skip_adder_tb();

reg [63:0] a,b;
reg cin;
wire cout;
wire [63:0] s_n;
reg clk;

SKadder_64 uut0(.a(a),.b(b),.cin(cin),.sum(s_n),.cout(cout),.clk(clk));

initial begin
    cin = 0;
    a = 0;
    b = 200;
    clk = 1;
    #100
    cin = 1;
    #100
    cin = 0;
    
end

always begin
    #10
    a = a+1;
    if (a=={64{1'b1}}) a = 0;
end
always begin
    #10
    b = b+1;
    if (b=={64{1'b1}}) b = 0;
end

always begin
    #5
    clk = ~clk;
end
endmodule