module reg_n_tb();

localparam N = 32;
reg clk,reset,load;
reg [N-1:0] in_data;
wire [N-1:0] out_data;
reg_n #(.N(N)) uut (.clk(clk),.reset(reset),.load(load),.in_data(in_data),.out_data(out_data));

initial begin
    clk = 0;
    in_data =0;
    reset = 1;
    load = 0;
    #20
    load = 1;
    #20
    reset = 0;
end

always begin
    #10 clk = ~clk;
end

always begin
    #10
    in_data =in_data +1;
    if (in_data == {N{1'b1}})
        in_data = 0;
end

endmodule