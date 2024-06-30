module dff_en_reset(
    input wire clk,en,reset,
    input wire d,
    output reg q
);
reg r_reg,r_next;

always @(posedge clk , posedge reset) begin
    if (reset)
        r_reg<= 1'b0;
    else r_reg<= r_next;
end

always @* begin
    if(en) r_next<= d;
    else r_next <= r_reg;
end

always @*
    q <= r_reg;
endmodule