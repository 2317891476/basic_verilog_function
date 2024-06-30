module  prio_endcoder_if(
    input wire  [3:0] r,
    output reg [2:0] y
);
    always @*
    if (r[3]==1'b1)
        y = 3'b100;
    else if (r[2]==1'b1)
        y = 3'b011;
    else if (r[1]==1'b1)
        y = 3'b010;
    else y = 3'b000;

endmodule