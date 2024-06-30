module SynsFIFO
#(  parameter WIDTH=4'd8,
    parameter LOG2DEPTH=4'd6)//假设位宽为8，深度为64,只考虑深度为2的幂次方的情况
(
input clk,
input rst,
input[WIDTH-1 : 0] din,
input wr_en,
input rd_en,
output reg [WIDTH-1 : 0] dout,
output empty,
output full
); 
reg [WIDTH-1 : 0] ram [(1<<LOG2DEPTH)-1 : 0];//开辟存储区
reg [LOG2DEPTH-1 :0] rp,wp;//定义读写指针

always@(posedge clk) begin
    if((wr_en & ~full) || (full & wr_en & rd_en))
        begin
        ram[wp] <= din;
    end
end

//读出数据dout
//assign dout = (rd_en & ~empty)?ram[rp]:0;
always@(posedge clk) begin
    if((rd_en & ~full) || (full & wr_en & rd_en))
        begin
        dout <= ram[rp];
    end
end

//写指针wp
always@(posedge clk)begin
    if(rst) begin
        wp <= 0;
    end
    else if(wr_en & ~full) begin
        if (wp != (1<<LOG2DEPTH)-1)
            wp <= wp + 1;
        else wp <= 0;
    end
    else if(full && (wr_en & rd_en)) begin
        if (wp != (1<<LOG2DEPTH)-1)
            wp <= wp + 1;
        else wp <= 0;
    end
end

always@(posedge clk) begin
    if(rst) begin
        rp <= 0;
    end
    else if(rd_en & ~empty) begin
        if (rp != (1<<LOG2DEPTH)-1)
            rp <= rp + 1;
        else rp <= 0;
    end
    else if(full && (wr_en & rd_en)) begin
        if (rp != (1<<LOG2DEPTH)-1)
            rp <= rp + 1;
        else rp <= 0;
    end
end

assign full = ((wr_en & ~rd_en) && (wp == rp - 1)) ?1:0;
assign empty = ((rd_en & ~wr_en) && (rp == wp - 1))?1:0;
endmodule

