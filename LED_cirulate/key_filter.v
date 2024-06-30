module key_filter
#(parameter N = 2_000000)
(
    input   clk,
    input   reset,
    input   key_in,
    output reg key_out
);
reg [31:0] count;
reg key_r0,key_r1,key_r2;//寄存2拍
wire flag;
wire pedge;//上升沿

assign pedge = key_r1 & ~key_r2;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        key_r0 <= 0;
        key_r1 <= 0;
        key_r2 <= 0;
    end
    else begin
        key_r0 <= key_in;
        key_r1 <= key_r0;
        key_r2 <= key_r1;
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <=0;
        key_out <=0;
    end
    else begin
        if (pedge) begin//每次检测到上升沿重新开始计时
            count <=0;
        end
        else if (key_r2) begin
            if (count == N) begin
                count <=N;
                key_out <= 1;
            end
            else begin
                count <= count +1;
                key_out <=0;
            end
        end
        else begin
            count <=0;
            key_out <=0;
        end
    end
end
endmodule