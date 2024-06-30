module counter8(
    input  wire clk,
    input  wire  reset,
    output reg [7:0]count  
);
always @(posedge clk) 
    if (reset)  count<=0;
    else if (count==8'b1111_1111) begin
        count<=0;
    end
    else count<=count + 1;
endmodule