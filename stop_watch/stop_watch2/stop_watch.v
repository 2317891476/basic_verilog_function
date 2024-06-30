module stop_watch
(
    input clk,
    input reset,
    input set,
    input pause,
    input up,
    output reg [3:0] d2,d1,d0,d3,
    output reg minus_flag
);
always @(posedge clk or posedge reset or posedge set or posedge pause) begin
    if (reset) begin
        d3 <= 0;
        d2 <= 0;
        d1 <= 0;
        d0 <= 0;
        minus_flag <=0;
    end
    else if (set) begin
        d3 <= 9;
        d2 <= 5;
        d1 <= 0;
        d0 <= 0;
        minus_flag <=0;
    end
    else if (pause) begin
        d3 <=d3;
        d2 <=d2;
        d1 <=d1;
        d0 <=d0;
        minus_flag <=0;
    end
    else begin
        if (up) begin
            if (d0 !=9) begin
                d0 <= d0 + 1;
            end
            else begin
                d0 <=0;
                if (d1 !=9) begin
                    d1 <= d1 +1;
                end
                else begin
                    d1 <=0;
                    if (d2 !=5) begin
                        d2 <= d2+1;
                    end
                    else begin
                        d2 <=0;
                        if (d3 !=9) begin
                            d3 <= d3+1;
                        end
                        else d3 <=0;
                        end
                    end
                end
            end
        else begin
            if (d0 !=0) begin
                d0 <= d0-1;
            end
            else begin
                d0 <= 9;
                if (d1 !=0) begin
                    d1 <= d1-1;
                end
                else begin
                    d1 <=9;
                    if (d2 !=0) begin
                        d2 <=d2 -1;
                    end
                    else begin
                        d2 <= 5;
                        if (d3 !=0) begin
                            d3 <=d3 -1;
                        end
                        else begin
                            d3 <=9;
                            minus_flag <=1;
                        end
                    end
                end
            end
        end
    end
end

endmodule