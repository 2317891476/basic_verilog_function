module SynsFIFO_tb();
reg clk,rst,wr_en,rd_en;
reg [7:0] din;
wire [7:0] dout;
wire empty,full;

SynsFIFO uut (.clk(clk),.rst(rst),.wr_en(wr_en),.rd_en(rd_en),.din(din),.dout(dout),.full(full),.empty(empty));

initial begin
    clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    #100
    rst = 0;
    repeat(64) begin
        @(posedge clk) begin
            wr_en <= 1;
            din <= $random;
        end
    end
    repeat(64) begin
        @(posedge clk) begin
            wr_en <= 0;
            rd_en <= 1;
        end
    end
    repeat(4) begin
        @(posedge clk) begin
            wr_en <=1;
            din <= $random;
            rd_en <= 0;
        end
    end
    forever begin
        @(posedge clk) begin
            wr_en <=1;
            din <= $random;
            rd_en <= 1;
        end
    end 
end

always begin
    #5 
    clk = ~clk;
end

endmodule