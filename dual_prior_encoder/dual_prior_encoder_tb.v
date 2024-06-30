module dual_prior_encoder_tb();

reg [15:0] cin;
wire [3:0]h_flag,l_flag;

dual_prior_encoder uut (.cin(cin),.h_flag(h_flag),.l_flag(l_flag));

initial begin
    cin = 0;
end

always begin
    #10 cin = cin+1;
    if (cin ==16'hffff) cin = 0;
end
endmodule