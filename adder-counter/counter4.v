module count4(
    input  wire clk,
    input  wire  reset,
    output reg [3:0]count  
);
always @(posedge clk) 
    if (reset)  count<=0;
    else if (count==4'b1111) begin
        count<=0;
    end
    else count<=count + 1;
endmodule