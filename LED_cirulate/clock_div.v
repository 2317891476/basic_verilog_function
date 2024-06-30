module clk_div
    #(parameter N = 100_000000)
    (
    input clk_in,
    input rst,
    output reg clk_out
    );
reg [31:0] count;
always @(posedge clk_in or posedge rst) begin
    if (rst) count <=0;
    else begin
        if (count<N)    count <=count +1;
        else    count<=0;
    end
end
always @(count) begin
    if (count == N) clk_out = 1;
    else clk_out = 0;
end
endmodule