module SynsFIFO(
input clk,
input rst,
input din,
input wr_en,
input rd_en,
output dout,
output reg empty,
output reg full
); 
parameter WIDTH=4'd8,LOG2DEPTH=4'd6;//假设位宽为8，深度为64,只考虑深度为2的幂次方的情况
reg [WIDTH-1 : 0] ram [(1<<LOG2DEPTH)-1 : 0];//开辟存储区
wire [WIDTH-1 : 0] dout,din;//读写数据
reg [LOG2DEPTH-1 :0] rp,wp;//定义读写指针

always@(posedge clk) begin
    if((wr_en & ~full) || (full & wr_en & rd_en))
        begin
        ram[wp] <= din;
    end
end
//读出数据dout
assign dout = (rd_en & ~empty)?ram[rp]:0;
//写指针wp
always@(posedge clk)begin
    if(rst)begin
        wp <= 0;
    end
    else if(wr_en & ~full) begin
        wp <= wp + 1;
    end
    else if(full && (wr_en & rd_en)) begin
        wp <= wp + 1;
    end
end

always@(posedge clk) begin
    if(rst) begin
        rp <= 0;
    end
    else if(rd_en & ~empty) begin
        rp <= rp + 1;
    end
end
//满标志full
always@(posedge clk) begin
    if(rst) begin
        full <= 0;
    end
    else if((wr_en & ~rd_en) && (wp == rp - 1)) begin
        full <= 1;
    end
    else if(full & rd_en) begin
        full <= 0;
    end
end
//空标志empty
always@(posedge clk) begin
        if(rst) begin
            empty <= 1;
        end
    else if(wr_en & empty) begin
        empty <= 0;
        end
    else if((rd_en & ~wr_en) && (rp == wp - 1)) begin
        empty <= 1;
    end
end
endmodule

