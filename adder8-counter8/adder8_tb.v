module adder8_tb();
reg [7:0] ina,inb;
reg  cin;
wire [7:0] sum;
wire cout;
adder8 uut (.sum(sum),.cout(cout),.ina(ina),.inb(inb),.cin(cin));

initial begin
    ina =0;
    inb =0;
    cin =0;
end

always begin
    #11
    ina = ina +1;
end

always begin
    #28
    inb = inb +1;
end

always begin
    #5
    cin = 1;
end
endmodule