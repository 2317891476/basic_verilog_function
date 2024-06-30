module LED_circulate(
    input clk,
    input reset,
    input key,
    input key_enable,
    input up,//1为向右边
    input rotate,
    output [3:0] d3,d2,d1,d0
);

reg [39:0] const ;
always @(*) begin
    if (reset) begin
        const = {{4'd0},{4'd1},{4'd2},{4'd3},{4'd4},{4'd5},{4'd6},{4'd7},{4'd8},{4'd9}};
    end
    else begin
        if (rotate) begin
            if (up) begin
                const = {{const[35:0]},{const[39:36]}};
            end
            else begin
                const = {{const[3:0]},{const[39:4]}};
            end
        end
        else begin 
            if (key_enable) begin
                if (up) begin
                    const = {{const[35:0]},{const[39:36]}};
                end
                else begin
                    const = {{const[3:0]},{const[39:4]}};
                end
            end
            else const =const;
        end
    end
end

assign d3 = const[39:36];
assign d2 = const[35:32];
assign d1 = const[31:28];
assign d0 = const[27:24];
endmodule