module top(
    input wire clk,
    input wire  a,
    input wire  b,
    output reg [5:0] z
);
reg a_tmp, b_tmp;
reg [3:0] z_tmp_reg;
wire z_tmp_xor_wire;
wire z_tmp_xnor_wire;

always @(posedge clk) begin
    a_tmp <= a;
    b_tmp <= b;
end

always @(*) begin
    z_tmp_reg[0] = a_tmp & b_tmp;
    z_tmp_reg[1] =~ (a_tmp & b_tmp);
    z_tmp_reg[2] = a_tmp | b_tmp;
    z_tmp_reg[3] = ~(a_tmp | b_tmp);
end

assign z_tmp_xor_wire = a_tmp ^ b_tmp;

xnor xnor_gate (z_tmp_xnor_wire, a_tmp, b_tmp);

always @(posedge clk) begin
    z[3:0]  <= z_tmp_reg;
    z[4]  <= z_tmp_xor_wire;
    z[5]  <= z_tmp_xnor_wire;
end

endmodule