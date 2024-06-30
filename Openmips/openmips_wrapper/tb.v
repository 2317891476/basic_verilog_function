`timescale 1ns/1ns


module tb;

reg clk;
reg rst;
always begin
#5    clk = ~clk;
end

wire [31:0] i_mem_data, i_mem_addr;
wire [31:0] d_mem_rdata, d_mem_wdata, d_mem_addr;
wire [3:0] d_mem_r_sel;
wire d_mem_w_en, d_mem_r_en;
reg [5:0] int_i;
reg timer_int;


integer i,j;
data_memory d_mem(
    .clk(clk),
    .addr_mem(d_mem_addr),
    .w_data_mem(d_mem_wdata),
    .w_en_mem({4{d_mem_w_en}} & d_mem_r_sel),
    .en_mem(d_mem_r_en),
    .r_data_mem(d_mem_rdata)
);

inst_memory i_mem(
    .clk(clk),
    .rstn(1'b1),
    .inst_addr(i_mem_addr),
    .inst_o(i_mem_data)
);
// 修改“openmips”为自己的处理器模块名
openmips dut(
    .rst(rst),
    .clk(clk),
    .rom_data_i(i_mem_data),
    .rom_addr_o(i_mem_addr),
    .rom_ce_o(),
    .ram_addr_o(d_mem_addr),
    .ram_we_o(d_mem_w_en),
    .ram_sel_o(d_mem_r_sel),
    .ram_data_o(d_mem_wdata),
    .ram_ce_o(d_mem_r_en),
    .ram_data_i(d_mem_rdata)
    // 以下为选做内容，实现异常时启用
    //,.int_i(int_i),
    //.timer_int_o(timer_int)
);


initial	begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        //$dumpall();
end

initial begin
    clk = 1'b0;
    rst = 1'b1;
    int_i = 6'b0;
    timer_int = 1'b0;
    #10
    rst = 1'b0;
    #50
    timer_int = 1'b1;
    #5
    timer_int = 1'b0;
    #5
    #50
    int_i = 6'b001000;
    #5
    int_i = 6'b0;
    #5
    #15000
    $finish();
end


endmodule