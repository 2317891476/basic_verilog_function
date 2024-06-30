module adder8(
    output wire [7:0] sum,
    output wire cout,
    input  wire [7:0] ina,
    input  wire [7:0] inb,
    input  wire cin
);
assign {cout,sum} = ina + inb + cin;
endmodule