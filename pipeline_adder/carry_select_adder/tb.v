module carry_select_adder_tb0();
reg [63:0] a,b;
reg cin;
wire cout;
wire [63:0] s_n;

carry_select_adder uut0(.a(a),.b(b),.cin(cin),.sum(s_n),.cout(cout));

initial begin
    cin = 0;
    a = 0;
    b = 0;
    #100
    cin = 1;
    #100
    cin = 0;
    #100
    a = 1;
    b = 9;
    #100
    a = 1;
    b = 64'h19;
    #100
    a = 1;
    b = {64{1'b1}};
end
endmodule