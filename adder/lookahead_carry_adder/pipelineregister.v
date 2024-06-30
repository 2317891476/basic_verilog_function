module pipelineregister #
(parameter N = 32)
(
    input [N-1:0] in,
    input clk,rst,
    output reg [N-1:0] out
);

always @(posedge clk) begin
    out <= in;
end
endmodule