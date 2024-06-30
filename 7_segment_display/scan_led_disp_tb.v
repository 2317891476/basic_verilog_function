module scan_led_disp_tb ();
reg clk,reset;
reg [3:0] hex3,hex2,hex1,hex0;
reg [3:0] dp_in;
wire [3:0] an;
wire [7:0] sseg;
localparam N0 = 5;

scan_led_disp #(.N(N0)) uut (.clk(clk),.reset(reset),.hex3(hex3),.hex2(hex2),.hex1(hex1),.hex0(hex0),.dp_in(dp_in),.sseg(sseg),.an(an));

initial begin
    clk = 0;
    reset = 1;
    dp_in = 0;
    hex3 = 0;
    hex2 = 0;
    hex1 = 0;
    hex0 = 0;
    #20
    reset = 0;
end

always #10 clk = ~clk;

always begin
    #100
    hex3 = hex3 +4;
    hex2 = hex2 +3;
    hex1 = hex1 +2;
    hex0 = hex0 +1;
end
endmodule