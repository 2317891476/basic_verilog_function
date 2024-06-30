`timescale 1ns/1ns
module tb();

reg clk;
reg [63:0] abc [20*3-1:0];
reg [63:0] a, b, c_expect;
wire [63:0] c;
wire error;

assign error = clk && (c != c_expect);

// 修改适配1：调整为所用仿真器的波形输出方式
initial begin
    $readmemh("E:\\Xilinx11\\VLSI-session\\RTL-code\\IEEE_double_mult\\dataset.dat", abc);
    //$dumpfile("wave.vcd");
    $dumpvars();
    #200;
    $finish();
end

initial begin
    clk <= 0;
end

always begin
    #5;
    clk <= ~clk;
end

integer i;
initial begin
    for ( i=0 ; i < 20; i=i+1) begin
        a <= abc[i*3];
        b <= abc[i*3+1];
        #10;
    end
end

integer j;
initial begin
    // 修改适配2：
    // 延迟为10 * (流水线级数 + 0.5)
    #35;
    for ( j=0 ; j < 20; j=j+1) begin
        c_expect <= abc[j*3+2];
        #10;
    end
end

multiplier_wrapper dut(clk, a, b, c);


endmodule