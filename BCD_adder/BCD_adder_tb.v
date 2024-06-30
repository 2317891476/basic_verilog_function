module BCD_adder_tb();
reg trig;
reg [11:0] cin;
wire [11:0] cout;

BCD_adder uut (.trig(trig),.cin(cin),.cout(cout));

initial begin
    trig = 0;
    cin = 0;
    #10
    trig = 1;
end

always begin
    #5
    cin = cin+1;
    if (cin == 12'hfff) cin =0;
end
endmodule