module adder4(
    output wire [3:0] sum,
    output wire cout,
    input  wire [3:0] ina,
    input  wire [3:0] inb,
    input  wire cin
);
assign {cout,sum} = ina + inb + cin;
endmodule