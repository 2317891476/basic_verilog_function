//秒表
module stop_watch
#(parameter N = 1000000)
(
    input clk,
    input reset,
    input start,
    output [3:0] d2,d1,d0,d3
);

reg [31:0] count;
reg [3:0] d2_reg,d1_reg,d0_reg,d3_reg;
reg [3:0] d2_next,d1_next,d0_next,d3_next;
wire ms_tick;

always @(posedge clk) begin
    if (reset) begin
        d3_reg <=0;
        d2_reg <=0;
        d1_reg <=0;
        d0_reg <=0;
        d3_next <=0;
        d2_next <=0;
        d1_next <=0;
        d0_next <=0;
        count  <=0;
    end

    else if (!start) begin
        d3_reg <=d3_reg;
        d2_reg <=d2_reg;
        d1_reg <=d1_reg;
        d0_reg <=d0_reg;
    end

    else  begin
        d3_reg <= d3_next;
        d2_reg <= d2_next;
        d1_reg <= d1_next;
        d0_reg <= d0_next;
        if (count < N)
            count <= count +1;
        else count <=0;
    end
end

assign ms_tick = (count == N) ? 1'b1:1'b0;

always @* begin
    if (ms_tick)
        if(d0_reg !=9)
            d0_next = d0_reg +1;
        else begin
            d0_next = 4'b0;
            if (d1_reg !=9)
                d1_next = d1_reg +1;
            else begin
                d1_next = 4'b0;
                if (d2_reg != 9)
                    d2_next = d2_reg +1;
                else begin
                    d2_next = 4'b0;
                    if (d3_reg !=9)
                        d3_next = d3_reg +1;
                    else d3_next = 4'b0;
                end
            end
        end
end

assign d3 = d3_reg;
assign d2 = d2_reg;
assign d1 = d1_reg;
assign d0 = d0_reg;
endmodule