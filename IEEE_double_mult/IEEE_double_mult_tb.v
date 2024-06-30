module double_multiplier_tb();

reg [63:0] a,b;
reg cin;
wire cout;
wire [63:0] s_n;
reg clk;

double_multiplier uut0(.input_a(a),.input_b(b),.output_z(s_n),.clk(clk));

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
    //a = {{$random()},{$random()}};
    a = 64'h40EA22B99999999A;
end
always begin
    #10
    //b = {{$random()},{$random()}};
    b = 64'h4215D094508FF000;
end

always begin
    #5
    clk = ~clk;
end
endmodule