module mult_for(
    input wire [7:0] op0,
    input wire [7:0] op1,
    output reg [15:0] result
);
integer i;
always @*
begin
    result =0;
    for (i = 0; i<=7;i = i+1)
        if (op1[i])
            result = result + (op0<<(i-1));
end
endmodule